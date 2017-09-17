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

@interface XDSRowModel : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property (copy, nonatomic) NSString *className;
@end
@implementation XDSRowModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedKey = %@", key);
}
@end

@interface XDSSectionModel : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray<XDSRowModel*> *rowModels;
@end
@implementation XDSSectionModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"undefinedKey = %@", key);
    if (![value isKindOfClass:[NSArray class]] || ![key isEqualToString:@"rows"]) {
        return;
    }
    
    NSMutableArray *rowModels = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *aRow in (NSArray *)value) {
        XDSRowModel *rowModel = [[XDSRowModel alloc] init];
        [rowModel setValuesForKeysWithDictionary:aRow];
        [rowModels addObject:rowModel];
    }
    self.rowModels = rowModels;
}
@end


@interface MainTableViewController ()
@property (nonatomic, copy) NSArray<XDSSectionModel*> *dataSource;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self dataInit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XDSSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.rowModels.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    XDSSectionModel *sectionModel = self.dataSource[section];
    return sectionModel.title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellId = @"MainTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    XDSSectionModel *sectionModel = self.dataSource[indexPath.section];
    XDSRowModel *rowModel = sectionModel.rowModels[indexPath.row];
    NSString * title = rowModel.title;
    NSString * subTitle = rowModel.subTitle;
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDSSectionModel *sectionModel = self.dataSource[indexPath.section];
    XDSRowModel *rowModel = sectionModel.rowModels[indexPath.row];
    NSString * className = rowModel.className;
    if (className) {
        Class class = NSClassFromString(className);
        UIViewController * controller = [[class alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        kTipAlert(@"这个模块还接进去，敬请期待~");
    }
}

- (void)dataInit {
    NSArray *dataSource = @[
                            @{
                                @"title":@"UI相关",
                                @"rows":@[
                                        @{@"title":@"iCarousel(轮播库)",
                                          @"subTitle":@"iCarouselViewController",
                                          @"className":@"iCarouselViewController"
                                          },
                                        @{@"title":@"MJPhotoBrowser(图片预览)",
                                          @"subTitle":@"MJPhotoBrowserViewController",
                                          @"className":@"MJPhotoBrowserViewController"
                                          },
                                        @{@"title":@"ZipArchive(文件解压/APP内动态升级)",
                                          @"subTitle":@"DynamicLoadViewController",
                                          @"className":@"DynamicLoadViewController"
                                          },
                                        @{@"title":@"JazzHands(交互动画)",
                                          @"subTitle":@"",
                                          @"className":@""
                                          },
                                        ]
                                
                                },
                            @{
                                @"title":@"功能相关",
                                @"rows":@[
                                        @{@"title":@"ZFPlayer(视频播放器)",
                                          @"subTitle":@"ZFMoviePlayerViewController",
                                          @"className":@"ZFMoviePlayerViewController"
                                          }
                                        ]
                                
                                },
                            @{
                                @"title":@"算法相关",
                                @"rows":@[
                                        @{@"title":@"可视化排序",
                                          @"subTitle":@"XDSVisualSortViewController",
                                          @"className":@"XDSVisualSortViewController"
                                          },
                                        ]
                                
                                },
                            ];
    
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *aData in dataSource) {
        XDSSectionModel *sectionModel = [[XDSSectionModel alloc] init];
        [sectionModel setValuesForKeysWithDictionary:aData];
        [sections addObject:sectionModel];
    }
    self.dataSource = sections;
}
@end
