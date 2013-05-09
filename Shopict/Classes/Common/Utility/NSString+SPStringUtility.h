//
//  NSString+SPStringUtility.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SPStringUtility)

- (BOOL) isValid;
- (BOOL)isEmailValid;
- (BOOL)isUsernameValid;

- (NSString *) md5;
- (NSString*)stringByTrimmingLeftWhitespace;
- (NSString*)stringByTrimmingRightWhitespace;
- (NSString*)stringByTrimmingTopTailWhitespace;
+ (NSString*)localizedStringWithKey:(NSString*)key;


@end
