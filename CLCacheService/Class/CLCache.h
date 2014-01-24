//
//  CLCache.h
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLCachePolicy;
@interface CLCache : NSObject

@property (nonatomic, strong) CLCachePolicy *policy;

+ (instancetype)cacheWithPolicy:(CLCachePolicy *)policy;

- (NSString *)generateUIDwithKey:(NSString *)key;

/**
 *
 *
 *  @param key
 *
 *  @return object
 */
- (id)objectForKey:(NSString *)key;
/**
 *
 *
 *  @param data
 *  @param key
 *
 *  @return
 */
- (NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key;
/**
 *  return data
 *
 *  @param key
 *
 *  @return data
 */
- (NSData *)dataForKey:(NSString *)key;
/**
 *  Description
 *
 *  @param data
 *  @param key
 *
 *  @return
 */
- (NSString *)setData:(NSData *)data forKey:(NSString *)key;
/**
 *  remove object with key
 *
 *  @param key
 *
 *  @return success
 */
- (BOOL)removeObjectForKey:(NSString *)key;

/**
 *  remove all cache data
 *
 *  @return
 */
- (BOOL)removeAllObjects;

@end
