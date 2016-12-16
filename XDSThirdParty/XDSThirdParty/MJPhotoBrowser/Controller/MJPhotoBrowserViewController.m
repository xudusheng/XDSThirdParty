//
//  MJPhotoBrowserViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/16.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "MJPhotoBrowserViewController.h"

#import "MJPhotoBrowserListView.h"
@interface MJPhotoBrowserViewController ()
@end

@implementation MJPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MJPhotoBrowserListView * listView = [[MJPhotoBrowserListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:listView];

}


@end
