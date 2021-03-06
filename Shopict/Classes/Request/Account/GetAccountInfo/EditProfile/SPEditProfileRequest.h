//
//  SPEditProfileRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountInfoResponseData, SPEditProfileRequestData;

@protocol SPEditProfileRequestDelegate <NSObject>

- (void)SPEditProfileRequestDidFinish:(SPGetAccountInfoResponseData*)response;

@end

@interface SPEditProfileRequest : SPBaseRequest

@property (nonatomic, retain) SPEditProfileRequestData *requestData;

+ (id)requestWithRequestData:(SPEditProfileRequestData*)data delegate:(id)delegate;

@end