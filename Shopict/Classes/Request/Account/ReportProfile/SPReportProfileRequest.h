//
//  SPReportProfileRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPReportProfileRequestData;

@protocol SPReportProfileRequestDelegate <NSObject>

- (void)SPReportProfileRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPReportProfileRequest : SPBaseRequest

@property (nonatomic, retain) SPReportProfileRequestData *requestData;

+ (id)requestWithRequestData:(SPReportProfileRequestData*)data delegate:(id)delegate;

@end
