//
//  PreferencesController.h
//  EdenGraph
//
//  Created by Chad Armstrong on 9/1/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kGraphColorKey		@"Graph Color"
#define kAxesColorKey		@"Axes Color"
#define kBackgroundColorKey	@"Background Color"
#define kGridColorKey		@"Grid Color"
#define kPrecisionSliderKey	@"Precision"
#define kPreferencesUpdatedNotification @"PreferencesUpdatedNotification"

@interface PreferencesController : NSWindowController 
{
    IBOutlet NSColorWell	*graphColorWell;
    IBOutlet NSColorWell	*axesColorWell;
    IBOutlet NSColorWell	*backgroundColorWell;
    IBOutlet NSColorWell	*gridColorWell;
    IBOutlet NSSlider		*precisionSlider;
	
	NSUserDefaults			*prefs;
}

- (void) prefWindowClosed: (NSNotification *) aNotification;
- (void) loadSettings;

- (IBAction) setAxesColor:(id)sender;
- (IBAction) setBGColor:(id)sender;
- (IBAction) setGraphColor:(id)sender;
- (IBAction) setGridColor:(id)sender;
- (IBAction) setPrecision: (id) sender;
- (void) sendPreferencesUpdatedNotification: (NSString *) key;

@end
