//
//  EditEquationsController.h
//  EdenGraph
//
//  Created by Chad Armstrong on 8/23/13.
//  Copyright 2013 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kEquationsTableDataType @"EquationsTableDataType"

@interface EditEquationsController : NSWindowController 
{
	IBOutlet NSButton		*addEquationButton;
	IBOutlet NSButton		*deleteEquationButton;
    IBOutlet NSTableView	*equationsTable;

	NSString				*equationsFile;
	NSMenu					*equationsMenu;
    NSMutableArray			*equationsList;
}

//- (void) loadEquations;
- (IBAction) closePanel: (id) sender;
- (IBAction) addEquation: (id) sender;
- (IBAction) deleteEquation: (id) sender;

@end
