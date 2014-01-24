//
//  CLMemoryCache.m
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLMemoryCache.h"
#import <objc/runtime.h>
#import "CLCachePolicy.h"

@implementation CLMemoryCache

- (id)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    id object = [self.cache objectForKey:identifier];
    NSNumber *expireTime = objc_getAssociatedObject(object, @"expireTime");
    long currentTime = (long)[[NSDate date] timeIntervalSince1970];
    if (currentTime > [expireTime longValue]) {
        [self.cache removeObjectForKey:key];
        return nil;
    } else {
        return object;
    }
}

- (NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    return [self setObject:object expireTime:self.policy.expireTime withIdentifier:identifier];
}

- (NSString *)setObject:(id <NSCoding>)object expireTime:(NSTimeInterval)expireTime withIdentifier:(NSString *)identifier {
    long currentTime = (long)[[NSDate date] timeIntervalSince1970];
    objc_setAssociatedObject(object, @"expireTime", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(object, @"expireTime", @(currentTime+expireTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.cache setObject:object forKey:identifier];
    return nil;
}

- (NSData *)dataForKey:(NSString *)key {
    return [self objectForKey:key];
}

- (NSString *)setData:(NSData *)data forKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    return [self setObject:data expireTime:self.policy.expireTime withIdentifier:identifier];
}

- (BOOL)removeObjectForKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    [self.cache removeObjectForKey:(id)identifier];
    return YES;
}

- (BOOL)removeAllObjects {
    [self.cache removeAllObjects];
    return YES;
}

@end
