//
//  SPFindFriendsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPFindFriendsRequest.h"
#import "SPFindFriendsRequestData.h"
#import "SPGetAccountsResponseData.h"
#import "SPEnum.h"
#import "SPURLs.h"
#import "NSObject+SBJSON.h"

@implementation SPFindFriendsRequest

+ (id)requestWithRequestData:(SPFindFriendsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPFindFriendsRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *path = nil;
        switch (self.requestData.path) {
            case FACEBOOK:
                path = @"1";
                break;
            case TWITTER:
                path = @"2";
                break;
            case WEIBO:
                path = @"3";
                break;
            default:
                break;
        }
        NSString * thirdPartyIdsJSON = [NSString stringWithFormat:@"{\"tIdsJSON\":%@}",[data.thirdPartyIds JSONRepresentation]];
        NSArray *values = [NSArray arrayWithObjects:
                           path,
                           data.token,
                           thirdPartyIdsJSON,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"path",
                         @"token",
                         @"tIdsJSON",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_FINDFRIENDS;
}

- (SPGetAccountsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPFindFriendsRequestDidFinish:)]) {
        [self.delegate SPFindFriendsRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
