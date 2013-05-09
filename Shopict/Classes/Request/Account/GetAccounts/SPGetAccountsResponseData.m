//
//  SPGetAccountsResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountsResponseData.h"
#import "SPAccount.h"
#import "NSString+SBJSON.h"

@implementation SPGetAccountsResponseData

- (void)dealloc
{
    [_accounts release];
    [_nextKey release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        //parseData
        self.accounts = [NSMutableArray array];
        NSArray *accounts = [data objectForKey:@"accounts"];
        for (NSDictionary *dictionary in accounts) {
            SPAccount *account = [SPAccount accountWithDictionary:dictionary];
            [self.accounts addObject:account];
        }
        self.nextKey = [data objectForKey:@"nextKey"];
    }else{
        [self handleErrorResponse:data];
    }
}

@end
