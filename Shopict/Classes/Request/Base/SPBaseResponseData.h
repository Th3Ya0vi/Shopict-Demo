//
//  SPBaseResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    //ASI
    SPRequestConnectionFailure,
    
    //SP
    SPRequestConnectionJSONError,
    SPRequestConnectionServerError,
    SPRequestConnectionTokenExpired,
}SPRequestError;

@interface SPBaseResponseData : NSObject

//SP
@property (nonatomic, assign) SPRequestError errorType;
@property (nonatomic, retain) NSString *error;

//Response
@property (nonatomic, retain) NSString *responseString;
@property (nonatomic, assign) NSInteger err;
@property (nonatomic, retain) NSString *errorMessage;

+ (id)responseWithString:(NSString *)responseString;
- (id)initWithString:(NSString *)responseString;
- (void)handleErrorResponse:(NSDictionary*)resposne;
- (BOOL)isNormalResponse:(id)response;

@end
