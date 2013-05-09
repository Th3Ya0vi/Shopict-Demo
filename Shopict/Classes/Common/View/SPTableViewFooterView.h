//
//  SPTableViewFooterView.h
//  SP
//
//  Created by bichenkk on 13年2月21日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPTableViewFooterViewDelegate <NSObject>

- (void)SPTableViewFooterViewDidSelectReload;
 
@end

@class SPLoadingView;
@interface SPTableViewFooterView : UIView

@property (nonatomic, retain) SPLoadingView *loadingView;
@property (nonatomic, retain) UIButton *reloadButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, assign) id delegate;

+ (SPTableViewFooterView *)footerView;
- (void)showLoading;
- (void)showReloadButton;
- (void)showTitleLabel:(NSString *)title;
- (void)recenterSubviews;
- (void)restartLoadingAnimation;

@end
