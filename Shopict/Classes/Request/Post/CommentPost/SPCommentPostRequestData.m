//
//  SPCommentPostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPCommentPostRequestData.h"

@implementation SPCommentPostRequestData

- (void)dealloc
{
    [_postId release];
    [_token release];
    [_comment release];
    [super dealloc];
}

+(id)dataWithPostId:(NSString *)postId token:(NSString *)token comment:(NSString *)comment
{
    return [[[self alloc]initWithPostId:postId token:token comment:comment]autorelease];
}

-(id)initWithPostId:(NSString *)postId token:(NSString *)token comment:(NSString *)comment
{
    self = [super init];
    if (self) {
        self.postId = postId;
        self.token = token;
        self.comment = comment;
    }
    return self;
}

@end
