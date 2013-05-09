//
//  SPGetFoursquareLocationsByLatLongRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetFoursquareLocationsByLatLongRequestData.h"

@implementation SPGetFoursquareLocationsByLatLongRequestData

+(id)dataWithLatitude:(float)latitude
            longitude:(float)longitude
{
    return [[[self alloc]initWithLatitude:latitude longitude:longitude]autorelease];
}

-(id)initWithLatitude:(float)latitude
            longitude:(float)longitude
{
    self = [super init];
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end
