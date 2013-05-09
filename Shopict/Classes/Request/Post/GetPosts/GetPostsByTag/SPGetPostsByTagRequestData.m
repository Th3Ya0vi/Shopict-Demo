//
//  SPGetPostsByTagRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsByTagRequestData.h"

@implementation SPGetPostsByTagRequestData

- (void)dealloc
{
    [_token release];
    [_tag release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
               tag:(NSString *)tag
          startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token tag:tag startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token
               tag:(NSString *)tag
          startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.tag = tag;
        self.startKey = startKey;
    }
    return self;
}


@end
