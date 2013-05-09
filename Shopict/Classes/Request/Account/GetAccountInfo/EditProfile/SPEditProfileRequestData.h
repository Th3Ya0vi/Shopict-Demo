//
//  SPEditProfileRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPEditProfileRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, assign) BOOL editProfilePic;
@property (nonatomic, retain) UIImage *profilePic;
@property (nonatomic, assign) BOOL editCoverPic;
@property (nonatomic, retain) UIImage *coverPic;

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
          coverPic:(UIImage *)coverPic;


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
          coverPic:(UIImage *)coverPic;

@end
