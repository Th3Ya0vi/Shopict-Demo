//
//  SPLoadingView.m
//  SP
//
//  Created by bichenkk on 13年2月21日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SPLoadingView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 30, 30);
        self.backgroundColor = [UIColor clearColor];
        UIImageView *rotateImageView = [[UIImageView alloc]initWithFrame:self.frame];
        [rotateImageView setContentMode:UIViewContentModeScaleAspectFit];
        [rotateImageView setImage:[UIImage imageNamed:@"icon_rotate"]];
        self.indicator = rotateImageView;
        [rotateImageView release];
        [self addSubview:self.indicator];
    }
    return self;
}

+ (SPLoadingView *)loadingView
{
    return [[[self alloc]init]autorelease];
}

- (void)startAnimation
{
    [self.indicator.layer removeAllAnimations];
    self.indicator.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 10.0 ];
    rotationAnimation.duration = 10.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [self.indicator.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [CATransaction commit];
}

- (void)dealloc
{
    [self.indicator.layer removeAllAnimations];
    [_indicator release];
    [super dealloc];
}

@end
