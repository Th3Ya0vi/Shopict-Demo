//
//  SPGetFoursquareLocationsByKeywordRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetFoursquareLocationsByKeywordResponseData, SPGetFoursquareLocationsByKeywordRequestData;

@protocol SPGetFoursquareLocationsByKeywordRequestDelegate <NSObject>

- (void)SPGetFoursquareLocationsByKeywordRequestDidFinish:(SPGetFoursquareLocationsByKeywordResponseData*)response;

@end

@interface SPGetFoursquareLocationsByKeywordRequest : SPBaseRequest

@property (nonatomic, retain) SPGetFoursquareLocationsByKeywordRequestData *requestData;

+ (id)requestWithRequestData:(SPGetFoursquareLocationsByKeywordRequestData*)data delegate:(id)delegate;

@end
