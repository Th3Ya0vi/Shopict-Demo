//
//  SPCategory.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCategory : NSObject

@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *whiteImageURL;
@property (nonatomic, retain) NSString *blackImageURL;
@property (nonatomic, retain) NSString *greyImageURL;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, assign) BOOL isLeave;
@property (nonatomic, assign) BOOL isBined;

+(id)categoryWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;


@end
