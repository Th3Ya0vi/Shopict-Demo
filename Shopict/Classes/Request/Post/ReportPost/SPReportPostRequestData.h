//
//  SPReportPostRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月26日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@class SPPost;
@interface SPReportPostRequestData : SPBaseRequestData

@property (nonatomic, retain) SPPost *post;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) ReportPostWithURLType type;

+ (id)dataWithPost:(SPPost *)post
             token:(NSString *)token
              type:(ReportPostWithURLType)type;
- (id)initWithPost:(SPPost *)post
             token:(NSString *)token
              type:(ReportPostWithURLType)type;
@end
