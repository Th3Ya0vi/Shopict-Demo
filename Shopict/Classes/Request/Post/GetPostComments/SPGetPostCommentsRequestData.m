//
//  SPGetPostCommentsRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostCommentsRequestData.h"

@implementation SPGetPostCommentsRequestData

- (void)dealloc
{
    [_postId release];
    [_token release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithPostId:(NSString *)postId token:(NSString *)token startKey:(NSString *)startKey
{
    return [[[self alloc]initWithPostId:postId token:token startKey:startKey]autorelease];
}

-(id)initWithPostId:(NSString *)postId token:(NSString *)token startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.postId = postId;
        self.token = token;
        self.startKey = startKey;
    }
    return self;
}


@end
