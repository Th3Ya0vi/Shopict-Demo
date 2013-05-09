//
//  SPAccount.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAccount : NSObject

@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *profileImgURL;
@property (nonatomic, retain) NSString *coverImgURL;

@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, assign) NSInteger wantCount;

@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *website;

@property (nonatomic, retain) NSMutableArray *itemThumbnails;

@property (nonatomic, assign) BOOL subscribed;
@property (nonatomic, assign) BOOL me;

+(id)accountWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
