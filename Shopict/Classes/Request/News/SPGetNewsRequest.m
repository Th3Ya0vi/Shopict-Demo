//
//  SPGetNewsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetNewsRequest.h"
#import "SPGetNewsRequestData.h"
#import "SPGetNewsResponseData.h"
#import "SPURLs.h"

@implementation SPGetNewsRequest

+ (id)requestWithRequestData:(SPGetNewsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetNewsRequestData*)data delegate:(id)delegate
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
    return SP_GETNEWS;
}

- (void)customizeRequest
{
    [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetNewsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetNewsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetNewsRequestDidFinish:startKey:)]) {
        [self.delegate SPGetNewsRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
