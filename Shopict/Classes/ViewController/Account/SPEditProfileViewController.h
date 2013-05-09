//
//  SBEditProfileViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月26日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPAccount;

@interface SPEditProfileViewController : SPBaseTabbedViewController
<UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) SPAccount *currentAccount;

@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIImageView *coverImageView;

@property (retain, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (retain, nonatomic) IBOutlet UIButton *changeCoverButton;


@property (retain, nonatomic) IBOutlet UIView *contentTapView;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *bioTextField;
@property (retain, nonatomic) IBOutlet UITextField *websiteTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *addStoresTextField;

@property (assign, nonatomic) NSInteger selectedImage; //0-photo, 1-cover
@property (assign, nonatomic) BOOL editedProfilePicture;
@property (assign, nonatomic) BOOL editedCoverPicture;

@end
