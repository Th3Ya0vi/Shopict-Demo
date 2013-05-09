//
//  SPRegisterRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPRegisterRequestData.h"
#import "NSString+SPStringUtility.h"

@implementation SPRegisterRequestData

- (void)dealloc
{
    [_name release];
    [_username release];
    [_email release];
    [_password release];
    [_profilePic release];
    [_locale release];
    [_country release];
    [_currency release];
    [super dealloc];
}

+(id)dataWithEmail:(NSString *)email
              name:(NSString *)name
          username:(NSString *)username
          password:(NSString *)password
        profilePic:(UIImage *)profilePic
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude
{
    return [[[self alloc]initWithEmail:email name:name username:username password:password profilePic:profilePic locale:locale country:country currency:currency device:device longitude:longitude latitude:latitude]autorelease];
}

-(id)initWithEmail:(NSString *)email
              name:(NSString *)name
          username:(NSString *)username
          password:(NSString *)password
        profilePic:(UIImage *)profilePic
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude
{
    self = [super init];
    if (self) {
        self.email = email;
        self.name = name;
        self.username = username;
        self.password = password;
        self.profilePic = profilePic;
        self.locale = locale;
        self.country = country;
        self.currency = currency;
        self.device = device;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
}

@end
