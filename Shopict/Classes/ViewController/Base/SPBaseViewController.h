//
//  SPBaseViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SPBaseViewController : UIViewController<MBProgressHUDDelegate>
{
	MBProgressHUD *HUD;
}

- (BOOL)isShown;
- (void)showErrorAlert:(NSString *)error;
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showHUDViewWithTitle:(NSString *)title;
- (void)showHUDLoadingViewWithTitle:(NSString *)title;
- (void)showHUDErrorViewWithMessage:(NSString *)message;
- (void)showHUDTickViewWithMessage:(NSString *)message;
- (void)showHUDViewWithHeart;
- (void)showHUDViewWithRepost;
- (void)hideHUDLoadingView;
- (void)backButtonPressed;
- (void)presentLoginViewController;

@end
