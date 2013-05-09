//
//  SPGetPostsByUserIdRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"
#import "SPEnum.h"

@class SPGetPostsResponseData, SPGetPostsByUserIdRequestData;

@protocol SPGetPostsByUserIdRequestDelegate <NSObject>

- (void)SPGetPostsByUserIdRequestDidFinish:(SPGetPostsResponseData*)response type:(PostType)type startKey:(NSString *)startKey;

@end

@interface SPGetPostsByUserIdRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostsByUserIdRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostsByUserIdRequestData*)data delegate:(id)delegate;

@end

