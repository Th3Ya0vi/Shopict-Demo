//
//  SPConfigurationRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月6日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPConfigurationRequestData.h"

@implementation SPConfigurationRequestData

- (void)dealloc
{
    [_token release];
    [_locale release];
    [_country release];
    [_currency release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude
{
    return [[[self alloc]initWithToken:token locale:locale country:country currency:currency device:device longitude:longitude latitude:latitude]autorelease];
}

-(id)initWithToken:(NSString *)token
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;
{
    self = [super init];
    if (self) {
        self.token = token;
        self.locale = locale;
        self.country = country;
        self.currency = currency;
        self.device = device;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
};

@end
