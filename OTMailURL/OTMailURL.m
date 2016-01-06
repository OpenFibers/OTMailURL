//
//  OTMailURL.m
//  OTMailURLDemo
//
//  Created by openthread on 1/6/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import "OTMailURL.h"

@interface OTMailURL ()
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
    NSString *mailAndQueryString = [self.originalURLString substringFromIndex:@"mailto:".length];
    
}

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

@end
