//
//  SPSubscribeAccountRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "SPEnum.h"

@class SPBaseResponseData, SPSubscribeAccountRequestData, SPAccount;

@protocol SPSubscribeAccountRequestDelegate <NSObject>

- (void)SPSubscribeAccountRequestDidFinish:(SPBaseResponseData*)response
                                   account:(SPAccount *)account
                                    follow:(BOOL)follow;

@end

@interface SPSubscribeAccountRequest : SPBaseRequest

@property (nonatomic, retain) SPSubscribeAccountRequestData *requestData;

+ (id)requestWithRequestData:(SPSubscribeAccountRequestData*)data delegate:(id)delegate;

@end
