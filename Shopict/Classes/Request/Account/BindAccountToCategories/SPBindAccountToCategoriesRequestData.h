//
//  SPBindAccountToCategoriesRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPBindAccountToCategoriesRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSMutableArray *categoryIds;

+(id)dataWithToken:(NSString *)token categoryIds:(NSMutableArray *)categoryIds;
-(id)initWithToken:(NSString *)token categoryIds:(NSMutableArray *)categoryIds;

@end
