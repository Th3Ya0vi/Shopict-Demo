//
//  SPChangePasswordRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPChangePasswordRequestData;

@protocol SPChangePasswordRequestDelegate <NSObject>

- (void)SPChangePasswordRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPChangePasswordRequest : SPBaseRequest

@property (nonatomic, retain) SPChangePasswordRequestData *requestData;

+ (id)requestWithRequestData:(SPChangePasswordRequestData*)data delegate:(id)delegate;

@end
