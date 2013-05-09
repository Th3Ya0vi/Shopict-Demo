//
//  SPAddPostRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPAddPostRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) PostType postType;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSMutableArray *categoryIds;
@property (nonatomic, retain) UIImage *img0;
@property (nonatomic, retain) UIImage *img1;
@property (nonatomic, retain) UIImage *img2;
@property (nonatomic, retain) UIImage *img3;
@property (nonatomic, retain) UIImage *img4;
@property (nonatomic, retain) UIImage *img5;
@property (nonatomic, retain) UIImage *img6;
@property (nonatomic, retain) UIImage *img7;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *comment;

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
            comment:(NSString *)comment;

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
            comment:(NSString *)comment;


@end
