//
//  SPGetFoursquareLocationsByKeywordRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetFoursquareLocationsByKeywordRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

+(id)dataWithKeyword:(NSString *)keyword
            latitude:(float)latitude
           longitude:(float)longitude;

-(id)initWithKeyword:(NSString *)keyword
            latitude:(float)latitude
           longitude:(float)longitude;

@end
