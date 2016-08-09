//
//  AppDelegate.m
//  emotionexperiment
//
//  Created by Hai Le on 2/18/15.
//  Copyright (c) 2015 Hai Le. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseView.h"

@interface AppDelegate () {
    NSArray *_screens;
    int _currentScreenIndex;
}


@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    //[self.window toggleFullScreen:nil];
    // Load screen data
    _screens = [[AppService sharedInstance] screenData];
    
    // Handle notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nextScreenNotification:)
                                                 name:kNextScreenNotification
                                               object:nil];
    
    // Transition to 1st screen
    [self _transitionToNextViewController];
    
    _currentScreenIndex = [AppService sharedInstance].currentScreenIndex;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [NSApp terminate:self];
}

- (void)windowWillClose:(NSNotification *)aNotification {
    [NSApp terminate:self];
}

#pragma mark - Notification
- (void)nextScreenNotification:(NSNotification*)notif {
    AppService *as = [AppService sharedInstance];
    _currentScreenIndex++;
    as.currentScreenIndex = _currentScreenIndex;
    if (_currentScreenIndex >= _screens.count) {
        [as saveTrackDatas];
        [[NSApplication sharedApplication] terminate:self];
    } else {
        [self _transitionToNextViewController];
    }
}

#pragma mark - Private
- (void)_transitionToNextViewController {
    // Add new view
    BaseView* baseController;
    NSDictionary* currentViewData = _screens[_currentScreenIndex];
    NSString* screenType = currentViewData[CType];
    
    baseController = [[BaseView alloc] initWithNibName:screenType bundle:nil];
    [self transitionToView:baseController.view];
}

- (void)_addEdgeConstraint:(NSLayoutAttribute)edge superview:(NSView *)superview subview:(NSView *)subview {
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

- (void)transitionToView:(NSView *)newSubview
{
    NSView *mainView = [[self window] contentView];
    // use a for loop if you want it to run on older OS's
    [[mainView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //    // fade out
    //    [[mainView animator] setAlphaValue:0.0f];
    //
    //    // make the sub view the same size as our super view
    [newSubview setFrame:[mainView bounds]];
    //    // *push* our new sub view
    //    [mainView addSubview:newSubview];
    //
    [newSubview setTranslatesAutoresizingMaskIntoConstraints:NO];
    //
    //    [mainView addSubview:newSubview];
    [self _prepareViews];
    [[mainView animator] addSubview:newSubview];
    
    [[self class] addEdgeConstraint:NSLayoutAttributeLeft
                          superview:mainView
                            subview:newSubview];
    [[self class] addEdgeConstraint:NSLayoutAttributeRight
                          superview:mainView
                            subview:newSubview];
    [[self class] addEdgeConstraint:NSLayoutAttributeTop
                          superview:mainView
                            subview:newSubview];
    [[self class] addEdgeConstraint:NSLayoutAttributeBottom
                          superview:mainView
                            subview:newSubview];
    
    // fade in
    [[mainView animator] setAlphaValue:1.0f];
}

- (void)_prepareViews
{ // this method will make sure we can animate in the switchSubViewsMethod
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionPush];
    [transition setSubtype:kCATransitionFromRight];
    NSView *mainView = [[self window] contentView];
    [mainView setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"subviews"]];
    [mainView setWantsLayer:YES];
}

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(NSView *)superview subview:(NSView *)subview {
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
                                                          attribute:edge
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:edge
                                                         multiplier:1
                                                           constant:0]];
}

@end
