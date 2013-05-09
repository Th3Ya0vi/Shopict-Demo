//
//  SPProduct.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEnum.h"

@class SPAccount,SPVenue;

@interface SPProduct : NSObject

@property (nonatomic, retain) NSString *productId;
@property (nonatomic, retain) SPAccount *account;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSArray *imgURLs;
@property (nonatomic, retain) NSArray *thumbnailURLs;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSMutableArray *ratios;
@property (nonatomic, retain) SPVenue *venue;

+(id)productWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
