//
//  SPSignUpViewController.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPSignUpViewController.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"
#import "SPImagePickerController.h"
#import "UIButton+SPButtonUtility.h"
#import "NSString+SPStringUtility.h"
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UIButton+WebCache.h"
#import "SPSocialManager.h"
#import "NSString+SBJSON.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseResponseData.h"
#import "SPGetTokenResponseData.h"

@interface SPSignUpViewController ()

@end

@implementation SPSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = [NSString localizedStringWithKey:@"REGISTER"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    self.termsButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.termsButton.titleLabel.textAlignment = UITextAlignmentCenter;
    self.termsButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.termsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // Do any additional setup after loading the view from its nib.
    [self.contentView setFrame:self.view.frame];
    [self.scrollView setContentSize:self.contentView.frame.size];
    [self.scrollView addSubview:self.contentView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    #ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    #endif
    
    [self.addPhotoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    NSLog(@"getConnectedFacebookUserId %@",[SPSocialManager getConnectedFacebookUserId]);
    
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
        [self importFacebookData];
    }else if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
        [self importTwitterData];
    }
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contentTapView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
    
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Join"];
    [rightBarButton addTarget:self action:@selector(signUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc]initWithCustomView:rightBarButton]autorelease];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    if (IS_IPAD) {
        UIButton *cancelBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
        [cancelBarButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBarButton];
        [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
        [cancelButtonItem release];
        
        [self.nameTextField becomeFirstResponder];
    }
}

- (void)dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)importFacebookData
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [self showHUDLoadingViewWithTitle:@"Loading"];
                 [self.nameTextField setText:user.name];
                 if ([user.username isUsernameValid]) {
                     [self.usernameTextField setText:user.username];
                 }
                 NSURL *emailUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=email&access_token=%@",user.id,[FBSession activeSession].accessTokenData.accessToken]];
                 NSError **error = nil;
                 NSString *emailData = [NSString stringWithContentsOfURL:emailUrl encoding:NSUTF8StringEncoding error:error];
                 if (emailData) {
                     NSDictionary *emailDictionary = [emailData JSONValue];
                     NSString *email = [emailDictionary objectForKey:@"email"];
                     [self.emailTextField setText:email];
                 }
                 [self hideHUDLoadingView];
                 NSString *profilePictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",user.id];
                 SDWebImageManager *manager = [SDWebImageManager sharedManager];
                 [manager downloadWithURL:[NSURL URLWithString:profilePictureUrl]
                                  options:0
                                 progress:^(NSUInteger receivedSize, long long expectedSize)
                  {
                      // progression tracking code
                  }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
                      if (image)
                      {
                          // do something with image
                          if (!error) {
                              self.capturedImage = image;
                              [self.addPhotoButton setImage:image forState:UIControlStateNormal];
                          }
                      }
                  }];
             }else{
             }
         }];
    }
}

- (void)importTwitterData
{
    [self showHUDLoadingViewWithTitle:@"Loading"];
    NSString *accountIdentifier = [SPSocialManager getConnectedTwitterIdentifier];
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccount *account = [accountStore accountWithIdentifier:accountIdentifier];
    [accountStore release];
    [self.usernameTextField setText:account.username];
    NSString *profilePictureUrl = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger",account.username];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:profilePictureUrl]
                     options:0
                    progress:^(NSUInteger receivedSize, long long expectedSize)
     {
     }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
         [self hideHUDLoadingView];
         if (image)
         {
             if (!error) {
                 self.capturedImage = image;
                 [self.addPhotoButton setImage:image forState:UIControlStateNormal];
             }
         }
     }];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setUsernameTextField:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setContentTapView:nil];
    [self setTermsButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [_addPhotoButton release];
    [_nameTextField release];
    [_emailTextField release];
    [_passwordTextField release];
    [_usernameTextField release];
    [_scrollView release];
    [_contentView release];
    [_contentTapView release];
    [_capturedImage release];
    [_termsButton release];
    [_imagePopoverController release];
    [super dealloc];
}

#pragma mark - Button Events

- (IBAction)signUpButtonPressed:(id)sender {
    
    [self.nameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.secureTextEntry = YES;
    
    if ([self validation]) {
        [self sendRegisterWithEmailRequest];
    }
}

- (IBAction)selectProfilePictureButtonPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet;
        if (self.capturedImage) {
            actionSheet = [[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:@"Delete Photo"
                                             otherButtonTitles:@"Take Photo",@"Select From Album", nil]
                           autorelease];
        }else{
            actionSheet = [[[UIActionSheet alloc]initWithTitle:@"Upload Profile Picture"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Take Photo",@"Select From Album", nil]
                           autorelease];
        }
        [actionSheet showInView:self.view];
    }else{
        [self selectFromAlbum];
    }
}

#pragma mark - UIImagePickerController Events

- (void)takeNewPhoto{
    SPImagePickerController *imagePicker = [SPImagePickerController Instance];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    if (IS_IPAD) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [popover presentPopoverFromRect:self.addPhotoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        self.imagePopoverController = popover;
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)selectFromAlbum{
    SPImagePickerController *imagePicker = [SPImagePickerController Instance];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    if (IS_IPAD) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [popover presentPopoverFromRect:self.addPhotoButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        self.imagePopoverController = popover;
    }else{
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

#pragma mark - UIImagePickerController Delegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.addPhotoButton setImage:image forState:UIControlStateNormal];
    self.capturedImage = image;
    
    if (IS_IPAD) {
        [self.imagePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (IS_IPAD) {
        [self.imagePopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Take Photo"]) {
        [self takeNewPhoto];
    }else if([title isEqualToString:@"Select From Album"]){
        [self selectFromAlbum];
    }else if ([title isEqualToString:@"Delete Photo"]){
        self.capturedImage = nil;
        [self.addPhotoButton setImage:[UIImage imageNamed:@"button_upload"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameTextField]) {
        [self.usernameTextField becomeFirstResponder];
    }else if ([textField isEqual:self.usernameTextField]){
        [self.emailTextField becomeFirstResponder];
    }else if ([textField isEqual:self.emailTextField]){
        [self.passwordTextField becomeFirstResponder];
    }else if ([textField isEqual:self.passwordTextField]){
        [textField resignFirstResponder];
        textField.secureTextEntry = YES;
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, self.nameTextField.frame.origin.y-10) animated:YES];
    if ([textField isEqual:self.passwordTextField]){
        textField.secureTextEntry = NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.nameTextField.text = [self.nameTextField.text stringByTrimmingTopTailWhitespace];
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingTopTailWhitespace];
    self.emailTextField.text = [self.emailTextField.text stringByTrimmingTopTailWhitespace];
    if ([textField isEqual:self.passwordTextField]){
        textField.secureTextEntry = YES;
    }
    return YES;
}

#pragma mark - Customized

- (BOOL)validation
{
    //Check Empty
    if (![self.nameTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    if (![self.usernameTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    if (![self.emailTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    if (![self.passwordTextField.text isValid]) {
        [self showErrorAlert:@"Please fill out the form."];
        return NO;
    }
    
    //Check Username
    if (![self.usernameTextField.text isUsernameValid]) {
        [self showErrorAlert:@"Username can only be contain a-z, 0-9 and _."];
        return NO;
    }
    
    //Check Email
    if (![self.emailTextField.text isEmailValid]) {
        //A Valid email is required
        [self showErrorAlert:@"Please enter a valid email address."];
        return NO;
    }
    
    if (self.nameTextField.text.length > 30) {
        [self showErrorAlert:@"Name must be not not more than 30 characters."];
        return NO;
    }
    
    if (self.usernameTextField.text.length > 20) {
        [self showErrorAlert:@"Username must be not not more than 20 characters."];
        return NO;
    }
    
    if (self.passwordTextField.text.length < 6) {
        //Password is too short
        [self showErrorAlert:@"Password must be at least 6 characters."];
        return NO;
    }
    
    return YES;
}

#pragma mark - Request Methods

- (void)sendRegisterWithEmailRequest
{
    [self showHUDLoadingViewWithTitle:@"Registering"];
    self.joinButton.enabled = NO;
    self.emailTextField.text = [self.emailTextField.text stringByTrimmingTopTailWhitespace];
    self.nameTextField.text = [self.nameTextField.text stringByTrimmingTopTailWhitespace];
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingTopTailWhitespace];
    
    [self sendRegisterRequestWithEmail:self.emailTextField.text name:self.nameTextField.text username:self.usernameTextField.text password:self.passwordTextField.text profilePic:self.capturedImage delegate:self];
}

- (void)SPRegisterRequestDidFinish:(SPGetTokenResponseData*)response
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
        self.joinButton.enabled = YES;
    }else{
        NSLog(@"Success");
        [SPUtility setStoredToken:response.token];
        
        if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
            [self sendBindAccountWithThirdPartyRequest:FACEBOOK];
        }else if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
            [self sendBindAccountWithThirdPartyRequest:FACEBOOK];
        }else{
            [self goToInterestSelectionViewController];
        }
        
    }
}

- (void)sendBindAccountWithThirdPartyRequest:(ThirdPartyPath)thirdPartyPath
{
    if (thirdPartyPath == FACEBOOK) {
        NSString *userID = [SPSocialManager getConnectedFacebookUserId];
        [self sendBindAccountToThirdPartyRequestWithThirdPartyId:userID path:FACEBOOK delegate:self];
        
    }else if (thirdPartyPath == TWITTER) {
        NSString *accountIdentifier = [SPSocialManager getConnectedTwitterIdentifier];
        ACAccountStore *accountStore = [[ACAccountStore alloc]init];
        ACAccount *account = [accountStore accountWithIdentifier:accountIdentifier];
        [accountStore release];
        NSString *userID = [[account valueForKey:@"properties"] valueForKey:@"user_id"];
        
        [self sendBindAccountToThirdPartyRequestWithThirdPartyId:userID path:TWITTER delegate:self];
    }
}

- (void)SPBindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path
{
    [self hideHUDLoadingView];
    if (response.error) {
        [self showErrorAlert:response.errorMessage];
        switch (path) {
            case FACEBOOK:
                [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
                break;
            case TWITTER:
                [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
            default:
                break;
        }
        [self goToInterestSelectionViewController];
    }else{
        [self goToInterestSelectionViewController];
    }
}



#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification*)notification {
    
////    if (IS_IPAD) {
////        return;
////    }
//    
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
//    CGFloat keyboardHeight = keyboardFrame.size.height;
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height-keyboardHeight)];
//    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
//    
////    if (IS_IPAD) {
////        return;
////    }
//    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.nameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.passwordTextField.secureTextEntry = YES;
}

- (IBAction)termsButtonPressed:(id)sender {
    [self showWebSupportViewControllerWithUrl:@"http://about.shopict.mobi/terms" withTitle:@"TERMS"];
}


@end
