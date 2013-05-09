//
//  SBWebBrowerViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月28日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPWebBrowerViewController.h"
#import "UIButton+SPButtonUtility.h"
#import "UIColor+SPColorUtility.h"
#import <QuartzCore/QuartzCore.h>

@interface SPWebBrowerViewController ()

@end

@implementation SPWebBrowerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationItem setTitle:@"WEB"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlAddress = self.websiteURL;
    
    BOOL result = [[urlAddress lowercaseString] hasPrefix:@"http://"]||[[urlAddress lowercaseString] hasPrefix:@"https://"];
    if (!result) {
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=http://%@", urlAddress];
    }else{
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=%@", urlAddress];
    }
    
    self.websiteURL = urlAddress;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    self.addPictButton.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {
    [_websiteURL release];
    [_webView release];
    [_previousButton release];
    [_reloadButton release];
    [_nextButton release];
    [_loadingView release];
    [_addPictButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setPreviousButton:nil];
    [self setReloadButton:nil];
    [self setNextButton:nil];
    [self setLoadingView:nil];
    [self setAddPictButton:nil];
    [super viewDidUnload];
}

- (IBAction)optionsButtonPressed:(id)sender
{
    UIActionSheet *actionSheet;
    actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:@"Open in Safari", @"Copy URL to Clipboard",nil]
                   autorelease];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
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
    if ([self.webView.request.URL.absoluteString isEqualToString:self.websiteURL]) {
        [self.addPictButton setHidden:YES];
    }else{
        [self.addPictButton setHidden:NO];
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

- (IBAction)closeButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)safariButtonPressed:(id)sender {
    NSString *currentURL = self.webView.request.URL.absoluteString;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentURL]];
    NSLog(@"currentURL %@",currentURL);
}

- (IBAction)addPictButtonPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Pict this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        if ([self.delegate respondsToSelector:@selector(SPWebBrowerViewControllerAddPict:)]) {
            NSNumber *websitePrice = nil;
            NSString *websiteTitle = nil;
            NSString *websiteURL = nil;
            NSLog(@"document.body.innerHTML %@", [self.webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"]);
            NSString *html = [self.webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
            NSString *priceRegex = @"\\$\\d+(?:\\.\\d+)?";
            NSRange priceRange = [html rangeOfString:priceRegex options:NSRegularExpressionSearch];
            if (priceRange.location != NSNotFound){
                NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                websitePrice = [formatter numberFromString:[[html substringWithRange:priceRange]stringByReplacingOccurrencesOfString:@"$" withString:@""]];
                [formatter release];
            }
            
            websiteTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            websiteTitle = [[websiteTitle componentsSeparatedByString:@"|"]objectAtIndex:0];
            
            websiteURL = self.webView.request.URL.absoluteString;
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            if (websitePrice) {
                [dictionary setValue:websitePrice forKey:@"price"];
            }
            
            if (websiteTitle) {
                [dictionary setValue:websiteTitle forKey:@"title"];
            }
            
            if (websiteURL) {
                [dictionary setValue:websiteURL forKey:@"url"];
            }
            
            [self.delegate SPWebBrowerViewControllerAddPict:dictionary];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}





@end
