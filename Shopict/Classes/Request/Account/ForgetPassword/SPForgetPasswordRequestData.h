//
//  SPForgetPasswordRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPForgetPasswordRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *email;

+(id)dataWithEmail:(NSString *)email;
-(id)initWithEmail:(NSString *)email;

@end
