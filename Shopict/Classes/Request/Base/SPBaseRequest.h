//
//  SPBaseRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIFormDataRequest;

@interface SPBaseRequest : NSObject

@property (nonatomic, retain) ASIFormDataRequest *request;

//ResponseData Object
@property (nonatomic, retain) id response;

//Sender
@property (nonatomic, assign) id delegate;

//Check request success (for ASIDataFormRequest)
@property (nonatomic, assign) BOOL isSuccess;

//Mandatory Parameters
@property (nonatomic, retain) NSDictionary *parameters;

- (id)initWithDelegate:(id)delegate;
- (void)retrieve;
- (NSURL *)url;

//ASIHTTP
- (void)setCustomizedPostValue:(NSObject *)value forKey:(NSString *)key;
- (void)setCustomizedImageData:(NSData *)data forKey:(NSString *)key;


@end

