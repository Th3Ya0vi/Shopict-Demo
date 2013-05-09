//
//  SPForgetPasswordViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPForgetPasswordViewController.h"
#import "SPBaseResponseData.h"
#import "UIButton+SPButtonUtility.h"
#import "NSString+SPStringUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"

@interface SPForgetPasswordViewController ()

@end

@implementation SPForgetPasswordViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"RESET PASSWORD";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Send"];
    [rightBarButton addTarget:self action:@selector(getPasswordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    
    [self.emailTextField becomeFirstResponder];
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [_emailTextField release];
    [super dealloc];
}

#pragma mark - Button events

- (IBAction)getPasswordButtonPressed:(id)sender {
    [self.emailTextField resignFirstResponder];
    if ([self valiadation]) {
        [self sendForgetPasswordRequest];
    }
}

#pragma mark - Request events

- (void)sendForgetPasswordRequest
{
    [self showHUDLoadingViewWithTitle:@"Loading..."];
    [self sendForgetPasswordRequestWithEmail:self.emailTextField.text delegate:self];
}

- (void)SPForgetPasswordRequestDidFinish:(SPBaseResponseData*)response
{
    [self hideHUDLoadingView];
    if (response.error) {
        if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
    }else{
        [self showAlertWithTitle:@"Success" message:@"New password is sent to your email."];
    }
}

#pragma mark - Customized events

- (BOOL)valiadation
{
    if (![self.emailTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    
    if (![self.emailTextField.text isEmailValid]) {
        //A Valid email is required
        [self showErrorAlert:@"Please enter a valid email address."];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.emailTextField resignFirstResponder];
    if ([self valiadation]) {
        [self sendForgetPasswordRequest];
    }
    return YES;
}

@end
