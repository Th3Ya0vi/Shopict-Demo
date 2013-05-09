//
//  SPAddPostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPAddPostRequest.h"
#import "SPAddPostRequestData.h"
#import "SPGetPostInfoResponseData.h"
#import "SPURLs.h"
#import "NSObject+SBJSON.h"

@implementation SPAddPostRequest

+ (id)requestWithRequestData:(SPAddPostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPAddPostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSMutableArray *categoryIdsINT = [NSMutableArray array];
        for (NSString *categoryIdString in data.categoryIds) {
            NSNumber *categoryNUM = [NSNumber numberWithInt:[categoryIdString intValue]];
            [categoryIdsINT addObject:categoryNUM];
        }
        NSString * categoryIdsJSON = [NSString stringWithFormat:@"{\"categoryIDs\":%@}",[categoryIdsINT JSONRepresentation]];
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.name,
                           categoryIdsJSON,
                           @"0",
                           @"0",
                           [NSString stringWithFormat:@"%f",self.requestData.price],
                           data.currency,
                           data.url,
                           @"1",
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"name",
                         @"cIdsJSON",
                         @"postType",
                         @"type",
                         @"price",
                         @"currency",
                         @"url",
                         @"isGlobal",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_ADDPOST;
}

- (void)customizeRequest
{
    
    [self setCustomizedPostValue:self.requestData.description forKey:@"desc"];
    [self setCustomizedPostValue:self.requestData.comment forKey:@"comment"];
    
    if (self.requestData.img0) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img0, 0.5)  forKey:@"img0"];
    }
    if (self.requestData.img1) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img1, 0.5)  forKey:@"img1"];
    }
    if (self.requestData.img2) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img2, 0.5)  forKey:@"img2"];
    }
    if (self.requestData.img3) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img3, 0.5)  forKey:@"img3"];
    }
    if (self.requestData.img4) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img4, 0.5)  forKey:@"img4"];
    }
    if (self.requestData.img5) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img5, 0.5)  forKey:@"img5"];
    }
    if (self.requestData.img6) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img6, 0.5)  forKey:@"img6"];
    }
    if (self.requestData.img7) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.img7, 0.5)  forKey:@"img7"];
    }
}

- (SPGetPostInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPAddPostRequestDidFinish:)]) {
        [self.delegate SPAddPostRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
