//
//  BaseView.h
//  emotionexperiment
//
//  Created by Hai Le on 2/18/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import "AppService.h"
#import "NSView+NibLoading.h"
#import "MouseEventView.h"
#import "ProgressView.h"

enum {
    kBaselineStart = 90,
    kBaselineEnd,
    kTrackName,
    kTrackStart,
    kTrackEnd
};
typedef NSUInteger EEState;

@interface BaseView : NSViewController <AVAudioPlayerDelegate,MouseEventViewDelegate> {
    NSTimer *_timer;
    double _maxTime;
    double _currentTime;
    
    BOOL _subTextBlink;
    BOOL _doubleTapEnabled;
    
    AVAudioPlayer *_player;
    NSDictionary* _screenData;
}

@property (strong) IBOutlet NSTextField *mainText;
@property (strong) IBOutlet NSTextField *subText;
@property (strong) IBOutlet NSTextField *timeText;
@property (strong) IBOutlet ProgressView *progressbar;
@property (strong) IBOutlet NSSlider *rating;

@end
