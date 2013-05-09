//
//  SPGetAccountInfoByUsernameRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountInfoByUsernameRequest.h"
#import "SPGetAccountInfoByUsernameRequestData.h"
#import "SPGetAccountInfoResponseData.h"
#import "SPURLs.h"

@implementation SPGetAccountInfoByUsernameRequest

+ (id)requestWithRequestData:(SPGetAccountInfoByUsernameRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetAccountInfoByUsernameRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.username,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"username",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETACCOUNTINFOBYUSERNAME;
}

- (SPGetAccountInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetAccountInfoByUsernameRequestDidFinish:)]) {
        [self.delegate SPGetAccountInfoByUsernameRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
