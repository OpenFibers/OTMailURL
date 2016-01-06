//
//  AppDelegate.m
//  OTMailURLDemo
//
//  Created by openthread on 1/6/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import "AppDelegate.h"
#import "OTMailURL.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    OTMailURL *mailURL = [[OTMailURL alloc] initWithString:
                          @"mailto:\
                          alice@example.com,bob@example.com%2ceve%40example.com?\
                          to=bob1@example.com,bob2@example.com&\
                          to=bob2%40example.com%2cbob3%40example.com&\
                          cc=bob@example.com&\
                          bcc=eve@example.com&\
                          body=bodytext&\
                          subject=hello"];
    NSLog(@"to: %@\ncc: %@\nbcc: %@\nsubject: %@\nbody %@\n",
          mailURL.toMailAddresses,
          mailURL.ccMailAddresses,
          mailURL.bccMailAddresses,
          mailURL.subject,
          mailURL.body);
    
    return YES;
}

@end
