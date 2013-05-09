//
//  SPGetSuggestedAccountsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetSuggestedAccountsRequestData.h"

@implementation SPGetSuggestedAccountsRequestData

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
