//
//  SPLoadingView.h
//  SP
//
//  Created by bichenkk on 13年2月21日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPLoadingView : UIView

+ (SPLoadingView *)loadingView;
- (void)startAnimation;

@property (nonatomic, retain) UIImageView *indicator;

@end
