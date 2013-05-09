//
//  SPLoginWithEmailRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPLoginWithEmailRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *locale;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, assign) DeviceType device;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;

+(id)dataWithEmail:(NSString *)email
          password:(NSString *)password
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;

-(id)initWithEmail:(NSString *)email
          password:(NSString *)password
            locale:(NSString *)locale
           country:(NSString *)country
          currency:(NSString *)currency
            device:(DeviceType)device
         longitude:(float)longitude
          latitude:(float)latitude;


@end
