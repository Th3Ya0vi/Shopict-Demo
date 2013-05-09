//
//  SPBaseViewController+SPViewControllerUtility.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月17日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPEnum.h"

@class SPAccount, SPPost, SPCategory, SPBaseViewController, SPVenue;
@interface SPBaseViewController (SPViewControllerUtility)

//Account
- (void)goToEditProfileViewControllerWithAccount:(SPAccount *)account;
- (void)goToChangePasswordViewController;
- (void)goToInterestSelectionViewController;
- (void)goToProfileViewControllerWithAccount:(SPAccount *)account;
- (void)goToSubscriptionFeedViewControllerWithAccount:(SPAccount *)account type:(FollowType)type;
- (void)goToWantedCountViewController:(SPPost *)post;

//Explore
- (void)goToExploreViewControllerWithCategory:(SPCategory *)category;

//Login
- (void)goToForgetPasswordViewController;
- (void)goToLoginOptionViewController;
- (void)goToLoginWithEmailViewController;
- (void)goToSignUpViewController;
- (void)goToFacebookFriendsViewController;

//Post
- (void)showAddPostFromURLViewControllerWithImage:(UIImage *)image;
- (void)goToAddPostFromURLBrowserViewControllerWithUrl:(NSString *)url;
- (void)showAddPostFromURLViewController;
- (void)showAddPostFromURLViewControllerWithWebsite:(NSMutableDictionary *)webDictionary;
- (void)goToPostViewControllerWithPost:(SPPost *)post;
- (void)goToPostHashTagFeedViewControllerWithHashTag:(NSString *)hashTag;
- (void)goToPostSearchFeedViewController:(NSString *)keyword;
- (void)goToPostCategoryFeedViewController:(SPCategory *)category;
- (void)showCategorySelectionViewControllerWithDelegate:(id)delegate;
- (void)showRepostViewControllerWithPost:(SPPost *)post;

//Setting
- (void)goToSettingViewController;
- (void)showInstagramImagePickerControllerWithDelegate:(id)delegate;
- (void)goToTextEditorViewControllerWithTitle:(NSString *)title limit:(NSInteger)limit text:(NSString *)text tag:(NSInteger)tag delegate:(id)delegate;
- (void)showTwitterAccountFeedViewControllerWithAccounts:(NSMutableArray *)accounts delegate:(id)delegate delegateViewController:(SPBaseViewController *)delegateViewController;
- (void)goToWebImportViewControllerWithWebSiteURL:(NSString *)websiteURL delegate:(id)delegate;
- (void)goToWebBrowerViewControllerWithWebSiteURL:(NSString *)websiteURL delegate:(id)delegate;
- (void)showCurrencySelectionControllerWithDelegate:(id)delegate currencyCode:(NSString*)currencyCode;

- (void)goToLocationSelectionControllerWithDelegate:(id)delegate;

- (void)showWebSupportViewControllerWithUrl:(NSString *)url withTitle:(NSString *)title;
- (void)goToVenueViewControllerWithVenue:(SPVenue *)venue;

@end
