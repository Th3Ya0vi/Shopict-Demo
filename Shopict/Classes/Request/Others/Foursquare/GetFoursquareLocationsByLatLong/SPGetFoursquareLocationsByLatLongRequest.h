//
//  SPGetFoursquareLocationsByLatLongRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetFoursquareLocationsByLatLongResponseData, SPGetFoursquareLocationsByLatLongRequestData;

@protocol SPGetFoursquareLocationsByLatLongRequestDelegate <NSObject>

- (void)SPGetFoursquareLocationsByLatLongRequestDidFinish:(SPGetFoursquareLocationsByLatLongResponseData*)response;

@end

@interface SPGetFoursquareLocationsByLatLongRequest : SPBaseRequest

@property (nonatomic, retain) SPGetFoursquareLocationsByLatLongRequestData *requestData;

+ (id)requestWithRequestData:(SPGetFoursquareLocationsByLatLongRequestData*)data delegate:(id)delegate;

@end