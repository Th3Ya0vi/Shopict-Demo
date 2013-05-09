//
//  SBAddProductViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "AFPhotoEditorController.h"
#import "SPEnum.h"

@class SPCategory,SPPost;
@protocol SPAddPostFromURLViewControllerDelegate <NSObject>

- (void)SPAddPostFromURLViewControllerDidUploadNewPost:(SPPost *)post;

@end

@interface SPAddPostFromURLViewController : SPBaseTabbedViewController
<UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet UIView *contentTapView;

@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (retain, nonatomic) IBOutlet UITextField *urlTextFIeld;
@property (retain, nonatomic) IBOutlet UITextField *categoryTextField;

@property (retain, nonatomic) IBOutletCollection (UIButton) NSArray *imageButtons;
@property (retain, nonatomic) NSMutableArray *images;
@property (assign, nonatomic) NSInteger selectedImageButtonTag;

@property (retain, nonatomic) IBOutlet UIButton *wantItButton;
@property (retain, nonatomic) IBOutlet UIButton *sellItButton;

@property (retain, nonatomic) IBOutlet UIView *sellItView;
@property (retain, nonatomic) IBOutlet UITextField *priceTextField;
@property (retain, nonatomic) IBOutlet UITextField *currencyTextField;
@property (retain, nonatomic) IBOutlet UISwitch *deliverGloballySwitch;


@property (retain, nonatomic) IBOutlet UIView *shareView;
@property (retain, nonatomic) IBOutlet UISwitch *shareFacebookSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *shareTwitterSwitch;

@property (retain, nonatomic) IBOutlet UITextView *commentTextView;

@property (retain, nonatomic) SPCategory *selectedCategory;

@property (retain, nonatomic) NSMutableDictionary *webDictionary;

- (IBAction)typeButtonPressed:(id)sender;

@end
