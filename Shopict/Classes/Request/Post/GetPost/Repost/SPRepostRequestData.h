//
//  SPRepostRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@class SPPost;
@interface SPRepostRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) SPPost *post;
@property (nonatomic, retain) NSString *comment;

+ (id)dataWithToken:(NSString *)token
               post:(SPPost *)post
            comment:(NSString *)comment;

- (id)initWithToken:(NSString *)token
             post:(SPPost *)post
            comment:(NSString *)comment;

@end
