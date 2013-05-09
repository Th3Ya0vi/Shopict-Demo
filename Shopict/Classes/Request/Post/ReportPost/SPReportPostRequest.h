//
//  SPReportPostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月26日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPReportPostRequestData;

@protocol SPReportPostRequestDelegate <NSObject>

- (void)SPReportPostRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPReportPostRequest : SPBaseRequest

@property (nonatomic, retain) SPReportPostRequestData *requestData;

+ (id)requestWithRequestData:(SPReportPostRequestData*)data delegate:(id)delegate;

@end
