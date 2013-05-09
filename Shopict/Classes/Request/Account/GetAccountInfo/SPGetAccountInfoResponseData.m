//
//  SPGetAccountInfoResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountInfoResponseData.h"
#import "SPAccount.h"
#import "NSString+SBJSON.h"

@implementation SPGetAccountInfoResponseData

- (void)dealloc
{
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
        self.account = [SPAccount accountWithDictionary:[data objectForKey:@"account"]];
    }else{
        [self handleErrorResponse:data];
    }
}


@end
