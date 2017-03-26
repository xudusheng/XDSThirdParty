//
//  UIViewController+XDSAddition.m
//  XDSKit
//
//  Created by Hmily on 2017/2/28.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "UIViewController+XDSAddition.h"
#import <objc/runtime.h>
@implementation UIViewController (XDSAddition)

#pragma mark - 是否隐藏UINavigationBar

void hideNavigationBar_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    char *swizzledTypes = (char *)method_getTypeEncoding(swizzledMethod);
    
    IMP originalImp = method_getImplementation(originalMethod);
    char *originalTypes = (char *)method_getTypeEncoding(originalMethod);
    BOOL success = class_addMethod(class,
                                   originalSelector,
                                   swizzledImp,
                                   swizzledTypes);
    if (success) {
        class_replaceMethod(class,
                            swizzledSelector,
                            originalImp,
                            originalTypes);
    }else {
        // 添加失败，表明已经有这个方法，直接交换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

//ShareSDK中会有问题，短信分享的导航栏按钮无法响应
+ (void)load{
    hideNavigationBar_swizzleMethod(self,
                  @selector(viewWillAppear:),
                  @selector(hideNavigationBar_ViewWillAppear:));
}

- (void)hideNavigationBar_ViewWillAppear:(BOOL)animated{
    [self hideNavigationBar_ViewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.hidesTopBarWhenPushed
                                             animated:YES];
}


char * hidesTopBarWhenPushedKey = "hidesTopBarWhenPushed";
- (void)setHidesTopBarWhenPushed:(BOOL)hidesTopBarWhenPushed{
    objc_setAssociatedObject(self,
                             hidesTopBarWhenPushedKey,
                             @(hidesTopBarWhenPushed),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hidesTopBarWhenPushed{
    id hidesTopBarWhenPushed = objc_getAssociatedObject(self, hidesTopBarWhenPushedKey);
    return [hidesTopBarWhenPushed boolValue];
}



#pragma mark - 获取当前可见ViewController
+ (UIViewController *)xds_visiableViewController {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [UIViewController xds_topViewControllerForViewController:rootViewController];
}

+ (UIViewController *)xds_topViewControllerForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self xds_topViewControllerForViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)viewController visibleViewController];
    } else {
        if (viewController.presentedViewController) {
            return [self xds_topViewControllerForViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}

@end
