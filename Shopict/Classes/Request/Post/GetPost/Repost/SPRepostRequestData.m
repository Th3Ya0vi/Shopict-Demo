//
//  SPRepostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPRepostRequestData.h"
#import "SPPost.h"

@implementation SPRepostRequestData

- (void)dealloc
{
    [_token release];
    [_post release];
    [_comment release];
    [super dealloc];
}

+ (id)dataWithToken:(NSString *)token
             post:(SPPost *)post
            comment:(NSString *)comment
{
    return [[[self alloc]initWithToken:token post:post comment:comment]autorelease];
}

- (id)initWithToken:(NSString *)token
             post:(SPPost *)post
            comment:(NSString *)comment
{
    self = [super init];
    if (self) {
        self.token = token;
        self.post = post;
        self.comment = comment;
    }
    return self;
}

@end
