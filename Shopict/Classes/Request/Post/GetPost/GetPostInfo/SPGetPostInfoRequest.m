//
//  SPGetPostInfoRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostInfoRequest.h"
#import "SPGetPostInfoRequestData.h"
#import "SPGetPostInfoResponseData.h"
#import "SPURLs.h"

@implementation SPGetPostInfoRequest

+ (id)requestWithRequestData:(SPGetPostInfoRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetPostInfoRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.postId,
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"pId",
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETPOSTINFO;
}

- (SPGetPostInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetPostInfoRequestDidFinish:)]) {
        [self.delegate SPGetPostInfoRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
