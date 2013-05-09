//
//  SBAddProductViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPAddPostFromURLViewController.h"
#import "SPUtility.h"
#import "SPImagePickerController.h"
#import "SPCategory.h"
#import "SPBaseNavigationController.h"
#import "SPSocialManager.h"
#import "ASIFormDataRequest.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIColor+SPColorUtility.h"
#import "SPBaseNavigationController.h"
#import "NSString+SPStringUtility.h"
#import "UIButton+SPButtonUtility.h"
#import "UIFont+SPFontUtility.h"
#import "SPWebImportViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetPostInfoResponseData.h"

@interface SPAddPostFromURLViewController ()

@end

@implementation SPAddPostFromURLViewController

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
    [self.navigationItem setTitle:@"FROM LINK"];
    
    [self.scrollView addSubview:self.contentView];
    [self.scrollView setContentSize:self.contentView.frame.size];
    
    self.imageButtons = [self.imageButtons sortedArrayWithOptions:NSSortStable
                                                                    usingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
                                                                        if (obj1.tag > obj2.tag) {
                                                                            return NSOrderedDescending;
                                                                        } else if (obj1.tag < obj2.tag) {
                                                                            return NSOrderedAscending;
                                                                        }
                                                                        return NSOrderedSame;
                                                                    }];
    for (UIButton *button in self.imageButtons) {
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    self.images = [NSMutableArray array];
    
    UIButton *cancelBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [cancelBarButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBarButton];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [cancelButtonItem release];

    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Post"];
    [rightBarButton addTarget:self action:@selector(uploadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *singleTapGestureRecognizerForSellPart = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *singleTapGestureRecognizerForSharePart = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contentTapView addGestureRecognizer:singleTapGestureRecognizer];
    [self.sellItView addGestureRecognizer:singleTapGestureRecognizerForSellPart];
    [self.shareView addGestureRecognizer:singleTapGestureRecognizerForSharePart];
    [singleTapGestureRecognizer release];
    [singleTapGestureRecognizerForSellPart release];
    [singleTapGestureRecognizerForSharePart release];
    
	self.wantItButton.titleLabel.font = [UIFont themeFontWithSize:15];
    
    //Normal
    [self.wantItButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.wantItButton setBackgroundImage:nil forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.wantItButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.wantItButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.wantItButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.wantItButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    
    //Selected
    [self.wantItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.wantItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_left"] forState:UIControlStateSelected];
    
    [self.wantItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_left"]  forState:UIControlStateSelected];
    [self.wantItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_left"]  forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.wantItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.wantItButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [self.wantItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.wantItButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    self.sellItButton.titleLabel.font = [UIFont themeFontWithSize:15];
    
    //Normal
    [self.sellItButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.sellItButton setBackgroundImage:nil forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.sellItButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.sellItButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sellItButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.sellItButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    
    //Selected
    [self.sellItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.sellItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_right"] forState:UIControlStateSelected];
    
    [self.sellItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_right"]  forState:UIControlStateSelected];
    [self.sellItButton setBackgroundImage:[UIImage imageNamed:@"button_red_red_right"]  forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.sellItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.sellItButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [self.sellItButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.sellItButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    
    self.wantItButton.selected = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    [self.deliverGloballySwitch setOnTintColor:[UIColor themeColor]];
    
    [self.shareFacebookSwitch addTarget:self action:@selector(shareFacebookSwitched:) forControlEvents:UIControlEventValueChanged];
    [self.shareFacebookSwitch setOnTintColor:[UIColor themeColor]];
    
    [self.shareTwitterSwitch addTarget:self action:@selector(shareTwitterSwitched:) forControlEvents:UIControlEventValueChanged];
    [self.shareTwitterSwitch setOnTintColor:[UIColor themeColor]];
    
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            self.shareFacebookSwitch.on = [SPUtility isToShareOnFacebook];
        }
    }
    
    if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
        self.shareTwitterSwitch.on = [SPUtility isToShareOnTwitter];
    }
    
    self.commentTextView.contentInset = UIEdgeInsetsMake(0,-8,0,-8);
    
    self.currencyTextField.text = @"USD";
    NSString *currencyCode = @"USD";
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    self.priceTextField.placeholder = currencySymbol;
    
    if (self.webDictionary) {
        self.urlTextFIeld.text = [self.webDictionary objectForKey:@"url"];
        self.titleTextField.text = [self.webDictionary objectForKey:@"title"];
        NSNumber *price = [self.webDictionary objectForKey:@"price"];
        NSString *currencyCode = [self.webDictionary objectForKey:@"currency"];
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
        NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
        
        
        if (price) {
            float priceFloat= [price floatValue];
            self.priceTextField.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,priceFloat];
            self.currencyTextField.text = currencyCode;
        }
        
        if ([self.webDictionary objectForKey:@"images"]) {
            self.images = [self.webDictionary objectForKey:@"images"];
            [self refreshImageButtons];
        }
        
    }
}

- (IBAction)typeButtonPressed:(id)sender {
    if ([sender isEqual:self.wantItButton]) {
        self.wantItButton.selected = YES;
        self.sellItButton.selected = NO;
        [self.sellItView setHidden:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.shareView setFrame:CGRectMake(self.sellItView.frame.origin.x, self.sellItView.frame.origin.y, self.shareView.frame.size.width, self.shareView.frame.size.height)];
        [UIView commitAnimations];
        
    }else{
        [self.sellItView setHidden:NO];
        self.wantItButton.selected = NO;
        self.sellItButton.selected = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [self.shareView setFrame:CGRectMake(self.sellItView.frame.origin.x, CGRectGetMaxY(self.sellItView.frame), self.shareView.frame.size.width, self.shareView.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webDictionary release];
    [_titleTextField release];
    [_descriptionTextField release];
    [_categoryTextField release];
    [_priceTextField release];
    [_imageButtons release];
    [_images release];
    [_scrollView release];
    [_contentView release];
    [_wantItButton release];
    [_sellItButton release];
    [_sellItView release];
    [_currencyTextField release];
    [_urlTextFIeld release];
    [_contentTapView release];
    [_shareView release];
    [_shareFacebookSwitch release];
    [_shareTwitterSwitch release];
    [_deliverGloballySwitch release];
    [_commentTextView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTitleTextField:nil];
    [self setDescriptionTextField:nil];
    [self setCategoryTextField:nil];
    [self setPriceTextField:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setWantItButton:nil];
    [self setSellItButton:nil];
    [self setSellItView:nil];
    [self setCurrencyTextField:nil];
    [self setUrlTextFIeld:nil];
    [self setContentTapView:nil];
    [self setShareView:nil];
    [self setShareFacebookSwitch:nil];
    [self setShareTwitterSwitch:nil];
    [self setDeliverGloballySwitch:nil];
    [self setCommentTextView:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Button Events

- (IBAction)uploadButtonPressed:(id)sender {
    [self.commentTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.urlTextFIeld resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.currencyTextField resignFirstResponder];
    
    if ([self validation]) {
        [self sendAddProductRequest];
    }
}

- (IBAction)addPictureButtonPressed:(id)sender {
    UIButton *imageButton = sender;
    self.selectedImageButtonTag = imageButton.tag;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = nil;
        if ([self checkImageExists:imageButton.tag]) {
            actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:@"Delete Photo"
                                             otherButtonTitles:@"Camera",@"Album", @"Instagram",nil]
                           autorelease];
        }else{
            actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Camera",@"Album", @"Instagram",nil]
                           autorelease];
        }
        [actionSheet showInView:self.view];
    }else{
        if ([self checkImageExists:imageButton.tag]) {
            UIActionSheet *actionSheet = nil;
            actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:@"Delete Photo"
                                             otherButtonTitles:@"Album", @"Instagram",nil]
                           autorelease];
            [actionSheet showInView:self.view];
        }else{
            
            [self selectFromAlbum];
        }
    }
}

#pragma mark -
#pragma mark Request Events

- (void)sendAddProductRequest
{
    
    [self showHUDLoadingViewWithTitle:@"Uploading"];
    
    UIImage *image0 = ((self.images.count > 0)?[self.images objectAtIndex:0]:nil);
    UIImage *image1 = ((self.images.count > 1)?[self.images objectAtIndex:1]:nil);
    UIImage *image2 = ((self.images.count > 2)?[self.images objectAtIndex:2]:nil);
    UIImage *image3 = ((self.images.count > 3)?[self.images objectAtIndex:3]:nil);
    UIImage *image4 = ((self.images.count > 4)?[self.images objectAtIndex:4]:nil);
    UIImage *image5 = ((self.images.count > 5)?[self.images objectAtIndex:5]:nil);
    UIImage *image6 = ((self.images.count > 6)?[self.images objectAtIndex:6]:nil);
    UIImage *image7 = ((self.images.count > 7)?[self.images objectAtIndex:7]:nil);
    
    NSMutableArray *categories = nil;
    if (self.selectedCategory) {
        categories = [NSMutableArray arrayWithObjects:self.selectedCategory.categoryId,nil];
    }else{
        categories = [NSMutableArray arrayWithObjects:@"-1",nil];
    }
    
    NSString *price = nil;
    
    NSString *currencyCode = self.currencyTextField.text;
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    price = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
    
    NSString *comment = nil;
    if ([self.commentTextView.text isValid]) {
        comment = self.commentTextView.text;
    }
    
    [self sendAddPostRequestWithPostType:SHARE name:self.titleTextField.text url:self.urlTextFIeld.text price:[price floatValue] currency:self.currencyTextField.text description:self.descriptionTextField.text categoryIds:categories tag:nil img0:image0 img1:image1 img2:image2 img3:image3 img4:image4 img5:image5 img6:image6 img7:image7 comment:comment delegate:self];
}

- (void)SPAddPostRequestDidFinish:(SPGetPostInfoResponseData*)response
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
        
        [SPUtility postSPNotificationWithName:POSTDIDADD dictionary:nil];
        
        if ([self.delegate respondsToSelector:@selector(SPAddPostFromURLViewControllerDidUploadNewPost:)]) {
            [self.delegate SPAddPostFromURLViewControllerDidUploadNewPost:response.post];
        }
        
        [self showHUDTickViewWithMessage:@"Pict'd"];
        [self performSelector:@selector(dismissAddPostViewController) withObject:self afterDelay:1.0f];
    }
}

- (void)dismissAddPostViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.y-40) animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.currencyTextField]) {
        [self showCurrencySelectionControllerWithDelegate:self currencyCode:self.currencyTextField.text];
        return NO;
    }
    
    if ([textField isEqual:self.descriptionTextField]) {
        [self.titleTextField resignFirstResponder];
        [self.urlTextFIeld resignFirstResponder];
        [self.priceTextField resignFirstResponder];
        
        [self goToTextEditorViewControllerWithTitle:@"DESCRIPTION" limit:0 text:textField.text tag:1 delegate:self];

        return NO;
    }
    
    if ([textField isEqual:self.categoryTextField]) {
        [self.titleTextField resignFirstResponder];
        [self.urlTextFIeld resignFirstResponder];
        [self.priceTextField resignFirstResponder];
        
        [self showCategorySelectionViewControllerWithDelegate:self];
        return NO;
    }

   if ([textField isEqual:self.priceTextField]) {
       NSString *currencyCode = self.currencyTextField.text;
       NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
       NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
       
       self.priceTextField.text = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
   }
    
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-30) animated:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.priceTextField]) {
        NSString *currencyCode = self.currencyTextField.text;
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
        NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
        
        NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        NSString *priceTextFieldNumericText = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
        NSNumber* number = [numberFormatter numberFromString:priceTextFieldNumericText];
        if (number != nil) {
            self.priceTextField.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,[priceTextFieldNumericText floatValue]];                   
        }else{
            self.priceTextField.text = nil;
        }
    }
}

- (void)SPCurrencySelectionViewControllerDidSelectCurrency:(NSString *)currency
{
    NSString *currencyCode = self.currencyTextField.text;
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    
    self.priceTextField.text = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
    
    self.currencyTextField.text = currency;
    currencyCode = currency;
    locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    
    NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    NSString *priceTextFieldNumericText = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
    NSNumber* number = [numberFormatter numberFromString:priceTextFieldNumericText];
    if (number != nil) {
        self.priceTextField.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,[priceTextFieldNumericText floatValue]];
    }else{
        self.priceTextField.text = nil;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark -
#pragma mark SBTextEditorViewController Delegate

- (void)SBTextEditorViewControllerDidFinishEdit:(NSInteger)tag text:(NSString *)text
{
    [self.descriptionTextField setText:text];
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

- (void)selectFromInstagram
{
    [self showInstagramImagePickerControllerWithDelegate:self];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    [self displayEditorForImage:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)SBInstagramImagePickerControllerDidSelectImage:(UIImage *)image
{
    if ([self checkImageExists:self.selectedImageButtonTag]) {
        [self.images removeObjectAtIndex:self.selectedImageButtonTag];
        [self.images insertObject:image atIndex:self.selectedImageButtonTag];
    }else{
        [self.images addObject:image];
    }
    [self refreshImageButtons];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Camera"]) {
        [self takeNewPhoto];
    }else if([title isEqualToString:@"Album"]){
        [self selectFromAlbum];
    }else if ([title isEqualToString:@"Delete Photo"]){
        [self deletePhoto];
    }else if ([title isEqualToString:@"Instagram"]){
        [self selectFromInstagram];
    }else if ([title isEqualToString:@"Delete post"]){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - AFPhotoEditorController Event

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:NO completion:nil];
    [editorController release];
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    
    if ([SPUtility isToSaveInCameraRoll]) {
        [self showHUDLoadingViewWithTitle:@"Saving to camera roll..."];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self hideHUDLoadingView];
    }
    
    if ([self checkImageExists:self.selectedImageButtonTag]) {
        [self.images removeObjectAtIndex:self.selectedImageButtonTag];
        [self.images insertObject:image atIndex:self.selectedImageButtonTag];
    }else{
        [self.images addObject:image];
    }
    [self refreshImageButtons];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [editor dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -

- (void)deletePhoto{
    [self.images removeObjectAtIndex:self.selectedImageButtonTag];
    [self refreshImageButtons];
}

- (void)refreshImageButtons
{
    for (UIButton *imageButton in self.imageButtons) {
        [imageButton setImage:[UIImage imageNamed:@"button_landscape"] forState:UIControlStateNormal];
    }
    for (NSInteger i = 0; i <self.images.count; i++) {
        UIImage *image = [self.images objectAtIndex:i];
        UIButton *imageButton = [self.imageButtons objectAtIndex:i];
        [imageButton setImage:image forState:UIControlStateNormal];
    }
}

- (BOOL)checkImageExists:(NSInteger)tag
{
    if (self.images.count > tag) {
        return YES;
    }
    return NO;
}

- (BOOL)validation
{
    //Check Empty
    if (![self.titleTextField.text isValid]) {
        [self showErrorAlert:@"Please enter a name"];
        return NO;
    }

//    if (self.sellItButton.selected == YES) {
//        if (![self.currencyTextField.text isValid]) {
//            [self showErrorAlert:@"Please select your currency"];
//            return NO;
//        }
//        if (![self.priceTextField.text isValid]) {
//            [self showErrorAlert:@"Please enter a price"];
//            return NO;
//        }
//    }
//    
//    if (self.wantItButton.selected == YES) {
//        if (![self.urlTextFIeld.text isValid]) {
//            [self showErrorAlert:@"Please enter the URL to share"];
//            return NO;
//        }
//    }
//    
    if (![self.urlTextFIeld.text isValid]) {
        [self showErrorAlert:@"Please enter the URL"];
        return NO;
    }
    
    if (![self.priceTextField.text isValid]) {
        [self showErrorAlert:@"Please enter a price"];
        return NO;
    }
    
    if (self.images.count < 1) {
        [self showErrorAlert:@"Please provide at least 1 photo"];
        return NO;
    }
    
    //Check PriceField
    NSString *currencyCode = self.currencyTextField.text;
    NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    
    NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    NSString *priceTextFieldNumericText = [self.priceTextField.text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
    NSNumber* number = [numberFormatter numberFromString:priceTextFieldNumericText];
    if ([number floatValue] == 0) {
        [self showErrorAlert:@"Please enter a valid price."];
        return NO;
    }
    
    return YES;

}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.commentTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.urlTextFIeld resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.currencyTextField resignFirstResponder];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"SHOP";
}

- (void)SPCategorySelectionViewControllerDidSelectCategory:(SPCategory *)category
{
    self.selectedCategory = category;
    [self.categoryTextField setText:category.name];
}

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
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height-keyboardHeight)];
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
    [self.scrollView setFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction)shareFacebookSwitched:(id)sender{
    if (self.shareFacebookSwitch.on) {
        if ([[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK]) {
            if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                                      defaultAudience:FBSessionDefaultAudienceFriends
                                                    completionHandler:^(FBSession *session, NSError *error) {
                                                        if (!error) {
                                                            [SPUtility setToShareOnFacebook:YES];
                                                            self.shareFacebookSwitch.on = YES;
                                                        }else{
                                                            [self showHUDErrorViewWithMessage:@"Permission denied."];
                                                            [SPUtility setToShareOnFacebook:NO];
                                                            self.shareFacebookSwitch.on = NO;
                                                        }
                                                        //For this example, ignore errors (such as if user cancels).
                                                    }];
            }else{
                [SPUtility setToShareOnFacebook:YES];
            }
        }else{
            [self showHUDLoadingViewWithTitle:@"Authorizing"];
            [SPSocialManager sharedManager].delegate = self;
            [[SPSocialManager sharedManager]connectToThirdParty:FACEBOOK];
        }
    }else{
    }
}

- (IBAction)shareTwitterSwitched:(id)sender{
    if (self.shareTwitterSwitch.on) {
        if ([[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER]) {
            [SPUtility setToShareOnTwitter:YES];
        }else{
            [self showHUDLoadingViewWithTitle:@"Authorizing"];
            [SPSocialManager sharedManager].delegate = self;
            [[SPSocialManager sharedManager]connectToThirdParty:TWITTER];
        }
    }else{
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
    self.shareFacebookSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:FACEBOOK];
    self.shareTwitterSwitch.on = [[SPSocialManager sharedManager]isThirdPartyConnected:TWITTER];
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
                self.shareFacebookSwitch.on = NO;
                break;
            case TWITTER:
                self.shareTwitterSwitch.on = NO;
                break;
            default:
                break;
        }
    }else{
        [self showHUDTickViewWithMessage:@"Connected"];
        switch (path) {
            case FACEBOOK:
            {
                self.shareFacebookSwitch.on = YES;
                [SPUtility setToShareOnFacebook:YES];
                
                if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                    [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                                          defaultAudience:FBSessionDefaultAudienceFriends
                                                        completionHandler:^(FBSession *session, NSError *error) {
                                                            if (!error) {
                                                                [SPUtility setToShareOnFacebook:YES];
                                                                self.shareFacebookSwitch.on = YES;
                                                            }else{
                                                                [self showHUDErrorViewWithMessage:@"Permission denied."];
                                                                [SPUtility setToShareOnFacebook:NO];
                                                                self.shareFacebookSwitch.on = NO;
                                                            }
                                                        }];
                }
                break;
            case TWITTER:
                self.shareTwitterSwitch.on = YES;
                [SPUtility setToShareOnTwitter:YES];
                break;
            default:
                break;
            }
        }
    }
}


- (void)backButtonPressed
{
    UIActionSheet *actionSheet = nil;
    actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete post"
                                         otherButtonTitles:nil]
                       autorelease];
    [actionSheet showInView:self.view];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //Cancel
        case 1:
            if (alertView.tag == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            break;
            }
        default:
            break;
    }
    
}

- (IBAction)importImageFromWebButtonPressed:(id)sender
{
    if (self.images.count == 4) {
        [self showHUDErrorViewWithMessage:@"4 Pict At Most"];
        return;
    }
    
    if (![self.urlTextFIeld.text isValid]) {
        [self showHUDErrorViewWithMessage:@"Enter URL First"];
        return;
    }
    
    [self.commentTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    [self.urlTextFIeld resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.currencyTextField resignFirstResponder];
    
    SPWebImportViewController *webImportViewController = [[SPWebImportViewController alloc]initWithNibName:@"SPWebImportViewController" bundle:nil];
    webImportViewController.delegate = self;
    webImportViewController.imageNumber = 4 - self.images.count;
    webImportViewController.websiteURL = self.urlTextFIeld.text;
    [self.navigationController pushViewController:webImportViewController animated:YES];
    [webImportViewController release];
}

- (void)SPWebImportViewControllerDidSelectImage:(NSMutableDictionary*)info
{
    NSMutableArray *images = [info objectForKey:@"images"];
    for (UIImage*image in images){
        [self.images addObject:image];
    }
    [self refreshImageButtons];
    
    NSString *title = [info objectForKey:@"title"];
    if (title && ![self.titleTextField.text isValid]) {
        self.titleTextField.text = title;
    }
    
    NSNumber *price = [info objectForKey:@"price"];
    if (price && ![self.priceTextField.text isValid]) {
        float priceFloat= [price floatValue];
        self.priceTextField.text = [NSString stringWithFormat:@"USD $%.2f",priceFloat];
    }
}

- (void)shareFacebook
{
    NSDictionary *postParams = [NSDictionary dictionaryWithObjectsAndKeys:@"TEST FOR S",@"message",@"www.google.com",@"link",@"This is caption",@"caption",@"This is name",@"name",@"This is description",@"description", nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (void)shareTwitterWithUrl:(NSString *)url image:(UIImage *)image
{
    NSString *accountIdentifier = [SPSocialManager getConnectedTwitterIdentifier];
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccount *twitterAccount = [accountStore accountWithIdentifier:accountIdentifier];
    [accountStore release];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"I have posted this on %@",url],@"status",nil];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/update_with_media.json"] parameters:parameters requestMethod:TWRequestMethodPOST];
    //statuses/update.json
    
    [postRequest setAccount:twitterAccount];
    
    [postRequest addMultiPartData:UIImageJPEGRepresentation(image, 0.5) withName:@"media" type:@"multipart/form-data"];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
     {
         //show status after done
         if ([urlResponse statusCode]==200) {
             NSLog(@"SUCCESS");
         }else{
         }
     }];
}


@end
