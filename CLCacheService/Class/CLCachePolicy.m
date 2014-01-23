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
    return policy;
}

- (id)init {
    self = [super init];
    if (self) {
        self.isRefresh = NO;
        self.expireTime = 120;
    }
    
    return self;
}

@end
