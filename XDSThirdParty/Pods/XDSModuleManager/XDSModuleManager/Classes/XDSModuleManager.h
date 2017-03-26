//
//  XDSModuleManager.h
//  XDSShellProject
//
//  Created by Hmily on 2017/3/25.
//  Copyright © 2017年 xudusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol XDSModuleManagerProtocol <NSObject>
//注册模块提供的服务(也就是注册其公开 protocol 的 handler), 在 app 生命周期中最早被调用
- (void)registerServices;

/// 暂时不关心返回了什么 (应不应该 handle launchOptions 里的 url 等)
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillResignActive:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

@end

@interface XDSModuleManager : NSObject

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (NSMutableArray<id<XDSModuleManagerProtocol>> *)modules;

@end



@interface XDSRootModuleManager : NSObject<XDSModuleManagerProtocol>

@end
