//
//  SPLogInOptionViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPLogInOptionViewController.h"
#import "SPUtility.h"
#import "SPSocialManager.h"
#import "SPTabMenuController.h"
#import "SPGetTokenResponseData.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"

#import "SPLogInWithEmailViewController.h"
#import "SPSignUpViewController.h"
#import "SPBaseNavigationController.h"

@interface SPLogInOptionViewController ()

@end

@implementation SPLogInOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    
    if (!IS_IPAD) {
        if ([UIScreen mainScreen].bounds.size.height > 500) {
            [self.launchCoverImageView setImage:[UIImage imageNamed:@"Default-568h@2x"]];
        }
    }
    
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
        [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
    }
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
        [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
    }
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        // viewController is visible
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
        
        if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
            [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
        }
        
        if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
            [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (![SPUtility getStoredToken]) {
        [self.launchCoverView setHidden:YES];
    }else{
        [self.launchCoverView setHidden:NO];
        [self performSelector:@selector(pushTabMenuController) withObject:nil afterDelay:0.5];
    }
    
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
        [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
    }
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
        [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
    }
}

- (void)dealloc {
    [_launchCoverView release];
    [_launchCoverImageView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLaunchCoverView:nil];
    [self setLaunchCoverImageView:nil];
    [super viewDidUnload];
}

#pragma mark - Connect to third parties

- (IBAction)facebookButtonPressed:(id)sender {
    [self showHUDLoadingViewWithTitle:@"Authorizing"];
    [SPSocialManager sharedManager].delegate = self;
    [[SPSocialManager sharedManager]connectToThirdParty:FACEBOOK];
}

- (IBAction)twitterButtonPressed:(id)sender {
    [self showHUDLoadingViewWithTitle:@"Authorizing"];
    [SPSocialManager sharedManager].delegate = self;
    [[SPSocialManager sharedManager]connectToThirdParty:TWITTER];
}

- (IBAction)weiboButtonPressed:(id)sender {
    [self showHUDErrorViewWithMessage:@"Not enabled yet"];
}


- (void)SPSocialManagerDelegateDidFinishConnectedToThirdParty:(ThirdPartyPath)thirdParty userId:(NSString *)userId errorMessage:(NSString *)errorMessage
{
    if (!errorMessage) {
        if (userId) {
            [self sendLoginWithThirdPartyRequestwithPath:thirdParty thirdPartyId:userId];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
            [self showHUDLoadingViewWithTitle:@"Signing In"];
        }
    }else{
        [self showErrorAlert:errorMessage];
        [self performSelectorOnMainThread:@selector(hideHUDLoadingView) withObject:nil waitUntilDone:YES];
    }
}

- (void)sendLoginWithThirdPartyRequestwithPath:(ThirdPartyPath)path thirdPartyId:(NSString *)thirdPartyId
{
    NSLog(@"thirdPartyId %@",thirdPartyId);
    [self sendLoginWithThirdPartyRequestWithPath:path thirdPartyId:thirdPartyId delegate:self];
}

- (void)SPLoginWithThirdPartyRequestDidFinish:(SPGetTokenResponseData*)response path:(ThirdPartyPath)path
{
    [self hideHUDLoadingView];
    if (response.error) {
        if (response.err == 3) {
            switch (path) {
                case FACEBOOK:{
                    UIActionSheet *actionSheet;
                    actionSheet = [[[UIActionSheet alloc]initWithTitle:@"No Matched Account"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Create new account",nil]
                                   autorelease];
                    actionSheet.tag = 1;
                    [actionSheet showInView:self.navigationController.view];
                    break;
                }
                case TWITTER:{
                    UIActionSheet *actionSheet;
                    actionSheet = [[[UIActionSheet alloc]initWithTitle:@"No Matched Account"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:@"Create new account",nil]
                                   autorelease];
                    actionSheet.tag = 2;
                    [actionSheet showInView:self.navigationController.view];
                    break;
                }
                default:
                    break;
            }
        }else{
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
        }
    }else{
        NSLog(@"Success");
        [SPUtility setStoredToken:response.token];
        
        [self pushTabMenuController];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //Cancel
        case 0:
            [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
            [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
            [[SPSocialManager sharedManager]disconnectToThirdParty:WEIBO];
            break;
        default:
            break;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Create new account"]) {
        [self goToSignUpViewController];
    }else{
        [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
        [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
        [[SPSocialManager sharedManager]disconnectToThirdParty:WEIBO];
    }
}

#pragma mark - Button Events


- (IBAction)logInWithEmailButtonPressed:(id)sender {
    if (IS_IPAD) {
        SPLogInWithEmailViewController *viewController = [[SPLogInWithEmailViewController alloc]initWithNibName:@"SPLogInWithEmailViewController" bundle:nil];
        SPBaseNavigationController *targetController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        targetController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:targetController animated:YES completion:nil];
        targetController.view.superview.frame = CGRectMake(0, 0, 500 , 520);//it's important to do this after
        targetController.view.superview.center = self.view.center;
        [viewController release];
        [targetController release];
        
    }else{
        [self goToLoginWithEmailViewController];
    }
}

- (IBAction)signUpButtonPressed:(id)sender {
    if (IS_IPAD) {
        SPSignUpViewController *viewController = [[SPSignUpViewController alloc]initWithNibName:@"SPSignUpViewController" bundle:nil];
        SPBaseNavigationController *targetController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
        targetController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:targetController animated:YES completion:nil];
        targetController.view.superview.frame = CGRectMake(0, 0, 500 , 520);//it's important to do this after
        targetController.view.superview.center = self.view.center;
        [viewController release];
        [targetController release];
        
    }else{
        [self goToSignUpViewController];
    }
}

@end
