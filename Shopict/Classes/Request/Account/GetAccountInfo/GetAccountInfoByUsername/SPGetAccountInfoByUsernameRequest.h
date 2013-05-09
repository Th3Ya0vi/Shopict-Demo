//
//  SPGetAccountInfoByUsernameRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetAccountInfoResponseData, SPGetAccountInfoByUsernameRequestData;

@protocol SPGetAccountInfoByUsernameRequestDelegate <NSObject>

- (void)SPGetAccountInfoByUsernameRequestDidFinish:(SPGetAccountInfoResponseData*)response;

@end

@interface SPGetAccountInfoByUsernameRequest : SPBaseRequest

@property (nonatomic, retain) SPGetAccountInfoByUsernameRequestData *requestData;

+ (id)requestWithRequestData:(SPGetAccountInfoByUsernameRequestData*)data delegate:(id)delegate;
@end
