//
//  SPRegisterRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetTokenResponseData,SPRegisterRequestData;

@protocol SPRegisterRequestDelegate <NSObject>

- (void)SPRegisterRequestDidFinish:(SPGetTokenResponseData*)response;

@end

@interface SPRegisterRequest : SPBaseRequest

@property (nonatomic, retain) SPRegisterRequestData *requestData;

+ (id)requestWithRequestData:(SPRegisterRequestData*)data delegate:(id)delegate;

@end

