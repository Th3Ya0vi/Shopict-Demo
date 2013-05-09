//
//  SPBaseViewController-SPRequestUtility.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseViewController.h"
#import "SPEnum.h"

@class SPAccount, SPPost;

@interface SPBaseViewController (SPRequestUtility)



-(void)sendRegisterRequestWithEmail:(NSString *)email
                               name:(NSString *)name
                           username:(NSString *)username
                           password:(NSString *)password
                         profilePic:(UIImage *)profilePic
                           delegate:(id)delegate;



-(void)sendLoginWithEmailRequestWithEmail:(NSString *)email
                                 password:(NSString *)password
                                 delegate:(id)delegate;



-(void)sendLoginWithThirdPartyRequestWithPath:(ThirdPartyPath)path
                                 thirdPartyId:(NSString *)thirdPartyId
                                     delegate:(id)delegate;



-(void)sendForgetPasswordRequestWithEmail:(NSString *)email
                                 delegate:(id)delegate;



-(void)sendBindAccountToThirdPartyRequestWithThirdPartyId:(NSString *)thirdPartyId
                                                     path:(ThirdPartyPath)path
                                                 delegate:(id)delegate;




-(void)sendUnbindAccountToThirdPartyRequestWithPath:(ThirdPartyPath)path
                                           delegate:(id)delegate;




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



-(void)sendGetAccountInfoByUserIdRequestWithUserId:(NSString *)userId
                                          delegate:(id)delegate;



-(void)sendGetAccountInfoByUsernameRequestWithUsername:(NSString *)username
                                              delegate:(id)delegate;



-(void)sendChangePasswordRequestWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
                                       delegate:(id)delegate;



-(void)sendBindAccountToCategoriesRequestWithCategoryIds:(NSMutableArray *)categoryIds
                                                delegate:(id)delegate;



-(void)sendReportProfileRequestWithReportUId:(NSString *)reportUId
                                    delegate:(id)delegate;



-(void)sendGetSubscriptionAccountsRequestWithUserId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey
                                           delegate:(id)delegate;



-(void)sendGetSuggestedAccountsRequestWithDelegate:(id)delegate;



-(void)sendFindFriendsRequestWithPath:(ThirdPartyPath)path
                        thirdPartyIds:(NSMutableArray *)thirdPartyIds
                             delegate:(id)delegate;



-(void)sendLogoutRequestWithDelegate:(id)delegate;



- (void)sendSubscribeAccountRequestWithAccount:(SPAccount *)account
                                    subscribe:(BOOL)subscribe
                                     delegate:(id)delegate;



-(void)sendGetCategoriesRequestWithCategoryId:(NSString *)categoryId
                                     delegate:(id)delegate;



-(void)sendGetInstagramUserMediaRequestWithNextUrl:(NSString *)nextUrl
                                          delegate:(id)delegate;



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
                                      longitude:(float)longitude;

- (void)sendRepostRequestWithPost:(SPPost *)post
                              comment:(NSString *)comment
                             delegate:(id)delegate;



-(void)sendCommentPostRequestWithPostId:(NSString *)postId
                                comment:(NSString *)comment
                               delegate:(id)delegate;


- (void)sendDeletePostRequestWithPost:(SPPost *)post
                                 repost:(BOOL)repost
                               delegate:(id)delegate;

- (void)sendGetPostCommentsRequestWithPostId:(NSString *)postId
                                    startKey:(NSString *)startKey
                                    delegate:(id)delegate;



-(void)sendGetPostInfoRequestWithPostId:(NSString *)postId
                               delegate:(id)delegate;



-(void)sendGetPostsRequestWithStartKey:(NSString *)startKey
                              delegate:(id)delegate;



-(void)sendGetPostsByCategoryRequestWithCategoryId:(NSString *)categoryId
                                          startKey:(NSString *)startKey
                                          delegate:(id)delegate;



-(void)sendGetPostsByTagRequestWithTag:(NSString *)tag
                              startKey:(NSString *)startKey
                              delegate:(id)delegate;



-(void)sendGetPostsByUserIdRequestWithUserId:(NSString *)userId
                                        type:(PostType)type
                                    startKey:(NSString *)startKey
                                    delegate:(id)delegate;



- (void)sendWantPostRequestWithPost:(SPPost *)post
                                 want:(BOOL)want
                             delegate:(id)delegate;



-(void)sendGetAccountsByKeywordRequestWithKeyword:(NSString *)keyword
                                         startKey:(NSString *)startKey
                                         delegate:(id)delegate;



-(void)sendGetPostsByKeywordRequestWithKeyword:(NSString *)keyword
                                      startKey:(NSString *)startKey
                                      delegate:(id)delegate;



- (void)sendGetTagsByKeywordRequestWithKeyword:(NSString *)keyword
                                     startKey:(NSString *)startKey
                                     delegate:(id)delegate;

- (void)sendGetNewsRequestWithStartKey:(NSString *)startKey
                             delegate:(id)delegate;

- (void)sendReportPostRequestWithPost:(SPPost *)post
                           delegate:(id)delegate
                                 type:(ReportPostWithURLType)type;

- (void)sendGetFoursquareLocationWithDelegate:(id)delegate;
- (void)sendGetFoursquareLocationWithKeyword:(NSString *)keyword delegate:(id)delegate;

@end


