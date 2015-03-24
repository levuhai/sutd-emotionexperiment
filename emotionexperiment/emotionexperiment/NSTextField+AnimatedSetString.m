//
//  NSTextField+AnimatedSetString.m
//  EmotionTracking
//
//  Created by Hai Le on 23/7/14.
//  Copyright (c) 2014 Earthling Studio. All rights reserved.
//

#import "NSTextField+AnimatedSetString.h"
#import <QuartzCore/QuartzCore.h>

@implementation NSTextField (AnimatedSetString)

- (void) setAnimatedStringValue:(NSString *)aString
{
    if ([[self stringValue] isEqual: aString])
    {
        return;
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [context setDuration: 0.5];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [self.animator setAlphaValue: 0.0];
    }
                        completionHandler:^{
                            [self setStringValue: aString];
                            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                                [context setDuration: 0.5];
                                [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
                                [self.animator setAlphaValue: 1.0];
                            } completionHandler: ^{}];
                        }];
}

@end
