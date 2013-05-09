//
//  SBChangePasswordViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月4日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@protocol SPChangePasswordRequestDelegate;
@interface SPChangePasswordViewController : SPBaseTabbedViewController

@property (retain, nonatomic) IBOutlet UITextField *oldPasswordTextFIeld;
@property (retain, nonatomic) IBOutlet UITextField *changedPasswordTextField;
@property (retain, nonatomic) IBOutlet UITextField *retypePasswordTextField;

@end
