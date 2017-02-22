//
//  iCarouselTableView.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "iCarouselTableView.h"

@interface iCarouselTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UIImageView * headerBackgroundView;

@property (assign, nonatomic) NSInteger rowCount;
@end

@implementation iCarouselTableView

NSString * const iCarouselTableViewCellIdentifier = @"iCarouselTableViewCell";
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _tableView = ({
            UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:iCarouselTableViewCellIdentifier];
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            MJRefreshHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            [header beginRefreshing];
            tableView.mj_header = header;
            tableView;
        });
        
        
        _headerBackgroundView = ({
            CGRect frame = self.bounds;
            frame.size.height = 200;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.image = [UIImage imageNamed:@"8.jpg"];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;

            UIView * headerView = [[UIView alloc] initWithFrame:imageView.bounds];
            [headerView addSubview:imageView];
            
//            self.tableView.tableHeaderView = headerView;
            imageView;
        });
        
        [_tableView bringSubviewToFront:_tableView.mj_header];
    }
    return self;
}


- (void)refresh{
    [self performSelector:@selector(endRefresh)
                               withObject:nil
                               afterDelay:3];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rowCount*5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iCarouselTableViewCellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];
    return cell;
}

//表头背景图片缩放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat originalHeight = 200;
    CGRect eaFrame = CGRectMake(0, MIN(0, offsetY), CGRectGetWidth(_headerBackgroundView.frame), MAX(originalHeight, originalHeight - offsetY));
    _headerBackgroundView.frame = eaFrame;
}

- (void)endRefresh {
    _rowCount = arc4random()%2;
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
    __weak typeof(self)weakSelf = self;
    [self configBlankPage:EaseBlankPageTypeViewiCarousel
                  hasData:_rowCount > 0
                 hasError:arc4random()%2
        reloadButtonBlock:^(id sender) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }clickButtonBlock:^(EaseBlankPageType type) {
            NSLog(@"type = %zd", type);
        }];
    
//    [self configBlankPage:EaseBlankPageTypeBank_SEARCH
//                  hasData:_rowCount > 0
//                 hasError:YES
//                  offsetY:20
//        reloadButtonBlock:^(id sender) {
//            [weakSelf.tableView.mj_header beginRefreshing];
//        }clickButtonBlock:^(EaseBlankPageType type) {
//            NSLog(@"type = %zd", type);
//        }];
}

@end
