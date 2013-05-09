//
//  SPGetAccountsByKeywordRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountsResponseData, SPSearchRequestData;

@protocol SPGetAccountsByKeywordRequestDelegate <NSObject>

- (void)SPGetAccountsByKeywordRequestDidFinish:(SPGetAccountsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetAccountsByKeywordRequest : SPBaseRequest

@property (nonatomic, retain) SPSearchRequestData *requestData;

+ (id)requestWithRequestData:(SPSearchRequestData*)data delegate:(id)delegate;

@end
