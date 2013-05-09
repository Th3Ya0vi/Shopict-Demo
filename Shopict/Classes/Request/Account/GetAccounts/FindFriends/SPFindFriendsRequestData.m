//
//  SPFindFriendsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPFindFriendsRequestData.h"


@implementation SPFindFriendsRequestData

- (void)dealloc
{
    [_token release];
    [_thirdPartyIds release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
              path:(ThirdPartyPath)path
     thirdPartyIds:(NSMutableArray *)thirdPartyIds
{
    return [[[self alloc]initWithToken:token path:path thirdPartyIds:thirdPartyIds]autorelease];
}

-(id)initWithToken:(NSString *)token
              path:(ThirdPartyPath)path
     thirdPartyIds:(NSMutableArray *)thirdPartyIds
{
    self = [super init];
    if (self) {
        self.token = token;
        self.path = path;
        self.thirdPartyIds = thirdPartyIds;
    }
    return self;
}

@end
