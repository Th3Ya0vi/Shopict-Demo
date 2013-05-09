//
//  SPGetTagsByKeywordResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetTagsByKeywordResponseData.h"
#import "NSString+SBJSON.h"

@implementation SPGetTagsByKeywordResponseData

- (void)dealloc
{
    [_tags release];
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
        if (![[data objectForKey:@"result"] isEqual:[NSNull null]]) {
            self.tags = [data objectForKey:@"result"];
            self.nextKey = [data objectForKey:@"nextKey"];
        }
    }else{
        [self handleErrorResponse:data];
    }
}


@end
