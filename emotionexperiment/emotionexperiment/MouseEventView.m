//
//  MouseEventView.m
//  emotionexperiment
//
//  Created by Hai Le on 2/18/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "MouseEventView.h"

@implementation MouseEventView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (theEvent.clickCount == 2) {
        [_delegate doubleClick:theEvent];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

@end
