//
//  NSMutableArray+Shuffling.h
//  EmotionExperiment
//
//  Created by Hai Le on 2/17/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
