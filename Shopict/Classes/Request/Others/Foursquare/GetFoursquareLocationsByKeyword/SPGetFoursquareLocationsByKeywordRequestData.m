//
//  SPGetFoursquareLocationsByKeywordRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetFoursquareLocationsByKeywordRequestData.h"

@implementation SPGetFoursquareLocationsByKeywordRequestData

- (void)dealloc
{
    [_keyword release];
    [super dealloc];
}

+(id)dataWithKeyword:(NSString *)keyword
            latitude:(float)latitude
           longitude:(float)longitude
{
    return [[[self alloc]initWithKeyword:keyword latitude:latitude longitude:longitude]autorelease];
}

-(id)initWithKeyword:(NSString *)keyword
            latitude:(float)latitude
           longitude:(float)longitude
{
    self = [super init];
    if (self) {
        self.keyword = keyword;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end
