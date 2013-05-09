//
//  SPGetNewsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetNewsRequestData.h"

@implementation SPGetNewsRequestData

- (void)dealloc
{
    [_token release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token startKey:(NSString *)startKey
{
    return [[self alloc]initWithToken:token startKey:startKey];
}

- (id)initWithToken:(NSString *)token startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.startKey = startKey;
    }
    return self;
}

@end
