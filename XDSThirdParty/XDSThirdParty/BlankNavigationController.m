//
//  BlankNavigationController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/26.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "BlankNavigationController.h"
#import "BlankViewController.h"
@interface BlankNavigationController ()

@end

@implementation BlankNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    BlankViewController * blankVC = [[BlankViewController alloc] init];
    blankVC.view.backgroundColor = [UIColor yellowColor];
    self.viewControllers = @[blankVC];
}


@end
