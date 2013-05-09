//
//  SPGetPostInfoRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetPostInfoRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) NSString *token;

+(id)dataWithPostId:(NSString *)postId token:(NSString *)token;
-(id)initWithPostId:(NSString *)postId token:(NSString *)token;

@end
