//
//  AppDelegate.h
//  Mojito
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MojitServer;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, nonatomic) MojitServer* mojitServer;

@end

