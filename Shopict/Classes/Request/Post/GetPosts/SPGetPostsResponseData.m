//
//  SPBaseGetPostsResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsResponseData.h"
#import "SPPost.h"
#import "NSString+SBJSON.h"
#import "SPProduct.h"

@implementation SPGetPostsResponseData

- (void)dealloc
{
    [_posts release];
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
        self.posts = [NSMutableArray array];
        NSArray *products = [data objectForKey:@"posts"];
        for (NSDictionary *dictionary in products) {
            SPPost *post = [SPPost postWithDictionary:dictionary];
            if (post.product.type == 0 || post.product.type == 2) {
                [self.posts addObject:post];
            }
        }
        self.nextKey = [data objectForKey:@"nextKey"];
    }else{
        [self handleErrorResponse:data];
    }
}


@end
