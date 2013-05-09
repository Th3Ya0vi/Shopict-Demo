//
//  SPProduct.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPProduct.h"
#import "SPAccount.h"
#import "NSString+SPStringUtility.h"
#import "SPVenue.h"

@implementation SPProduct

- (void)dealloc
{
    [_productId release];
    [_account release];
    [_name release];
    [_currency release];
    [_description release];
    [_imgURLs release];
    [_thumbnailURLs release];
    [_url release];
    [_tags release];
    [_ratios release];
    [super dealloc];
}

+(id)productWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.productId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
        self.account = [SPAccount accountWithDictionary:[dictionary objectForKey:@"account"]];
        self.name = [dictionary objectForKey:@"name"];
        self.price = [[dictionary objectForKey:@"price"]floatValue];
        self.currency = [dictionary objectForKey:@"currency"];
        self.description = [dictionary objectForKey:@"desc"];
        self.imgURLs = [dictionary objectForKey:@"imgURLs"];
        self.thumbnailURLs = [dictionary objectForKey:@"thumbnailURLs"];
        self.url = [[dictionary objectForKey:@"url"]isValid]?[dictionary objectForKey:@"url"]:nil;
        self.tags = [NSMutableArray array];
        if ([[dictionary objectForKey:@"tags"]isValid]) {
            NSArray *tagsArray = [[dictionary objectForKey:@"tags"]componentsSeparatedByString:@","];
            for (NSString *component in tagsArray) {
                NSString *tag = [component stringByTrimmingTopTailWhitespace];
                [self.tags addObject:tag];
            }
        }
        self.type = [[dictionary objectForKey:@"postType"]integerValue];
        self.ratios = [dictionary objectForKey:@"ratios"];
        self.venue = [SPVenue venueWithDictionary:[dictionary objectForKey:@"venue"]];
    }
    return self;
}

@end
