//
//  SPForgetPasswordRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPForgetPasswordRequestData;

@protocol SPForgetPasswordRequestDelegate <NSObject>

- (void)SPForgetPasswordRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPForgetPasswordRequest : SPBaseRequest

@property (nonatomic, retain) SPForgetPasswordRequestData *requestData;

+ (id)requestWithRequestData:(SPForgetPasswordRequestData*)data delegate:(id)delegate;

@end
