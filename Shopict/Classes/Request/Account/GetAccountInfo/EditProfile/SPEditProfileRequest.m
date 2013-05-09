//
//  SPEditProfileRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPEditProfileRequest.h"
#import "SPEditProfileRequestData.h"
#import "SPGetAccountInfoResponseData.h"
#import "SPURLs.h"

@implementation SPEditProfileRequest

+ (id)requestWithRequestData:(SPEditProfileRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPEditProfileRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSString *editProfilePic = (self.requestData.editProfilePic?@"1":@"0");
        NSString *editCoverPic = (self.requestData.editCoverPic?@"1":@"0");
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.name,
                           data.username,
                           data.email,
                           editProfilePic,
                           editCoverPic,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"name",
                         @"username",
                         @"email",
                         @"editProfilePic",
                         @"editCoverPic",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_EDITPROFILE;
}

- (void)customizeRequest
{
    [self setCustomizedPostValue:self.requestData.website forKey:@"website"];
    [self setCustomizedPostValue:self.requestData.description forKey:@"description"];
    [self setCustomizedPostValue:self.requestData.phoneNumber forKey:@"phone"];
    
    if (self.requestData.editProfilePic) {
        if (self.requestData.profilePic) {
            [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.profilePic, 0.5) forKey:@"profilePic"];
        }
    }

    if (self.requestData.editCoverPic) {
        if (self.requestData.coverPic) {
            [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.coverPic, 0.5) forKey:@"coverPic"];
        }
    }
}

- (SPGetAccountInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPEditProfileRequestDidFinish:)]) {
        [self.delegate SPEditProfileRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
