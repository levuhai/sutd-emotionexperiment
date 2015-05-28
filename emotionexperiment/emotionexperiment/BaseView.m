//
//  BaseView.m
//  emotionexperiment
//
//  Created by Hai Le on 2/18/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "BaseView.h"


@implementation BaseView

//- (void)viewWillMoveToSuperview:(NSView *)newSuperview {
//    [_mainText setStringValue:@""];
//    [_subText setStringValue:@""];
//}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.mainText setStringValue:@""];
    [self.subText setStringValue:@""];
    
    AppService* as = [AppService sharedInstance];
    _screenData = as.screenData[as.currentScreenIndex];
    
    [self.progressbar setHidden:YES];
    _doubleTapEnabled = NO;
    
    // SETUP TEXT
    // Font size
    CGFloat fontSize;
    
    // Main text
    if (_screenData[CMainText]) {
        [self.mainText setStringValue:_screenData[CMainText][CText]];
        fontSize = [_screenData[CMainText][CFontSize] floatValue];
        [self.mainText setFont:[NSFont systemFontOfSize:fontSize]];
    }
    
    // Sub text
    if (_screenData[CSubText]) {
        [self.subText setAnimatedStringValue:_screenData[CSubText][CText]];
        fontSize = [_screenData[CSubText][CFontSize] floatValue];
        [self.subText setFont:[NSFont systemFontOfSize:fontSize]];
        
        _subTextBlink = [_screenData[CSubText][CBlink] boolValue];
    } else {
        _subTextBlink = NO;
    }
    
    // SWITCH PROGRESS TYPE
    // Setup NSTimer if the screen progress type is Time
    NSString* progressType = _screenData[CProgressType];
    if([progressType isEqual:@"Time"]) {
        [self _setupTimeScreen];
    } else if([progressType isEqual:@"Break"]) {
        NSLog(@"Break");
        [self _setupTimeScreen];
        _doubleTapEnabled = YES;
    }
    else if([progressType isEqual:@"Baseline"]) {
         // Send marker start baseline
        [self _sendMarker:@"Baseline Start"];
        [self _setupTimeScreen];
        
    } else if([progressType isEqual:@"Track"]) {
        [self _sendMarker:@"Track Start"];
        [self _setupTrackScreen];
        
    } else if ([progressType isEqual:@"Double Tap"]) {
        _doubleTapEnabled = YES;
    }
    
    // Check if should hide progress bar
    BOOL progressHidden = [_screenData[@"Progress Hidden"] boolValue];
    [self.progressbar setHidden:progressHidden];
    
    // NSVIEW BG COLOR
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:[[NSColor whiteColor] CGColor]]; //RGB plus Alpha Channel
    [self.view setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self.view setLayer:viewLayer];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self _sendMarker:@"Track End"];
    [[AppService sharedInstance] newTrackData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNextScreenNotification object:self];
}

#pragma mark - Private
//
- (void)_setupTimeScreen {
    _maxTime = [_screenData[CInterval] intValue];
    [self.progressbar setMaxValue:_maxTime];
    [self.progressbar setHidden:NO];
    _currentTime = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1/50.0)
                                              target:self
                                            selector:@selector(progress)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)_setupTrackScreen {
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[AppService sharedInstance] nextTrack] error:nil];
    _player.delegate = self;
    [self _sendMarker:@"Track Name" value:[[_player.url path] lastPathComponent]];
    _maxTime = _player.duration;
    [self.progressbar setMaxValue:_maxTime];
    [self.progressbar setHidden:NO];
    _currentTime = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1/50.0)
                                              target:self
                                            selector:@selector(progressTrack)
                                            userInfo:nil
                                             repeats:YES];
    
    [_player prepareToPlay];
    [_player play];
}

// Display progress bar
- (void)progress {
    if (_subTextBlink) {
        [self.subText setAlphaValue:cos(_currentTime*3)];
    }
    
    _currentTime += 1/50.0;
    [self.progressbar setValue:_currentTime];
    if (_currentTime >= _maxTime) {
        if ([_screenData[CProgressType] isEqualToString:@"Baseline"]) {
            // Send marker end baseline
            [self _sendMarker:@"Baseline End"];
        }
        [_timer invalidate];
        [self.progressbar setHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNextScreenNotification object:self];
    }
}

// Display progress bar
- (void)progressTrack {
    if (_subTextBlink) {
        [self.subText setAlphaValue:cos(_currentTime*3)];
    }
    
    _currentTime = _player.currentTime;
    [self.progressbar setValue:_currentTime];
}

- (void)doubleClick:(NSEvent *)event {
    if (_doubleTapEnabled) {
        if ([_screenData[CType] isEqualToString:@"Rating"]) {
            NSNumber *value = [NSNumber numberWithFloat:self.rating.floatValue];
            [self _sendMarker:_screenData[CMainText][@"Short"] value:value];
        }
        if ([_screenData[CType] isEqualToString:@"Break"]) {
            [_timer invalidate];
            [self.progressbar setHidden:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNextScreenNotification object:self];
    }
}

// Send marker
- (void)_sendMarker:(NSString*)message value:(id)value {
    [[AppService sharedInstance] addMarkerToTrackData:message value:value];
}

- (void)_sendMarker:(NSString*)message {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd HH:mm:ss.SSSS";
    [formatter setDateFormat:formatString];
    
    NSString* date = [formatter stringFromDate:[NSDate date]];
    
    [[AppService sharedInstance] addMarkerToTrackData:message value:date];
}


@end
