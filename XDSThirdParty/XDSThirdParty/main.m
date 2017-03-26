//
//  main.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XDSSPAppDelegate.h"
int main(int argc, char * argv[]) {
    @autoreleasepool {
        XDSSPAppDelegate.rootViewControllerClassString = @"MainNavigationController";
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([XDSSPAppDelegate class]));
    }
}
