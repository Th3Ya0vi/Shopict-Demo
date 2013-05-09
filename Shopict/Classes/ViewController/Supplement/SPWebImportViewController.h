//
//  SPWebImportViewController.h
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月3日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"


@protocol SPWebImportViewControllerDelegate <NSObject>

- (void)SPWebImportViewControllerDidSelectImage:(NSMutableDictionary*)info;

@end

@interface SPWebImportViewController : SPBaseTabbedViewController<UIGestureRecognizerDelegate , UIActionSheetDelegate>

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) NSString *websiteURL;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *importImageButton;

@property (assign, nonatomic) NSInteger imageNumber;

@property (retain, nonatomic) IBOutletCollection (UIButton) NSArray *imageButtons;
@property (retain, nonatomic) NSMutableArray *images;
@property (retain, nonatomic) NSMutableArray *imageURLs;

@property (assign, nonatomic) NSInteger selectedImageButtonTag;
@property (retain, nonatomic) IBOutlet UIView *imageButtonView;

@property (retain, nonatomic) IBOutlet UIButton *previousButton;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *loadingView;

@property (retain, nonatomic) IBOutlet UIImageView *currentImageView;
@property (retain, nonatomic) IBOutlet UIView *currentView;


@end
