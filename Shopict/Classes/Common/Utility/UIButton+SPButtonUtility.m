//
//  UIButton+SPButtonUtility.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "UIButton+SPButtonUtility.h"

@implementation UIButton (SPButtonUtility)

+ (UIButton *)barButtonItemWithTitle:(NSString *)title
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 52, 32)];
    [barButton setBackgroundImage:[UIImage imageNamed:@"button_bar_button"] forState:UIControlStateNormal];
    [barButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [barButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    return barButton;
}

+ (UIButton *)longBarButtonItemWithTitle:(NSString *)title
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 62, 32)];
    [barButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_button"] forState:UIControlStateNormal];
    [barButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [barButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [barButton setTitle:title forState:UIControlStateNormal];
    [barButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    return barButton;
}

+ (UIButton *)barButtonItemWithImage:(UIImage *)image
{
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 30, 31)];
    [barButton setImage:image forState:UIControlStateNormal];
    return barButton;
}

@end
