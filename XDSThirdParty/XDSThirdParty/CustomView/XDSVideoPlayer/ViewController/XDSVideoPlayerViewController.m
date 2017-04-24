//
//  XDSVideoPlayerViewController.m
//  XDSThirdParty
//
//  Created by dusheng.xu on 2017/4/1.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "XDSVideoPlayerViewController.h"
#import "XDSVideoPlayer.h"
@interface XDSVideoPlayerViewController ()

@end

@implementation XDSVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    ({
        XDSVideoPlayer * player = [[XDSVideoPlayer alloc] initWithFrame:CGRectZero];
        player.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:player];
        
        NSDictionary * viewdict = NSDictionaryOfVariableBindings(player);
        NSArray *constraint_player_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[player]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewdict];
        NSArray *constraint_player_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[player]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewdict];
        [self.view addConstraints:constraint_player_h];
        [self.view addConstraints:constraint_player_v];
        
        
    });
}


@end
