//
//  SPGetInstagramUserMediaRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetInstagramUserMediaResponseData, SPGetInstagramUserMediaRequestData;

@protocol SPGetInstagramUserMediaRequestDelegate <NSObject>

- (void)SPGetInstagramUserMediaRequestDidFinish:(SPGetInstagramUserMediaResponseData*)response;

@end

@interface SPGetInstagramUserMediaRequest : SPBaseRequest

@property (nonatomic, retain) SPGetInstagramUserMediaRequestData *requestData;

+ (id)requestWithRequestData:(SPGetInstagramUserMediaRequestData*)data delegate:(id)delegate;

@end
