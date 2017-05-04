//
//  ZFMoviePlayerViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2017/5/5.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "ZFMoviePlayerViewController.h"
#import "ZFPlayer.h"
@interface ZFMoviePlayerViewController ()

@end

@implementation ZFMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UIView *fatherView = [[UIView alloc] initWithFrame:CGRectZero];
    fatherView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:fatherView];
    
    [fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    ZFPlayerModel *playerModel                  = [[ZFPlayerModel alloc] init];
    playerModel.title            = @"这里设置视频标题";
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
    playerModel.fatherView       = fatherView;
}



@end
