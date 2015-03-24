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
        _maxTime = [_screenData[CInterval] intValue];
        [self.progressbar setMaxValue:_maxTime];
        [self.progressbar setHidden:NO];
        _currentTime = 0;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:(1/50.0)
                                                  target:self
                                                selector:@selector(progress)
                                                userInfo:nil
                                                 repeats:YES];
    } else if([progressType isEqual:@"Track"]) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[AppService sharedInstance] nextTrack] error:nil];
        _player.delegate = self;
        
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
        
    } else if ([_screenData[CProgressType] isEqual:@"Double Tap"]) {
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNextScreenNotification object:self];
}

// Display progress bar
- (void)progress {
    if (_subTextBlink) {
        [self.subText setAlphaValue:cos(_currentTime*3)];
    }
    
    _currentTime += 1/50.0;
    [self.progressbar setValue:_currentTime];
    if (_currentTime >= _maxTime) {
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kNextScreenNotification object:self];
    }
}


@end
