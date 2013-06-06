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

@end

@implementation TKImageIpsum

- (id)init{
    self = [super init];
    _defaultSize = CGSizeMake(100.0f, 100.0f);
    return self;
}

- (NSString *)urlFormat{
    if (!_urlFormat) {
        _urlFormat = @"http://lorempixel.com/%d/%d";
    }
    return _urlFormat;
}

- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (NSMutableDictionary *)caches{
    if (!_caches) {
        _caches = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _caches;
}

- (void)imageWithSize:(CGSize)size group:(id<NSCopying>)group key:(id<NSCopying>)key completion:(void (^)(UIImage *image))completionBlock{
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
NSLog(@"image for key %@ group %@", key, group);
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
