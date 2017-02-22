//
//  MainTableViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "MainTableViewController.h"
#import "iCarouselViewController.h"
#import "MJPhotoBrowserViewController.h"
typedef NS_ENUM(NSUInteger, MainTableViewRow) {
    MainTableViewRowAFNetworking = 0,
    MainTableViewRowICarousel,
    MainTableViewRowMJPhotoBrowser,
};

static NSString * const CellTitles[] = {
    [MainTableViewRowAFNetworking]    = @"aFNetworkingViewController",
    [MainTableViewRowICarousel]       = @"iCarouselViewController",
    [MainTableViewRowMJPhotoBrowser]  = @"MJPhotoBrowserViewController",

};

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * className = CellTitles[indexPath.row];
    if (className) {
        Class class = NSClassFromString(className);
        UIViewController * controller = [[class alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        kTipAlert(@"这个模块还接进去，敬请期待~");
    }
}

@end
