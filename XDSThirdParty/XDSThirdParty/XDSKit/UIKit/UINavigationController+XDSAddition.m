//
//  UINavigationController+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "UINavigationController+XDSAddition.h"

@implementation UINavigationController (XDSAddition)

- (NSArray *)popToViewControllerWithClass:(Class)controllerClass animated:(BOOL)animated {
    __block NSArray *viewControllers = nil;
    [self.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                           usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                               if ([obj isKindOfClass:controllerClass]) {
                                                   viewControllers = [self popToViewController:obj animated:animated];
                                                   *stop = YES;
                                               }
                                           }];
    
    return viewControllers;
}

@end
