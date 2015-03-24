//
//  MouseEventView.h
//  emotionexperiment
//
//  Created by Hai Le on 2/18/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Delegate method
@protocol MouseEventViewDelegate
- (void)doubleClick:(NSEvent *)event;
@end

@interface MouseEventView : NSView

@property (nonatomic, strong) IBOutlet id delegate;

@end
