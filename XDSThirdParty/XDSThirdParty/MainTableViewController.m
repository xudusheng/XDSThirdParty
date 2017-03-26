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
    MainTableViewRowDynamicLoad,
    MainTableViewRowJazzHands,
};


static NSString * const CellTitles[] = {
    [MainTableViewRowAFNetworking]    = @"AFNetworking(Web Request)",
    [MainTableViewRowICarousel]       = @"iCarousel(轮播库)",
    [MainTableViewRowMJPhotoBrowser]  = @"MJPhotoBrowser(图片预览)",
    [MainTableViewRowDynamicLoad] = @"ZipArchive(文件解压/APP内动态升级)",
    [MainTableViewRowJazzHands] = @"JazzHands(交互动画)",
};

static NSString * const CellSubTitles[] = {
    [MainTableViewRowAFNetworking]    = @"aFNetworkingViewController",
    [MainTableViewRowICarousel]       = @"iCarouselViewController",
    [MainTableViewRowMJPhotoBrowser]  = @"MJPhotoBrowserViewController",
    [MainTableViewRowDynamicLoad] = @"DynamicLoadViewController",
    //    [MainTableViewRowJazzHands] = @"",
};

@interface MainTableViewController ()@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"MainTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }

    NSString * title = CellTitles[indexPath.row];
    NSString * subTitle = CellSubTitles[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * className = CellSubTitles[indexPath.row];
    if (className) {
        Class class = NSClassFromString(className);
        UIViewController * controller = [[class alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        kTipAlert(@"这个模块还接进去，敬请期待~");
    }
}

@end
