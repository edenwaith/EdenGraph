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
	
//	[_sharedWindowController window];	// load the nib
//	// Do any preperations here
//	[_sharedWindowController loadSettings];
//	[_sharedWindowController showWindow: NULL];
	
	
	
	return _sharedWindowController;
}

- (id) init
{
	self = [super initWithWindowNibName: @"Preferences"];

	return self;
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

- (IBAction) showWindow: (id) sender 
{
	if (![[self window] isVisible])
		[[self window] center];
	
	[super showWindow:sender];
}

// similar to awakeFromNib or windowControllerDidLoadNib:
- (void) windowDidLoad
{
	[super windowDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(prefWindowClosed:)
												 name:NSWindowWillCloseNotification
											   object: [self window]];

}

- (void) hideWindow
{
	[[self window] orderOut:self];
}

//- (void) awakeFromNib
//{
//	[[self window] center];
//
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(prefWindowClosed:)
//												 name:NSWindowWillCloseNotification
//											   object: [_sharedWindowController window]];
//}

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

#pragma mark -

- (IBAction) setAxesColor:(id)sender
{}

- (IBAction) setBGColor:(id)sender
{}

- (IBAction) setGraphColor:(id)sender
{}

- (IBAction) setGridColor:(id)sender
{}

- (IBAction) setPrecision: (id) sender
{}

@end
