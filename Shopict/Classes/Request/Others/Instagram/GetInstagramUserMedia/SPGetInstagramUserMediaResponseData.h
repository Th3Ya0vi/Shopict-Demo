//
//  SPGetInstagramUserMediaResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"

@interface SPGetInstagramUserMediaResponseData : SPBaseResponseData

@property (nonatomic, retain) NSString *nextUrl;
@property (nonatomic, retain) NSMutableArray* thumbnailUrls;
@property (nonatomic, retain) NSMutableArray* standardUrls;
@property (nonatomic, assign) BOOL lastImage;

@end
