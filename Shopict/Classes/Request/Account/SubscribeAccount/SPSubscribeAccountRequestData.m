//
//  SPSubscribeAccountRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPSubscribeAccountRequestData.h"

@implementation SPSubscribeAccountRequestData

- (void)dealloc
{
    [_account release];
    [_token release];
    [super dealloc];
}

+ (id)dataWithAccount:(SPAccount *)account
                token:(NSString *)token
            subscribe:(BOOL)subscribe
{
    return [[[self alloc]initWithAccount:account token:token subscribe:subscribe]autorelease];
}

- (id)initWithAccount:(SPAccount *)account
                token:(NSString *)token
            subscribe:(BOOL)subscribe
{
    self = [super init];
    if (self) {
        self.account = account;
        self.token = token;
        self.type = subscribe;
    }
    return self;
}


@end
