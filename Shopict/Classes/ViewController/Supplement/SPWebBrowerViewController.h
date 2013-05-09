//
//  SBWebBrowerViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月28日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseViewController.h"

@protocol SPWebBrowerViewControllerDelegate <NSObject>

- (void)SPWebBrowerViewControllerAddPict:(NSDictionary *)webDictionary;

@end

@interface SPWebBrowerViewController : SPBaseViewController
<UIActionSheetDelegate>

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) NSString *websiteURL;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *previousButton;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *loadingView;

@property (retain, nonatomic) IBOutlet UIButton *addPictButton;

@end
