//
//  SPGetNewsRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetNewsRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *startKey;

+(id)dataWithToken:(NSString *)token startKey:(NSString *)startKey;

@end
