//
//  SPSettingViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import <MessageUI/MessageUI.h>

@interface SPSettingViewController : SPBaseTabbedViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UISwitch *savePhotoSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *facebookConnectSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *twitterConnectSwitch;

@end
