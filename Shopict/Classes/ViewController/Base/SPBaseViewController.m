//
//  SPBaseViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseViewController.h"
#import "UIFont+SPFontUtility.h"
#import "UIColor+SPColorUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPUtility.h"
#import "SPSocialManager.h"

@interface SPBaseViewController ()

@end

@implementation SPBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.hidesBackButton = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBackButton];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [super dealloc];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackButton
{
    NSInteger n = [self.navigationController.viewControllers count] - 2;
    if (n >= 0)
    {
        if ([(UIViewController*)[self.navigationController.viewControllers objectAtIndex:n]navigationItem].backBarButtonItem == nil)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(0, 0, 53, 32)];
            [button setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
            [button setTitle:@"Back" forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
            [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
            [button setTitle:@"Back" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
            [self.navigationItem setLeftBarButtonItem:barButtonItem];
        }
    }
}

- (void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alert methods

- (void)showErrorAlert:(NSString *)error
{
    if (!error) {
        error = @"Something goes wrong.";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    if (!message) {
        message = @"Something goes wrong.";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

- (void)showHUDErrorViewWithMessage:(NSString *)message
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.delegate = self;
	HUD.labelText = message;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (void)showHUDTickViewWithMessage:(NSString *)message
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_alert_tick"]] autorelease];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.delegate = self;
	HUD.labelText = message;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (void)showHUDViewWithTitle:(NSString *)title
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]]autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    [HUD setLabelText:title];
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}

- (void)showHUDViewWithHeart
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.square = YES;
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_alert_heart"]]autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    [HUD show:YES];
    [HUD hide:YES afterDelay:0.6];
}

- (void)showHUDViewWithRepost
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    HUD.square = YES;
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_alert_repost"]]autorelease];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    [HUD show:YES];
    [HUD hide:YES afterDelay:0.6];
}

- (void)showHUDLoadingViewWithTitle:(NSString *)title
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    if (HUD.hidden || HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        HUD.delegate = self;
    }
    HUD.square = YES;
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = title;
    [HUD show:YES];
}

- (void)hideHUDLoadingView{
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
    
    if (HUD.hidden == NO) {
        [HUD hide:YES];
    }
}

- (BOOL)isShown
{
    if (self.isViewLoaded && self.view.window) {
        return YES;
    }
    return NO;
}

- (void)SPWebBrowerViewControllerAddPict:(NSMutableDictionary *)webDictionary
{
    [self showAddPostFromURLViewControllerWithWebsite:webDictionary];
}

- (void)presentLoginViewController
{
    [SPUtility clearImageCacheInstantly:YES];
    [SPUtility setStoredToken:nil];
    [SPUtility setToSavedInCameraRoll:YES];
    [SPUtility setIsMainFeedGrid:NO];
    [SPUtility setConfigDate:nil];
    
    [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
    [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
    [[SPSocialManager sharedManager]disconnectToThirdParty:WEIBO];
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.presentingViewController.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    }else{
        [self.navigationController.tabBarController.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

@end
