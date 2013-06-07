//
//  TKImageIpsum.h
//
//  Created by Tomasz Kuźma on 5/16/13.
//  Copyright (c) 2013 mapedd@mapedd.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKImageIpsum : NSObject <NSCacheDelegate>

/* Method to get the singleton instance */
+ (TKImageIpsum *)lorem;

/* Method to clear all caches */
+ (void)clearCaches;

/* Method to clear image cache for given group */
+ (void)clearCachesForGroup:(id<NSCopying>)group;

+ (void)getRandomImageWithCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (void)getRandomImageWithSize:(CGSize)size withCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (void)getRandomImageWithSize:(CGSize)size key:(id<NSCopying>)key withCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (void)getRandomImageWithSize:(CGSize)size group:(id<NSCopying>)group key:(id<NSCopying>)key withCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (void)getRandomImageWithSize:(CGSize)size urlFormat:(NSString *)urlFormat group:(id<NSCopying>)group key:(id<NSCopying>)key withCompletionBlock:(void (^)(UIImage *image))completionBlock;

/* Default is http://lorempixel.com/%d/%d */
@property (nonatomic, copy) NSString *urlFormat;

/* Default is 100 x 100 */
@property (nonatomic, assign) CGSize defaultSize;

@end
