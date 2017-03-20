//
//  ConfigManager.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/19.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "ConfigManager.h"

@implementation ConfigManager
+ (instancetype)manager {
    static ConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ConfigManager alloc] init];
    });
    return manager;
}


- (instancetype)init{
    if (self = [super init]) {
        self.color = [UIColor whiteColor];
    }
    return self;
}


- (void)setColor:(UIColor *)color{
    _color = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"colorChanged" object:nil];
}

@end
