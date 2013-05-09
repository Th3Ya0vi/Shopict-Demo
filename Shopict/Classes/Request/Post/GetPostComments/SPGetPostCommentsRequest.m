//
//  SPGetPostCommentsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostCommentsRequest.h"
#import "SPGetPostCommentsRequestData.h"
#import "SPGetPostCommentsResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPGetPostCommentsRequest

+ (id)requestWithRequestData:(SPGetPostCommentsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetPostCommentsRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.postId,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"pId",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETPOSTCOMMENTS;
}

- (void)customizeRequest
{
        [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetPostCommentsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostCommentsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetPostCommentsRequestDidFinish:startKey:)]) {
        [self.delegate SPGetPostCommentsRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
