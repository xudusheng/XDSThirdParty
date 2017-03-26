//
//  MainNavigationController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/26.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "MainNavigationController.h"
#import "MainTableViewController.h"
@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    ({
        MainTableViewController * mainVC = [[MainTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        self.viewControllers = @[mainVC];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
