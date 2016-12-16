//
//  MJPhotoBrowserCollectionViewCell.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/16.
//  Copyright © 2016年 Hmily. All rights reserved.
//

#import "MJPhotoBrowserCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIImageView+WebCache.h"

@interface MJPhotoBrowserCollectionViewCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation MJPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = ({
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            imageView;
        });
        
        _titleLabel = ({
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.tintColor = [UIColor whiteColor];
            [self addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.left.mas_equalTo(5);
                make.right.mas_equalTo(-5);
            }];
            titleLabel;
        });
        
    }
    return self;
}


- (void)cellWithImageModel:(MJPhotoBrowserImageModel *)imageModel{
    if (!imageModel) {
        _imageView.image = nil;
        _titleLabel.text = @"";
    }else{
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.imageScr] placeholderImage:nil];
        _titleLabel.text = imageModel.title;
        
        if (imageModel.imageArray == nil) {
            [self fetchDetailImageListWithImageID:imageModel.imageId];
        }
        
    }
}


- (void)fetchDetailImageListWithImageID:(NSString *)imageId{
    
}

@end
