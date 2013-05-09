//
//  SPAddPostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPAddPostRequestData.h"

@implementation SPAddPostRequestData

- (void)dealloc
{
    [_token release];
    [_name release];
    [_currency release];
    [_description release];
    [_categoryIds release];
    [_img0 release];
    [_img1 release];
    [_img2 release];
    [_img3 release];
    [_img4 release];
    [_img5 release];
    [_img6 release];
    [_img7 release];
    [_url release];
    [_comment release];
    [super dealloc];
}

+ (id)dataWithToken:(NSString *)token
           postType:(PostType)postType
               name:(NSString *)name
                url:(NSString *)url
              price:(float)price
           currency:(NSString *)currency
        description:(NSString *)description
        categoryIds:(NSMutableArray *)categoryIds
                tag:(NSString *)tag
               img0:(UIImage *)img0
               img1:(UIImage *)img1
               img2:(UIImage *)img2
               img3:(UIImage *)img3
               img4:(UIImage *)img4
               img5:(UIImage *)img5
               img6:(UIImage *)img6
               img7:(UIImage *)img7
            comment:(NSString *)comment
{
    return [[[self alloc]initWithToken:token postType:postType name:name url:url price:price currency:currency description:description categoryIds:categoryIds tag:tag img0:img0 img1:img1 img2:img2 img3:img3 img4:img4 img5:img5 img6:img6 img7:img7 comment:comment]autorelease];
}

- (id)initWithToken:(NSString *)token
           postType:(PostType)postType
               name:(NSString *)name
                url:(NSString *)url
              price:(float)price
           currency:(NSString *)currency
        description:(NSString *)description
        categoryIds:(NSMutableArray *)categoryIds
                tag:(NSString *)tag
               img0:(UIImage *)img0
               img1:(UIImage *)img1
               img2:(UIImage *)img2
               img3:(UIImage *)img3
               img4:(UIImage *)img4
               img5:(UIImage *)img5
               img6:(UIImage *)img6
               img7:(UIImage *)img7
            comment:(NSString *)comment
{
    self = [super init];
    if (self) {
        self.token = token;
        self.postType = postType;
        self.name = name;
        self.price = price;
        self.currency = currency;
        self.description = description;
        self.categoryIds = categoryIds;
        self.img0 = img0;
        self.img1 = img1;
        self.img2 = img2;
        self.img3 = img3;
        self.img4 = img4;
        self.img5 = img5;
        self.img6 = img6;
        self.img7 = img7;
        self.url = url;
        self.comment = comment;
    }
    return self;
}


@end
