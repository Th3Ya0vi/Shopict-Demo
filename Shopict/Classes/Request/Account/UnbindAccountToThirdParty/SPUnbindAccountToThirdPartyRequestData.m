//
//  SPUnbindAccountToThirdPartyRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPUnbindAccountToThirdPartyRequestData.h"

@implementation SPUnbindAccountToThirdPartyRequestData

- (void)dealloc
{
    [_token release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
              path:(ThirdPartyPath)path
{
    return [[[self alloc]initWithToken:token path:path]autorelease];
}

-(id)initWithToken:(NSString *)token
              path:(ThirdPartyPath)path
{
    self = [super init];
    if (self) {
        self.token = token;
        self.path = path;
    }
    return self;
}

@end
