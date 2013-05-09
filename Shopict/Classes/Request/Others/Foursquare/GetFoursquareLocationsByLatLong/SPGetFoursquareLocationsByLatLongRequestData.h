//
//  SPGetFoursquareLocationsByLatLongRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetFoursquareLocationsByLatLongRequestData : SPBaseRequestData

@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

+(id)dataWithLatitude:(float)latitude
           longitude:(float)longitude;

-(id)initWithLatitude:(float)latitude
            longitude:(float)longitude;

@end
