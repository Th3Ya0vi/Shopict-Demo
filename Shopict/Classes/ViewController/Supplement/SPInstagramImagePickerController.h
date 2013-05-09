//
//  SBInstagramImagePickerControllerViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月25日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPTableViewFooterView;
@protocol SBInstagramImagePickerControllerDelegate <NSObject>

- (void)SBInstagramImagePickerControllerDidSelectImage:(UIImage *)image;

@end

@interface SPInstagramImagePickerController : SPBaseTabbedViewController <UIWebViewDelegate>

@property (assign, nonatomic) id delegate;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UITableView *imageTableView;
@property (nonatomic, strong) NSString* accessToken;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *nextUrl;
@property (nonatomic, retain) NSMutableArray* thumbnailUrls;
@property (nonatomic, retain) NSMutableArray* standardUrls;
@property (nonatomic, assign) BOOL lastImage;
@property (nonatomic, assign) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;

@end
