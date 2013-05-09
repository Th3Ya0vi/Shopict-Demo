//
//  SPUnbindAccountToThirdPartyRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "SPEnum.h"

@class SPBaseResponseData, SPUnbindAccountToThirdPartyRequestData;

@protocol SPUnbindAccountToThirdPartyRequestDelegate <NSObject>

- (void)SPUnbindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path;

@end

@interface SPUnbindAccountToThirdPartyRequest : SPBaseRequest

@property (nonatomic, retain) SPUnbindAccountToThirdPartyRequestData *requestData;

+ (id)requestWithRequestData:(SPUnbindAccountToThirdPartyRequestData*)data delegate:(id)delegate;

@end