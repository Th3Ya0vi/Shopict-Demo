//
//  SPGetSubscriptionAccountsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetSubscriptionAccountsRequestData.h"

@implementation SPGetSubscriptionAccountsRequestData

- (void)dealloc
{
    [_token release];
    [_userId release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token userId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token  userId:userId follow:follow startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token userId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.token = token;
        self.type = follow;
        self.startKey = startKey;
    }
    return self;
}


@end
