//
//  AppDelegate.m
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

#import "AppDelegate.h"
#import "Mojito-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString *connectionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"InputMethodConnectionName"];
    //DDLogInfo(@"Connection %@", connectionName);
    _mojitServer = [[MojitServer alloc] initWithName:connectionName bundleIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    //DDLogInfo(@"Initialized IMKServer %@", self.mojitServer);
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
