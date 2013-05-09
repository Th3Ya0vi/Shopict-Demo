//
//  SPCommentPostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPCommentPostRequestData;

@protocol SPCommentPostRequestDelegate <NSObject>

- (void)SPCommentPostRequestDidFinish:(SPBaseResponseData*)response comment:(NSString *)comment;

@end

@interface SPCommentPostRequest : SPBaseRequest

@property (nonatomic, retain) SPCommentPostRequestData *requestData;

+ (id)requestWithRequestData:(SPCommentPostRequestData*)data delegate:(id)delegate;

@end
