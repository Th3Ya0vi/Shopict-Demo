//
//  SPBaseResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"
#import "NSString+SBJSON.h"

@implementation SPBaseResponseData

+ (id)responseWithString:(NSString*)response {
    return [[[self alloc] initWithString:response] autorelease];
}

- (id)initWithString:(NSString*)response {
    self = [self init];
    if (self) {
        self.responseString = response;
        [self processResponseString];
    }
    return self;
}

- (void)processResponseString
{
    //Override this to extract data
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];;
    self.errorMessage = [data objectForKey:@"errMsg"];
    if (data) {
        if ([self isNormalResponse:data]) {
        }else{
            [self handleErrorResponse:data];
        }
    }else{
        [self handleErrorResponse:data];
    }
}

- (void)dealloc
{
    [_responseString release];
    [_errorMessage release];
    [super dealloc];
}

- (void)handleErrorResponse:(NSDictionary*)resposne
{
    if (self.errorMessage) {
        if (self.err == 91||self.err == 92||self.err == 93||self.err == 94) {
            self.errorType = SPRequestConnectionTokenExpired;
        }else{
            //Server Error
            self.errorType = SPRequestConnectionServerError;
        }
        self.error = self.errorMessage;
    }else{
        //JSON Error
        self.errorType = SPRequestConnectionJSONError;
        self.error = @"Please try again later.";
    }
}

- (BOOL)isNormalResponse:(id)response
{
    if (response) {
        return [[response objectForKey:@"err"]intValue]==0;
    }
    return NO;
}

@end
