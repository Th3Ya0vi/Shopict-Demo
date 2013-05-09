//
//  SPSignUpViewController.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseLoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFPhotoEditorController.h"
#import "SPEnum.h"

@interface SPSignUpViewController : SPBaseLoginViewController
<UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *contentTapView;

@property (retain, nonatomic) UIButton *joinButton;

@property (retain, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *emailTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, retain) UIImage *capturedImage;

@property (retain, nonatomic) IBOutlet UIButton *termsButton;

@property (retain, nonatomic) UIPopoverController *imagePopoverController;

@end
