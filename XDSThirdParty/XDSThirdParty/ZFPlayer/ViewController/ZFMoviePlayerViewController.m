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
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (strong, nonatomic) UIView *fatherView;
@end

@implementation ZFMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.fatherView = [[UIView alloc] initWithFrame:CGRectZero];
    self.fatherView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.fatherView];
    
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fenghuaxueyue" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    ZFPlayerModel *playerModel                  = [[ZFPlayerModel alloc] init];
    playerModel.title            = @"风花雪月";
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
    playerModel.fatherView       = self.fatherView;
    

    self.playerView = [[ZFPlayerView alloc] init];
    
    /*****************************************************************************************
     *   // 指定控制层(可自定义)
     *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
     *   // 设置控制层和播放模型
     *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
     *   // 等效于 [_playerView playerModel:self.playerModel];
     ******************************************************************************************/
    [self.playerView playerControlView:nil playerModel:playerModel];
    
    // 设置代理
//    playerView.delegate = self;
    
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
    
    // 打开下载功能（默认没有这个功能）
    self.playerView.hasDownload    = NO;
    
    // 打开预览图
    self.playerView.hasPreviewView = YES;
    
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp4"];
//    NSURL *videoURL = [NSURL fileURLWithPath:path];
//    ZFPlayerModel *playerModel                  = [[ZFPlayerModel alloc] init];
//    playerModel.title            = @"第三集";
//    playerModel.videoURL         = videoURL;
//    playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
//    playerModel.fatherView       = self.fatherView;
//    
//    [self.playerView resetPlayer];
//    [self.playerView playerControlView:nil playerModel:playerModel];
//
//}

@end
