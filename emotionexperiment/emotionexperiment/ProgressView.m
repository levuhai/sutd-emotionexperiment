//
//  ProgressView.m
//  emotionexperiment
//
//  Created by Hai Le on 2/23/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.maxValue = 100;
        self.value = 0;
        _percentage = 0;
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)setValue:(float)value {
    _value = value;
    _percentage = _value/_maxValue;
    
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Fill in background Color
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context, 1,1,1,1);
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
    // Get the graphics context that we are currently executing under
    NSGraphicsContext* gc = [NSGraphicsContext currentContext];
    
    // Save the current graphics context settings
    [gc saveGraphicsState];
    
    CGFloat height = dirtyRect.size.height;
    CGFloat width = dirtyRect.size.width;
    
    // Draw Progess
    [[NSColor colorWithRed:39.0/255.0 green:174/255.0 blue:96/255.0 alpha:1] setStroke];
    NSBezierPath* progressPath = [NSBezierPath bezierPath];
    progressPath.lineWidth = 5;
    [progressPath moveToPoint:NSMakePoint(0,height)];
    [progressPath lineToPoint:NSMakePoint(_percentage*width,height)];
    //NSLog(@"%f %f %f",_value,_maxValue,_percentage);
    [progressPath stroke];
    
    // Restore the context to what it was before we messed with it
    [gc restoreGraphicsState];
}

@end
