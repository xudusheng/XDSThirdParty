//
//  iCarouselTableView.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "iCarouselTableView.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
@interface iCarouselTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView * tableView;
@end

@implementation iCarouselTableView

NSString * const iCarouselTableViewCellIdentifier = @"iCarouselTableViewCell";
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _tableView = ({
            UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:iCarouselTableViewCellIdentifier];
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            MJRefreshHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
            tableView.mj_header = header;
            tableView;
        });
    }
    return self;
}


- (void)refresh{
    [_tableView.mj_header performSelector:@selector(endRefreshing)
                               withObject:nil
                               afterDelay:3];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iCarouselTableViewCellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];
    return cell;
}

@end
