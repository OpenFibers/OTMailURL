//
//  OTMailURL.h
//  OTMailURLDemo
//
//  Created by openthread on 1/6/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTMailURL : NSObject

+ (instancetype)URLWithString:(NSString *)URLString;

- (instancetype)initWithString:(NSString *)URLString;

@property (nonatomic, readonly) NSString *originalURLString;
@property (nonatomic, readonly) NSArray<NSString *> *toMailAddresses;
@property (nonatomic, readonly) NSArray<NSString *> *ccMailAddresses;
@property (nonatomic, readonly) NSArray<NSString *> *bccMailAddresses;
@property (nonatomic, readonly) NSString *subject;
@property (nonatomic, readonly) NSString *body;

@end
