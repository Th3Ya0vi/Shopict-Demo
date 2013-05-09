//
//  SPGetPostInfoResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostInfoResponseData.h"
#import "SPPost.h"
#import "NSString+SBJSON.h"

@implementation SPGetPostInfoResponseData

- (void)dealloc
{
    [_post release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        //parseData
        self.post = [SPPost postWithDictionary:[data objectForKey:@"post"]];
    }else{
        [self handleErrorResponse:data];
    }
}

@end
