//
//  OTMailURL.m
//  OTMailURLDemo
//
//  Created by openthread on 1/6/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import "OTMailURL.h"

@interface OTMailURL ()
@property (nonatomic, strong) NSMutableArray<NSString *> *parsingToMailAddresses;
@property (nonatomic, strong) NSMutableArray<NSString *> *parsingCcMailAddresses;
@property (nonatomic, strong) NSMutableArray<NSString *> *parsingBccMailAddresses;
@end

@implementation OTMailURL

+ (instancetype)URLWithString:(NSString *)URLString
{
    return [[self alloc] initWithString:URLString];
}

- (instancetype)initWithString:(NSString *)URLString
{
    NSString *schemeLowercase = [[[self class] schemeForURLString:URLString] lowercaseString];
    if (![schemeLowercase isEqualToString:@"mailto"])
    {
        return nil;
    }

    self = [super init];
    if (self)
    {
        _originalURLString = URLString;
        [self parseURL];
    }
    return self;
}

- (void)parseURL
{
    self.parsingToMailAddresses = [NSMutableArray array];
    self.parsingCcMailAddresses = [NSMutableArray array];
    self.parsingBccMailAddresses = [NSMutableArray array];

    NSString *trimmedURLString = [[self class] stringByTrimmingAllWhiteSpace:self.originalURLString];
    NSString *mailAndQueryString = [trimmedURLString substringFromIndex:@"mailto:".length];

    NSString *mailAddressBodyString;
    NSString *mailQueryString;
    [[self class] parseURLBody:mailAndQueryString mailAddress:&mailAddressBodyString queryString:&mailQueryString];
}

//remove all whitespace from string
+ (NSString *)stringByTrimmingAllWhiteSpace:(NSString *)originalString
{
    NSArray *words = [originalString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *noSpaceString = [words componentsJoinedByString:@""];
    return noSpaceString;
}

//get scheme for URL string, scheme is the substring before :
+ (nullable NSString *)schemeForURLString:(NSString *)URLString
{
    NSString *const schemeSeparator = @":";
    NSRange separatorRange = [URLString rangeOfString:schemeSeparator];
    if (separatorRange.location != NSNotFound)
    {
        NSString *scheme = [URLString substringToIndex:separatorRange.location];
        return scheme;
    }
    return nil;
}

//get mail body and query string
//e.g. bodyWithoutScheme is 'alice@example.com,bob@example.com?subject=hello&body=world'
//then *mailAddressString is 'alice@example.com,bob@example.com', *queryString is 'subject=hello&body=world'
+ (void)parseURLBody:(NSString *)bodyWithoutScheme mailAddress:(NSString **)mailAddressString queryString:(NSString **)queryString
{
    NSString *const bodySeparator = @"?";
    NSRange separatorRange = [bodyWithoutScheme rangeOfString:bodySeparator];
    NSString *parsedMailAddressString = @"";
    NSString *parsedQueryString = @"";
    if (separatorRange.location != NSNotFound)
    {
        parsedMailAddressString = [bodyWithoutScheme substringToIndex:separatorRange.location];
        parsedQueryString = [bodyWithoutScheme substringFromIndex:separatorRange.location + separatorRange.length];
    }
    if (mailAddressString)
    {
        *mailAddressString = parsedMailAddressString;
    }
    if (queryString)
    {
        *queryString = parsedQueryString;
    }
    return;
}

//components from query string
//e.g. queryString is 'subject=hello&body=world', return ['subject=hello', 'body=world']
+ (NSArray *)queryComponentsForQueryString:(NSString *)queryString
{
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    return queryComponents;
}

//parse single component, get key and value
//e.g. component is 'subject=hello', *key is 'subject', *value is 'hello'
+ (void)parseQueryComponent:(NSString *)component key:(NSString **)key value:(NSString **)value
{
    NSString *const keyValueSeparator = @"=";
    NSRange separatorRange = [component rangeOfString:keyValueSeparator];
    NSString *parsedKeyString = @"";
    NSString *parsedValueString = @"";
    if (separatorRange.location != NSNotFound)
    {
        parsedKeyString = [component substringToIndex:separatorRange.location];
        parsedValueString = [component substringFromIndex:separatorRange.location + separatorRange.length];
    }
    if (key)
    {
        *key = parsedKeyString;
    }
    if (value)
    {
        *value = parsedValueString;
    }
    return;
}

//parse combined mail string
//e.g. combinedMailString is 'alice@example.com,bob@example.com', return ['alice@example.com','bob@example.com']
+ (NSArray<NSString *> *)mailAddressesFromCombinedMailString:(NSString *)combinedMailString
{
    NSArray *mailAddresses = [combinedMailString componentsSeparatedByString:@","];
    return mailAddresses;
}

@end
