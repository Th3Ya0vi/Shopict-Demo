//
//  SPGetNewsResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetNewsResponseData.h"
#import "SPNews.h"
#import "NSString+SBJSON.h"

@implementation SPGetNewsResponseData

- (void)dealloc
{
    [_news release];
    [_nextKey release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        self.news = [NSMutableArray array];
        NSArray *newsArray = [data objectForKey:@"news"];
        for (NSDictionary *dictionary in newsArray) {
            SPNews *news = [SPNews newsWithDictionary:dictionary];
            if (news.type == 0) {
                [self.news addObject:news];
            }
        }
        self.nextKey = [data objectForKey:@"nextKey"];
    }else{
        [self handleErrorResponse:data];
    }
}

@end
