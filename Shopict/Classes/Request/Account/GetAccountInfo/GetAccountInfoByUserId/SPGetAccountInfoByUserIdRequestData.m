//
//  SPGetAccountInfoByUserIdRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountInfoByUserIdRequestData.h"

@implementation SPGetAccountInfoByUserIdRequestData

- (void)dealloc
{
    [_token release];
    [_userId release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token userId:(NSString *)userId
{
    return [[[self alloc]initWithToken:token userId:userId]autorelease];
}

-(id)initWithToken:(NSString *)token userId:(NSString *)userId
{
    self = [super init];
    if (self) {
        self.token = token;
        self.userId = userId;
    }
    return self;
}

@end
