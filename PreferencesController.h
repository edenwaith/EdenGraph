//
//  PreferencesController.h
//  EdenGraph
//
//  Created by Chad Armstrong on 9/1/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSWindowController 
{
    IBOutlet NSColorWell	*graphColorWell;
    IBOutlet NSColorWell	*axesColorWell;
    IBOutlet NSColorWell	*backgroundColorWell;
    IBOutlet NSColorWell	*gridColorWell;
    IBOutlet NSSlider		*precisionSlider;
    IBOutlet NSSlider		*nudgeSlider;
}

// TODO: Implement these methods
//- (void) setAxesColor:(id)sender;
//- (void) setBGColor:(id)sender;
//- (void) setGraphColor:(id)sender;
//- (void) setGridColor:(id)sender;
//- (IBAction) setPrecision: (id) sender;
//- (IBAction) setNudge: (id) sender;

@end
