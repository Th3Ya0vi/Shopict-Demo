//
//  SPSubscribeAccountRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPSubscribeAccountRequest.h"
#import "SPSubscribeAccountRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "SPAccount.h"

@implementation SPSubscribeAccountRequest

+ (id)requestWithRequestData:(SPSubscribeAccountRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPSubscribeAccountRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *type = (self.requestData.type?@"1":@"2");
        NSArray *values = [NSArray arrayWithObjects:
                           data.account.accountId,
                           data.token,
                           type,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"uId",
                         @"token",
                         @"type",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_SUBSCRIBEACCOUNT;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPSubscribeAccountRequestDidFinish:account:follow:)]) {
        [self.delegate SPSubscribeAccountRequestDidFinish:self.response account:self.requestData.account follow:self.requestData.type];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end

