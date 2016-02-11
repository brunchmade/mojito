//
//  main.m
//  Foobar
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <InputMethodKit/InputMethodKit.h>
#import "OVInputSourceHelper.h"
#import "Mojito-Swift.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [Logging setupLogging];
        // register and enable the input source (along with all its input modes)
        if (argc > 1 && !strcmp(argv[1], "install")) {
            NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
            NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
            TISInputSourceRef inputSource = [OVInputSourceHelper inputSourceForInputSourceID:bundleID];
            
            if (!inputSource) {
                NSLog(@"Registering input source %@ at %@.", bundleID, [bundleURL absoluteString]);
                BOOL status = [OVInputSourceHelper registerInputSource:bundleURL];
                
                if (!status) {
                    NSLog(@"Fatal error: Cannot register input source %@ at %@.", bundleID, [bundleURL absoluteString]);
                    return -1;
                }
                
                inputSource = [OVInputSourceHelper inputSourceForInputSourceID:bundleID];
                if (!inputSource) {
                    NSLog(@"Fatal error: Cannot find input source %@ %@ after registration.", bundleID, [bundleURL absoluteString]);
                    return -1;
                }
            }
            
            if (inputSource && ![OVInputSourceHelper inputSourceEnabled:inputSource]) {
                NSLog(@"Enabling input source %@ at %@.", bundleID, [bundleURL absoluteString]);
                BOOL status = [OVInputSourceHelper enableInputSource:inputSource];
                
                if (!status != noErr) {
                    NSLog(@"Fatal error: Cannot enable input source %@.", bundleID);
                    return -1;
                }
            }
            return 0;
        }

        NSApplication *app = [NSApplication sharedApplication];
        id<NSApplicationDelegate> appDelegate;
        if ([RunningModeDetection runningMode] == RunningModeInputMethod) {
            appDelegate = [InputMethodAppDelegate new];
        } else {
            appDelegate = [ConfigAppDelegate new];
        }
        app.delegate = appDelegate;
        [app run];
    }
    return 0;
}
