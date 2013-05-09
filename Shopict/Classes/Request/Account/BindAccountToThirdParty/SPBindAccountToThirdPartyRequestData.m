//
//  SPBindAccountToThirdPartyRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBindAccountToThirdPartyRequestData.h"

@implementation SPBindAccountToThirdPartyRequestData

- (void)dealloc
{
    [_token release];
    [_thirdPartyId release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
      thirdPartyId:(NSString *)thirdPartyId
              path:(ThirdPartyPath)path
{
    return [[[self alloc]initWithToken:token thirdPartyId:thirdPartyId path:path]autorelease];
}

-(id)initWithToken:(NSString *)token
      thirdPartyId:(NSString *)thirdPartyId
              path:(ThirdPartyPath)path
{
    self = [super init];
    if (self) {
        self.token = token;
        self.thirdPartyId = thirdPartyId;
        self.path = path;
    }
    return self;
}


@end
