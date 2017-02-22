//
//  MJPhotoBrowserListView.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/16.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "MJPhotoBrowserListView.h"
#import "MJPhotoBrowserCollectionViewCell.h"

#import "MJPhotoBrowser.h"

@interface MJPhotoBrowserListView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) NSInteger page;
@end

@implementation MJPhotoBrowserListView
NSString * const MJPhotoBrowserCollectionViewCellIdentifier = @"MJPhotoBrowserCollectionViewCell";
NSString * const ImagePrefixUrl = @"http://tnfs.tngou.net/image";

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
        
        _collectionView = ({
            CGFloat selfWidth = CGRectGetWidth(self.bounds);
            //创建一个layout布局类
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            //设置布局方向为垂直流布局
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            //设置每个item的大小
            CGFloat itemMargin = 10;
            CGFloat width = (selfWidth - itemMargin * 4)/3;
            layout.itemSize = CGSizeMake(width, width*4/3);
            //创建collectionView 通过一个布局策略layout来创建
            UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.backgroundColor = [UIColor whiteColor];
            //代理设置
            collectionView.delegate=self;
            collectionView.dataSource=self;
            //注册item类型 这里使用系统的类型
            [self addSubview:collectionView];
            
            [collectionView registerClass:[MJPhotoBrowserCollectionViewCell class]
               forCellWithReuseIdentifier:MJPhotoBrowserCollectionViewCellIdentifier];
            
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchTop)];
            collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(fetchBottom)];
            [collectionView.mj_header beginRefreshing];
            
            collectionView;
        });
    }
    
    return self;
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MJPhotoBrowserCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:MJPhotoBrowserCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    MJPhotoBrowserImageModel * imageModel = _dataArray[indexPath.row];
    [cell cellWithImageModel:imageModel];
    
    //这里先这么处理，比较合理的做法应该是存数据库
    if (!imageModel.imageArray) {
        [self fetchDetailImageListWithImageModel:imageModel finish:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MJPhotoBrowserImageModel * imageModel = _dataArray[indexPath.row];
    if (!imageModel.imageArray) {
        __weak typeof(self)weakSelf = self;
        [self fetchDetailImageListWithImageModel:imageModel finish:^{
            NSLog(@"xxxxxxxxxxxxxxx");
            [weakSelf showPhotoBrowserWithImageModel:imageModel];

        }];
    }else{
        [self showPhotoBrowserWithImageModel:imageModel];
    }
}


//下来刷新
- (void)fetchTop {
    [_collectionView.mj_footer resetNoMoreData];
    [self fetch:NO];
}

//上拉刷新
- (void)fetchBottom {
    [self fetch:YES];
}

#pragma mark - 网络请求
- (void)fetch:(BOOL)isLoadMore{
    NSString * page = isLoadMore?@(_page).stringValue:@"1";
    NSString * url = [@"http://www.tngou.net/tnfs/api/list?id=6&page=" stringByAppendingString:page];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask * task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                        NSLog(@"=========================");
                                        if (error) {
                                        }else{
                                            id result = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableLeaves error:nil];
                                            if ([result isKindOfClass:[NSDictionary class]]) {
                                                NSArray * imageArray = result[@"tngou"];
                                                NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                                                for (NSDictionary * anImage in imageArray) {
                                                    NSString * imageId = anImage[@"id"];
                                                    NSString * imageSrc = anImage[@"img"];
                                                    NSString * title = anImage[@"title"];
                                                    imageSrc = imageSrc?imageSrc:@"";
                                                    if (![imageSrc hasPrefix:@"http"]) {
                                                        imageSrc = [ImagePrefixUrl stringByAppendingString:imageSrc];
                                                    }
                                                    MJPhotoBrowserImageModel * imageModel = [[MJPhotoBrowserImageModel alloc] init];
                                                    imageModel.imageId = imageId?[NSString stringWithFormat:@"%@", imageId]:@"";
                                                    imageModel.imageScr = imageSrc?imageSrc:@"";
                                                    
                                                    imageModel.title = title?title:@"";
                                                    [array addObject:imageModel];
                                                }
                                                
                                                if (!isLoadMore) {
                                                    _page = 1;
                                                    [_dataArray removeAllObjects];
                                                }else if (array.count == 0){
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [_collectionView.mj_footer endRefreshingWithNoMoreData];
                                                    });
                                                }
                                                [_dataArray addObjectsFromArray:array];

                                                _page += 1;
                                            }
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [_collectionView.mj_header endRefreshing];
                                            [_collectionView.mj_footer endRefreshing];
                                            [_collectionView reloadData];
                                            [self configBlankPage:EaseBlankPageTypePhotos
                                                          hasData:_dataArray.count > 0
                                                         hasError:error != nil
                                                reloadButtonBlock:^(id sender) {
                                                    [_collectionView.mj_header beginRefreshing];
                                                    
                                                } clickButtonBlock:nil];
                                        });
                                        
                                    }];
    [task resume];
    
}




- (void)fetchDetailImageListWithImageModel:(MJPhotoBrowserImageModel *)imageModel finish:(void(^)())finish{
    NSString * url = [@"http://www.tngou.net/tnfs/api/show?id=" stringByAppendingString:imageModel.imageId];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDataTask * task =
    [[NSURLSession sharedSession] dataTaskWithRequest:request
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                        NSLog(@"||||||||||||||||||||||||||||||||||||||||");
                                        if (error) {
                                        }else{
                                            id result = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableLeaves error:nil];
                                            if ([result isKindOfClass:[NSDictionary class]]) {
                                                NSArray * imageArray = result[@"list"];
                                                imageModel.imageArray = imageArray;
                                            }
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (finish) {
                                                finish();
                                            }
                                        });
                                        
                                    }];
    [task resume];
    
}




#pragma mark - MJPhotoBrowser库关键代码
- (void)showPhotoBrowserWithImageModel:(MJPhotoBrowserImageModel *)imageModel {
    //显示大图
    int count = (int)imageModel.imageArray.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSDictionary *imageItem = imageModel.imageArray[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString * scr = imageItem[@"src"];
        if (![scr hasPrefix:@"http"]) {
            scr = [ImagePrefixUrl stringByAppendingString:scr];
        }
        photo.url = [NSURL URLWithString:scr]; // 图片路径
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.showSaveBtn = NO;
    [browser show];
}
@end
