//
//  SPNews.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPNews.h"
#import "SPAccount.h"
#import "SPPost.h"

@implementation SPNews

- (void)dealloc
{
    [_newsId release];
    [_account release];
    [_post release];
    [_description release];
    [_dateTime release];
    [super dealloc];
}

+(id)newsWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.account = [SPAccount accountWithDictionary:[dictionary objectForKey:@"peerAccount"]];
        self.post = [SPPost postWithDictionary:[dictionary objectForKey:@"post"]];
        self.type = [[dictionary objectForKey:@"type"]integerValue];
        self.description = [dictionary objectForKey:@"desc"];
        self.dateTime = [dictionary objectForKey:@"time"];
        self.newsId = [dictionary objectForKey:@"newsId"];
    }
    return self;
}


@end
