//
//  SPProductMainFeedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostMainFeedViewController.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"
#import "SPProduct.h"
#import "SPPost.h"
#import "UIButton+SPButtonUtility.h"
#import "SPImagePickerController.h"
#import "SPBaseNavigationController.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPGetPostsResponseData.h"
#import "SPAddPostFromURLBrowserViewController.h"
#import "SPLocationManager.h"
#import "SDWebImageManager.h"

@interface SPPostMainFeedViewController ()

@end

@implementation SPPostMainFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBarWithLogo];
    
    //Add +post button
    UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"+ Pict"];
    [addPostButton addTarget:self action:@selector(addItemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
    [self.navigationItem setLeftBarButtonItem:addPostButtonItem];
    [addPostButton release];
    
    self.addPostOptionView.hidden = YES;
    
    [self setIsGridViewButton:[SPUtility isMainFeedGrid]];
}

#pragma mark - Request Methods

- (void)sendGetPostsRequest
{
    [self sendGetAllProductsRequest];
}

- (void)sendGetAllProductsRequest
{
    self.isLoading = YES;
    self.isRequestFailed = NO;
    
    [self sendGetPostsRequestWithStartKey:self.nextKey delegate:self];
}

- (void)SPGetPostsRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey
{
    if (_reloading) {
        self.isLastPost = NO;
        [self doneLoadingTableViewData];
    }
    
    if (response.error) {
        
        self.isRequestFailed = YES;
        
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
        
        if (!startKey) {
            self.posts = nil;
            [self.productTableView reloadData];
        }
        
        if (self.posts) {
            for (SPPost *toAddProduct in response.posts) {
                BOOL included = NO;
                for (SPPost *product in self.posts) {
                    if ([product.postId isEqualToString:toAddProduct.postId]) {
                        included = YES;
                    }
                }
                if (!included) {
                    if (self.isGridView) {
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadWithURL:[NSURL URLWithString:[toAddProduct.product.thumbnailURLs objectAtIndex:0]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        }];
                    }else{
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadWithURL:[NSURL URLWithString:[toAddProduct.product.imgURLs objectAtIndex:0]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        }];
                    }
                    [self.posts addObject:toAddProduct];
                }
                
            }
        }else{
            self.posts = response.posts;
        }
        
        self.nextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.isLastPost = YES;
        }
    }
    [self.productTableView reloadData];
    self.isLoading = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Button events

- (IBAction)addItemButtonPressed:(id)sender {
    
    UIButton *cancelButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [cancelButton release];

    [self killScroll];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [self.navigationItem setRightBarButtonItem:nil];
    [self hideTabBar:self.navigationController.tabBarController];
    self.addPostOptionView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
}

- (void)productDidAdd:(NSNotification *)notification
{
    _reloading = YES;
    self.posts = nil;
    self.isRequestFailed = NO;
    [self.productTableView reloadData];
    self.nextKey = nil;
	[self sendGetPostsRequest];
}

- (void)postDidAdd:(NSNotification *)notification
{
    [self reloadAll];
}

- (IBAction)viewStyleButtonPressed:(id)sender{
    [super viewStyleButtonPressed:sender];
    [SPUtility setIsMainFeedGrid:self.isGridView];
}

- (void)dealloc
{
    [_addPostFromURLBrowserViewController release];
    [_addPostOptionView release];
    [super dealloc];
}



- (SPAddPostFromURLBrowserViewController *)addPostFromURLBrowserViewController
{
    if (!_addPostFromURLBrowserViewController) {
        _addPostFromURLBrowserViewController = [[SPAddPostFromURLBrowserViewController alloc]initWithNibName:@"SPAddPostFromURLBrowserViewController" bundle:nil];
        [_addPostFromURLBrowserViewController retain];
    }
    return _addPostFromURLBrowserViewController;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self setIsGridViewButton:self.isGridView];
    [self showTabBar:self.navigationController.tabBarController];
    self.addPostOptionView.hidden = YES;

    //Add +post button
    UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"+ Pict"];
    [addPostButton addTarget:self action:@selector(addItemButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
    [self.navigationItem setLeftBarButtonItem:addPostButtonItem];
    [addPostButton release];
}

- (IBAction)addPictFromPlaceButtonPressed:(id)sender {
    [[SPLocationManager sharedManager]startUpdatingLocation];
    [self cancelButtonPressed:nil];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = nil;
        actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Camera",@"Album", @"Instagram",nil];
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else{
        UIActionSheet *actionSheet = nil;
        actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Album", @"Instagram",nil]
                       autorelease];
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}

- (IBAction)addPictFromLinkButtonPressed:(id)sender {
    [self cancelButtonPressed:nil];
    [self.navigationController pushViewController:self.addPostFromURLBrowserViewController animated:YES];
    [self.addPostFromURLBrowserViewController.urlTextField becomeFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Camera"]) {
        [self takeNewPhoto];
    }else if([title isEqualToString:@"Album"]){
        [self selectFromAlbum];
    }else if ([title isEqualToString:@"Instagram"]){
        [self selectFromInstagram];
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
    [editor dismissViewControllerAnimated:YES completion:^{
        [self showAddPostFromURLViewControllerWithImage:image];
    }];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [editor dismissViewControllerAnimated:YES completion:nil];
}

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
    [self showAddPostFromURLViewControllerWithImage:image];
}

- (void) hideTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
    float fHeight = screenRect.size.height;
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width;
    }
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
            view.backgroundColor = [UIColor blackColor];
        }
    }
//    [UIView commitAnimations];
}



- (void) showTabBar:(UITabBarController *) tabbarcontroller
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float fHeight = screenRect.size.height - 44.0;
    
    if(  UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) )
    {
        fHeight = screenRect.size.width - 44.0;
    }
    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, fHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, fHeight)];
        }       
    }
//    [UIView commitAnimations]; 
}

- (void)killScroll
{
    CGPoint offset = self.productTableView.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self.productTableView setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self.productTableView setContentOffset:offset animated:NO];
}

@end
