//
//  SPReportProfileRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPReportProfileRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *reportUId;

+(id)dataWithToken:(NSString *)token reportUId:(NSString *)reportUId;
-(id)initWithToken:(NSString *)token reportUId:(NSString *)reportUId;

@end
