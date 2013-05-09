//
//  SPRepostViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月23日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPRepostViewController.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPPost.h"
#import "SPBaseResponseData.h"
#import "NSString+SPStringUtility.h"
#import "UIButton+WebCache.h"
#import "SPUtility.h"
#import "SPProduct.h"
#import "SPGetPostInfoResponseData.h"

@interface SPRepostViewController ()

@end

@implementation SPRepostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"REPICT";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIButton *cancelBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [cancelBarButton addTarget:self action:@selector(dismissRepostViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBarButton];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [cancelButtonItem release];
    
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Post"];
    [rightBarButton addTarget:self action:@selector(uploadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    [self.commentTextView becomeFirstResponder];
    
    [self.authorImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.authorImageButton setImageWithURL:[NSURL URLWithString:[self.post.product.imgURLs objectAtIndex:0]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadButtonPressed:(id)sender
{
    [self.commentTextView resignFirstResponder];
    NSString *comment = nil;
    if (![self.commentTextView.text isEqualToString:@"Add a comment..."]&&[self.commentTextView.text isValid]) {
        comment = self.commentTextView.text;
    }
    [self showHUDLoadingViewWithTitle:@"Uploading"];
    [self sendRepostRequestWithPost:self.post comment:comment delegate:self];
}

- (void)SPRepostRequestDidFinish:(SPGetPostInfoResponseData*)response originalPost:(SPPost *)originalPost
{
    [self hideHUDLoadingView];
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
        [self.commentTextView becomeFirstResponder];
    }else{
        NSLog(@"Success");
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:response.post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDREPOST dictionary:dictionary];
        
        [self showHUDViewWithRepost];
        [self performSelector:@selector(dismissRepostViewController) withObject:self afterDelay:1.0f];
        
    }
}

- (void)dismissRepostViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [_post release];
    [_commentTextView release];
    [_authorImageButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCommentTextView:nil];
    [self setAuthorImageButton:nil];
    [super viewDidUnload];
}

@end
