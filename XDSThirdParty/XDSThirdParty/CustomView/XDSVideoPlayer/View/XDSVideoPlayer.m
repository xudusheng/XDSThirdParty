//
//  XDSVideoPlayer.m
//  XDSThirdParty
//
//  Created by dusheng.xu on 2017/4/1.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "XDSVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(NSInteger, XDSVideoPlayerType) {
    XDSVideoPlayerTypeFull = 0,//在view中显示的player，带返回按钮
    XDSVideoPlayerTypeItem,//在cell中显示的player，不带返回按钮
};
@interface XDSVideoPlayer ()

@property (strong, nonatomic) UIView *contentView;//内容视图，负责内容的展示与屏幕旋转切换
@property (strong, nonatomic) UIView *topBar;//标题栏
@property (strong, nonatomic) UIButton *backButton;//back button
@property (strong, nonatomic) UIButton *airPlayButton;//airPlay button
@property (strong, nonatomic) UIButton *downloadButton;//download button

@property (strong, nonatomic) UIView *bottomBar;//进度条栏
@property (strong, nonatomic) UIButton *fullScreenButton;//maximize screen button
@property (strong, nonatomic) UIButton *playButton;//download button
@property (strong, nonatomic) UISlider *prograssBar;//prograssBar
@property (strong, nonatomic) UILabel *currentTileLabel;//to show current time
@property (strong, nonatomic) UILabel *leftTimeLabel;//to show left time

@property (assign, nonatomic) XDSVideoPlayerType playerType;


/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;
@property (nonatomic, strong) AVAssetImageGenerator  *imageGenerator;
/** playerLayer */
@property (nonatomic, strong) AVPlayerLayer          *playerLayer;

@property (strong, nonatomic) id periodicTimeObserver;//监听播放时间
@end

@implementation XDSVideoPlayer
NSInteger const kVideoPlayerBarHeight = 44;
- (void)dealloc{
    NSLog(@"dealloc = XDSVideoPlayer");
    [self removeObserverFromSelf];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self createUI];
        [self prepareToPlay];
    }
    return self;
}


- (void)createUI{
    self.backgroundColor = [UIColor blackColor];
    _contentView = ({
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.backgroundColor = [UIColor yellowColor];
        [self addSubview:contentView];
        contentView;
    });
    
    UIColor *barColor = [UIColor colorWithWhite:0 alpha:0.2];
    _topBar = ({
        UIView *topBar = [[UIView alloc] initWithFrame:CGRectZero];
        topBar.translatesAutoresizingMaskIntoConstraints = NO;
        topBar.backgroundColor = barColor;
        [_contentView addSubview:topBar];
        topBar;
    });
    _bottomBar = ({
        UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectZero];
        bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
        bottomBar.backgroundColor = barColor;
        [_contentView addSubview:bottomBar];
        bottomBar;
    });
    
    //add constraints for _contentView
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_contentView, _topBar, _bottomBar);
    NSDictionary *metrics = @{@"height":@(kVideoPlayerBarHeight)};
    
    NSArray *constraint_contentView_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewDic];
    NSArray *constraint_contentView_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewDic];
    [self addConstraints:constraint_contentView_h];
    [self addConstraints:constraint_contentView_v];
    
    //add constraints for _topBar and _bottomBar
    NSArray *constraint_topbar_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topBar]|"
                                                                           options:NSLayoutFormatAlignAllCenterX
                                                                           metrics:metrics
                                                                             views:viewDic];
    NSArray *constraint_topbar_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topBar(==height)]"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:metrics
                                                                             views:viewDic];
    NSArray *constraint_bottomBar_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomBar]|"
                                                                              options:NSLayoutFormatAlignAllCenterX
                                                                              metrics:metrics
                                                                                views:viewDic];
    NSArray *constraint_bottomBar_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomBar(==height)]|"
                                                                              options:NSLayoutFormatAlignAllCenterY
                                                                              metrics:metrics
                                                                                views:viewDic];
    [_contentView addConstraints:constraint_topbar_h];
    [_contentView addConstraints:constraint_topbar_v];
    [_contentView addConstraints:constraint_bottomBar_h];
    [_contentView addConstraints:constraint_bottomBar_v];
    
    [self createTopBarUI];
    [self createBottomBarUI];
    
}

/** topbar ui */
- (void)createTopBarUI{
    self.backButton = self.backButton;
    self.downloadButton = self.downloadButton;
    self.airPlayButton = self.airPlayButton;
}

/** backButton */
- (UIButton *)backButton{
    if (nil == _backButton) {
        _backButton = ({
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.translatesAutoresizingMaskIntoConstraints = NO;
            [backButton setImage:[UIImage imageNamed:@"xds_back"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:backButton];
            NSDictionary *viewDic = NSDictionaryOfVariableBindings(backButton);
            NSDictionary *metrics = @{@"width":@(kVideoPlayerBarHeight)};
            NSArray *constraint_backButton_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backButton(==width)]"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            NSArray *constraint_backButton_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backButton]|"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            [_topBar addConstraints:constraint_backButton_h];
            [_topBar addConstraints:constraint_backButton_v];
            backButton;
        });
    }
    
    return _backButton;
}

/** airPlayButton */
- (UIButton *)airPlayButton{
    if (nil == _airPlayButton) {
        _airPlayButton = ({
            UIButton *airPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            airPlayButton.translatesAutoresizingMaskIntoConstraints = NO;
            [airPlayButton setImage:[UIImage imageNamed:@"xds_Airplay"] forState:UIControlStateNormal];
            [airPlayButton addTarget:self action:@selector(airPlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:airPlayButton];
            UIButton *downloadButton = _downloadButton;
            
            NSMutableDictionary *viewDic = [NSMutableDictionary dictionary];
            NSDictionary *metrics = @{@"width":@(kVideoPlayerBarHeight)};
            
            [viewDic setValue:airPlayButton forKey:@"airPlayButton"];
            NSString *vf_h = @"H:[airPlayButton(==width)]|";//右边距为0，宽width
            NSString *vf_v = @"V:|[airPlayButton(==width)]|";//下边距为0，高width
            
            if (downloadButton) {
                [viewDic setValue:downloadButton forKey:@"downloadButton"];
                vf_h = @"H:[airPlayButton(==width)][downloadButton]";
            }
            NSArray *constraint_backButton_h = [NSLayoutConstraint constraintsWithVisualFormat:vf_h
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            NSArray *constraint_backButton_v = [NSLayoutConstraint constraintsWithVisualFormat:vf_v
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            [_topBar addConstraints:constraint_backButton_h];
            [_topBar addConstraints:constraint_backButton_v];
            airPlayButton;
        });
    }
    
    return _airPlayButton;
}

/** downloadButton */
- (UIButton *)downloadButton{
    if (nil == _downloadButton) {
        _downloadButton = ({
            UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            downloadButton.translatesAutoresizingMaskIntoConstraints = NO;
            [downloadButton setImage:[UIImage imageNamed:@"xds_download"] forState:UIControlStateNormal];
            [downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_topBar addSubview:downloadButton];
            
            NSMutableDictionary *viewDic = [NSMutableDictionary dictionary];
            NSDictionary *metrics = @{@"width":@(kVideoPlayerBarHeight)};
            
            [viewDic setValue:downloadButton forKey:@"downloadButton"];
            NSString *vf_h = @"H:[downloadButton(==width)]|";//右边距为0，宽width
            NSString *vf_v = @"V:|[downloadButton(==width)]|";//下边距为0，高width
            
            UIButton *airPlayButton = _airPlayButton;
            if (airPlayButton) {
                [viewDic setValue:airPlayButton forKey:@"airPlayButton"];
                vf_h = @"H:[downloadButton(==width)][airPlayButton]";
                
            }
            NSArray *constraint_backButton_h = [NSLayoutConstraint constraintsWithVisualFormat:vf_h
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            NSArray *constraint_backButton_v = [NSLayoutConstraint constraintsWithVisualFormat:vf_v
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewDic];
            [_topBar addConstraints:constraint_backButton_h];
            [_topBar addConstraints:constraint_backButton_v];
            downloadButton;
        });
    }
    
    return _downloadButton;
}

/** bottombar ui */
- (void)createBottomBarUI{
    _playButton = ({
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.translatesAutoresizingMaskIntoConstraints = NO;
        [playButton setImage:[UIImage imageNamed:@"xds_play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"xds_pause"] forState:UIControlStateSelected];
        [playButton addTarget:self
                       action:@selector(playButtonClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:playButton];
        playButton;
    });
    
    _fullScreenButton = ({
        UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = NO;
        [fullScreenButton setImage:[UIImage imageNamed:@"xds_fullscreen"] forState:UIControlStateNormal];
        [fullScreenButton setImage:[UIImage imageNamed:@"xds_shrinkscreen"] forState:UIControlStateSelected];
        [fullScreenButton addTarget:self
                             action:@selector(fullScreenButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];
        [_bottomBar addSubview:fullScreenButton];
        fullScreenButton;
    });
    
    _currentTileLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"1:22:02";
        [_bottomBar addSubview:label];
        label;
    });
    
    _leftTimeLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"19:20";
        [_bottomBar addSubview:label];
        label;
    });
    
    _prograssBar = ({
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectZero];
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        [slider setThumbImage:[UIImage imageNamed:@"xds_slider"] forState:UIControlStateNormal];
        [_bottomBar addSubview:slider];
        slider;
    });
    
    
    //add constraints for _playButton, _currentTileLabel, _prograssBar, _leftTimeLabel, _fullScreenButton
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_playButton, _currentTileLabel, _prograssBar, _leftTimeLabel, _fullScreenButton);
    NSDictionary *metrics = @{@"gap":@10, @"maxLabelWidth":@60, @"buttonWidth":@(kVideoPlayerBarHeight)};
    
    NSString *vf_h = @"H:|[_playButton(==buttonWidth)][_currentTileLabel(<=maxLabelWidth)]-gap-[_prograssBar]-gap-[_leftTimeLabel(<=maxLabelWidth)][_fullScreenButton(==buttonWidth)]|";
    NSString *vf_v = @"V:|[_playButton]|";
    NSArray *constraint_h = [NSLayoutConstraint constraintsWithVisualFormat:vf_h
                                                                    options:NSLayoutFormatAlignAllCenterY | NSLayoutFormatAlignAllTop
                                                                    metrics:metrics
                                                                      views:viewDic];
    NSArray *constraint_v = [NSLayoutConstraint constraintsWithVisualFormat:vf_v
                                                                    options:0
                                                                    metrics:metrics
                                                                      views:viewDic];
    [_bottomBar addConstraints:constraint_h];
    [_bottomBar addConstraints:constraint_v];
    
}



#pragma mark - handle events
/** backButton event */
-(void)backButtonClick:(UIButton *)backButton{
    kTipAlert(@"可以返回了");
}

/** airPlayButton event */
- (void)airPlayButtonClick:(UIButton *)airPlayButton{
    kTipAlert(@"可以投影看视频了");
}

/** downloadButton event */
- (void)downloadButtonClick:(UIButton *)downloadButton{
    kTipAlert(@"可以下载了");
}

/** playButton event */
- (void)playButtonClick:(UIButton *)playButton{
    playButton.selected = !playButton.selected;
    kTipAlert(@"开始播放了");
    if (playButton.selected) {
        [_player play];
    }else{
        [_player pause];
    }
}

/** fullScreenButton event */
- (void)fullScreenButtonClick:(UIButton *)fullScreenButton{
    fullScreenButton.selected = !fullScreenButton.selected;
    kTipAlert(@"全屏播放了");
    
}



#pragma mark - player config
- (void)prepareToPlay {
        NSURL *videoURL = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"性感舞曲.mp4" ofType:nil];
//    NSURL *videoURL = [NSURL fileURLWithPath:path];
    self.urlAsset = [AVURLAsset assetWithURL:videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.contentView.backgroundColor = [UIColor yellowColor];
    // 此处为默认视频填充模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.contentView.layer insertSublayer:self.playerLayer atIndex:0];
    
    //添加播放过程监听
    [self addPeriodicTimeObserver];
    
    //添加事件监听
    [self addObserverForSelf];

}

//TODO:添加监听
- (void)addObserverForSelf{
    // 监听播放器状态变化
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听缓存进去，就是大家所看到的一开始进去底部灰色的View会迅速加载
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
//TODO:移除监听
- (void)removeObserverFromSelf{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//TODU:屏幕旋转处理
- (void)onDeviceOrientationChange{
    NSLog(@"%s", __func__);
}
//TODO:监听事件处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        NSLog(@"status changed = %@", change);
        AVPlayerItemStatus statues = [change[NSKeyValueChangeNewKey] integerValue];
        switch (statues) {
                // 监听到这个属性的时候，理论上视频就可以进行播放了
            case AVPlayerItemStatusReadyToPlay:{
                //初始化成功以后更新播放时间
                [self showCurrentTime];

//                [self initTimer];
//                启动定时器 5秒自动隐藏
//                if (!self.autoDismissTimer)
//                {
//                    self.autoDismissTimer = [NSTimer timerWithTimeInterval:8.0 target:self selector:@selector(autoDismissView:) userInfo:nil repeats:YES];
//                    [[NSRunLoop currentRunLoop] addTimer:self.autoDismissTimer forMode:NSDefaultRunLoopMode];
//                }
                                break;
            }
                
            case AVPlayerItemStatusUnknown:
                
                
                
                break;
                //这个就是不能播放喽，加载失败了
            case AVPlayerItemStatusFailed:
                
                // 这时可以通过`self.player.error.description`属性来找出具体的原因
                
                break;
                
            default:
                break;
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSLog(@"loadedTimeRanges changed = %@", change);
    }
}

/** 添加播放过程监听 */
- (void)addPeriodicTimeObserver{
    __weak typeof(self)weakSelf = self;
    self.periodicTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time) {
        __strong typeof(self)strongSelf = weakSelf;
        //更新播放时间
        [strongSelf showCurrentTime];
    }];
}

/** 更新播放时间 */
- (void)showCurrentTime{
    AVPlayerItem *currentItem = self.playerItem;
    NSArray *loadedRanges = currentItem.seekableTimeRanges;
    if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
        NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
        CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
        CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
        
        [self playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
    }
}
- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    // 更新slider
    self.prograssBar.value = value;
    // 更新当前播放时间
    self.currentTileLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    // 更新剩余播放时间
    self.leftTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

//调用addSubview时为playerLayer设置frame
- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.contentView.bounds;
    NSLog(@"frame = %@", NSStringFromCGRect(self.contentView.frame));
}
@end
