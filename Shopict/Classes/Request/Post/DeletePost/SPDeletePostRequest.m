//
//  SPDeletePostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPDeletePostRequest.h"
#import "SPDeletePostRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "SPPost.h"

@implementation SPDeletePostRequest

+ (id)requestWithRequestData:(SPDeletePostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPDeletePostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        
        self.requestData = data;
        
        NSString *type = nil;
        if (self.requestData.repost) {
            type = @"1";
        }else{
            type = @"0";
        }
        
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.post.postId,
                           type,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"pId",
                         @"type",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_DELETEPOST;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPDeletePostRequestDidFinish:post:)]) {
        [self.delegate SPDeletePostRequestDidFinish:self.response post:self.requestData.post];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
