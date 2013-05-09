//
//  SPGetPostsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsRequestData.h"

@implementation SPGetPostsRequestData

- (void)dealloc
{
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
          startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token
          startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.startKey = startKey;
    }
    return self;
}

@end
