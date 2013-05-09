//
//  SPLoginWithEmailRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLoginWithEmailRequest.h"
#import "SPLoginWithEmailRequestData.h"
#import "SPGetTokenResponseData.h"
#import "SPURLs.h"

@implementation SPLoginWithEmailRequest

+ (id)requestWithRequestData:(SPLoginWithEmailRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPLoginWithEmailRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *device = (data.device==IPHONE?@"1":@"2");
        NSArray *values = [NSArray arrayWithObjects:
                           data.email,
                           data.password,
                           device,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"email",
                         @"password",
                         @"device",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_LOGINWITHEMAIL;
}

- (void)customizeRequest
{
    if (self.requestData.latitude!=0) {
        [self setCustomizedPostValue:[NSString stringWithFormat:@"%f",self.requestData.latitude] forKey:@"lat"];
        [self setCustomizedPostValue:[NSString stringWithFormat:@"%f",self.requestData.longitude] forKey:@"long"];
    }
    
    [self setCustomizedPostValue:self.requestData.locale forKey:@"locale"];
    [self setCustomizedPostValue:self.requestData.country forKey:@"country"];
    [self setCustomizedPostValue:self.requestData.currency forKey:@"currency"];
}

- (SPGetTokenResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetTokenResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPLoginWithEmailRequestDidFinish:)]) {
        [self.delegate SPLoginWithEmailRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
