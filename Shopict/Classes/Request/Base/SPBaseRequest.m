//
//  SPBaseRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "ASIFormDataRequest.h"
#import "SPBaseResponseData.h"
#import "SPUtility.h"

@implementation SPBaseRequest

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self != nil) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [_request release];
    [_response release];
    [_parameters release];
    [super dealloc];
}

- (NSString *)urlString
{
    return nil;
}

- (NSURL *)url
{
    NSMutableString *tempStr = [NSMutableString stringWithString:[self urlString]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@",tempStr]];
}

- (void)retrieve
{
    [SPUtility shouldReload];
    NSLog(@"URL = %@",[self url]);
    
    NSURL *urlToRequest = [self url];
    if (!urlToRequest){
        return;
    }
    
    self.request = [ASIFormDataRequest requestWithURL:urlToRequest];
    
    for (NSString *key in [self.parameters allKeys]) {
        [(ASIFormDataRequest*)self.request setPostValue:[self.parameters objectForKey:key] forKey:key];
    }
    
    [self customizeRequest];
    
    [self.request setValidatesSecureCertificate:NO];
    [self.request setRequestMethod:@"POST"];
	self.request.delegate = self;
    self.request.timeOutSeconds = 30;
	[self.request startAsynchronous];
    
	[self retain];
	[self.delegate retain];
}

- (void)customizeRequest
{
    
}

- (void)setCustomizedPostValue:(NSObject *)value forKey:(NSString *)key
{
    [self.request setPostValue:value forKey:key];
}

- (void)setCustomizedImageData:(NSData *)data forKey:(NSString *)key
{
    [self.request setUseKeychainPersistence:YES];
    [self.request setData:data withFileName:@"123.jpeg" andContentType:@"image/jpeg" forKey:key];
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSLog(@"Response String = %@",request.responseString);
    
	self.isSuccess = YES;
    [request setResponseEncoding:NSUTF8StringEncoding];
	[self responseString:[request responseString]];
	[self autorelease];
	[self.delegate autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	self.isSuccess = NO;
	[self responseString:[request responseString]];
	[self autorelease];
	[self.delegate autorelease];
}

- (void)responseString:(NSString *)response
{
    SPBaseResponseData *data = [self responseHandlerWithResponse:response];
    
    if (self.isSuccess) {
        
    }else{
        switch ([[[self request] error] code]) {
            case ASIConnectionFailureErrorType:
                data.error = @"Connection Failure";
                break;
            case ASIRequestTimedOutErrorType:
                data.error = @"Connection Timed Out";
                break;
            case ASIRequestCancelledErrorType:
                data.error = @"Connection Cancelled";
                break;
            default:
                data.error = @"Connection Unknown Error";
                break;
        }
        data.errorType = SPRequestConnectionFailure;
    }
    self.response = data;
    [self responseToDelegate];
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return nil;
}

- (void)responseToDelegate
{
    
}


@end
