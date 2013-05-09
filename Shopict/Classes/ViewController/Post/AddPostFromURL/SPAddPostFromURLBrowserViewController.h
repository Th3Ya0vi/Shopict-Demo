//
//  SPAddPostFromURLBrowserViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月28日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@interface SPAddPostFromURLBrowserViewController : SPBaseTabbedViewController
<UIScrollViewDelegate>

@property (retain, nonatomic) NSString *websiteURL;

@property (retain, nonatomic) IBOutlet UIView *URLView;
@property (retain, nonatomic) IBOutlet UITextField *urlTextField;

@property (retain, nonatomic) IBOutlet UIButton *previousButton;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIImageView *loadingView;
@property (retain, nonatomic) IBOutlet UIButton *reloadButton;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@property (retain, nonatomic) IBOutlet UIView *imageSelectionView;
@property (retain, nonatomic) IBOutlet UIPageControl *imageSelectionPageControl;
@property (retain, nonatomic) IBOutlet UIView *imageSelectionContentView;
@property (retain, nonatomic) IBOutlet UIScrollView *imageSelectionScrollView;
@property (retain, nonatomic) NSMutableArray *imageSelectionImageViews;
@property (retain, nonatomic) NSMutableArray *selectedImageViews;

@end
