//
//  SPConfigurationRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月6日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPConfigurationRequest.h"
#import "SPConfigurationRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPConfigurationRequest

+ (id)requestWithRequestData:(SPConfigurationRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPConfigurationRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *device = (data.device==IPHONE?@"1":@"2");
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           device,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"device",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_CONFIG;
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

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPConfigurationRequestDidFinish:)]) {
        [self.delegate SPConfigurationRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
