//
//  SPCategory.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPCategory.h"

@implementation SPCategory

- (void)dealloc
{
    [_categoryId release];
    [_name release];
    [_description release];
    [_whiteImageURL release];
    [_blackImageURL release];
    [_greyImageURL release];
    [super dealloc];
}

+(id)categoryWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.categoryId = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:@"categoryID"]integerValue]];
        self.name = [dictionary objectForKey:@"name"];
        self.description = [dictionary objectForKey:@"description"];
        self.whiteImageURL = [dictionary objectForKey:@"whiteImg"];
        self.blackImageURL = [dictionary objectForKey:@"blackImg"];
        self.greyImageURL = [dictionary objectForKey:@"greyImg"];
        
        self.isRoot = [[dictionary objectForKey:@"isRoot"]boolValue];
        self.isLeave = [[dictionary objectForKey:@"isLeave"]boolValue];
        self.isBined = [[dictionary objectForKey:@"isBind"]boolValue];
    }
    return self;
}
@end
