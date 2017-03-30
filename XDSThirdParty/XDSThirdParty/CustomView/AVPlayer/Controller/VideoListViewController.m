//
//  VideoListViewController.m
//  XDSThirdParty
//
//  Created by yangjun zhu on 2017/3/29.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "VideoListViewController.h"
#import "MoviePlayerViewController.h"

@interface VideoListViewController ()<MoviePlayerViewControllerDataSource>

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton * localVedioButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:@"播放本地视频" forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(localVedioButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

    UIButton * webVideoButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:@"播放网络视频" forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(webVideoButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    UIButton * vedioListButton = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button setTitle:@"播放视频集" forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(vedioListButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    NSDictionary * viewDict = NSDictionaryOfVariableBindings(localVedioButton, webVideoButton, vedioListButton);
    
    NSArray * constrain_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[localVedioButton]-30-|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewDict];
    NSArray * constrain_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[localVedioButton(==40)]-20-[webVideoButton(==40)]-20-[vedioListButton(==40)]" options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:nil views:viewDict];
    
    [self.view addConstraints:constrain_H];
    [self.view addConstraints:constrain_V];
}


- (void)localVedioButtonClick:(UIButton *)button{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURL:url movieTitle:button.titleLabel.text];
    [self presentViewController:movieVC animated:YES completion:nil];
}

- (void)webVideoButtonClick:(UIButton *)button{
    NSURL *url = [NSURL URLWithString:@"http://v.youku.com/player/getRealM3U8/vid/XMjE4MDU1MDE2/type/mp4/v.m3u8"];
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initNetworkMoviePlayerViewControllerWithURL:url movieTitle:button.titleLabel.text];
    movieVC.datasource = self;
    [self presentViewController:movieVC animated:YES completion:nil];
}
- (void)vedioListButtonClick:(UIButton *)button{
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"1" withExtension:@"mp4"];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"mp4"];
    NSURL *url3 = [[NSBundle mainBundle] URLForResource:@"3" withExtension:@"mp4"];
    NSArray *list = @[url1,url2,url3];
    MoviePlayerViewController *movieVC = [[MoviePlayerViewController alloc]initLocalMoviePlayerViewControllerWithURLList:list movieTitle:button.titleLabel.text];
    [self presentViewController:movieVC animated:YES completion:nil];
}



#pragma mark - MoviePlayerViewControllerDataSource
- (BOOL)isHavePreviousMovie{
    return NO;
}
- (BOOL)isHaveNextMovie{
    return NO;
}
- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSURL URLWithString:@"http://v.youku.com/player/getRealM3U8/vid/XNjQ5MDM3Nzg0/type/mp4/v.m3u8"],KURLOfMovieDicTionary,@"qqqqqqq",KTitleOfMovieDictionary, nil];
    return dic;
}
- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie{
    return nil;
}
@end
