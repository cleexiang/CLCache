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

+ (BOOL)existCacheForKey:(NSString *)key;

/**
 *  读取缓存
 *
 *  @param key 缓存的键值
 *
 *  @return 缓存数据
 */
- (id)objectForKey:(NSString *)key;

/**
 *
 *
 *  @param data 数据
 *  @param key 键值
 *
 *  @return 是否成功
 */
- (NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key;

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
 *  @return 是否成功
 */
- (BOOL)removeAllObjects;

@end
