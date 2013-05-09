//
//  SPSearchRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPSearchRequestData.h"

@implementation SPSearchRequestData

- (void)dealloc
{
    [_token release];
    [_keyword release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
           keyword:(NSString *)keyword
          startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token keyword:keyword startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token
           keyword:(NSString *)keyword
          startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.keyword = keyword;
        self.startKey = startKey;
    }
    return self;
}


@end
