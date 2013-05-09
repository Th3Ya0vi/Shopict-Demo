//
//  SPFacebookAccount.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPFacebookAccount.h"

@implementation SPFacebookAccount

- (void)dealloc
{
    [_userId release];
    [_username release];
    [super dealloc];
}

+ (id)facebookAccountWithUserId:(NSString *)userId username:(NSString *)username
{
    return [[[self alloc]initWithUserId:userId username:username]autorelease];
}

- (id)initWithUserId:(NSString *)userId username:(NSString *)username
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.username = username;
    }
    return self;
}

@end
