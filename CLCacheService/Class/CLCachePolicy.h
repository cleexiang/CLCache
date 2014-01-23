//
//  CLCachePolicy.h
//  CLCacheService
//
//  Created by lixiang on 14-1-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CLCachePolicyLevel) {
    CLCachePolicyMemory,
    CLCachePolicyMemoryToDisk,
    CLCachePolicyDisk
};

/**
 *  缓存策略类
 */
@interface CLCachePolicy : NSObject

/**
 *  force refresh data(YES/NO), default is NO.
 */
@property (nonatomic, assign) BOOL                  isRefresh;
/**
 *  expire time of cache
 */
@property (nonatomic, assign) NSTimeInterval        expireTime;
/**
 *  cached in memory or disk
 */
@property (nonatomic, assign) CLCachePolicyLevel    level;

+ (instancetype)defaultCachePolicy;

@end
