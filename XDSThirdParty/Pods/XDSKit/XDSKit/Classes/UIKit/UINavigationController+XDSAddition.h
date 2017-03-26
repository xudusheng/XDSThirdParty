//
//  UINavigationController+XDSAddition.h
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (XDSAddition)

/**
 *
 *  @param controllerClass viewController‘s class name
 *  @param animated        动画
 
 *  pop到指定的ViewControllerClass，如果有重复的，那么是最靠近栈顶的视图
 *  example: [self.navigationController popToViewControllerWithClass:NSClassFromString(@"XDSSettingViewController")
 *                                                          animated:YES];
 */
- (NSArray *)popToViewControllerWithClass:(Class)controllerClass animated:(BOOL)animated;


@end
