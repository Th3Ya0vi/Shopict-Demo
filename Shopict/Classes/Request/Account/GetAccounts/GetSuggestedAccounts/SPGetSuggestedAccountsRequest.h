//
//  SPGetSuggestedAccountsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountsResponseData, SPGetSuggestedAccountsRequestData;

@protocol SPGetSuggestedAccountsRequestDelegate <NSObject>

- (void)SPGetSuggestedAccountsRequestDidFinish:(SPGetAccountsResponseData*)response;

@end

@interface SPGetSuggestedAccountsRequest : SPBaseRequest

@property (nonatomic, retain) SPGetSuggestedAccountsRequestData *requestData;

+ (id)requestWithRequestData:(SPGetSuggestedAccountsRequestData*)data delegate:(id)delegate;

@end
