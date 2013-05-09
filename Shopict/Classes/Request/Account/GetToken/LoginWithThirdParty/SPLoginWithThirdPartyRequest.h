//
//  SPLoginWithThirdPartyRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "SPEnum.h"

@class SPGetTokenResponseData,SPLoginWithThirdPartyRequestData;

@protocol SPLoginWithThirdPartyRequestDelegate <NSObject>

- (void)SPLoginWithThirdPartyRequestDidFinish:(SPGetTokenResponseData*)response path:(ThirdPartyPath)path;

@end

@interface SPLoginWithThirdPartyRequest : SPBaseRequest

@property (nonatomic, retain) SPLoginWithThirdPartyRequestData *requestData;

+ (id)requestWithRequestData:(SPLoginWithThirdPartyRequestData*)data delegate:(id)delegate;

@end
