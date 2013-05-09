//
//  SPGetCategoriesResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetCategoriesResponseData.h"
#import "SPCategory.h"
#import "NSString+SBJSON.h"

@implementation SPGetCategoriesResponseData

- (void)dealloc
{
    [_categories release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    self.err = [[data objectForKey:@"err"]integerValue];;
    self.errorMessage = [data objectForKey:@"errMsg"];
    if ([self isNormalResponse:data]) {
        //parseData
        self.categories = [NSMutableArray array];
        NSArray *categories = [data objectForKey:@"categories"];
        for (NSDictionary *dictionary in categories) {
            SPCategory *category = [SPCategory categoryWithDictionary:dictionary];
            [self.categories addObject:category];
        }
    }else{
        [self handleErrorResponse:data];
    }
}


@end
