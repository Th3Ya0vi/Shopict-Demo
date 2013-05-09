//
//  SPComment.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPComment.h"
#import "SPAccount.h"

@implementation SPComment

- (void)dealloc
{
    [_commentId release];
    [_account release];
    [_reply release];
    [_comment release];
    [_dateTime release];
    [super dealloc];
}

+(id)commentWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.commentId = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"id"]integerValue]];
        self.account = [SPAccount accountWithDictionary:[dictionary objectForKey:@"account"]];
        self.reply = [NSMutableArray array];
        NSArray *replyDictionaryArray = [dictionary objectForKey:@"reply"];
        for (NSDictionary *replyDictionary in replyDictionaryArray) {
            SPAccount *replyAccount = [SPAccount accountWithDictionary:replyDictionary];
            [self.reply addObject:replyAccount];
        }
        self.comment = [dictionary objectForKey:@"comment"];
        self.dateTime = [dictionary objectForKey:@"datetime"];
    }
    return self;
}


@end
