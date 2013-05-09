//
//  SPGetAccountInfoByUserIdRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountInfoResponseData, SPGetAccountInfoByUserIdRequestData;

@protocol SPGetAccountInfoByUserIdRequestDelegate <NSObject>

- (void)SPGetAccountInfoByUserIdRequestDidFinish:(SPGetAccountInfoResponseData*)response;

@end

@interface SPGetAccountInfoByUserIdRequest : SPBaseRequest

@property (nonatomic, retain) SPGetAccountInfoByUserIdRequestData *requestData;

+ (id)requestWithRequestData:(SPGetAccountInfoByUserIdRequestData*)data delegate:(id)delegate;
@end

