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
@property (nonatomic, strong) NSArray<NSString *> *toMailAddresses;
@property (nonatomic, strong) NSArray<NSString *> *ccMailAddresses;
@property (nonatomic, strong) NSArray<NSString *> *bccMailAddresses;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *body;

@end
