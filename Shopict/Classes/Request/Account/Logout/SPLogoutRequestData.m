//
//  SBLogoutRequestData.m
//  ShopbookAPI
//
//  Created by BCKK on 12年11月10日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPLogoutRequestData.h"

@implementation SPLogoutRequestData

- (void)dealloc
{
    [_token release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
{
    return [[[self alloc]initWithToken:token]autorelease];
}

-(id)initWithToken:(NSString *)token
{
    self = [super init];
    if (self) {
        self.token = token;
    }
    return self;
}

@end
