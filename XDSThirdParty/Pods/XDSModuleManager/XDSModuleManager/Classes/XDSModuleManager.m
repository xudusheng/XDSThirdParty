//
//  XDSModuleManager.m
//  XDSShellProject
//
//  Created by Hmily on 2017/3/25.
//  Copyright © 2017年 xudusheng. All rights reserved.
//

#import "XDSModuleManager.h"
#import <objc/runtime.h>

/**
 *  添加模块到数组中
 *  在子类 +load 方法中调用。
 */
void XDSRegisterModule(Class moduleClass) {
    if (!moduleClass) { return; }
    if (!class_conformsToProtocol(moduleClass, @protocol(XDSModuleManagerProtocol))) { return; }
    [[[XDSModuleManager sharedInstance] modules] addObject:[moduleClass new]];
}



//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
@interface XDSModuleManager ()

@property (nonatomic, strong) NSMutableArray<id<XDSModuleManagerProtocol>> *modules;

@end
@implementation XDSModuleManager

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray *)modules {
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}

@end



//-----------------------------------------------------------------
//-----------------------------------------------------------------
//-----------------------------------------------------------------
@interface XDSRootModuleManager ()
@end
@implementation XDSRootModuleManager

//注册模块提供的服务(也就是注册其公开 protocol 的 handler), 在 app 生命周期中最早被调用
- (void)registerServices{};

/// 暂时不关心返回了什么 (应不应该 handle launchOptions 里的 url 等)
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{}

- (void)applicationWillEnterForeground:(UIApplication *)application{}

- (void)applicationDidBecomeActive:(UIApplication *)application{}

- (void)applicationWillResignActive:(UIApplication *)application{}

- (void)applicationDidEnterBackground:(UIApplication *)application{}

- (void)applicationWillTerminate:(UIApplication *)application{};

@end
