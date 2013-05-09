//
//  NSString+SPStringUtility.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "NSString+SPStringUtility.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SPStringUtility)

- (BOOL) isValid
{
    if (!self){
        return NO;
    }
    if ([self isEqual:[NSNull null]]) {
        return NO;
    }
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0){
        return NO;
    }
    return YES;
}


- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

- (NSString*)stringByTrimmingLeftWhitespace
{
    if (!self) {
        return nil;
    }
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for(i = 0; i < [self length]; i++)
    {
        if ( ![cs characterIsMember: [self characterAtIndex: i]] ) break;
    }
    return [self substringFromIndex: i];
}

- (NSString*)stringByTrimmingRightWhitespace
{
    if (!self) {
        return nil;
    }
    NSInteger i;
    NSCharacterSet *cs = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for(i = [self length] -1; i >= 0; i--)
    {
        if ( ![cs characterIsMember: [self characterAtIndex: i]] ) break;
    }
    return [self substringToIndex: (i+1)];
}

- (NSString*)stringByTrimmingTopTailWhitespace
{
    if (!self) {
        return nil;
    }
    return [self
            stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)localizedStringWithKey:(NSString*)key{
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"SPLocalizedString" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSDictionary *stringDictionary = [dictionary objectForKey:key];
    
    NSString *string = nil;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    string = [stringDictionary objectForKey:language];
    if (!string) {
        string = [stringDictionary objectForKey:@"en"];
    }
    
    if (string) {
        return string;
    }
    
    return key;
}

- (BOOL)isEmailValid
{
    NSString *expression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (match){
        return YES;
    }
    return NO;
}

- (BOOL)isUsernameValid
{
    NSString * VALIDUSERNAME = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_";
    NSCharacterSet *unacceptedInput = nil;
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:VALIDUSERNAME] invertedSet];
    return ([[self componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}


@end
