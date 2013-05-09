//
//  SPGetPostsByUserIdRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsByUserIdRequestData.h"

@implementation SPGetPostsByUserIdRequestData

- (void)dealloc
{
    [_token release];
    [_userId release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
            userId:(NSString *)userId
              type:(PostType)type
          startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token userId:userId type:type startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token
            userId:(NSString *)userId
              type:(PostType)type
          startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.userId = userId;
        self.type = type;
        self.startKey = startKey;
    }
    return self;
}


@end
