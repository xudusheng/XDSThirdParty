//
//  BlankViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/3/26.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "BlankViewController.h"
#import "DynamicLoadViewController.h"
@interface BlankViewController ()

@end

@implementation BlankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DynamicLoadViewController * dy = [[DynamicLoadViewController alloc] init];
    [self.navigationController pushViewController:dy animated:YES];
}

@end
