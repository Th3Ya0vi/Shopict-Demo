//
//  SPWebImportViewController.m
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月3日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPWebImportViewController.h"
#import "UIButton+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface SPWebImportViewController ()

@end

@implementation SPWebImportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationItem setTitle:@"SELECT PHOTOS"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *urlAddress = self.websiteURL;
    BOOL result = [[urlAddress lowercaseString] hasPrefix:@"http://"]||[[urlAddress lowercaseString] hasPrefix:@"https://"];
    if (!result) {
        urlAddress = [NSString stringWithFormat:@"http://%@", urlAddress];
    }
    
    self.websiteURL = urlAddress;
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    UITapGestureRecognizer *gs = [[UITapGestureRecognizer alloc] init];
    gs.numberOfTapsRequired = 1;
    gs.delegate = self;
    [self.webView addGestureRecognizer:gs];
    [gs release];
    
    [self.importImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.importImageButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [self.importImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.importImageButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    CGFloat totalWidth = 40*self.imageNumber + self.importImageButton.frame.size.width;
    [self.imageButtonView setFrame:CGRectMake((self.view.frame.size.width-totalWidth)/2, self.imageButtonView.frame.origin.y, 40*self.imageNumber, self.imageButtonView.frame.size.height)];
    [self.importImageButton setFrame:CGRectMake(CGRectGetMaxX(self.imageButtonView.frame), self.importImageButton.frame.origin.y, self.importImageButton.frame.size.width, self.importImageButton.frame.size.height)];
    
    self.images = [NSMutableArray array];
    self.imageURLs = [NSMutableArray array];
    
    self.imageButtons = [self.imageButtons sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    
    for (UIButton *button in self.imageButtons) {
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    self.currentView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_websiteURL release];
    [_webView release];
    [_importImageButton release];
    [_imageButtons release];
    [_images release];
    [_imageURLs release];
    [_imageButtonView release];
    [_previousButton release];
    [_reloadButton release];
    [_nextButton release];
    [_loadingView release];
    [_currentImageView release];
    [_currentView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setImportImageButton:nil];
    [self setImageButtonView:nil];
    [self setCurrentImageView:nil];
    [self setCurrentView:nil];
    [super viewDidUnload];
}

- (IBAction)openInSafariButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.websiteURL]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
    
    if ([error code] != -999) {
        [self showHUDErrorViewWithMessage:@"Failed"];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.loadingView.hidden = NO;
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 10.0 ];
    rotationAnimation.duration = 10.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [CATransaction commit];
    
    self.reloadButton.hidden = YES;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint touchPoint = [touch locationInView:self.view];
        if(self.interfaceOrientation==UIInterfaceOrientationPortrait||self.interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
            NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
            NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
            NSURL * imageURL = [NSURL URLWithString:urlToSave];
            if (self.images.count <= self.imageNumber) {
                for (NSString *url in self.imageURLs) {
                    if ([url isEqualToString:urlToSave]) {
                        return YES;
                    }
                }
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:imageURL
                                 options:0
                                progress:^(NSUInteger receivedSize, long long expectedSize)
                 {
                     // progression tracking code
                 }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     if (image)
                     {
                         if (image && self.images.count<self.imageNumber) {
                             for (NSString *url in self.imageURLs) {
                                 if ([url isEqualToString:urlToSave]) {
                                     return;
                                 }
                             }
                             [self.imageURLs addObject:urlToSave];
                             [self.images addObject:image];
                             [self refreshImageButtons];
                         }
                     }
                 }];
            }
        }
    }
    return YES;
}

- (IBAction)importImageButtonPressed:(id)sender {
    if (self.images.count>0 && self.imageURLs.count == self.images.count) {
        if ([self.delegate respondsToSelector:@selector(SPWebImportViewControllerDidSelectImage:)]) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:self.images forKey:@"images"];
            [self.delegate SPWebImportViewControllerDidSelectImage:dictionary];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)imageButtonPressed:(id)sender {
    UIButton *imageButton = sender;
    self.selectedImageButtonTag = imageButton.tag;
    if ([self checkImageExists:imageButton.tag]) {
        [self.currentImageView setImage:[self.images objectAtIndex:imageButton.tag]];
        self.currentView.hidden = NO;
    }
}

- (BOOL)checkImageExists:(NSInteger)tag
{
    if (self.images.count > tag) {
        return YES;
    }
    return NO;
}

- (void)deletePhoto{
    self.currentView.hidden = YES;
    [self.images removeObjectAtIndex:self.selectedImageButtonTag];
    [self.imageURLs removeObjectAtIndex:self.selectedImageButtonTag];
    [self refreshImageButtons];
}

- (void)refreshImageButtons
{
    for (UIButton *imageButton in self.imageButtons) {
        [imageButton setImage:nil forState:UIControlStateNormal];
    }
    for (NSInteger i = 0; i <self.images.count; i++) {
        UIImage *image = [self.images objectAtIndex:i];
        UIButton *imageButton = [self.imageButtons objectAtIndex:i];
        [imageButton setImage:image forState:UIControlStateNormal];
    }
    if (self.images.count>0) {
        self.importImageButton.enabled = YES;
    }
}

- (IBAction)goBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)reloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)goNextButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)hideCurrentImageViewButtonPressed:(id)sender {
    self.currentView.hidden = YES;
}

- (IBAction)deleteCurrentImageButtonPressed:(id)sender {
    [self deletePhoto];
}


@end
