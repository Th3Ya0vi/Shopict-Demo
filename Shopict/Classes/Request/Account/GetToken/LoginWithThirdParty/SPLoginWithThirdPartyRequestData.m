//
//  SPLoginWithThirdPartyRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLoginWithThirdPartyRequestData.h"

@implementation SPLoginWithThirdPartyRequestData

+(id)dataWithPath:(ThirdPartyPath)path
     thirdPartyId:(NSString *)thirdPartyId
           locale:(NSString *)locale
          country:(NSString *)country
         currency:(NSString *)currency
           device:(DeviceType)device
        longitude:(float)longitude
         latitude:(float)latitude
{
    return [[[self alloc]initWithPath:path thirdPartyId:thirdPartyId locale:locale country:country currency:currency device:device longitude:longitude latitude:latitude]autorelease];
}

-(id)initWithPath:(ThirdPartyPath)path
     thirdPartyId:(NSString *)thirdPartyId
           locale:(NSString *)locale
          country:(NSString *)country
         currency:(NSString *)currency
           device:(DeviceType)device
        longitude:(float)longitude
         latitude:(float)latitude
{
    self = [super init];
    if (self) {
        self.path = path;
        self.thirdPartyId = thirdPartyId;
        self.locale = locale;
        self.country = country;
        self.currency = currency;
        self.device = device;
        self.longitude = longitude;
        self.latitude = latitude;
    }
    return self;
}

- (void)dealloc
{
    [_thirdPartyId release];
    [_locale release];
    [_country release];
    [super dealloc];
}

@end
