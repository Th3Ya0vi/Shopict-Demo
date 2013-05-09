//
//  SPNews.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEnum.h"

@class SPAccount, SPPost;
@interface SPNews : NSObject


@property (nonatomic, retain) NSString *newsId;
@property (nonatomic, retain) SPAccount *account;
@property (nonatomic, retain) SPPost *post;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *dateTime;

+(id)newsWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
