//
//  SPRepostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPRepostRequest.h"
#import "SPRepostRequestData.h"
#import "SPGetPostInfoResponseData.h"
#import "SPURLs.h"
#import "SPPost.h"

@implementation SPRepostRequest

+ (id)requestWithRequestData:(SPRepostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPRepostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.post.postId,
                           @"1",
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
    return SP_ADDPOST;
}

- (void)customizeRequest
{
    [self setCustomizedPostValue:self.requestData.comment forKey:@"comment"];
}

- (SPGetPostInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPRepostRequestDidFinish:originalPost:)]) {
        [self.delegate SPRepostRequestDidFinish:self.response originalPost:self.requestData.post];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}



@end
