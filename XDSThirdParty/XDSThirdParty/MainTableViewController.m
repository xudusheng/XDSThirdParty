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

typedef NS_ENUM(NSUInteger, MainTableViewSection) {
    MainTableViewSectionThirdParty = 0,
    MainTableViewSectionCustom,
};

static NSString * const SectionTitles[] = {
    [MainTableViewSectionThirdParty] = @"第三方库",
    [MainTableViewSectionCustom] = @"自定义",
};
typedef NS_ENUM(NSUInteger, MainTableViewThirdPartyRow) {
    MainTableViewThirdPartyRowAFNetworking = 0,
    MainTableViewThirdPartyRowICarousel,
    MainTableViewThirdPartyRowMJPhotoBrowser,
    MainTableViewThirdPartyRowDynamicLoad,
    MainTableViewThirdPartyRowJazzHands,
};

typedef NS_ENUM(NSUInteger, MainTableViewCustomRow) {
    MainTableViewCustomRowPlayer = 0,
};

static NSString * const CellTitles[2][5] = {
    [MainTableViewSectionThirdParty] = {
        [MainTableViewThirdPartyRowAFNetworking]    = @"AFNetworking(Web Request)",
        [MainTableViewThirdPartyRowICarousel]       = @"iCarousel(轮播库)",
        [MainTableViewThirdPartyRowMJPhotoBrowser]  = @"MJPhotoBrowser(图片预览)",
        [MainTableViewThirdPartyRowDynamicLoad]     = @"ZipArchive(文件解压/APP内动态升级)",
        [MainTableViewThirdPartyRowJazzHands]       = @"JazzHands(交互动画)",
    },
    
    [MainTableViewSectionCustom] = {
        [MainTableViewCustomRowPlayer]              = @"AVPlayer(自定义播放器样式)",
    },
};

static NSString * const CellSubTitles[2][5] = {
    [MainTableViewSectionThirdParty] = {
        [MainTableViewThirdPartyRowAFNetworking]    = @"aFNetworkingViewController",
        [MainTableViewThirdPartyRowICarousel]       = @"iCarouselViewController",
        [MainTableViewThirdPartyRowMJPhotoBrowser]  = @"MJPhotoBrowserViewController",
        [MainTableViewThirdPartyRowDynamicLoad]     = @"DynamicLoadViewController",
        //    [MainTableViewThirdPartyRowJazzHands] = @"",
    },
    [MainTableViewSectionCustom] = {
        [MainTableViewCustomRowPlayer]              = @"XDSVideoPlayerViewController",
    },
};

@interface MainTableViewController ()@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sizeof(SectionTitles)/sizeof(SectionTitles[0]);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    NSString * title = CellTitles[section][rows];
    while (title) {
        rows++;
        title = CellTitles[section][rows];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"MainTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }

    NSString * title = CellTitles[indexPath.section][indexPath.row];
    NSString * subTitle = CellSubTitles[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * className = CellSubTitles[indexPath.section][indexPath.row];
    if (className) {
        Class class = NSClassFromString(className);
        UIViewController * controller = [[class alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        kTipAlert(@"这个模块还接进去，敬请期待~");
    }
}

@end
