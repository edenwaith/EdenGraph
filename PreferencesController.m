//
//  PreferencesController.m
//  EdenGraph
//
//  Created by Chad Armstrong on 9/1/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

- (id) init
{
	if (self = [super initWithWindowNibName: @"Preferences"])
	{
	}

	return self;
}

- (void) dealloc
{
	// Unregister the NSWindowWillCloseNotification
	[[NSNotificationCenter defaultCenter] removeObserver: self name: NSWindowWillCloseNotification object:  [self window]];
	[super dealloc];
}

// This loads the settings faster than using windowDidLoad
- (void) awakeFromNib
{
	[self loadSettings];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(prefWindowClosed:)
												 name:NSWindowWillCloseNotification
											   object:[self window]];
}


#pragma mark -

- (void) prefWindowClosed: (NSNotification *) aNotification
{	
	[prefs synchronize];	// Force the defaults to update
}

- (void) loadSettings
{
	prefs = [NSUserDefaults standardUserDefaults];
    
	// Axes color
    if ([prefs objectForKey: kAxesColorKey] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: kAxesColorKey];
        [axesColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [axesColorWell setColor: [NSColor lightGrayColor]];
    }
    
	// Graph color
    if ([prefs objectForKey: kGraphColorKey] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: kGraphColorKey];
        [graphColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [graphColorWell setColor: [NSColor redColor]];
    }
    
	// Background color
    if ([prefs objectForKey: kBackgroundColorKey] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: kBackgroundColorKey];
        [backgroundColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [backgroundColorWell setColor: [NSColor whiteColor]];
    }
    
	// Grid color
    if ([prefs objectForKey: kGridColorKey] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: kGridColorKey];
        [gridColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [gridColorWell setColor: [NSColor colorWithCalibratedRed: 0.8 green: 1.0 blue: 1.0 alpha:1.0]];
    }
	
	// Precision slider
    if ([prefs floatForKey:kPrecisionSliderKey] != nil)
    {
        float precision = [prefs floatForKey: kPrecisionSliderKey];
		
        [precisionSlider setFloatValue: precision];
        
        if ([precisionSlider floatValue] < 0.1)
        {
            [precisionSlider setFloatValue: 0.1 + fabs([precisionSlider floatValue] - 0.1)];
        }
        else
        {
            [precisionSlider setFloatValue: 0.1 - fabs([precisionSlider floatValue] - 0.1)];
        }
    }
    else
    {
        [precisionSlider setFloatValue: 0.18f];
    }
}


#pragma mark - Setter Methods

- (IBAction) setAxesColor: (id) sender
{
//    [axesColor autorelease];
//    NSColor *axesColor = [[sender color] retain];
    
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: [sender color]];
    [prefs setObject:colorAsData forKey: kAxesColorKey];
	[prefs synchronize];
}

- (IBAction) setBGColor: (id) sender
{
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: [sender color]];
    [prefs setObject:colorAsData forKey: kBackgroundColorKey];
	[prefs synchronize];
}

- (IBAction) setGraphColor: (id) sender
{
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: [sender color]];
    [prefs setObject:colorAsData forKey: kGraphColorKey];
	[prefs synchronize];
}

- (IBAction) setGridColor: (id) sender
{
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: [sender color]];
    [prefs setObject:colorAsData forKey: kGridColorKey];
	[prefs synchronize];
}

- (IBAction) setPrecision: (id) sender
{
	float precison = 0.1;
	
    if ([precisionSlider floatValue] < 0.1)
    {
        precison = 0.1 + fabs([precisionSlider floatValue] - 0.1);
    }
    else
    {
        precison = 0.1 - fabs([precisionSlider floatValue] - 0.1);
    }
    
    if (precison <= 0.001)
    {
        precison = 0.001;
    }
    
    [prefs setFloat: precison forKey: kPrecisionSliderKey];
	[prefs synchronize];
}

@end
