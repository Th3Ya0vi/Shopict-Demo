//
//  SPDeletePostRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@class SPPost;
@interface SPDeletePostRequestData : SPBaseRequestData

@property (nonatomic, retain) SPPost *post;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) BOOL repost;

+ (id)dataWithPost:(SPPost *)post token:(NSString *)token repost:(BOOL)repost;
- (id)initWithPost:(SPPost *)post token:(NSString *)token repost:(BOOL)repost;

@end
