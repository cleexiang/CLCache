//
//  CLDiskCache.h
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLCache.h"

@interface CLDiskCache : CLCache

- (NSString *)absolutePathOfCacheWithKey:(NSString *)key;

- (BOOL)existCacheForKey:(NSString *)key path:(NSString **)path;

@end
