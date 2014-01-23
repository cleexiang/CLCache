//
//  CLMemoryCache.h
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLCache.h"

@interface CLMemoryCache : CLCache

@property (nonatomic, strong) NSCache *cache;

@end
