//
//  SPGetSubscriptionAccountsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetSubscriptionAccountsRequest.h"
#import "SPGetSubscriptionAccountsRequestData.h"
#import "SPGetAccountsResponseData.h"
#import "SPURLs.h"

@implementation SPGetSubscriptionAccountsRequest

+ (id)requestWithRequestData:(SPGetSubscriptionAccountsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetSubscriptionAccountsRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSString *type = nil;
        switch (self.requestData.type) {
            case FOLLOWED:
                type = @"1";
                break;
            case FOLLOWING:
                type = @"2";
                break;
            default:
                break;
        }
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.userId,
                           type,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"uId",
                         @"type",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETSUBSCRIBEDACCOUNTS;
}

- (void)customizeRequest
{
    [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetAccountsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetSubscriptionAccountsRequestDidFinish:)]) {
        [self.delegate SPGetSubscriptionAccountsRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
