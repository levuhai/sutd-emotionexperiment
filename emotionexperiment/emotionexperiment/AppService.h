//
//  AppService.h
//  EmotionExperiment
//
//  Created by Hai Le on 2/15/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "NSTextField+AnimatedSetString.h"
#import "NSMutableArray+Shuffling.h"

@interface AppService : NSObject {
    NSString *_rootFolder;
    NSString *_dataFolder;
    NSString *_tracksFolder;
    NSMutableArray *_trackURLs;
    NSMutableArray *_shuffledTrackURLs;
    
    int _currentTrackIndex;
    NSMutableArray *_recoredData;
    NSMutableDictionary* _tempDictionary;
}

@property (nonatomic) NSArray *screenData;
@property int currentScreenIndex;
+ (AppService *) sharedInstance;
- (NSURL*)nextTrack;
- (void)addMarkerToTrackData:(NSString*)name value:(id)val;
- (void)newTrackData;
- (void)saveTrackDatas;

@end
