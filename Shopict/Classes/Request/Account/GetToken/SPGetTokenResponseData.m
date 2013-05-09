//
//  SPGetTokenResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetTokenResponseData.h"
#import "NSString+SBJSON.h"
#import "SPAccount.h"

@implementation SPGetTokenResponseData

- (void)dealloc
{
    [_token release];
    [_account release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        //parseData
        self.token = [data objectForKey:@"token"];
        self.account = [SPAccount accountWithDictionary:[data objectForKey:@"account"]];
    }else{
        [self handleErrorResponse:data];
    }
}

@end
