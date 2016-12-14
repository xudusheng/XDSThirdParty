//
//  MultiTaskManagerViewController.m
//  XDSThirdParty
//
//  Created by Hmily on 2016/12/14.
//  Copyright © 2016年 Hmily. All rights reserved.
//http://www.cocoachina.com/ios/20150804/12878.html

#import "MultiTaskManagerViewController.h"
#import <iCarousel/iCarousel.h>
#import <Masonry/Masonry.h>


@interface MultiTaskManagerViewController () <iCarouselDelegate, iCarouselDataSource>

@property (strong, nonatomic) iCarousel *carousel;

@property (assign, nonatomic) CGSize cardSize;

@end

@implementation MultiTaskManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width*5.0/7.0;
    _cardSize = CGSizeMake(cardWidth, cardWidth*16.0/9.0);
    
    _carousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.type = iCarouselTypeCustom;
        icarousel.bounceDistance = 0.2;
        
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        icarousel;
    });
}

#pragma mark - iCarouselDelegate, iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 13;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return _cardSize.width;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
   
    UIView *cardView = view;
    if (!cardView){
        CGRect frame = CGRectZero;
        frame.origin = CGPointMake(0, 0);
        frame.size = _cardSize;
        cardView = [[UIView alloc] initWithFrame:frame];

        NSString * imageName = [@(index).stringValue stringByAppendingString:@".jpg"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        [cardView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.image = [UIImage imageNamed:imageName];
        
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0].CGPath;
        cardView.layer.shadowRadius = 3.0;
        cardView.layer.shadowColor = [UIColor blackColor].CGColor;
        cardView.layer.shadowOpacity = 0.5f;
        cardView.layer.shadowOffset = CGSizeMake(0, 0);
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0].CGPath;
        imageView.layer.mask = layer;
    }
    
    return cardView;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    CATransform3D transform3D = CATransform3DTranslate(transform, translation * _cardSize.width + _cardSize.width/5, 0, offset);
    return CATransform3DScale(transform3D, scale, scale, 1.0);
    
//    struct CATransform3D {
//        CGFloat     m11（x缩放）,     m12（y切变）,     m13（旋转）,     m14（）;
//        CGFloat     m21（x切变）,     m22（y缩放）,     m23（）,     m24（）;
//        CGFloat     m31（旋转）,      m32（ ）,        m33（）,     m34（透视）;
//        CGFloat     m41（x平移）,     m42（y平移）,     m43（z平移）,     m44（）;
//    };
}


- (void)carouselDidScroll:(iCarousel *)carousel {
    for ( UIView *view in carousel.visibleItemViews) {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        
        if ( offset < -3.0 ) {
            view.alpha = 0.0;
        }else if ( offset < -2.0) {
            view.alpha = offset + 3.0;
        }else {
            view.alpha = 1.0;
        }
    }
}


//形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset{
    return offset*0.04f + 1.0;
}

//位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset{
    CGFloat z = 5.0/4.0;
    CGFloat n = 5.0/8.0;
    
    //z/n是临界值 >= 这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if ( offset >= z/n ){
        return 2.0;
    }
    
    return 1/(z-n*offset)-1/z;
}





@end
