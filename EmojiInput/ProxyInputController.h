//
//  ProxyInputController.h
//  EmojiInput
//
//  Created by Fang-Pen Lin on 12/22/15.
//  Copyright © 2015 VictorLin. All rights reserved.
//

#import <InputMethodKit/InputMethodKit.h>

// I have no idea how to use a Swift class as the controller, it's not working when I tried,
// so this class is a proxy class for bypassing all event calls to the Swift one
@interface ProxyInputController : IMKInputController

@end
