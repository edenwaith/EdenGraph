//
//  ToolbarDelegateCategory.m
//  EdenGraph
//
//  Created by admin on Sat 7 September 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//
//  Tutorial on creating tool bars is at
//  http://www.macdevcenter.com/pub/a/mac/2002/03/15/cocoa.html

#import "ToolbarDelegateCategory.h"

@implementation EGView (ToolbarDelegateCategory)

// =========================================================================
// (void) setupToolbar
// Keep this in the ToolbarDelegateCategory.m file so the toolbar items
// will not be faded out.  When this function was in EGView.m, I had 
// that problem with the toolbar items not being available
// =========================================================================
- (void) setupToolbar
{
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
    [toolbar autorelease];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [Window setToolbar:toolbar]; // Window is an IBOutlet defined in EGView.h
}

// =========================================================================
// (NSToolbarItem *) toolbar: (NSToolbar *) toolbar ...
// =========================================================================
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
    itemForItemIdentifier:(NSString *)itemIdentifier
    willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if ( [itemIdentifier isEqualToString:@"ZoomIn"] ) 
    {
	// Configuration code for "ZoomIN"
        [item setLabel:@"Zoom In"];
        [item setToolTip: @"Zoom In"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"ZoomIn"]];
		[item setTarget:self];
		[item setAction:@selector(zoomIn:)];
    } 
    else if ( [itemIdentifier isEqualToString:@"ZoomOut"] ) 
    {
	// Configuration code for "ZoomOut"
        [item setLabel:@"Zoom Out"];
        [item setToolTip: @"Zoom Out"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"ZoomOut"]];
		[item setTarget:self];
		[item setAction:@selector(zoomOut:)];
    }
    else if ( [itemIdentifier isEqualToString:@"Save"] ) 
    {
	// Configuration code for "Save"
        [item setLabel:@"Save"];
        [item setToolTip: @"Save"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Floppy.png"]];
		[item setTarget: self];
		[item setAction:@selector(saveDocumentTo:)];
    }
    else if ( [itemIdentifier isEqualToString:@"Clear"] ) 
    {
	// Configuration code for "Save"
        [item setLabel:@"Clear"];
        [item setToolTip: @"Clear Graph"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Clear"]];
		[item setTarget:self];
		[item setAction:@selector(clearGraph:)];
    }
    else if ( [itemIdentifier isEqualToString:@"Origin"] ) 
    {
	// Configuration code for "Return to Origin"
        [item setLabel:@"Origin"];
        [item setToolTip: @"Return to Origin"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Origin.png"]];
		[item setTarget:self];
		[item setAction:@selector(returnToOrigin:)];
    }
    // http://www.opendarwin.org/cgi-bin/cvsweb.cgi/proj/dp-cocoa/src/DarwinPorts/DPToolbarDelegate.m?annotate=1.1&sortby=date
    else if ( [itemIdentifier isEqualToString: NSToolbarPrintItemIdentifier])
    {
		[item setAction:@selector(print:)];
    }
    else if ( [itemIdentifier isEqualToString:@"Quit"] )
    {
        // Configuration code for "Quit"
        [item setLabel:@"Quit"];
        [item setToolTip: @"Quit EdenGraph"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Stop-red"]];
		[item setTarget:self];
		[item setAction:@selector(off:)];
    }
     
    return [item autorelease];
}


// This was added so the print button would finally work
// Version: 2. February 2003 18:09
// Created: 2. February 2003 18:09
- (void) toolbarWillAddItem: (NSNotification *) notif
{
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey: @"item"];
    
    if ([[addedItem itemIdentifier] isEqual: NSToolbarPrintItemIdentifier])
    {
        [addedItem setToolTip: @"Print graph"];
        [addedItem setAction:@selector(print:)];
    }

}


- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
				     NSToolbarSpaceItemIdentifier,
				     NSToolbarFlexibleSpaceItemIdentifier,
				     NSToolbarCustomizeToolbarItemIdentifier,
                                     @"ZoomIn", @"ZoomOut", @"Save" , @"Clear", 
                                     @"Origin", NSToolbarPrintItemIdentifier, 
                                     @"Quit", nil];
}


- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
    return [NSArray arrayWithObjects: @"ZoomIn", @"ZoomOut", @"Save", @"Clear", 
                                      @"Origin",
                                      NSToolbarFlexibleSpaceItemIdentifier,
                                      NSToolbarPrintItemIdentifier,
                                      NSToolbarSeparatorItemIdentifier,
                                      @"Quit", nil];
}



- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    if ( [theItem action] == @selector(zoomIn:) )
    {
        return YES;
    }
    else if ( [theItem action] == @selector(zoomOut:) )
    {
        return YES;
    }
    else if ( [theItem action] == @selector(saveDocumentTo:) )
    {
        return YES;
    }
    else if ( [theItem action] == @selector(clearGraph:) )
    {
        return YES;
    }
    else if ( [theItem action] == @selector(returnToOrigin:) )
    {
        return YES;
    }  
    else if ( [theItem action] == @selector(print:))
    {
        return YES;
    }
    else if ( [theItem action] == @selector(off:) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
