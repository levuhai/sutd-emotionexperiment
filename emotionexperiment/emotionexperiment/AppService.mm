//
//  AppService.m
//  EmotionExperiment
//
//  Created by Hai Le on 2/15/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "AppService.h"

static AppService *sharedInstance = nil;

@implementation AppService


+ (AppService*) sharedInstance {
    @synchronized(self)
    {
        if (sharedInstance == nil) {
            sharedInstance = [[AppService alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance; // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (AppService*)init
{
    self = [super init];
    if (self) {
        // Check folders in document
        [self _checkDocumentFolder];
        
        // Check screen data in document
        [self _checkScreenDataFile];
        
        // Get track list
        [self _getTrackList];
        _currentScreenIndex = 0;
        _recoredData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)_checkDocumentFolder {
    // Check if Tracks folder is exist and creat new folder
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // Create "Emotion Experiment" folder if not exist
    _rootFolder = [documentPath stringByAppendingPathComponent:@"/Emotion Experiment"];
    NSFileManager *manager = [NSFileManager defaultManager] ;
    if (![manager createDirectoryAtPath:_rootFolder
            withIntermediateDirectories:NO
                             attributes:nil
                                  error:nil]){
    }

    
    // Create "Tracks" folder if not exist
    _tracksFolder = [_rootFolder stringByAppendingPathComponent:@"/Tracks"];
    if (![manager createDirectoryAtPath:_tracksFolder
            withIntermediateDirectories:NO
                             attributes:nil
                                  error:nil]){
    }
    
    // Create "Data" folder if not exist
    _dataFolder = [_rootFolder stringByAppendingPathComponent:@"/Data"];
    if (![manager createDirectoryAtPath:_dataFolder
            withIntermediateDirectories:NO
                             attributes:nil
                                  error:nil]){
    }
}

- (void)_checkScreenDataFile {
    // Read data from plist file
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *screenFilePath = [_rootFolder stringByAppendingPathComponent:@"/Screens.plist"];
    if ([manager fileExistsAtPath:screenFilePath]) {
        self.screenData = [NSArray arrayWithContentsOfFile:screenFilePath];
    } else {
        // Load screen data
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Screens" ofType:@"plist"];
        self.screenData = [NSArray arrayWithContentsOfFile:path];
    }
}

- (void)_getTrackList {
    _currentTrackIndex = 0;
    
    _trackURLs = [[NSMutableArray alloc] init];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:_tracksFolder];
    
    NSString *file;
    NSString *fullFilePath;
    while (file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString: @"mp3"]||[[file pathExtension] isEqualToString: @"wav"]) {
            // process the document
            fullFilePath = [_tracksFolder stringByAppendingPathComponent:file];
            [_trackURLs addObject:[NSURL fileURLWithPath:fullFilePath]];
        }
    }
    //NSLog(@"%@",_trackURLs);
    
    _shuffledTrackURLs = [[NSMutableArray alloc] initWithArray:_trackURLs];
    [_shuffledTrackURLs shuffle];
    NSLog(@"%@",_shuffledTrackURLs);
}

- (NSURL *)nextTrack {
    NSURL *url = _shuffledTrackURLs[_currentTrackIndex];
    NSLog(@"Track Index %d",_currentTrackIndex);
    _currentTrackIndex++;
    return url;
}

- (void)addMarkerToTrackData:(NSString*)name value:(id)val {
    if (_tempDictionary == nil)
        _tempDictionary = [NSMutableDictionary new];
    _tempDictionary[name] = val;
}

- (void)newTrackData {
    if (_tempDictionary != nil) {
        [_recoredData addObject:[NSDictionary dictionaryWithDictionary:_tempDictionary]];
        NSLog(@"%@",_tempDictionary);
        //_tempDictionary = nil;
        _tempDictionary = [NSMutableDictionary new];
    } else {
        _tempDictionary = [NSMutableDictionary new];
    }
}

- (void)saveTrackDatas {
    NSLog(@"%@",_recoredData);
    [self _writeToPlist:@"recorded.plist" withData:_recoredData];
}

- (void)_writeToPlist: (NSString*)fileName withData:(NSMutableArray *)data
{
    NSString *finalPath = [_dataFolder stringByAppendingPathComponent:fileName];
    
    [data writeToFile:finalPath atomically: YES];
    /* This would change the firmware version in the plist to 1.1.1 by initing the NSDictionary with the plist, then changing the value of the string in the key "ProductVersion" to what you specified */
}

@end
