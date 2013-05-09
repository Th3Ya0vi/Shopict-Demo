//
//  SPGetPostInfoRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostInfoRequestData.h"

@implementation SPGetPostInfoRequestData

- (void)dealloc
{
    [_postId release];
    [super dealloc];
}

+(id)dataWithPostId:(NSString *)postId token:(NSString *)token
{
    return [[[self alloc]initWithPostId:postId token:token]autorelease];
}

-(id)initWithPostId:(NSString *)postId token:(NSString *)token
{
    self = [super init];
    if (self) {
        self.postId = postId;
        self.token = token;
    }
    return self;
}

@end
