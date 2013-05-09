//
//  SPLoginWithEmailRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetTokenResponseData,SPLoginWithEmailRequestData;

@protocol SPLoginWithEmailRequestDelegate <NSObject>

- (void)SPLoginWithEmailRequestDidFinish:(SPGetTokenResponseData*)response;

@end

@interface SPLoginWithEmailRequest : SPBaseRequest

@property (nonatomic, retain) SPLoginWithEmailRequestData *requestData;

+ (id)requestWithRequestData:(SPLoginWithEmailRequestData*)data delegate:(id)delegate;

@end

