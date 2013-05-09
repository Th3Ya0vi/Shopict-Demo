//
//  SPBaseViewController+SPRequestUtility.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController+SPRequestUtility.h"
#import "SPRegisterRequest.h"
#import "SPRegisterRequestData.h"
#import "SPLoginWithEmailRequest.h"
#import "SPLoginWithEmailRequestData.h"
#import "SPLoginWithThirdPartyRequest.h"
#import "SPLoginWithThirdPartyRequestData.h"
#import "SPForgetPasswordRequest.h"
#import "SPForgetPasswordRequestData.h"
#import "SPBindAccountToThirdPartyRequest.h"
#import "SPBindAccountToThirdPartyRequestData.h"
#import "SPUnbindAccountToThirdPartyRequest.h"
#import "SPUnbindAccountToThirdPartyRequestData.h"
#import "SPEditProfileRequest.h"
#import "SPEditProfileRequestData.h"
#import "SPGetAccountInfoByUserIdRequest.h"
#import "SPGetAccountInfoByUserIdRequestData.h"
#import "SPGetAccountInfoByUsernameRequest.h"
#import "SPGetAccountInfoByUsernameRequestData.h"
#import "SPChangePasswordRequest.h"
#import "SPChangePasswordRequestData.h"
#import "SPBindAccountToCategoriesRequest.h"
#import "SPBindAccountToCategoriesRequestData.h"
#import "SPReportProfileRequest.h"
#import "SPReportProfileRequestData.h"
#import "SPGetSubscriptionAccountsRequest.h"
#import "SPGetSubscriptionAccountsRequestData.h"
#import "SPGetSuggestedAccountsRequest.h"
#import "SPGetSuggestedAccountsRequestData.h"
#import "SPFindFriendsRequest.h"
#import "SPFindFriendsRequestData.h"
#import "SPLogoutRequest.h"
#import "SPLogoutRequestData.h"
#import "SPSubscribeAccountRequest.h"
#import "SPSubscribeAccountRequestData.h"
#import "SPGetCategoriesRequest.h"
#import "SPGetCategoriesRequestData.h"
#import "SPGetInstagramUserMediaRequest.h"
#import "SPGetInstagramUserMediaRequestData.h"
#import "SPAddPostRequest.h"
#import "SPAddPostRequestData.h"
#import "SPRepostRequest.h"
#import "SPRepostRequestData.h"
#import "SPCommentPostRequest.h"
#import "SPCommentPostRequestData.h"
#import "SPGetPostCommentsRequest.h"
#import "SPGetPostCommentsRequestData.h"
#import "SPGetPostInfoRequest.h"
#import "SPGetPostInfoRequestData.h"
#import "SPGetPostsRequest.h"
#import "SPGetPostsRequestData.h"
#import "SPGetPostsByCategoryRequest.h"
#import "SPGetPostsByCategoryRequestData.h"
#import "SPGetPostsByTagRequest.h"
#import "SPGetPostsByTagRequestData.h"
#import "SPGetPostsByUserIdRequest.h"
#import "SPGetPostsByUserIdRequestData.h"
#import "SPWantPostRequest.h"
#import "SPWantPostRequestData.h"
#import "SPGetAccountsByKeywordRequest.h"
#import "SPGetPostsByKeywordRequest.h"
#import "SPGetTagsByKeywordRequest.h"
#import "SPSearchRequestData.h"
#import "SPUtility.h"
#import "SPDeletePostRequest.h"
#import "SPDeletePostRequestData.h"
#import "SPGetNewsRequest.h"
#import "SPGetNewsRequestData.h"
#import "SPGetNewsResponseData.h"
#import "SPReportPostRequest.h"
#import "SPReportPostRequestData.h"
#import "SPGetFoursquareLocationsByKeywordRequest.h"
#import "SPGetFoursquareLocationsByKeywordRequestData.h"
#import "SPGetFoursquareLocationsByKeywordResponseData.h"
#import "SPGetFoursquareLocationsByLatLongRequest.h"
#import "SPGetFoursquareLocationsByLatLongRequestData.h"
#import "SPGetFoursquareLocationsByLatLongResponseData.h"
#import "SPAddPostFromPlaceRequest.h"
#import "SPAddPostFromPlaceRequestData.h"

@implementation SPBaseViewController (SPRequestUtility)

-(void)sendRegisterRequestWithEmail:(NSString *)email
                               name:(NSString *)name
                           username:(NSString *)username
                           password:(NSString *)password
                         profilePic:(UIImage *)profilePic
                           delegate:(id)delegate;
{
    SPRegisterRequestData *data = [SPRegisterRequestData dataWithEmail:email name:name username:username password:password profilePic:profilePic locale:[SPUtility locale] country:[SPUtility country] currency:[SPUtility currency] device:[SPUtility device] longitude:[SPUtility getDeviceLongitude] latitude:[SPUtility getDeviceLatitude]];
    SPRegisterRequest *request = [SPRegisterRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendLoginWithEmailRequestWithEmail:(NSString *)email
                                 password:(NSString *)password
                                 delegate:(id)delegate;
{
    SPLoginWithEmailRequestData *data = [SPLoginWithEmailRequestData dataWithEmail:email password:password locale:[SPUtility locale] country:[SPUtility country] currency:[SPUtility currency] device:[SPUtility device] longitude:[SPUtility getDeviceLongitude] latitude:[SPUtility getDeviceLatitude]];
    SPLoginWithEmailRequest *request = [SPLoginWithEmailRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendLoginWithThirdPartyRequestWithPath:(ThirdPartyPath)path
                                 thirdPartyId:(NSString *)thirdPartyId
                                     delegate:(id)delegate;
{
    SPLoginWithThirdPartyRequestData *data = [SPLoginWithThirdPartyRequestData dataWithPath:path thirdPartyId:thirdPartyId locale:[SPUtility locale] country:[SPUtility country] currency:[SPUtility currency] device:[SPUtility device] longitude:[SPUtility getDeviceLongitude] latitude:[SPUtility getDeviceLatitude]];
    SPLoginWithThirdPartyRequest *request = [SPLoginWithThirdPartyRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendForgetPasswordRequestWithEmail:(NSString *)email
                                 delegate:(id)delegate;
{
    SPForgetPasswordRequestData *data = [SPForgetPasswordRequestData dataWithEmail:email];
    SPForgetPasswordRequest *request = [SPForgetPasswordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendBindAccountToThirdPartyRequestWithThirdPartyId:(NSString *)thirdPartyId
                                                     path:(ThirdPartyPath)path
                                                 delegate:(id)delegate;
{
    SPBindAccountToThirdPartyRequestData *data = [SPBindAccountToThirdPartyRequestData dataWithToken:[SPUtility getStoredToken] thirdPartyId:thirdPartyId path:path];
    SPBindAccountToThirdPartyRequest *request = [SPBindAccountToThirdPartyRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendUnbindAccountToThirdPartyRequestWithPath:(ThirdPartyPath)path
                                           delegate:(id)delegate
{
    SPUnbindAccountToThirdPartyRequestData *data = [SPUnbindAccountToThirdPartyRequestData dataWithToken:[SPUtility getStoredToken] path:path];
    SPUnbindAccountToThirdPartyRequest *request = [SPUnbindAccountToThirdPartyRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendEditProfileRequestWithName:(NSString *)name
                             username:(NSString *)username
                                email:(NSString *)email
                              website:(NSString *)website
                          description:(NSString *)description
                          phoneNumber:(NSString *)phoneNumber
                       editProfilePic:(BOOL)editProfilePic
                           profilePic:(UIImage *)profilePic
                         editCoverPic:(BOOL)editCoverPic
                             coverPic:(UIImage *)coverPic
                             delegate:(id)delegate;
{
    SPEditProfileRequestData *data = [SPEditProfileRequestData dataWithToken:[SPUtility getStoredToken] name:name username:username email:email website:website description:description phoneNumber:phoneNumber editProfilePic:editProfilePic profilePic:profilePic editCoverPic:editCoverPic coverPic:coverPic];
    SPEditProfileRequest *request = [SPEditProfileRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetAccountInfoByUserIdRequestWithUserId:(NSString *)userId
                                          delegate:(id)delegate;
{
    SPGetAccountInfoByUserIdRequestData *data = [SPGetAccountInfoByUserIdRequestData dataWithToken:[SPUtility getStoredToken] userId:userId];
    SPGetAccountInfoByUserIdRequest *request = [SPGetAccountInfoByUserIdRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetAccountInfoByUsernameRequestWithUsername:(NSString *)username
                                              delegate:(id)delegate;

{
    SPGetAccountInfoByUsernameRequestData *data = [SPGetAccountInfoByUsernameRequestData dataWithToken:[SPUtility getStoredToken] username:username];
    SPGetAccountInfoByUsernameRequest *request = [SPGetAccountInfoByUsernameRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendChangePasswordRequestWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
                                       delegate:(id)delegate;
{
    SPChangePasswordRequestData *data = [SPChangePasswordRequestData dataWithToken:[SPUtility getStoredToken] oldPassword:oldPassword newPassword:newPassword];
    SPChangePasswordRequest *request = [SPChangePasswordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendBindAccountToCategoriesRequestWithCategoryIds:(NSMutableArray *)categoryIds
                                                delegate:(id)delegate;
{
    SPBindAccountToCategoriesRequestData *data = [SPBindAccountToCategoriesRequestData dataWithToken:[SPUtility getStoredToken] categoryIds:categoryIds];
    SPBindAccountToCategoriesRequest *request = [SPBindAccountToCategoriesRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendReportProfileRequestWithReportUId:(NSString *)reportUId
                                    delegate:(id)delegate;
{
    SPReportProfileRequestData *data = [SPReportProfileRequestData dataWithToken:[SPUtility getStoredToken] reportUId:reportUId];
    SPReportProfileRequest *request = [SPReportProfileRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetSubscriptionAccountsRequestWithUserId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey
                                           delegate:(id)delegate;
{
    SPGetSubscriptionAccountsRequestData *data = [SPGetSubscriptionAccountsRequestData dataWithToken:[SPUtility getStoredToken] userId:userId follow:follow startKey:startKey];
    SPGetSubscriptionAccountsRequest *request = [SPGetSubscriptionAccountsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetSuggestedAccountsRequestWithDelegate:(id)delegate;
{
    SPGetSuggestedAccountsRequestData *data = [SPGetSuggestedAccountsRequestData dataWithToken:[SPUtility getStoredToken]];
    SPGetSuggestedAccountsRequest *request = [SPGetSuggestedAccountsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendFindFriendsRequestWithPath:(ThirdPartyPath)path
                        thirdPartyIds:(NSMutableArray *)thirdPartyIds
                             delegate:(id)delegate;
{
    SPFindFriendsRequestData *data = [SPFindFriendsRequestData dataWithToken:[SPUtility getStoredToken] path:path thirdPartyIds:thirdPartyIds];
    SPFindFriendsRequest *request = [SPFindFriendsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendLogoutRequestWithDelegate:(id)delegate;
{
    SPLogoutRequestData *data = [SPLogoutRequestData dataWithToken:[SPUtility getStoredToken]];
    SPLogoutRequest *request = [SPLogoutRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendSubscribeAccountRequestWithAccount:(SPAccount *)account
                                     subscribe:(BOOL)subscribe
                                      delegate:(id)delegate;
{
    SPSubscribeAccountRequestData *data = [SPSubscribeAccountRequestData dataWithAccount:account token:[SPUtility getStoredToken] subscribe:subscribe];
    SPSubscribeAccountRequest *request = [SPSubscribeAccountRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetCategoriesRequestWithCategoryId:(NSString *)categoryId
                                     delegate:(id)delegate;
{
    SPGetCategoriesRequestData *data = [SPGetCategoriesRequestData dataWithToken:[SPUtility getStoredToken] categoryId:categoryId];
    SPGetCategoriesRequest *request = [SPGetCategoriesRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetInstagramUserMediaRequestWithNextUrl:(NSString *)nextUrl
                                          delegate:(id)delegate;
{
    SPGetInstagramUserMediaRequestData *data = [SPGetInstagramUserMediaRequestData dataWithNextUrl:nextUrl];
    SPGetInstagramUserMediaRequest *request = [SPGetInstagramUserMediaRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendAddPostRequestWithPostType:(PostType)postType
                                  name:(NSString *)name
                                   url:(NSString *)url
                                 price:(float)price
                              currency:(NSString *)currency
                           description:(NSString *)description
                           categoryIds:(NSMutableArray *)categoryIds
                                   tag:(NSString *)tag
                                  img0:(UIImage *)img0
                                  img1:(UIImage *)img1
                                  img2:(UIImage *)img2
                                  img3:(UIImage *)img3
                                  img4:(UIImage *)img4
                                  img5:(UIImage *)img5
                                  img6:(UIImage *)img6
                                  img7:(UIImage *)img7
                               comment:(NSString *)comment
                              delegate:(id)delegate;
{
    SPAddPostRequestData *data = [SPAddPostRequestData dataWithToken:[SPUtility getStoredToken] postType:postType name:name url:url price:price currency:currency description:description categoryIds:categoryIds tag:tag img0:img0 img1:img1 img2:img2 img3:img3 img4:img4 img5:img5 img6:img6 img7:img7 comment:comment];
    SPAddPostRequest *request = [SPAddPostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendAddPostFromPlaceRequestWithPostType:(PostType)postType
                                           name:(NSString *)name
                                          price:(float)price
                                       currency:(NSString *)currency
                                    description:(NSString *)description
                                    categoryIds:(NSMutableArray *)categoryIds
                                            tag:(NSString *)tag
                                           img0:(UIImage *)img0
                                           img1:(UIImage *)img1
                                           img2:(UIImage *)img2
                                           img3:(UIImage *)img3
                                           img4:(UIImage *)img4
                                           img5:(UIImage *)img5
                                           img6:(UIImage *)img6
                                           img7:(UIImage *)img7
                                        comment:(NSString *)comment
                                       delegate:(id)delegate
                                   foursquareId:(NSString *)foursquareId
                                      placeName:(NSString *)placeName
                                        address:(NSString *)address
                                    countryCode:(NSString *)countryCode
                                       latitude:(float)latitude
                                      longitude:(float)longitude
{
    SPAddPostFromPlaceRequestData *data = [SPAddPostFromPlaceRequestData dataWithToken:[SPUtility getStoredToken] postType:SHARE name:name price:price currency:currency description:description categoryIds:categoryIds tag:tag img0:img0 img1:img1 img2:img2 img3:img3 img4:img4 img5:img5 img6:img6 img7:img7 comment:comment foursquareId:foursquareId placeName:placeName address:address countryCode:countryCode latitude:latitude longitude:longitude];
    SPAddPostFromPlaceRequest *request = [SPAddPostFromPlaceRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendRepostRequestWithPost:(SPPost *)post
                          comment:(NSString *)comment
                         delegate:(id)delegate;
{
    SPRepostRequestData *data = [SPRepostRequestData dataWithToken:[SPUtility getStoredToken] post:post comment:comment];
    SPRepostRequest *request = [SPRepostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendCommentPostRequestWithPostId:(NSString *)postId
                                comment:(NSString *)comment
                               delegate:(id)delegate;
{
    SPCommentPostRequestData *data = [SPCommentPostRequestData dataWithPostId:postId token:[SPUtility getStoredToken] comment:comment];
    SPCommentPostRequest *request = [SPCommentPostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendDeletePostRequestWithPost:(SPPost *)post
                                 repost:(BOOL)repost
                               delegate:(id)delegate
{
    SPDeletePostRequestData *data = [SPDeletePostRequestData dataWithPost:post token:[SPUtility getStoredToken] repost:repost];
    SPDeletePostRequest *request = [SPDeletePostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendGetPostCommentsRequestWithPostId:(NSString *)postId
                                    startKey:(NSString *)startKey
                                    delegate:(id)delegate;
{
    SPGetPostCommentsRequestData *data = [SPGetPostCommentsRequestData dataWithPostId:postId token:[SPUtility getStoredToken] startKey:startKey];
    SPGetPostCommentsRequest *request = [SPGetPostCommentsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostInfoRequestWithPostId:(NSString *)postId
                               delegate:(id)delegate;
{
    SPGetPostInfoRequestData *data = [SPGetPostInfoRequestData dataWithPostId:postId token:[SPUtility getStoredToken]];
    SPGetPostInfoRequest *request = [SPGetPostInfoRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostsRequestWithStartKey:(NSString *)startKey
                              delegate:(id)delegate;
{
    SPGetPostsRequestData *data = [SPGetPostsRequestData dataWithToken:[SPUtility getStoredToken] startKey:startKey];
    SPGetPostsRequest *request = [SPGetPostsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostsByCategoryRequestWithCategoryId:(NSString *)categoryId
                                          startKey:(NSString *)startKey
                                          delegate:(id)delegate;
{
    SPGetPostsByCategoryRequestData *data = [SPGetPostsByCategoryRequestData dataWithToken:[SPUtility getStoredToken] categoryId:categoryId startKey:startKey];
    SPGetPostsByCategoryRequest *request = [SPGetPostsByCategoryRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostsByTagRequestWithTag:(NSString *)tag
                              startKey:(NSString *)startKey
                              delegate:(id)delegate;
{
    SPGetPostsByTagRequestData *data = [SPGetPostsByTagRequestData dataWithToken:[SPUtility getStoredToken] tag:tag startKey:startKey];
    SPGetPostsByTagRequest *request = [SPGetPostsByTagRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostsByUserIdRequestWithUserId:(NSString *)userId
                                        type:(PostType)type
                                    startKey:(NSString *)startKey
                                    delegate:(id)delegate;
{
    SPGetPostsByUserIdRequestData *data = [SPGetPostsByUserIdRequestData dataWithToken:[SPUtility getStoredToken] userId:userId type:type startKey:startKey];
    SPGetPostsByUserIdRequest *request = [SPGetPostsByUserIdRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendWantPostRequestWithPost:(SPPost *)post
                                 want:(BOOL)want
                             delegate:(id)delegate;
{
    SPWantPostRequestData *data =[SPWantPostRequestData dataWithPost:post token:[SPUtility getStoredToken] want:want];
    SPWantPostRequest *request = [SPWantPostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetAccountsByKeywordRequestWithKeyword:(NSString *)keyword
                                         startKey:(NSString *)startKey
                                         delegate:(id)delegate;
{
    SPSearchRequestData *data = [SPSearchRequestData dataWithToken:[SPUtility getStoredToken] keyword:keyword startKey:startKey];
    SPGetAccountsByKeywordRequest *request = [SPGetAccountsByKeywordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetPostsByKeywordRequestWithKeyword:(NSString *)keyword
                                      startKey:(NSString *)startKey
                                      delegate:(id)delegate
{
    SPSearchRequestData *data = [SPSearchRequestData dataWithToken:[SPUtility getStoredToken] keyword:keyword startKey:startKey];
    SPGetPostsByKeywordRequest *request = [SPGetPostsByKeywordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetTagsByKeywordRequestWithKeyword:(NSString *)keyword
                                     startKey:(NSString *)startKey
                                     delegate:(id)delegate;
{
    SPSearchRequestData *data = [SPSearchRequestData dataWithToken:[SPUtility getStoredToken] keyword:keyword startKey:startKey];
    SPGetTagsByKeywordRequest *request = [SPGetTagsByKeywordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

-(void)sendGetNewsRequestWithStartKey:(NSString *)startKey
                             delegate:(id)delegate
{
    SPGetNewsRequestData *data = [SPGetNewsRequestData dataWithToken:[SPUtility getStoredToken] startKey:startKey];
    SPGetNewsRequest *request = [SPGetNewsRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendReportPostRequestWithPost:(SPPost *)post
                             delegate:(id)delegate
                                 type:(ReportPostWithURLType)type;
{
    SPReportPostRequestData *data = [SPReportPostRequestData dataWithPost:post token:[SPUtility getStoredToken] type:type];
    SPReportPostRequest *request = [SPReportPostRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendGetFoursquareLocationWithDelegate:(id)delegate
{
    SPGetFoursquareLocationsByLatLongRequestData *data = [SPGetFoursquareLocationsByLatLongRequestData dataWithLatitude:[SPUtility getDeviceLatitude] longitude:[SPUtility getDeviceLongitude]];
    SPGetFoursquareLocationsByLatLongRequest *request = [SPGetFoursquareLocationsByLatLongRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}

- (void)sendGetFoursquareLocationWithKeyword:(NSString *)keyword delegate:(id)delegate
{
    SPGetFoursquareLocationsByKeywordRequestData *data = [SPGetFoursquareLocationsByKeywordRequestData dataWithKeyword:keyword latitude:[SPUtility getDeviceLatitude] longitude:[SPUtility getDeviceLongitude]];
    SPGetFoursquareLocationsByKeywordRequest *request = [SPGetFoursquareLocationsByKeywordRequest requestWithRequestData:data delegate:delegate];
    [request retrieve];
}



@end
