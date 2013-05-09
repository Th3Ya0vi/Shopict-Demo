//
//  SPCommentPostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPCommentPostRequest.h"
#import "SPCommentPostRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPCommentPostRequest

+ (id)requestWithRequestData:(SPCommentPostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPCommentPostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.postId,
                           data.comment,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"pId",
                         @"comment",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_COMMENTPOST;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPCommentPostRequestDidFinish:comment:)]) {
        [self.delegate SPCommentPostRequestDidFinish:self.response comment:self.requestData.comment];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
