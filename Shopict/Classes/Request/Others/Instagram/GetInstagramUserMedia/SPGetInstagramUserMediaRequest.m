//
//  SPGetInstagramUserMediaRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetInstagramUserMediaRequest.h"
#import "SPGetInstagramUserMediaRequestData.h"
#import "SPGetInstagramUserMediaResponseData.h"
#import "ASIFormDataRequest.h"

@implementation SPGetInstagramUserMediaRequest

+ (id)requestWithRequestData:(SPGetInstagramUserMediaRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetInstagramUserMediaRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
    }
    return self;
}

- (NSString *)urlString
{
    return self.requestData.nextUrl;
}

- (void)retrieve
{
    NSLog(@"URL = %@",[self url]);
    
    NSURL *urlToRequest = [self url];
    if (!urlToRequest){
        return;
    }
    
    self.request = [ASIFormDataRequest requestWithURL:urlToRequest];
    
    for (NSString *key in [self.parameters allKeys]) {
        [(ASIFormDataRequest*)self.request setPostValue:[self.parameters objectForKey:key] forKey:key];
    }
    
    [self.request setValidatesSecureCertificate:NO];
    [self.request setRequestMethod:@"GET"];
	self.request.delegate = self;
    self.request.timeOutSeconds = 30;
	[self.request startAsynchronous];
    
	[self retain];
	[self.delegate retain];
}

- (SPGetInstagramUserMediaResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetInstagramUserMediaResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetInstagramUserMediaRequestDidFinish:)]) {
        [self.delegate SPGetInstagramUserMediaRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
