//
//  SPCommentPostRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPCommentPostRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *comment;

+(id)dataWithPostId:(NSString *)postId token:(NSString *)token comment:(NSString *)comment;
-(id)initWithPostId:(NSString *)postId token:(NSString *)token comment:(NSString *)comment;

@end
