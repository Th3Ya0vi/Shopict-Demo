//
//  SBEditProfileViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月26日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPEditProfileViewController.h"
#import "SPAccount.h"
#import "SPUtility.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SPTextEditorViewController.h"
#import "SPChangePasswordViewController.h"
#import "SPImagePickerController.h"
#import "UIColor+SPColorUtility.h"
#import "NSString+SPStringUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetAccountInfoResponseData.h"

@interface SPEditProfileViewController ()

@end

@implementation SPEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationItem setTitle:[@"Edit Profile" uppercaseString]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.contentScrollView setContentSize:self.contentView.frame.size];
    [self.contentScrollView addSubview:self.contentView];
    
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.currentAccount.coverImgURL]];
    [self.changePhotoButton setImageWithURL:[NSURL URLWithString:self.currentAccount.profileImgURL] forState:UIControlStateNormal];
    [self.changePhotoButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    self.nameTextField.text = self.currentAccount.name;
    self.usernameTextField.text = self.currentAccount.username;
    self.emailTextField.text = self.currentAccount.email;
    self.bioTextField.text = self.currentAccount.description;
    self.websiteTextField.text = self.currentAccount.website;
    self.phoneTextField.text = self.currentAccount.phoneNumber;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    #ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    #endif
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contentTapView addGestureRecognizer:singleTapGestureRecognizer];
    [singleTapGestureRecognizer release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_currentAccount release];
    [_contentScrollView release];
    [_contentView release];
    [_coverImageView release];
    [_changePhotoButton release];
    [_changeCoverButton release];
    [_nameTextField release];
    [_emailTextField release];
    [_bioTextField release];
    [_websiteTextField release];
    [_phoneTextField release];
    [_addStoresTextField release];
    [_usernameTextField release];
    [_contentTapView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setContentScrollView:nil];
    [self setContentView:nil];
    [self setCoverImageView:nil];
    [self setChangePhotoButton:nil];
    [self setChangeCoverButton:nil];
    [self setNameTextField:nil];
    [self setEmailTextField:nil];
    [self setBioTextField:nil];
    [self setWebsiteTextField:nil];
    [self setPhoneTextField:nil];
    [self setAddStoresTextField:nil];
    [self setUsernameTextField:nil];
    [self setContentTapView:nil];
    [super viewDidUnload];
}

#pragma mark-
#pragma mark Button Events

- (IBAction)addPictureButtonPressed:(id)sender {
    UIButton *imageButton = sender;
    if ([imageButton isEqual:self.changePhotoButton]) {
        self.selectedImage = 0;
    }else{
        self.selectedImage = 1;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = nil;
        UIImage *selectedImage = (self.selectedImage == 0?self.changePhotoButton.imageView.image:self.coverImageView.image);
        if (selectedImage) {
            actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:@"Delete Photo"
                                             otherButtonTitles:@"Take Photo",@"Select From Album", nil]
                           autorelease];
        }else{
            actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Take Photo",@"Select From Album", nil]
                           autorelease];
        }
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else{
        [self selectFromAlbum];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    [self resignFirstResponderForTextFields];
    if ([self validation]) {
        [self sendEditProfileRequest];
    }
}

- (IBAction)changePasswordButtonPressed:(id)sender {
    [self goToChangePasswordViewController];
}

#pragma mark -
#pragma mark UIImagePickerController Events

- (void)takeNewPhoto{
    SPImagePickerController *imagePicker = [SPImagePickerController Instance];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectFromAlbum{
    SPImagePickerController *imagePicker = [SPImagePickerController Instance];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.selectedImage == 0) {
        [self.changePhotoButton setImage:image forState:UIControlStateNormal];
        self.editedProfilePicture = YES;
    }else{
        self.coverImageView.image = nil;
        self.coverImageView.image = image;
        self.editedCoverPicture = YES;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Take Photo"]) {
        [self takeNewPhoto];
    }else if([title isEqualToString:@"Select From Album"]){
        [self selectFromAlbum];
    }else if ([title isEqualToString:@"Delete Photo"]){
        [self deletePhoto];
    }
}

#pragma mark -
#pragma mark Request Events

- (void)sendEditProfileRequest
{
    [self sendEditProfileRequestWithName:self.nameTextField.text username:self.usernameTextField.text email:self.emailTextField.text website:self.websiteTextField.text description:self.bioTextField.text phoneNumber:self.phoneTextField.text editProfilePic:self.editedProfilePicture profilePic:(self.editedProfilePicture?self.changePhotoButton.imageView.image:nil) editCoverPic:self.editedCoverPicture coverPic:(self.editedCoverPicture?self.coverImageView.image:nil) delegate:self];
    [self showHUDLoadingViewWithTitle:@"Loading..."];
}

- (void)SPEditProfileRequestDidFinish:(SPGetAccountInfoResponseData*)response
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
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:response.account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDUPDATE dictionary:userInfo];
        
        [self showHUDTickViewWithMessage:@"Saved"];
        [self performSelector:@selector(backButtonPressed) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    CGRect frame = self.coverImageView.frame;
    CGFloat factor;
    if (offset.y < 0) {
        factor = 0.5;
    } else {
        factor = 1;
    }
    if (-80-offset.y*factor < 0) {
        frame.origin.y = -80-offset.y*factor;
    }
    self.coverImageView.frame = frame;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.bioTextField]) {
        [self resignFirstResponderForTextFields];
        
        [self goToTextEditorViewControllerWithTitle:@"BIO" limit:150 text:textField.text tag:1 delegate:self];
        
        return NO;
    }
    [self.contentScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-50) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.nameTextField.text = [self.nameTextField.text stringByTrimmingTopTailWhitespace];
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingTopTailWhitespace];
    self.emailTextField.text = [self.emailTextField.text stringByTrimmingTopTailWhitespace];
    self.bioTextField.text = [self.bioTextField.text stringByTrimmingTopTailWhitespace];
    self.websiteTextField.text = [self.websiteTextField.text stringByTrimmingTopTailWhitespace];
    
    return YES;
}

#pragma mark -
#pragma mark SBTextEditorViewController Delegate

- (void)SBTextEditorViewControllerDidFinishEdit:(NSInteger)tag text:(NSString *)text
{
    [self.bioTextField setText:text];
}

#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSLog(@"%f",keyboardHeight);
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [self.contentScrollView setFrame:CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.view.frame.size.height-keyboardHeight)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSLog(@"%f",keyboardHeight);
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [self.contentScrollView setFrame:CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark -

- (void)deletePhoto{
    if (self.selectedImage == 0) {
        self.changePhotoButton.imageView.image = nil;
        [self.changePhotoButton setImage:nil forState:UIControlStateNormal];
        self.editedProfilePicture = YES;
    }else{
        self.coverImageView.image = nil;
        self.editedCoverPicture = YES;
    }
}

- (BOOL)validation
{
    //Check Empty
    if (![self.nameTextField.text isValid]) {
        [self showErrorAlert:@"Name cannot be empty."];
        return NO;
    }
    
    if (![self.usernameTextField.text isValid]) {
        [self showErrorAlert:@"Username cannot be empty."];
        return NO;
    }
    
    if (![self.emailTextField.text isValid]) {
        [self showErrorAlert:@"Email cannot be empty."];
        return NO;
    }
    
    //Check Username
    if (![self.usernameTextField.text isValid]) {
        [self showErrorAlert:@"Username can only be contain A-Z, 0-9 and _."];
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
    

    return YES;
}

- (void)resignFirstResponderForTextFields
{
    [self.nameTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.bioTextField resignFirstResponder];
    [self.websiteTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.addStoresTextField resignFirstResponder];
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self resignFirstResponderForTextFields];
}

@end
