//
//  SPGetPostCommentsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostCommentsResponseData, SPGetPostCommentsRequestData;

@protocol SPGetPostCommentsRequestDelegate <NSObject>

- (void)SPGetPostCommentsRequestDidFinish:(SPGetPostCommentsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetPostCommentsRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostCommentsRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostCommentsRequestData*)data delegate:(id)delegate;

@end
