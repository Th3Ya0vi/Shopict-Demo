//
//  SPPost.m
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月13日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPost.h"
#import "SPAccount.h"
#import "SPProduct.h"

@implementation SPPost

- (void)dealloc
{
    [_postId release];
    [_product release];
    [_author release];
    [_comment release];
    [_createTime release];
    [super dealloc];
}

+(id)postWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.postId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
        self.author = [SPAccount accountWithDictionary:[dictionary objectForKey:@"author"]];
        self.product = [SPProduct productWithDictionary:[dictionary objectForKey:@"product"]];
        self.comment = [dictionary objectForKey:@"comment"];
        self.createTime = [dictionary objectForKey:@"createTime"];
        self.commentCount = [[dictionary objectForKey:@"commentCnt"]integerValue];
        self.repostCount = [[dictionary objectForKey:@"repostCnt"]integerValue];
        self.wantCount = [[dictionary objectForKey:@"wantCnt"]integerValue];
        self.isAvailable = [[dictionary objectForKey:@"isAvailable"]boolValue];
        self.repost = [[dictionary objectForKey:@"type"]boolValue];
        self.isReposted = [[[dictionary objectForKey:@"product"]objectForKey:@"isPosted"]boolValue];
        self.isWanted = [[dictionary objectForKey:@"isWanted"]boolValue];
        self.isEditorPick = [[dictionary objectForKey:@"isEditorPick"]boolValue];
    }
    return self;
}

@end
