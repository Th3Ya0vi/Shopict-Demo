//
//  SPGetPostInfoRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostInfoResponseData, SPGetPostInfoRequestData;

@protocol SPGetPostInfoRequestDelegate <NSObject>

- (void)SPGetPostInfoRequestDidFinish:(SPGetPostInfoResponseData*)response;

@end

@interface SPGetPostInfoRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostInfoRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostInfoRequestData*)data delegate:(id)delegate;

@end
