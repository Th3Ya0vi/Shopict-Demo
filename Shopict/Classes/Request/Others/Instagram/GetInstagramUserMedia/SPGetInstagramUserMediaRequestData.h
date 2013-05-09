//
//  SPGetInstagramUserMediaRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetInstagramUserMediaRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *nextUrl;

+(id)dataWithNextUrl:(NSString *)nextUrl;
-(id)initWithNextUrl:(NSString *)nextUrl;

@end
