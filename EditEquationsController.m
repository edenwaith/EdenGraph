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

	[equationsTable registerForDraggedTypes: [NSArray arrayWithObject: kEquationsTableDataType] ];
	
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
	[equationsList writeToFile:equationsFile atomically:YES];
	
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
// (void) tableView:setObjectValue:forTableColumn:row
// -------------------------------------------------------------------------
// Created: 17. June 2004 22:38
// Version: 19 October 2013
// =========================================================================
- (void) tableView: (NSTableView *)aTableView setObjectValue: (id)object forTableColumn:(NSTableColumn *)inColumn row:(int) rowIndex
{
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

#pragma mark Drag-and-drop

// =========================================================================
// (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op
// -------------------------------------------------------------------------
// http://developer.apple.com/documentation/Cocoa/Conceptual/DragandDrop/UsingDragAndDrop.html#//apple_ref/doc/uid/20000726-BABFIDAB
// -------------------------------------------------------------------------
// Created: 20 October 2013 21:03
// Version: 20 October 2013 21:03
// =========================================================================
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op
{
    // Add code here to validate the drop
    return NSDragOperationEvery;
}	

// =========================================================================
// - (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
// -------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------
// Created: 20 October 2013 21:15
// Version: 20 October 2013 21:15
// =========================================================================
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	// Copy the row numbers to the pasteboard.
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:kEquationsTableDataType] owner:self];
	[pboard setData:data forType: kEquationsTableDataType];
	
	return YES; 
}	

// =========================================================================
// (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
// -------------------------------------------------------------------------
// 
// -------------------------------------------------------------------------
// Created: 20 October 2013 21:19
// Version: 20 October 2013 21:19
// =========================================================================
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType: kEquationsTableDataType];
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	//    int dragRow = [rowIndexes firstIndex];
	
	int		insertionRow;
	int		newIndex;
	int		firstDragRowIndex;
	NSArray	*draggedItems = [equationsList objectsAtIndexes: rowIndexes];
	
	if (draggedItems != NULL) 
	{
		
		[equationsList removeObjectsAtIndexes: rowIndexes];
		
		//	the row number for insertion is before we removed the dragged items, if the insertion is below the removal
		//	we need to adjust the insertion row. We also need to honor the drag operation
		
		//	ddwr - this code will not work for non-contiguous selection of table rows
		
		insertionRow = row;
		firstDragRowIndex = [rowIndexes firstIndex];
		if (insertionRow >  firstDragRowIndex) {
			insertionRow -= [draggedItems count];
		}
		
		if (operation == NSTableViewDropOn) {
			insertionRow++;
		}
		
		NSMutableIndexSet *insertionIndexSet = [[[NSMutableIndexSet alloc] init] autorelease];
		
		//	insert them back in the reverse order so they keep the order that they were selected
		for (newIndex = [draggedItems count] - 1; newIndex >= 0; newIndex--) {
			
			if (insertionRow >= (int) [equationsList count]) {
				[equationsList addObject: [draggedItems objectAtIndex: newIndex]];
			} else {
				[equationsList insertObject: [draggedItems objectAtIndex: newIndex] atIndex: insertionRow];
			}
			
			[insertionIndexSet addIndex: insertionRow];
		}
		
		[equationsTable deselectAll:self];
		//		[table selectRowIndexes:insertionIndexSet byExtendingSelection:YES];	// select row(s) at new location
//		[self updateChangeCount:NSChangeDone]; // Not sure if this is needed...
		[equationsTable reloadData];
		
	}
    // Move the specified row to its new location...
	
	return YES;
	
}

@end
