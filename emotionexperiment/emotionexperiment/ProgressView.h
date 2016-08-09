//
//  ProgressView.h
//  emotionexperiment
//
//  Created by Hai Le on 2/23/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressView : NSView {
    float _percentage;
}

@property (nonatomic) float value;
@property (nonatomic) float maxValue;

@end
