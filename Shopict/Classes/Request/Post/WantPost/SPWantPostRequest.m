//
//  SPWantPostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPWantPostRequest.h"
#import "SPWantPostRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "SPPost.h"

@implementation SPWantPostRequest

+ (id)requestWithRequestData:(SPWantPostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPWantPostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSString *type = (data.type?@"1":@"2");
        
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
    return SP_WANTPOST;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPWantPostRequestDidFinish:post:want:)]) {
        [self.delegate SPWantPostRequestDidFinish:self.response post:self.requestData.post want:self.requestData.type];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
