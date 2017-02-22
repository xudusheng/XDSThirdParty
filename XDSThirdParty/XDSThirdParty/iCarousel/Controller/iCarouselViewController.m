//
//  iCarouselViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "iCarouselViewController.h"
#import <iCarousel/iCarousel.h>
#import "iCarouselTableView.h"

@interface iCarouselViewController ()
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation iCarouselViewController
NSString * const iCarouselViewTableViewCellIdentifier = @"iCarouselViewTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [@[
                    @{@"title":@"Android Fragement", @"className":@"AndroidFragementViewController"},
                    @{@"title":@"仿iOS多任务管理器", @"className":@"MultiTaskManagerViewController"},
                    ] mutableCopy];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:iCarouselViewTableViewCellIdentifier];
        
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iCarouselViewTableViewCellIdentifier];
    
    NSDictionary * info = _dataArray[indexPath.row];
    cell.textLabel.text = info[@"title"];
    cell.detailTextLabel.text = info[@"className"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * info = _dataArray[indexPath.row];
    NSString * className = info[@"className"];
    Class class = NSClassFromString(className);
    UIViewController * controller = (UIViewController *)[[class alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}

@end
