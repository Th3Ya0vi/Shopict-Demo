//
//  SPConfigurationRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月6日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"


@class SPBaseResponseData,SPConfigurationRequestData;

@protocol SPConfigurationRequestDelegate <NSObject>

- (void)SPConfigurationRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPConfigurationRequest : SPBaseRequest

@property (nonatomic, retain) SPConfigurationRequestData *requestData;

+ (id)requestWithRequestData:(SPConfigurationRequestData*)data delegate:(id)delegate;

@end