//
//  SPWantPostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPWantPostRequestData, SPPost;

@protocol SPWantPostRequestDelegate <NSObject>

- (void)SPWantPostRequestDidFinish:(SPBaseResponseData*)response post:(SPPost *)post want:(BOOL)want;

@end

@interface SPWantPostRequest : SPBaseRequest

@property (nonatomic, retain) SPWantPostRequestData *requestData;

+ (id)requestWithRequestData:(SPWantPostRequestData*)data delegate:(id)delegate;

@end
