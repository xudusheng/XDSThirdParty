//
//  MainTableViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "MainTableViewController.h"
#import "iCarouselViewController.h"
typedef NS_ENUM(NSUInteger, MainTableViewRow) {
    MainTableViewRowICarousel = 0,
};

static NSString * const CellTitles[] = {
    [MainTableViewRowICarousel]       = @"iCarousel",
};

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (MainTableViewRowICarousel == indexPath.row) {
        iCarouselViewController * iCarouselVC = [[iCarouselViewController alloc] init];
        [self.navigationController pushViewController:iCarouselVC animated:YES];
    }
    
    
}


@end