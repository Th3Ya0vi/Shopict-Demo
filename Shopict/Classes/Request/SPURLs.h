//
//  URLs.h
//  SosoShare
//
//  Created by bichenkk on 31/10/12.
//  Copyright (c) 2012 biworks. All rights reserved.
//

#define SP_DOMAIN                         @"http://shopict.mobi/"
//@"http://shopict.mobi/"
//@"http://theshopbook.co/"

//ACCOUNT
#define SP_REGISTER                       [SP_DOMAIN stringByAppendingString:@"accounts/register"]
#define SP_LOGINWITHEMAIL                 [SP_DOMAIN stringByAppendingString:@"accounts/loginWithEmail"]
#define SP_LOGINWITHTHIRDPARTY            [SP_DOMAIN stringByAppendingString:@"accounts/loginWithThirdParty"]
#define SP_FORGETPASSWORD                 [SP_DOMAIN stringByAppendingString:@"accounts/forgetPW"]
#define SP_BINDACCTTOTHIRDPARTY           [SP_DOMAIN stringByAppendingString:@"accounts/bindAccountToThirdParty"]
#define SP_UNBINDACCTTOTHIRDPARTY         [SP_DOMAIN stringByAppendingString:@"accounts/unbindAccountFromThirdParty"]
#define SP_EDITPROFILE                    [SP_DOMAIN stringByAppendingString:@"accounts/editProfile"]
#define SP_CHANGEPASSWORD                 [SP_DOMAIN stringByAppendingString:@"accounts/changePW"]
#define SP_BINDACCTTOCATEGORY             [SP_DOMAIN stringByAppendingString:@"accounts/bindAccountToCategories"]
#define SP_REPORTPROFILE                  [SP_DOMAIN stringByAppendingString:@"accounts/reportAccount"]
#define SP_GETACCOUNTINFOBYUSERID         [SP_DOMAIN stringByAppendingString:@"accounts/getAccountInfo"]
#define SP_GETACCOUNTINFOBYUSERNAME       [SP_DOMAIN stringByAppendingString:@"accounts/getAccountInfoByUsername"]
#define SP_GETSUGGESTEDACCOUNTS           [SP_DOMAIN stringByAppendingString:@"accounts/getSuggestedAccounts"]
#define SP_GETSUBSCRIBEDACCOUNTS          [SP_DOMAIN stringByAppendingString:@"accounts/getSubscriptionAccounts"]
#define SP_SUBSCRIBEACCOUNT               [SP_DOMAIN stringByAppendingString:@"accounts/subscribeAccount"]
#define SP_FINDFRIENDS                    [SP_DOMAIN stringByAppendingString:@"accounts/findFriends"]
#define SP_LOGOUT                         [SP_DOMAIN stringByAppendingString:@"accounts/logout"]
#define SP_CONFIG                         [SP_DOMAIN stringByAppendingString:@"accounts/setAccountLocation"]

//POST
#define SP_ADDPOST                        [SP_DOMAIN stringByAppendingString:@"posts/addPost"]
#define SP_DELETEPOST                     [SP_DOMAIN stringByAppendingString:@"posts/removePost"]
#define SP_WANTPOST                       [SP_DOMAIN stringByAppendingString:@"posts/wantPost"]
#define SP_GETWANTEDACCOUNTS              [SP_DOMAIN stringByAppendingString:@"posts/getWantedPeers"]
#define SP_GETPOSTS                       [SP_DOMAIN stringByAppendingString:@"posts/getPosts"]
#define SP_GETPOSTINFO                    [SP_DOMAIN stringByAppendingString:@"posts/getPostByPostId"]
#define SP_GETPOSTSBYUSERID               [SP_DOMAIN stringByAppendingString:@"posts/getPostsByUId"]
#define SP_GETPOSTSBTCATEGORY             [SP_DOMAIN stringByAppendingString:@"posts/getPostsByCategory"]
#define SP_GETPOSTSBYTAG                  [SP_DOMAIN stringByAppendingString:@"posts/getPostsByTag"]
#define SP_REPORTPOST                     [SP_DOMAIN stringByAppendingString:@"posts/reportPost"]
#define SP_COMMENTPOST                    [SP_DOMAIN stringByAppendingString:@"comments/commentPost"]
#define SP_GETPOSTCOMMENTS                [SP_DOMAIN stringByAppendingString:@"comments/getPostComments"]

//PRODUCT
#define SP_GETTAGSBYKEYWORD               [SP_DOMAIN stringByAppendingString:@"products/getTagsByKeyword"]
#define SP_GETACCOUNTSBYKEYWORD           [SP_DOMAIN stringByAppendingString:@"products/getAccountsByKeyword"]
#define SP_GETPRODUCTSBYKEYWORD           [SP_DOMAIN stringByAppendingString:@"products/getProductsByKeyword"]

//CATEGORY
#define SP_GETCATEGORY                    [SP_DOMAIN stringByAppendingString:@"categories/getChildNodes"]

//NEWS
#define SP_GETNEWS                        [SP_DOMAIN stringByAppendingString:@"newfeeds/getNews"]






