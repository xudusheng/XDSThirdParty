//
//  XDSSPAppDelegate.m
//  XDSShellProject
//
//  Created by Hmily on 2017/3/25.
//  Copyright © 2017年 xudusheng. All rights reserved.
//

#import "XDSSPAppDelegate.h"
#import "XDSShellProject.h"
#import <objc/runtime.h>
#if HasModuleManager
#import <XDSModuleManager/XDSModuleManager.h>
#endif

@implementation XDSSPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self registerModules];
    [self launchModulesWithApplication:application options:launchOptions];
    
    NSAssert(self.class.rootViewControllerClassString, @"请设置初始化类的名称");
    NSAssert(NSClassFromString(self.class.rootViewControllerClassString), @"没有找到名为%@类", self.class.rootViewControllerClassString);
    
    UIViewController *rootViewController = nil;
    if (self.class.rootViewControllerClassString) {
        Class cls = NSClassFromString(self.class.rootViewControllerClassString);
        if (cls) {
            rootViewController = [cls new];
        }
    }
    self.window.rootViewController = rootViewController;
    self.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

//注册模块相关的服务
- (void)registerModules {
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        [module registerServices];
    }];
#endif
}


- (void)launchModulesWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [module application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(applicationWillResignActive:)]) {
            [module applicationWillResignActive:application];
        }
    }];
#endif
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [module applicationDidEnterBackground:application];
        }
    }];
#endif
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(applicationWillEnterForeground:)]) {
            [module applicationWillEnterForeground:application];
        }
    }];
#endif
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [module applicationDidBecomeActive:application];
        }
    }];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application{
#if HasModuleManager
    [[[XDSModuleManager sharedInstance] modules] enumerateObjectsUsingBlock:^(id<XDSModuleManagerProtocol> module, NSUInteger idx, BOOL * stop) {
        if ([module respondsToSelector:@selector(applicationWillTerminate:)]) {
            [module applicationWillTerminate:application];
        }
    }];
#endif
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication{

    return YES;
}

# pragma mark - 组件
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

static NSString *_rootViewControllerClassString = nil;
+ (void)setRootViewControllerClassString:(NSString *)rootViewControllerClassString {
    _rootViewControllerClassString = [rootViewControllerClassString copy];
}

+ (NSString *)rootViewControllerClassString {
    return _rootViewControllerClassString;
}



@end
