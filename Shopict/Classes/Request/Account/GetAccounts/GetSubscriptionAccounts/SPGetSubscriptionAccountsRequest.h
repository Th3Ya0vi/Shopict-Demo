//
//  SPGetSubscriptionAccountsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountsResponseData, SPGetSubscriptionAccountsRequestData;

@protocol SPGetSubscriptionAccountsRequestDelegate <NSObject>

- (void)SPGetSubscriptionAccountsRequestDidFinish:(SPGetAccountsResponseData*)response;

@end

@interface SPGetSubscriptionAccountsRequest : SPBaseRequest

@property (nonatomic, retain) SPGetSubscriptionAccountsRequestData *requestData;

+ (id)requestWithRequestData:(SPGetSubscriptionAccountsRequestData*)data delegate:(id)delegate;
@end

