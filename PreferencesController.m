//
//  PreferencesController.m
//  EdenGraph
//
//  Created by Chad Armstrong on 9/1/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import "PreferencesController.h"

static PreferencesController *_sharedWindowController = nil;

@implementation PreferencesController

+ (PreferencesController *) sharedWindowController
{
	if (_sharedWindowController == NULL)
	{
		_sharedWindowController = [[self alloc] initWithWindowNibName: [self nibName]];
	}
	
	[_sharedWindowController window];	// load the nib
	// Do any preperations here
//	[_sharedWindowController loadSettings];
	[_sharedWindowController showWindow: NULL];
//	[[NSApplication sharedApplication] runModalForWindow: [_sharedWindowController window]];
	
	// Need to also register when the window closes
	
	return NULL;
}

- (void) dealloc
{
	// Unregister the NSWindowWillCloseNotification
	[[NSNotificationCenter defaultCenter] removeObserver: self name: NSWindowWillCloseNotification object:  [_sharedWindowController window]];
	[super dealloc];
}

+ (NSString *) nibName
{
	return @"Preferences";
}

- (void) awakeFromNib
{
	[[self window] center];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(prefWindowClosed:)
												 name:NSWindowWillCloseNotification
											   object: [_sharedWindowController window]];
}

#pragma mark -

- (void) prefWindowClosed: (NSNotification *) aNotification
{
	
	[[NSUserDefaults standardUserDefaults] synchronize];	// Force the defaults to update
	
//	[[NSApplication sharedApplication] stopModal];
//	
//	[[NSApp delegate] preferencesClosed];
}

- (void) loadSettings
{
}

@end
