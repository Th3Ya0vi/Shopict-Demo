//
//  SPGetPostCommentsResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostCommentsResponseData.h"
#import "NSString+SBJSON.h"
#import "SPComment.h"

@implementation SPGetPostCommentsResponseData

- (void)dealloc
{
    [_nextKey release];
    [_comments release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        //parseData
        self.comments = [NSMutableArray array];
        NSArray *comments = [data objectForKey:@"comments"];
        for (NSDictionary *dictionary in comments) {
            SPComment *comment = [SPComment commentWithDictionary:dictionary];
            [self.comments addObject:comment];
        }
        self.nextKey = [data objectForKey:@"nextKey"];
    }else{
        [self handleErrorResponse:data];
    }
}


@end
