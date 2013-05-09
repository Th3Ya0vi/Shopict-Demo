//
//  SPVenue.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPVenue.h"
#import "NSString+SPStringUtility.h"

@implementation SPVenue

- (void)dealloc
{
    [_venueId release];
    [_fourSquareId release];
    [_name release];
    [_address release];
    [_fourSquareUrl release];
    [_countryCode release];
    [super dealloc];
}

+(id)venueWithDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc]initWithDictionary:dictionary]autorelease];
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.venueId = [dictionary objectForKey:@"id"];
        self.fourSquareId = [dictionary objectForKey:@"foursquare_id"];
        self.name = [dictionary objectForKey:@"name"];
        self.address = [dictionary objectForKey:@"address"];
        self.fourSquareUrl = [NSString stringWithFormat:@"foursquare.com/v/%@",[dictionary objectForKey:@"foursquare_id"]];
        self.countryCode = [dictionary objectForKey:@""];
        self.latitude = [[dictionary objectForKey:@"latitude"]doubleValue];
        self.longitude = [[dictionary objectForKey:@"longitude"]doubleValue];
    }
    return self;
}

+(id)venueWithFoursquareDictionary:(NSDictionary *)foursquareDictionary
{
    return [[[self alloc]initWithFoursquareDictionary:foursquareDictionary]autorelease];
}

-(id)initWithFoursquareDictionary:(NSDictionary *)foursquareDictionary
{
    self = [super init];
    if (self) {
        self.fourSquareId = [foursquareDictionary objectForKey:@"id"];
        self.name = [foursquareDictionary objectForKey:@"name"];
        NSDictionary *locationDictionary = [foursquareDictionary objectForKey:@"location"];
        NSString *address = [locationDictionary objectForKey:@"address"];
        if ([[locationDictionary objectForKey:@"city"]isValid]) {
            address = [NSString stringWithFormat:@"%@, %@",address, [locationDictionary objectForKey:@"city"]];
        }
        self.fourSquareUrl = [NSString stringWithFormat:@"foursquare.com/v/%@",[foursquareDictionary objectForKey:@"id"]];
        self.address = address;
        self.countryCode = [locationDictionary objectForKey:@"cc"];
        self.latitude = [[locationDictionary objectForKey:@"lat"]doubleValue];
        self.longitude = [[locationDictionary objectForKey:@"lng"]doubleValue];
        
        NSLog(@"fourSquareId %@",self.fourSquareId);
        
    }
    return self;
}

@end
