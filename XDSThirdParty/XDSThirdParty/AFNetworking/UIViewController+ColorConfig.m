//
//  UIViewController+ColorConfig.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/20.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "UIViewController+ColorConfig.h"
#import "XDSSwizzing.h"
@implementation UIViewController (ColorConfig)

+ (void)load{
    [XDSSwizzing swizzingInstanceMethodByClass:UIViewController.self
                                originSelector:@selector(viewDidLoad)
                              swizzingSelector:@selector(xds_viewDidLoad)];
}

- (void)dealloc{
    NSLog(@"UIViewController (ColorConfig) ===== dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)xds_viewDidLoad{
    [self xds_viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reLayout:) name:@"colorChanged"
                                               object:nil];
}



- (void)reLayout:(NSNotification *)notification{
    NSLog(@"xxxxxxxxx");
    [self.view layoutIfNeeded];
}
@end
