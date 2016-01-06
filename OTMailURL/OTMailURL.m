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

#pragma mark - Readonly properties

- (NSArray<NSString *> *)toMailAddresses
{
    return [NSArray arrayWithArray:self.parsingToMailAddresses];
}

- (NSArray<NSString *> *)ccMailAddresses
{
    return [NSArray arrayWithArray:self.parsingCcMailAddresses];
}

- (NSArray<NSString *> *)bccMailAddresses
{
    return [NSArray arrayWithArray:self.parsingBccMailAddresses];
}

#pragma mark - Parse methods

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

    mailAddressBodyString = [[self class] urlDecode:mailAddressBodyString];
    [self addToAddressesByString:mailAddressBodyString];

    NSArray *components = [[self class] queryComponentsForQueryString:mailQueryString];
    for (NSString *singleComponent in components)
    {
        NSString *key;
        NSString *value;
        [[self class] parseQueryComponent:singleComponent key:&key value:&value];
        value = [[self class] urlDecode:value];

        if ([[key lowercaseString] isEqualToString:@"to"])
        {
            [self addToAddressesByString:value];
        }
        else if ([[key lowercaseString] isEqualToString:@"cc"])
        {
            [self addCcAddressesByString:value];
        }
        else if ([[key lowercaseString] isEqualToString:@"bcc"])
        {
            [self addBccAddressesByString:value];
        }
        else if ([[key lowercaseString] isEqualToString:@"subject"])
        {
            [self setSubjectByValue:value];
        }
        else if ([[key lowercaseString] isEqualToString:@"body"])
        {
            [self setBodyByValue:value];
        }
    }
}

- (void)addToAddressesByString:(NSString *)toMailAddress
{
    NSArray *mailAddresses = [[self class] mailAddressesFromCombinedMailString:toMailAddress];
    for (NSString *eachAddress in mailAddresses)
    {
        if (![self.parsingToMailAddresses containsObject:eachAddress])
        {
            [self.parsingToMailAddresses addObject:eachAddress];
        }
    }
}

- (void)addCcAddressesByString:(NSString *)ccMailAddress
{
    NSArray *mailAddresses = [[self class] mailAddressesFromCombinedMailString:ccMailAddress];
    for (NSString *eachAddress in mailAddresses)
    {
        if (![self.parsingCcMailAddresses containsObject:eachAddress])
        {
            [self.parsingCcMailAddresses addObject:eachAddress];
        }
    }
}

- (void)addBccAddressesByString:(NSString *)bccMailAddress
{
    NSArray *mailAddresses = [[self class] mailAddressesFromCombinedMailString:bccMailAddress];
    for (NSString *eachAddress in mailAddresses)
    {
        if (![self.parsingBccMailAddresses containsObject:eachAddress])
        {
            [self.parsingBccMailAddresses addObject:eachAddress];
        }
    }
}

- (void)setSubjectByValue:(NSString *)value
{
    _subject = value;
}

- (void)setBodyByValue:(NSString *)value
{
    _body = value;
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

//parse combined mail string into array, invalid address won't be added into return array
//e.g. combinedMailString is 'alice@example.com,bob@example.com', return ['alice@example.com','bob@example.com']
+ (NSArray<NSString *> *)mailAddressesFromCombinedMailString:(NSString *)combinedMailString
{
    NSArray *mailAddresses = [combinedMailString componentsSeparatedByString:@","];
    NSMutableArray *validMailAddresses = [NSMutableArray array];
    for (NSString *eachAddress in mailAddresses)
    {
        if ([self isValidEmailAddress:eachAddress])
        {
            [validMailAddresses addObject:[eachAddress lowercaseString]];
        }
    }
    return [NSArray arrayWithArray:validMailAddresses];
}

//decide whether string is a valid email address
+ (BOOL)isValidEmailAddress:(NSString *)emailAddressToDecide
{
    static NSPredicate *emailPredicate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9._-]+\\.[A-Za-z]{2,4}";
        NSString *emailRegex = stricterFilterString;
        emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    });
    return [emailPredicate evaluateWithObject:emailAddressToDecide];
}

//url decode
+ (NSString *)urlDecode:(NSString *)stringToDecode
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL,
                                                                                    (__bridge CFStringRef)stringToDecode,
                                                                                    (CFStringRef) @"");
}

@end
