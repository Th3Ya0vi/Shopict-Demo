//
//  SPGetPostsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsRequest.h"
#import "SPGetPostsRequestData.h"
#import "SPGetPostsResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPGetPostsRequest

+ (id)requestWithRequestData:(SPGetPostsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetPostsRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETPOSTS;
}

- (void)customizeRequest
{
        [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetPostsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetPostsRequestDidFinish:startKey:)]) {
        [self.delegate SPGetPostsRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
