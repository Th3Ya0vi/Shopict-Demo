//
//  SPAccount.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPAccount.h"
#import "NSString+SPStringUtility.h"
#import "SPUtility.h"

@implementation SPAccount

- (void)dealloc
{
    [_accountId release];
    [_name release];
    [_username release];
    [_description release];
    [_status release];
    [_profileImgURL release];
    [_coverImgURL release];
    [_location release];
    [_phoneNumber release];
    [_email release];
    [_website release];
    [_itemThumbnails release];
    [super dealloc];
}

+(id)accountWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.accountId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"id"]];
        self.name = ![[dictionary objectForKey:@"name"]isValid]?nil:[dictionary objectForKey:@"name"];
        self.username = ![[dictionary objectForKey:@"username"]isValid]?nil:[dictionary objectForKey:@"username"];
        self.description = ![[dictionary objectForKey:@"desc"]isValid]?nil:[dictionary objectForKey:@"desc"];
        self.status = ![[dictionary objectForKey:@"status"]isValid]?nil:[dictionary objectForKey:@"status"];
        self.profileImgURL = ![[dictionary objectForKey:@"profileImageURL"]isValid]?nil:[dictionary objectForKey:@"profileImageURL"];
        self.coverImgURL = ![[dictionary objectForKey:@"coverImageURL"]isValid]?nil:[dictionary objectForKey:@"coverImageURL"];
        self.wantCount = [[dictionary objectForKey:@"wantCnt"]integerValue];
        self.postCount = [[dictionary objectForKey:@"postCnt"]integerValue];
        self.followCount = [[dictionary objectForKey:@"followCnt"]integerValue];
        self.fansCount = [[dictionary objectForKey:@"fansCnt"]integerValue];
        self.location = ![[dictionary objectForKey:@"location"]isValid]?nil:[dictionary objectForKey:@"location"];
        self.phoneNumber = ![[dictionary objectForKey:@"mobileNumber"]isValid]?nil:[dictionary objectForKey:@"mobileNumber"];
        self.email = ![[dictionary objectForKey:@"email"]isValid]?nil:[dictionary objectForKey:@"email"];
        self.website = ![[dictionary objectForKey:@"website"]isValid]?nil:[dictionary objectForKey:@"website"];
        self.itemThumbnails = [dictionary objectForKey:@"itemThumbnailURLs"];
        self.subscribed = [[dictionary objectForKey:@"subscribed"]boolValue];
        self.me = [[dictionary objectForKey:@"me"]boolValue];
    }
    return self;
}

@end
