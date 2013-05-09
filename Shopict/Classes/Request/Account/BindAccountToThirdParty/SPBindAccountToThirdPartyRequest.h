//
//  SPBindAccountToThirdPartyRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "SPEnum.h"

@class SPBaseResponseData, SPBindAccountToThirdPartyRequestData;

@protocol SPBindAccountToThirdPartyRequestDelegate <NSObject>

- (void)SPBindAccountToThirdPartyRequestDidFinish:(SPBaseResponseData*)response path:(ThirdPartyPath)path;

@end

@interface SPBindAccountToThirdPartyRequest : SPBaseRequest

@property (nonatomic, retain) SPBindAccountToThirdPartyRequestData *requestData;

+ (id)requestWithRequestData:(SPBindAccountToThirdPartyRequestData*)data delegate:(id)delegate;
@end