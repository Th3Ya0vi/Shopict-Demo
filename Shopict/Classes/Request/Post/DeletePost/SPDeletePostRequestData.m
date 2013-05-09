//
//  SPDeletePostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPDeletePostRequestData.h"

@implementation SPDeletePostRequestData

- (void)dealloc
{
    [_token release];
    [_post release];
    [super dealloc];
}

+ (id)dataWithPost:(SPPost *)post token:(NSString *)token repost:(BOOL)repost
{
    return [[[self alloc]initWithPost:post token:token repost:repost]autorelease];
}

- (id)initWithPost:(SPPost *)post token:(NSString *)token repost:(BOOL)repost
{
    self = [super init];
    if (self) {
        self.post = post;
        self.token = token;
        self.repost = repost;
    }
    return self;
}


@end
