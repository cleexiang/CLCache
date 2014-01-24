//
//  CLCache.m
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "CLCachePolicy.h"
#import "CLMemoryCache.h"
#import "CLDiskCache.h"

@interface CLCache ()

- (NSString *)generateUIDwithKey:(NSString *)key;

@end

@implementation CLCache

+ (instancetype)cacheWithPolicy:(CLCachePolicy *)policy {
    NSAssert(policy, @"policy must not be nil.");
    CLCache *cache = nil;
    switch (policy.level) {
        case CLCachePolicyMemory:
            cache = [[CLMemoryCache alloc] init];
            break;
        case CLCachePolicyDisk:
            cache = [[CLDiskCache alloc] init];
            break;
        default:
            cache = [[CLMemoryCache alloc] init];
            break;
    }
    cache.policy = policy;
    return cache;
}

- (NSString *)generateUIDwithKey:(NSString *)key {
    const char* string = [key UTF8String];
    unsigned char result[16];
    CC_MD5(string, strlen(string), result);
    NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
    return [hash lowercaseString];
}

- (id)objectForKey:(NSString *)key {
    return nil;
}

- (NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key {
    return nil;
}

- (NSData *)dataForKey:(NSString *)key {
    return nil;
}

- (NSString *)setData:(NSData *)data forKey:(NSString *)key {
    return nil;
}

- (BOOL)removeObjectForKey:(NSString *)key {
    return NO;
}

- (BOOL)removeAllObjects {
    return NO;
}

@end
