//
//  SPConfigurationRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月6日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPConfigurationRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *locale;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, assign) DeviceType device;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;

+(id)dataWithToken:(NSString *)token
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;

-(id)initWithToken:(NSString *)token
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;

@end
