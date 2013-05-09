//
//  SPEditProfileRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPEditProfileRequestData.h"

@implementation SPEditProfileRequestData

- (void)dealloc
{
    [_token release];
    [_name release];
    [_username release];
    [_email release];
    [_website release];
    [_description release];
    [_phoneNumber release];
    [_profilePic release];
    [_coverPic release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
              name:(NSString *)name
          username:(NSString *)username
             email:(NSString *)email
           website:(NSString *)website
       description:(NSString *)description
       phoneNumber:(NSString *)phoneNumber
    editProfilePic:(BOOL)editProfilePic
        profilePic:(UIImage *)profilePic
      editCoverPic:(BOOL)editCoverPic
          coverPic:(UIImage *)coverPic
{
    return [[[self alloc]initWithToken:token name:name username:username email:email website:website description:description phoneNumber:phoneNumber  editProfilePic:editProfilePic profilePic:profilePic editCoverPic:editCoverPic coverPic:coverPic]autorelease];
}


-(id)initWithToken:(NSString *)token
              name:(NSString *)name
          username:(NSString *)username
             email:(NSString *)email
           website:(NSString *)website
       description:(NSString *)description
       phoneNumber:(NSString *)phoneNumber
    editProfilePic:(BOOL)editProfilePic
        profilePic:(UIImage *)profilePic
      editCoverPic:(BOOL)editCoverPic
          coverPic:(UIImage *)coverPic
{
    self = [super init];
    if (self) {
        self.token = token;
        self.name = name;
        self.username = [username lowercaseString];
        self.email = email;
        self.website = website;
        self.description = description;
        self.phoneNumber = phoneNumber;
        self.editProfilePic = editProfilePic;
        self.editCoverPic = editCoverPic;
        
        if (editProfilePic) {
            if (profilePic) {
                self.profilePic = profilePic;
            }
        }
        
        if (editCoverPic) {
            if (coverPic) {
                self.coverPic = coverPic;
            }
        }
    }
    return self;
}


@end
