//
//  SPBaseViewController+SPViewControllerUtility.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月17日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPEditProfileViewController.h"
#import "SPChangePasswordViewController.h"
#import "SPInterestSelectionViewController.h"
#import "SPProfileViewController.h"
#import "SPSubscriptionFeedViewController.h"
#import "SPWantedCountViewController.h"
#import "SPExploreViewController.h"
#import "SPForgetPasswordViewController.h"
#import "SPLogInOptionViewController.h"
#import "SPLogInWithEmailViewController.h"
#import "SPSignUpViewController.h"
#import "SPAddPostFromURLViewController.h"
#import "SPPostViewController.h"
#import "SPPostHashTagFeedViewController.h"
#import "SPPostSearchFeedViewController.h"
#import "SPSettingViewController.h"
#import "SPInstagramImagePickerController.h"
#import "SPTextEditorViewController.h"
#import "SPTwitterAccountFeedViewController.h"
#import "SPWebImportViewController.h"
#import "SPBaseNavigationController.h"
#import "SPWebBrowerViewController.h"
#import "SPPostCategoryFeedViewController.h"
#import "SPFacebookFriendsViewController.h"
#import "SPCategorySelectionViewController.h"
#import "SPRepostViewController.h"
#import "SPAddPostFromURLBrowserViewController.h"
#import "SPCurrencySelectionViewController.h"
#import "SPLocationSelectionViewController.h"
#import "SPAddPostFromPlaceViewController.h"
#import "SPWebSupportViewController.h"
#import "SPPostMapViewController.h"

@implementation SPBaseViewController (SPViewControllerUtility)

//Account
- (void)goToEditProfileViewControllerWithAccount:(SPAccount *)account
{
    SPEditProfileViewController *viewController = [[SPEditProfileViewController alloc]initWithNibName:@"SPEditProfileViewController" bundle:nil];
    viewController.currentAccount = account;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToChangePasswordViewController
{
    SPChangePasswordViewController *viewController = [[SPChangePasswordViewController alloc]initWithNibName:@"SPChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToInterestSelectionViewController
{
    SPInterestSelectionViewController *viewController = [[SPInterestSelectionViewController alloc]initWithNibName:@"SPInterestSelectionViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToProfileViewControllerWithAccount:(SPAccount *)account
{
    SPProfileViewController *viewController = [[SPProfileViewController alloc]initWithNibName:(IS_IPAD?@"SPProfileViewController_iPad":@"SPProfileViewController") bundle:nil];
    viewController.account = account;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToSubscriptionFeedViewControllerWithAccount:(SPAccount *)account type:(FollowType)type
{
    SPSubscriptionFeedViewController *viewController = [[SPSubscriptionFeedViewController alloc]initWithNibName:@"SPSubscriptionFeedViewController" bundle:nil];
    viewController.account = account;
    viewController.type = type;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToWantedCountViewController:(SPPost *)post
{
    SPWantedCountViewController *viewController = [[SPWantedCountViewController alloc]initWithNibName:@"SPWantedCountViewController" bundle:nil];
    viewController.post = post;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

//Explore
- (void)goToExploreViewControllerWithCategory:(SPCategory *)category
{
    SPExploreViewController *viewController = [[SPExploreViewController alloc]initWithNibName:@"SPExploreViewController" bundle:nil];
    viewController.category = category;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

//Login
- (void)goToForgetPasswordViewController
{
    SPForgetPasswordViewController *viewController = [[SPForgetPasswordViewController alloc]initWithNibName:@"SPForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToLoginOptionViewController
{
    SPLogInOptionViewController *viewController = [[SPLogInOptionViewController alloc]initWithNibName:@"SPLogInOptionViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToLoginWithEmailViewController
{
    SPLogInWithEmailViewController *viewController = [[SPLogInWithEmailViewController alloc]initWithNibName:@"SPLogInWithEmailViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)goToSignUpViewController
{
    SPSignUpViewController *viewController = [[SPSignUpViewController alloc]initWithNibName:@"SPSignUpViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

//Post
- (void)showAddPostFromURLViewControllerWithImage:(UIImage *)image
{
    SPAddPostFromPlaceViewController *viewController = [[SPAddPostFromPlaceViewController alloc]initWithNibName:@"SPAddPostFromPlaceViewController" bundle:nil];
    viewController.capturedImage = image;
    viewController.delegate = self;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}



- (void)goToAddPostFromURLBrowserViewControllerWithUrl:(NSString *)url
{
    SPAddPostFromURLBrowserViewController *viewController = [[SPAddPostFromURLBrowserViewController alloc]initWithNibName:@"SPAddPostFromURLBrowserViewController" bundle:nil];
    viewController.websiteURL = url;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showAddPostFromURLViewController
{
    SPAddPostFromURLViewController *viewController = [[SPAddPostFromURLViewController alloc]initWithNibName:@"SPAddPostFromURLViewController" bundle:nil];
    viewController.delegate = self;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)showAddPostFromURLViewControllerWithWebsite:(NSMutableDictionary *)webDictionary
{
    SPAddPostFromURLViewController *viewController = [[SPAddPostFromURLViewController alloc]initWithNibName:@"SPAddPostFromURLViewController" bundle:nil];
    viewController.delegate = self;
    viewController.webDictionary = webDictionary;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)goToPostViewControllerWithPost:(SPPost *)post
{
    SPPostViewController *viewController = [[SPPostViewController alloc]initWithNibName:@"SPPostViewController" bundle:nil];
    viewController.post = post;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToPostHashTagFeedViewControllerWithHashTag:(NSString *)hashTag
{
    SPPostHashTagFeedViewController *viewController = [[SPPostHashTagFeedViewController alloc]initWithNibName:@"SPPostHashTagFeedViewController" bundle:nil];
    viewController.hashTag = hashTag;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
- (void)goToPostSearchFeedViewController:(NSString *)keyword
{
    SPPostSearchFeedViewController *viewController = [[SPPostSearchFeedViewController alloc]initWithNibName:@"SPPostSearchFeedViewController" bundle:nil];
    viewController.keyword = keyword;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToPostCategoryFeedViewController:(SPCategory *)category
{
    SPPostCategoryFeedViewController *viewController = [[SPPostCategoryFeedViewController alloc]initWithNibName:@"SPPostCategoryFeedViewController" bundle:nil];
    viewController.category = category;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showCategorySelectionViewControllerWithDelegate:(id)delegate
{
    SPCategorySelectionViewController *viewController = [[SPCategorySelectionViewController alloc]initWithNibName:@"SPCategorySelectionViewController" bundle:nil];
    viewController.delegate = delegate;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)showRepostViewControllerWithPost:(SPPost *)post
{
    SPRepostViewController *viewController = [[SPRepostViewController alloc]initWithNibName:@"SPRepostViewController" bundle:nil];
    viewController.post = post;
    viewController.delegate = self;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

//Setting
- (void)goToSettingViewController
{
    SPSettingViewController *viewController =[[ SPSettingViewController alloc]initWithNibName:@"SPSettingViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showInstagramImagePickerControllerWithDelegate:(id)delegate
{
    SPInstagramImagePickerController *viewController = [[SPInstagramImagePickerController alloc]initWithNibName:@"SPInstagramImagePickerController" bundle:nil];
    viewController.delegate = delegate;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)goToTextEditorViewControllerWithTitle:(NSString *)title limit:(NSInteger)limit text:(NSString *)text tag:(NSInteger)tag delegate:(id)delegate
{
    SPTextEditorViewController *viewController = [[SPTextEditorViewController alloc]initWithNibName:@"SPTextEditorViewController" bundle:nil];
    viewController.title = title;
    viewController.wordLimit = limit;
    viewController.editorText = text;
    viewController.tag = tag;
    viewController.delegate = delegate;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showTwitterAccountFeedViewControllerWithAccounts:(NSMutableArray *)accounts delegate:(id)delegate delegateViewController:(SPBaseViewController *)delegateViewController
{
    SPTwitterAccountFeedViewController *viewController = [[SPTwitterAccountFeedViewController alloc]initWithNibName:@"SPTwitterAccountFeedViewController" bundle:nil];
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    viewController.delegate = delegate;
    viewController.accounts = accounts;
    [delegateViewController.navigationController presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)goToWebImportViewControllerWithWebSiteURL:(NSString *)websiteURL delegate:(id)delegate
{
    SPWebImportViewController *viewController = [[SPWebImportViewController alloc]initWithNibName:@"SPWebImportViewController" bundle:nil];
    viewController.websiteURL = websiteURL;
    viewController.delegate = delegate;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToWebBrowerViewControllerWithWebSiteURL:(NSString *)websiteURL delegate:(id)delegate
{
    SPWebBrowerViewController *viewController = [[SPWebBrowerViewController alloc]initWithNibName:@"SPWebBrowerViewController" bundle:nil];
    viewController.websiteURL = websiteURL;
    viewController.delegate = delegate;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)goToFacebookFriendsViewController
{
    SPFacebookFriendsViewController *viewController = [[SPFacebookFriendsViewController alloc]initWithNibName:@"SPFacebookFriendsViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showCurrencySelectionControllerWithDelegate:(id)delegate currencyCode:(NSString*)currencyCode
{
    SPCurrencySelectionViewController *viewController = [[SPCurrencySelectionViewController alloc]initWithNibName:@"SPCurrencySelectionViewController" bundle:nil];
    viewController.delegate = delegate;
    viewController.currency = currencyCode;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)goToLocationSelectionControllerWithDelegate:(id)delegate
{
    SPLocationSelectionViewController *viewController = [[SPLocationSelectionViewController alloc]initWithNibName:@"SPLocationSelectionViewController" bundle:nil];
    viewController.delegate = delegate;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)showWebSupportViewControllerWithUrl:(NSString *)url withTitle:(NSString *)title
{
    SPWebSupportViewController *viewController = [[SPWebSupportViewController alloc]initWithNibName:@"SPWebSupportViewController" bundle:nil];
    viewController.websiteURL = url;
    viewController.navigationItem.title = title;
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [viewController release];
    [navigationController release];
}

- (void)goToVenueViewControllerWithVenue:(SPVenue *)venue
{
    SPPostMapViewController *viewController = [[SPPostMapViewController alloc]initWithNibName:@"SPPostMapViewController" bundle:nil];
    viewController.venue = venue;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
