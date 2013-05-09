//
//  SPWebSupportViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月5日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPWebSupportViewController.h"
#import "UIButton+SPButtonUtility.h"

@interface SPWebSupportViewController ()

@end

@implementation SPWebSupportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Done"];
    [rightBarButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_websiteURL release];
    [_webView release];
    [super dealloc];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([error code] != -999) {
        [self showHUDErrorViewWithMessage:@"Failed"];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
