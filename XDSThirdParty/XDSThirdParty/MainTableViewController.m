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
    MainTableViewRowICarousel = 0,
    MainTableViewRowMJPhotoBrowser,
};

static NSString * const CellTitles[] = {
    [MainTableViewRowICarousel]       = @"iCarousel",
    [MainTableViewRowMJPhotoBrowser]  = @"MJPhotoBrowser",

};

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (MainTableViewRowICarousel == indexPath.row) {
        iCarouselViewController * iCarouselVC = [[iCarouselViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:iCarouselVC animated:YES];
        
    }else if (MainTableViewRowMJPhotoBrowser == indexPath.row) {
        MJPhotoBrowserViewController * MJPhotoBrowserVC = [[MJPhotoBrowserViewController alloc] init];
        [self.navigationController pushViewController:MJPhotoBrowserVC animated:YES];
    }
    
    
}


@end
