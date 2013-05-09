//
//  SBChangePasswordViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月4日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPChangePasswordViewController.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPBaseResponseData.h"

@interface SPChangePasswordViewController ()

@end

@implementation SPChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"PASSWORD"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SPChangePasswordRequestDidFinish:(SPBaseResponseData*)response
{
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
        [self showHUDTickViewWithMessage:@"Changed"];
        [self performSelector:@selector(returnViewController) withObject:nil afterDelay:1.0f];
    }
}

- (void)returnViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_oldPasswordTextFIeld release];
    [_changedPasswordTextField release];
    [_retypePasswordTextField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOldPasswordTextFIeld:nil];
    [self setChangedPasswordTextField:nil];
    [self setRetypePasswordTextField:nil];
    [super viewDidUnload];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if ([self validation]) {
        [self sendChangePasswordRequestWithOldPassword:self.oldPasswordTextFIeld.text newPassword:self.changedPasswordTextField.text delegate:self];
    }
}



- (BOOL)validation
{
    //Check Empty
    if (![self.oldPasswordTextFIeld.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    if (![self.changedPasswordTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    
    if (![self.retypePasswordTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
        
    if (self.oldPasswordTextFIeld.text.length < 6) {
        //Password is too short
        [self showErrorAlert:@"Password must be at least 6 characters."];
        return NO;
    }
    if (self.changedPasswordTextField.text.length < 6) {
        //Password is too short
        [self showErrorAlert:@"Password must be at least 6 characters."];
        return NO;
    }
    if (self.retypePasswordTextField.text.length < 6) {
        //Password is too short
        [self showErrorAlert:@"Password must be at least 6 characters."];
        return NO;
    }
    if (![self.retypePasswordTextField.text isEqual:self.changedPasswordTextField.text]) {
        [self showErrorAlert:@"Passwords do not match."];
        return NO;
    }        
}
    return YES;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.oldPasswordTextFIeld]) {
        [self.changedPasswordTextField becomeFirstResponder];
    }else if ([textField isEqual:self.changedPasswordTextField]){
        [self.retypePasswordTextField becomeFirstResponder];
    }else if ([textField isEqual:self.retypePasswordTextField]){
        [textField resignFirstResponder];
    }
    return YES;
}


@end
