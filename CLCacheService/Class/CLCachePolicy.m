//
//  CLCachePolicy.m
//  CLCacheService
//
//  Created by lixiang on 14-1-7.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLCachePolicy.h"

@implementation CLCachePolicy

+ (instancetype)defaultCachePolicy {
    CLCachePolicy *policy = [[CLCachePolicy alloc] init];
    policy.isRefresh = NO;
    policy.expireTime = 120;
    policy.level = CLCachePolicyDisk;
    return policy;
}

- (id)init {
    self = [super init];
    if (self) {

    }
    
    return self;
}

@end
