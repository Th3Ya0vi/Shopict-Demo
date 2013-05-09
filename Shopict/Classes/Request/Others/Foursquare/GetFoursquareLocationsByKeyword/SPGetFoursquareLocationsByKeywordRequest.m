//
//  SPGetFoursquareLocationsByKeywordRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetFoursquareLocationsByKeywordRequest.h"
#import "SPGetFoursquareLocationsByKeywordRequestData.h"
#import "SPGetFoursquareLocationsByKeywordResponseData.h"
#import "ASIFormDataRequest.h"

@implementation SPGetFoursquareLocationsByKeywordRequest

+ (id)requestWithRequestData:(SPGetFoursquareLocationsByKeywordRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetFoursquareLocationsByKeywordRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
    }
    return self;
}

- (NSString *)urlString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    dateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    NSString *ll = [NSString stringWithFormat:@"%f,%f",self.requestData.latitude,self.requestData.longitude];
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/suggestCompletion?ll=%@&query=%@&client_id=R3MTBYMRMIY5P4VMSI0ZJODKBDKAFNWU0X21KN31GMMJUUBN&client_secret=BIDBBLNJLFYHOWTO1R534YB2BOIC3HHPKUQJHM15OP3LSKAS&v=%@&limit=100",ll,[[NSString stringWithFormat:@"%@",self.requestData.keyword]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],dateString];
    return urlString;
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

- (SPGetFoursquareLocationsByKeywordResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetFoursquareLocationsByKeywordResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetFoursquareLocationsByKeywordRequestDidFinish:)]) {
        [self.delegate SPGetFoursquareLocationsByKeywordRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
