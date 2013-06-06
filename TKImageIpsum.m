//
//  TKImageIpsum.m
//
//  Created by Tomasz Kuźma on 5/16/13.
//  Copyright (c) 2013 mapedd@mapedd.com. All rights reserved.
//

#import "TKImageIpsum.h"

static NSString *const placeholder = @"TKPlaceholder";

@interface TKImageIpsum ()

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSMutableDictionary *caches;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic,assign) NSInteger activeDownloads;

@end

@implementation TKImageIpsum

- (id)init{
    self = [super init];
    _defaultSize = CGSizeMake(100.0f, 100.0f);
    return self;
}

#pragma mark - Getters

- (NSLock *)lock{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

- (NSString *)urlFormat{
    if (!_urlFormat) {
        _urlFormat = @"http://lorempixel.com/%d/%d/food";
    }
    return _urlFormat;
}

- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 4;
    }
    return _queue;
}

- (NSMutableDictionary *)caches{
    if (!_caches) {
        _caches = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _caches;
}

#pragma mark - Setters

- (void)setActiveDownloads:(NSInteger)activeDownloads{
    if (_activeDownloads != activeDownloads) {
        
        [self.lock lock];
        _activeDownloads = activeDownloads;
        
        BOOL showingIndicator = [UIApplication sharedApplication].networkActivityIndicatorVisible;
        
        if (_activeDownloads > 0 && !showingIndicator)
             [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        else if(_activeDownloads == 0 && showingIndicator)
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [self.lock unlock];
    }
}

#pragma mark - Private

- (void)imageWithSize:(CGSize)size group:(id<NSCopying>)group key:(id<NSCopying>)key completion:(void (^)(UIImage *image))completionBlock{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{

        CGSize fetchSize = CGSizeEqualToSize(CGSizeZero, size) ? self.defaultSize : size;
        
        UIImage *image;
        NSCache *cache = self.caches[group];
        
        if (!cache) {
            cache = [[NSCache alloc] init];
            cache.delegate = self;
            self.caches[group] = cache;
        }
        
        image = [cache objectForKey:key ?: placeholder];
        
        
        if (image) {
            if(completionBlock) completionBlock(image);
            return ;
        }
        else{
            [cache setObject:placeholder forKey:key ?: placeholder];
        }
    
        self.activeDownloads ++;
        NSInteger width = fetchSize.width;
        NSInteger height = fetchSize.height;
        NSString *stringURL = [NSString stringWithFormat:self.urlFormat, width, height];
        NSURL *url = [NSURL URLWithString:stringURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        
        if (image)
            [cache setObject:image forKey:key ?: placeholder];
        else
            [cache removeObjectForKey:key ?: placeholder];
        
        self.activeDownloads --;
        
        if (completionBlock) {
            completionBlock(image);
        }
    }];
    
    operation.queuePriority = NSOperationQueuePriorityNormal;
    
    [self.queue addOperation:operation];
}

+ (TKImageIpsum *)lorem{
    static TKImageIpsum *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[TKImageIpsum alloc] init];
    });
    
    return singleton;
}

- (void)clearCaches{
    for (id key in self.caches) {
        NSCache *cache = self.caches[key];
        [cache removeAllObjects];
    }
}

#pragma mark - Public

+ (void)clearCaches{
    [[TKImageIpsum lorem] clearCaches];
}

+ (void)getRandomImageWithSize:(CGSize)size
                           group:(id<NSCopying>)group
                            key:(id<NSCopying>)key
           withCompletionBlock:(void (^)(UIImage *image))completionBlock{
    [[TKImageIpsum lorem] imageWithSize:size group:group key:key completion:completionBlock];
}

+ (void)getRandomImageWithSize:(CGSize)size key:(id<NSCopying>)key withCompletionBlock:(void (^)(UIImage *image))completionBlock{
    [[TKImageIpsum lorem] imageWithSize:size group:@"group" key:key completion:completionBlock];
}

+ (void)getRandomImageWithSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock{
    [[TKImageIpsum lorem] imageWithSize:size group:@"group" key:@"key" completion:completionBlock];
}

+ (void)getRandomImageWithCompletionBlock:(void (^)(UIImage *image))completionBlock{
    [[TKImageIpsum lorem] imageWithSize:CGSizeZero group:@"group" key:@"key" completion:completionBlock];
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj{
}

@end
