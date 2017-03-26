//
//  XDSSPAppDelegate.h
//  XDSShellProject
//
//  Created by Hmily on 2017/3/25.
//  Copyright © 2017年 xudusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSSPAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;

@property (class, nonatomic, copy) NSString *rootViewControllerClassString;

@end
