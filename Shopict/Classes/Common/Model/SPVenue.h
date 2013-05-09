//
//  SPVenue.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPVenue : NSObject

@property (nonatomic, retain) NSString *venueId;
@property (nonatomic, retain) NSString *fourSquareId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *fourSquareUrl;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;

+(id)venueWithDictionary:(NSDictionary *)dictionary;
+(id)venueWithFoursquareDictionary:(NSDictionary *)foursquareDictionary;

@end
