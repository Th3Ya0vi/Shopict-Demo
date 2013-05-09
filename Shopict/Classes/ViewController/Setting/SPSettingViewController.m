//
//  SPSettingViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPSettingViewController.h"
#import "SPUtility.h"
#import "SPSocialManager.h"
#import <Accounts/Accounts.h>
#import "UIColor+SPColorUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseResponseData.h"

@interface SPSettingViewController ()

@end

@implementation SPSettingViewController

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
        self.facebookConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
        self.twitterConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER];
        self.savePhotoSwitch.on = [SPUtility isToSaveInCameraRoll];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    self.facebookConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
    self.twitterConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER];
    self.savePhotoSwitch.on = [SPUtility isToSaveInCameraRoll];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"SETTINGS";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView setContentSize:self.contentView.frame.size];
    [self.scrollView addSubview:self.contentView];
    self.savePhotoSwitch.onTintColor = [UIColor themeColor];
    self.facebookConnectSwitch.onTintColor = [UIColor themeColor];
    self.twitterConnectSwitch.onTintColor = [UIColor themeColor];
    self.facebookConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
    self.twitterConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER];
    self.savePhotoSwitch.on = [SPUtility isToSaveInCameraRoll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log out" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

- (void)dealloc {
    [_facebookConnectSwitch release];
    [_twitterConnectSwitch release];
    [_savePhotoSwitch release];
    [_contentView release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFacebookConnectSwitch:nil];
    [self setTwitterConnectSwitch:nil];
    [self setSavePhotoSwitch:nil];
    [self setContentView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //Cancel
        case 1:
            if (alertView.tag == 0) {
                [self sendLogoutRequestWithDelegate:self];
                [self presentLoginViewController];
            }
            break;
        default:
            break;
    }
    
}

- (IBAction)facebookConnectSwitched:(id)sender {
    if (self.facebookConnectSwitch.on) {
        [self showHUDLoadingViewWithTitle:@"Authorizing"];
        [SPSocialManager sharedManager].delegate = self;
        [[SPSocialManager sharedManager]connectToThirdParty:FACEBOOK];
    }else{
        [self sendUnbindAccountWithThirdPartyRequestwithPath:FACEBOOK];
    }
}

- (IBAction)twitterConnectSwitched:(id)sender {
    if (self.twitterConnectSwitch.on) {
        [self showHUDLoadingViewWithTitle:@"Authorizing"];
        [SPSocialManager sharedManager].delegate = self;
        [[SPSocialManager sharedManager]connectToThirdParty:TWITTER];
    }else{
        [self sendUnbindAccountWithThirdPartyRequestwithPath:TWITTER];
    }
}

- (void)SPSocialManagerDelegateDidFinishConnectedToThirdParty:(ThirdPartyPath)thirdParty userId:(NSString *)userId errorMessage:(NSString *)errorMessage
{
    if (!errorMessage) {
        if (userId) {
            [self sendBindAccountWithThirdPartyRequest:thirdParty userId:userId];
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
            [self showHUDLoadingViewWithTitle:@"Connecting"];
        }
    }else{
        [self showErrorAlert:errorMessage];
        [self performSelectorOnMainThread:@selector(hideHUDLoadingView) withObject:nil waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(assignDisconnectedSwitch) withObject:nil waitUntilDone:YES];
    }
}

- (void)assignDisconnectedSwitch
{
    self.facebookConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
    self.twitterConnectSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER];
}

- (void)sendBindAccountWithThirdPartyRequest:(ThirdPartyPath)thirdPartyPath userId:(NSString *)userId
{
    if (thirdPartyPath == FACEBOOK) {
        
        [self sendBindAccountToThirdPartyRequestWithThirdPartyId:userId path:FACEBOOK delegate:self];
        
    }else if (thirdPartyPath == TWITTER) {
        
        [self sendBindAccountToThirdPartyRequestWithThirdPartyId:userId path:TWITTER delegate:self];
    }
}

- (void)SPBindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path
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
        switch (path) {
            case FACEBOOK:
                self.facebookConnectSwitch.on = NO;
                [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
                break;
            case TWITTER:
                self.twitterConnectSwitch.on = NO;
                [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
                break;
            default:
                break;
        }
    }else{
        [self showHUDTickViewWithMessage:@"Connected"];
        switch (path) {
            case FACEBOOK:
                self.facebookConnectSwitch.on = YES;
                [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
                break;
            case TWITTER:
                self.twitterConnectSwitch.on = YES;
                break;
            default:
                break;
        }
    }
}

- (void)sendUnbindAccountWithThirdPartyRequestwithPath:(ThirdPartyPath)path
{
    [self showHUDLoadingViewWithTitle:@"Disconnecting"];
    [self sendUnbindAccountToThirdPartyRequestWithPath:path delegate:self];
}

- (void)SPUnbindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path
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
        switch (path) {
            case FACEBOOK:
                self.facebookConnectSwitch.on = YES;
                break;
            case TWITTER:
                self.twitterConnectSwitch.on = YES;
                break;
            default:
                break;
        }
    }else{
        [self showHUDTickViewWithMessage:@"Disconnected"];
        switch (path) {
            case FACEBOOK:
                self.facebookConnectSwitch.on = NO;
                break;
            case TWITTER:
                self.twitterConnectSwitch.on = NO;
                break;
            default:
                break;
        }
    }
}

- (IBAction)savePhotoSwitched:(id)sender {
    if (![SPUtility isToSaveInCameraRoll]) {
        [SPUtility setToSavedInCameraRoll:YES];
        self.savePhotoSwitch.on = YES;
    }else{
        [SPUtility setToSavedInCameraRoll:NO];
        self.savePhotoSwitch.on = NO;
    }
}

- (IBAction)inviteViaTextButtonPressed:(id)sender {
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Hey! Find me on Shopict\n______\nDon't have Shopict? Get it from App Store now.";
		controller.recipients = [NSArray arrayWithObjects:nil];
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:nil];
            [self showHUDTickViewWithMessage:@"Text Sent"];
            break;
        case MessageComposeResultFailed:
            [self showHUDErrorViewWithMessage:@"Delivery Failed"];
            break;
        default:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (IBAction)inviteViaEmailButtonPressed:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Find me on Shopict"];
    [controller setMessageBody:@"Hey! Find me in Shopict\n______\nDon't have Shopict? Get it from App Store now." isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:nil];
    [controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    switch (result) {
        case MFMailComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:nil];
            [self showHUDTickViewWithMessage:@"Email Sent"];
            break;
        case MFMailComposeResultFailed:
            [self showHUDErrorViewWithMessage:@"Delivery Failed"];
            break;
        default:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

- (IBAction)findFriendsFromFacebookButtonPressed:(id)sender {
    [self goToFacebookFriendsViewController];
}

- (IBAction)selectInterestButtonPressed:(id)sender {
    [self goToInterestSelectionViewController];
}


@end
