//
//  SPPost.h
//  SP
//
//  Created by Bi Chen Ka Kit on 13年3月13日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPAccount, SPProduct;
@interface SPPost : NSObject

@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) SPProduct *product;
@property (nonatomic, retain) SPAccount *author;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, assign) NSInteger wantCount;
@property (nonatomic, assign) NSInteger repostCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) BOOL isAvailable;
@property (nonatomic, assign) BOOL isWanted;
@property (nonatomic, assign) BOOL repost;
@property (nonatomic, assign) BOOL isReposted;
@property (nonatomic, assign) BOOL isEditorPick;


+(id)postWithDictionary:(NSDictionary *)dictionary;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
