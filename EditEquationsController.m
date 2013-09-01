//
//  EditEquationsController.m
//  EdenGraph
//
//  Created by Chad Armstrong on 8/23/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import "EditEquationsController.h"


@implementation EditEquationsController

- (id)initWithWindow:(NSWindow *)awindow
{
    self = [super initWithWindow:awindow];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
	if (equationsFile != nil)
	{
		[equationsFile release], equationsFile = nil;
	}
	
	if (equationsList != nil)
	{
		[equationsList release], equationsList = nil;
	}
	
    [super dealloc];
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//}
//
//- (void) loadEquations
//{
	if (equationsFile != nil)
	{
		[equationsFile release], equationsFile = nil;
	}
	
	if (equationsList != nil)
	{
		[equationsList release], equationsList = nil;
	}
	
	equationsFile = [[NSString alloc] initWithString: [@"~/Library/Preferences/EdenGraph.plist" stringByExpandingTildeInPath]];
    
    equationsList = [[NSMutableArray alloc] initWithContentsOfFile:equationsFile];
	
	NSMenu *mainMenu = [NSApp mainMenu];
	equationsMenu = [[mainMenu itemWithTitle:NSLocalizedString(@"Equations", @"Equations")] submenu];
	
	// Reveal the scroll bar if there are a lot (generally more than 10) of saved equations
	if ([equationsList count] > 0)
	{
		[equationsTable reloadData];
	}
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction) closePanel: (id) sender
{
	[equationsTable deselectAll:self];
	
	// Update Equations menu
	int menuItemsCount = [[equationsMenu itemArray] count];
	int i = 2;

	// Clear out all equations from the menu
	for (i = 2; i < menuItemsCount; i++)
	{
		[equationsMenu removeItemAtIndex: 2];
	}
	
	// Add the updated list of equations
	if ([equationsList count] > 0)
	{
		[equationsMenu addItem: [NSMenuItem separatorItem]];
		
		int menuIdx = 0;
		
		for (menuIdx = 0; menuIdx < [equationsList count]; menuIdx++)
		{
			[equationsMenu addItemWithTitle: [equationsList objectAtIndex:menuIdx] action:@selector(insertEquation:) keyEquivalent: @""];
		}
	}
	
//	[[self window] close];
	[NSApp stopModal];
}

- (IBAction) addEquation: (id) sender
{   
    [equationsList addObject: @""];
	
	[equationsTable reloadData];
	
	int index = [equationsList count] - 1;
	NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
	[equationsTable selectRowIndexes:indexSet byExtendingSelection:YES];
	
	[equationsTable editColumn: 0 row:index withEvent: nil select: YES];
}

- (IBAction) deleteEquation: (id) sender
{
	NSEnumerator *enumerator;
    NSNumber *index;
    NSMutableArray *tempArray  = [[NSMutableArray alloc] init];
    id tempObject;
	
    if ( [equationsTable numberOfSelectedRows] > 0 )
    {
        enumerator = [equationsTable selectedRowEnumerator];
        
        while ( (index = [enumerator nextObject]) ) 
        {
            tempObject = [equationsList objectAtIndex:[index intValue]];
            [tempArray addObject:tempObject];
        }
		
        [equationsList removeObjectsInArray:tempArray];
        [tempArray release];
        
        [equationsList writeToFile:equationsFile atomically:YES];
        
        [equationsTable reloadData];
	}
}

#pragma mark -
#pragma mark TableView Methods

// =========================================================================
// (void) tableViewSelectionDidChange: (NSNotification *) aNotification
// -------------------------------------------------------------------------
// Version: 19. June 2004 1:30
// Created: 17. June 2004 22:38
// -------------------------------------------------------------------------
// This method is called when the selection (or highlighting) of table rows
// changes.  This is useful in reacting, such as enabling or disabling buttons
// =========================================================================
- (void) tableViewSelectionDidChange: (NSNotification *) aNotification
{
    if ([equationsTable numberOfSelectedRows] > 0)
    {
        [deleteEquationButton setEnabled: YES];
    }
    else
    {
        [deleteEquationButton setEnabled: NO];
    }
}


// =========================================================================
// (int) numberOfRowsInTableView: 
// -------------------------------------------------------------------------
// Version: 17. June 2004 22:38
// Created: 17. June 2004 22:38
// =========================================================================
- (int)numberOfRowsInTableView:(NSTableView*)table
{
    return [equationsList count];
}


// =========================================================================
// (id) tableView:
// -------------------------------------------------------------------------
// Version: 17. June 2004 22:38
// Created: 17. June 2004 22:38
// =========================================================================
- (id)tableView:(NSTableView*)table objectValueForTableColumn:(NSTableColumn*)col row:(int)rowIndex
{
    id result = nil;
	
    result = [equationsList objectAtIndex:rowIndex];
    
    return result;
}

// =========================================================================
// (void) tableView:
// -------------------------------------------------------------------------
// Version: 30. June 2004 20:39
// Created: 17. June 2004 22:38
// =========================================================================
- (void) tableView: (NSTableView *)aTableView setObjectValue: (id)object forTableColumn:(NSTableColumn *)inColumn row:(int) rowIndex
{
//    int index 	= 0;
    // add three since the first three slots of the Equations menu are already filled up
//    index = rowIndex+3;

	// It cannot be blank
	// It cannot previously or currently exist
	// If this is new, it cannot match anything else already existing
	// if the changed/added item is not empty
	// If this is a valid item, make sure it has proper placing in the table list and menu
	if ( [object isEqualTo: @""] == NO && 
		([equationsList containsObject: object] == NO || ([equationsList containsObject: object] == YES && 
														  [equationsList indexOfObject: object] == rowIndex)) )
    {
        [equationsList replaceObjectAtIndex:rowIndex withObject:object];        
    }
    else // if the selection is empty or a duplicate equation
    {
        // check if this is a new item?
        [equationsList removeObjectAtIndex: rowIndex];
    }
    
    [equationsList writeToFile:equationsFile atomically:YES];
	
	[equationsTable deselectAll:self];
    [equationsTable reloadData]; // refresh the table
}


@end
