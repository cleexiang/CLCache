//
//  CLDishCache.m
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLDiskCache.h"
#import "CLCachePolicy.h"

#ifndef kCachePath
    #define kCachePath @"/clCacheData"
#endif

@implementation CLDiskCache

- (NSString *)absolutePathOfCacheWithKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    for (NSString *fileName in files) {
        if ([fileName hasPrefix:identifier]) {
            return [cachePath stringByAppendingPathComponent:fileName];
        }
    }
    return nil;
}

- (BOOL)existCacheForKey:(NSString *)key path:(NSString **)path {
    NSString *p = [self absolutePathOfCacheWithKey:key];
    if (p) {
        *path = p;
        return YES;
    } else {
        *path = nil;
        return NO;
    }
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    NSError *error = nil;
    NSString *identifier = [self generateUIDwithKey:key];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    for (NSString *fileName in files) {
        if ([fileName hasPrefix:identifier]) {
            NSArray *arr = [fileName componentsSeparatedByString:@"_"];
            long lastTime = 0;
            if (arr && [arr count] == 2) {
                lastTime = [arr[1] longValue];
            }
            long currentTime = (long)[[NSDate date] timeIntervalSince1970];
            if (currentTime > lastTime) {
                [[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName]
                                                           error:nil];
                return nil;
            } else {
                return [NSKeyedUnarchiver unarchiveObjectWithFile:[cachePath stringByAppendingPathComponent:fileName]];
            }
        }
    }
    return nil;
}

- (NSData *)dataForKey:(NSString *)key {
    NSError *error = nil;
    NSString *identifier = [self generateUIDwithKey:key];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    for (NSString *fileName in files) {
        if ([fileName hasPrefix:identifier]) {
            NSArray *arr = [fileName componentsSeparatedByString:@"_"];
            long lastTime = 0;
            if (arr && [arr count] == 2) {
                lastTime = [arr[1] longValue];
            }
            long currentTime = (long)[[NSDate date] timeIntervalSince1970];
            if (currentTime > lastTime) {
                [[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName]
                                                           error:nil];
                return nil;
            } else {
                return [NSData dataWithContentsOfFile:[cachePath stringByAppendingPathComponent:fileName]];
            }
        }
    }
    return nil;
}

- (NSString *)setObject:(id <NSCoding>)object forKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    return [self setObject:object expireTime:self.policy.expireTime withIdentifier:identifier];
}

- (NSString *)setObject:(id <NSCoding>)object expireTime:(NSTimeInterval)expireTime withIdentifier:(NSString *)identifier {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    NSError *err = nil;
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&err];
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%.0f", identifier, time+expireTime]];
    BOOL success = [NSKeyedArchiver archiveRootObject:object toFile:path];
    
    if (success) {
        return path;
    } else {
        return nil;
    }
}

- (NSString *)setData:(NSData *)data forKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    return [self setData:data expireTime:self.policy.expireTime withIdentifier:identifier];
}

- (NSString *)setData:(NSData *)data expireTime:(NSTimeInterval)expireTime withIdentifier:(NSString *)identifier {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    NSError *err = nil;
    if (!isExist) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&err];
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%.0f", identifier, time+expireTime]];
    BOOL success = [data writeToFile:path
                             options:NSDataWritingAtomic
                               error:&err];
    
    if (success) {
        return path;
    } else {
        return nil;
    }
}

- (BOOL)removeObjectForKey:(NSString *)key {
    NSString *identifier = [self generateUIDwithKey:key];
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    NSError *err = nil;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:&err];
    if (err) {
        NSLog(@"%@", [err localizedDescription]);
    } else {
        for (NSString *fileName in files) {
            if ([fileName hasPrefix:identifier]) {
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName] error:&err];
                return success;
            }
        }
    }
    return NO;
}

- (BOOL)removeAllObjects {
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kCachePath];
    NSError *err = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&err];
    return success;
}

@end
