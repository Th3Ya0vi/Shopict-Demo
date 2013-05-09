//
//  SPLogInWithEmailViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPLogInWithEmailViewController.h"
#import "SPTabMenuController.h"
#import "NSString+SPStringUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPUtility.h"
#import "SPTabMenuController.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetTokenResponseData.h"
#import "SPAccount.h"

@interface SPLogInWithEmailViewController ()

@end

@implementation SPLogInWithEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = [NSString localizedStringWithKey:@"SIGN IN"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIButton *barButton = [UIButton barButtonItemWithTitle:@"Done"];
    [barButton addTarget:self action:@selector(logInButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    [self.emailTextField becomeFirstResponder];
    
    if (IS_IPAD) {
        UIButton *cancelBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
        [cancelBarButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBarButton];
        [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
        [cancelButtonItem release];
    }
}

- (void)dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_emailTextField release];
    [_passwordTextField release];
    [_forgetPasswordButton release];
    [super dealloc];
}

- (IBAction)logInButtonPressed:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if ([self validation]) {
        [self sendLoginWithEmailRequest];
    }
}

- (IBAction)forgetPasswordButtonPressed:(id)sender {
    [self goToForgetPasswordViewController];
}

- (BOOL)validation
{
    if (![self.emailTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    if (![self.passwordTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    
    //Check Email
    if (![self.emailTextField.text isEmailValid]) {
        //A Valid email is required
        [self showErrorAlert:@"Please enter a valid email address."];
        return NO;
    }
    
    if (self.passwordTextField.text.length < 6) {
        //Password is too short
        [self showErrorAlert:@"Password must be at least 6 characters."];
        return NO;
    }
    
    return YES;
}

- (void)sendLoginWithEmailRequest
{
    [self showHUDLoadingViewWithTitle:@"Signing In..."];
    [self sendLoginWithEmailRequestWithEmail:self.emailTextField.text password:self.passwordTextField.text delegate:self];
}

- (void)SPLoginWithEmailRequestDidFinish:(SPGetTokenResponseData*)response
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
    }else{
        NSLog(@"Success");
        [SPUtility setStoredToken:response.token];
        [SPUtility setStoredAccountId:response.account.accountId];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        SPTabMenuController *tabBarViewController = [[SPTabMenuController alloc]init];
        [self.navigationController pushViewController:tabBarViewController animated:NO];
        [tabBarViewController release];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }else if ([textField isEqual:self.passwordTextField]){
        [textField resignFirstResponder];
        
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        if ([self validation]) {
            [self sendLoginWithEmailRequest];
        }
        
    }
    return YES;
}


@end
