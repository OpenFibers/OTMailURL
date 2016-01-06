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
    
    OTMailURL *mailURL = [[OTMailURL alloc] initWithString:@"mailto:?to=alice@example.com&cc=bob@example.com&body=bodytext&subject=hello"];
    NSLog(@"to: %@\ncc: %@\nbcc: %@\nsubject: %@\nbody %@\n",
          mailURL.toMailAddress,
          mailURL.ccMailAddress,
          mailURL.bccMailAddress,
          mailURL.subject,
          mailURL.body);
    
    return YES;
}

@end
