//
//  SPGetAccountInfoByUsernameRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountInfoByUsernameRequestData.h"

@implementation SPGetAccountInfoByUsernameRequestData

- (void)dealloc
{
    [_token release];
    [_username release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token username:(NSString *)username
{
    return [[[self alloc]initWithToken:token username:username]autorelease];
}

-(id)initWithToken:(NSString *)token username:(NSString *)username
{
    self = [super init];
    if (self) {
        self.token = token;
        self.username = username;
    }
    return self;
}

@end
