//
//  ProxyInputController.m
//  EmojiInput
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

#import "ProxyInputController.h"
#import "EmojiInput-Swift.h"

@interface ProxyInputController ()

@property (readonly, nonatomic) EmojiInputController *inputController;

@end

@implementation ProxyInputController

- (id)initWithServer:(IMKServer *)inServer delegate:(id)inDelegate client:(id)inClient {
    self = [super initWithServer:inServer delegate:inDelegate client:inClient];
    if (self) {
        _inputController = [[EmojiInputController alloc] initWithServer:inServer delegate:inDelegate client:inClient];
    }
    return self;
}

- (NSMenu *)menu {
    return self.inputController.menu;
}

#pragma mark IMKStateSetting protocol methods

- (void)activateServer:(id)inClient {
    [self.inputController activateServer:inClient];
}

- (void)deactivateServer:(id)inClient {
    [self.inputController deactivateServer:inClient];
}

- (void)commitComposition:(id)inClient {
    [self.inputController commitComposition:inClient];
}

- (BOOL)inputText:(NSString *)string client:(id)sender {
    return [self.inputController inputText:string client:sender];
}

- (BOOL)didCommandBySelector:(SEL)aSelector client:(id)sender {
    return [self.inputController didCommandBySelector:aSelector client:sender];
}

@end
