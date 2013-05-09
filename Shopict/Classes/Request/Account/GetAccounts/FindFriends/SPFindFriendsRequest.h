//
//  SPFindFriendsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"


@class SPGetAccountsResponseData, SPFindFriendsRequestData;

@protocol SPFindFriendsRequestDelegate <NSObject>

- (void)SPFindFriendsRequestDidFinish:(SPGetAccountsResponseData*)response;

@end

@interface SPFindFriendsRequest : SPBaseRequest

@property (nonatomic, retain) SPFindFriendsRequestData *requestData;

+ (id)requestWithRequestData:(SPFindFriendsRequestData*)data delegate:(id)delegate;

@end