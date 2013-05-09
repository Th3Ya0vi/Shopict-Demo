//
//  SPLoginWithEmailRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLoginWithEmailRequestData.h"
#import "NSString+SPStringUtility.h"


@implementation SPLoginWithEmailRequestData

- (void)dealloc
{
    [_email release];
    [_password release];
    [_locale release];
    [_country release];
    [_currency release];
    [super dealloc];
}

+(id)dataWithEmail:(NSString *)email
          password:(NSString *)password
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude
{
    return [[[self alloc]initWithEmail:email password:password locale:locale country:country currency:currency device:device longitude:longitude latitude:latitude]autorelease];
}

-(id)initWithEmail:(NSString *)email
          password:(NSString *)password
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;
{
    self = [super init];
    if (self) {
        self.email = email;
        self.password = [password md5];
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
