//
//  SPForgetPasswordRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPForgetPasswordRequest.h"
#import "SPForgetPasswordRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPForgetPasswordRequest

+ (id)requestWithRequestData:(SPForgetPasswordRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPForgetPasswordRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.email,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"email",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_FORGETPASSWORD;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPForgetPasswordRequestDidFinish:)]) {
        [self.delegate SPForgetPasswordRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
