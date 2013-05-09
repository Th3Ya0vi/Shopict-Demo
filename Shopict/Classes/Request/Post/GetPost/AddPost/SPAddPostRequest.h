//
//  SPAddPostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostInfoResponseData, SPAddPostRequestData;

@protocol SPAddPostRequestDelegate <NSObject>

- (void)SPAddPostRequestDidFinish:(SPGetPostInfoResponseData*)response;

@end

@interface SPAddPostRequest : SPBaseRequest

@property (nonatomic, retain) SPAddPostRequestData *requestData;

+ (id)requestWithRequestData:(SPAddPostRequestData*)data delegate:(id)delegate;

@end
