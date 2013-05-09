//
//  SPComment.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPAccount;

@interface SPComment : NSObject

@property (nonatomic, retain) NSString *commentId;
@property (nonatomic, retain) SPAccount *account;
@property (nonatomic, retain) NSMutableArray *reply;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *dateTime;

+(id)commentWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;


@end
