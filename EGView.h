//
//  EGView.h
//  EdenGraph
//
//  Created by admin on Thu May 30 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
// #include <mathlink/mathlink.h>
#import "TheParser.h"
#import "EditEquationsController.h"
#import "PreferencesController.h"
#import "CustomSlider.h"

@interface EGView : NSClipView 
{
    NSString 		*path;
    NSString		*equationsFile;
	EditEquationsController *editEquationsController;
	PreferencesController	*preferencesController;
	
    IBOutlet id				formulaField;
    IBOutlet id				graphButton;
    IBOutlet id				Window;
    IBOutlet NSTextField	*xCoordField;
    IBOutlet NSTextField	*yCoordField;
    IBOutlet NSColorWell	*graphColorWell;
    IBOutlet NSColorWell	*axesColorWell;
    IBOutlet NSColorWell	*backgroundColorWell;
    IBOutlet NSColorWell	*gridColorWell;
    IBOutlet NSSlider		*precisionSlider;
    IBOutlet NSSlider		*nudgeSlider;
	IBOutlet CustomSlider		*zoomLevelSlider;
    IBOutlet NSPopUpButton	*kernelButton;
    IBOutlet id				equationsSheet;
    IBOutlet NSMenu			*equationsMenu;
//    IBOutlet NSTableView	*equationsTable;
//    IBOutlet NSButton		*delete_equation_button;
	IBOutlet NSClipView		*formulaView;
	
	IBOutlet NSTextField	*coordinatesField;
	IBOutlet NSTextField	*zoomLevelField;
    
    NSUserDefaults			*prefs;
    
    TheParser				*parser;
    
    NSColor					*graphColor;
    NSColor					*axesColor;
    NSColor					*gridColor;
    NSColor					*backgroundColor;
    
    NSPipe					*toPipe;
    NSPipe					*fromPipe;
    NSFileHandle			*toEvaluator;
    NSFileHandle			*fromEvaluator;
    NSTask					*evaluator;
    
    NSTrackingRectTag		trackingRect;	// tracking rectangle to identify when mouse has entered
    
    NSMutableString			*fromBuf;
    
    NSMutableString			*kernelType;
    
    // tracking coordinate variables
    NSMutableString			*x_string;
    NSMutableString			*y_string;
    NSFont					*font;
    NSMutableDictionary		*attrs;
    
    double					ymin;
    double					ymax;
    
    double					xavg;
    double					yavg;
    
    double					temp_ymin;
    double					temp_ymax;    
    
    double					zoom_factor; 	// factor of magnification, starts at 1
    double					zoom_percent;	// zoom percent which shows in title bar
    
    int						os_version;	// Operating System version (i.e. 1000 = 10.0.0)
    
    NSMutableArray			*equationsList;
    
    // Display list
    NSMutableArray			*displayList;
    BOOL					first;		// Getting the first point?
    NSPoint					lastPt;		// Last point received
    
    // Communications with stuffer thread
    BOOL					stop_sending;
    BOOL					sending;
    BOOL					receiving;
    
    BOOL					appHasLaunched;
    
    BOOL					isDragging;
    
    // MathLink variables
/*    
    float 		sum;
    int 		argc;
    char 		*argv[5];
    MLINK 		lp;
    MLEnvironment 	env;
    char 		*expr;
*/
    
@public	// For use by stuffer thread

    BOOL		graphing;
    char		*formula;
    int			toFd;
    double		xmin, xmax;
    double		xstep;  // how much to increment
    double		temp_xmin, temp_xmax;
    double		nudge_step;
    
    float		scrollwheel_delta; // scroll wheel variables
    float		old_timestamp;
}

// system init, dealloc and such
- (void) dealloc;
- (void) awakeFromNib;
- (BOOL)acceptsFirstResponder;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication;
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;

- (void)off:(id)sender;
- (IBAction) copyGraph : (id) sender;

- (void) setString;

// mouse functions
- (BOOL) checkBounds : (NSPoint)myPoint;
- (NSPoint) distanceOutsideView: (NSPoint) p;

- (void)mouseEntered: (NSEvent *) event;
- (void)mouseExited: (NSEvent *) event;

- (void)mouseDown: (NSEvent *) event;
- (void)mouseMoved:(NSEvent *)event;
- (void)mouseUp: (NSEvent *) event;

- (void) scrollWheel: (NSEvent *)event;

- (void)keyUp: (NSEvent *) event;

// graph drawing
- (IBAction)graph: (id)sender;
- (void)drawGraph;
- (IBAction)stopGraph: (id)sender;
- (IBAction)zoomIn: (id) sender;
- (IBAction)zoomOut: (id) sender;
- (void) toolZoomIn;
- (void) toolZoomOut;

- (IBAction) zoomToPercent: (id) sender;
- (IBAction) returnToOrigin: (id) sender;
- (IBAction) resetGraph: (id) sender;

- (void)doStop:(int)which;
- (void)getFormAndScaleView;
- (void)addGraphElement:(id)element;
- (void)clear;
- (IBAction) clearGraph: (id) sender;
- (void)sendData;
- (void)addAxesFrom:(NSPoint)pt1 to:(NSPoint)pt2;
- (void) addGrid: (NSPoint)pt1 to:(NSPoint)pt2;

// preferences
- (void) preferencesUpdated: (NSNotification *) aNotification;
- (void) updatePreferences;
- (void) setAxesColor:(id)sender;
- (void) setBGColor:(id)sender;
- (void) setGraphColor:(id)sender;
- (void) setGridColor:(id)sender;
- (IBAction) setPrecision: (id) sender;
- (IBAction) setNudge: (id) sender;

- (IBAction) saveDocumentTo: (id) sender;

- (IBAction) openPreferences: (id) sender;
- (IBAction) checkForNewVersion: (id) sender;
- (IBAction) goToProductPage: (id) sender;
- (IBAction) feedBack: (id)sender;

- (IBAction) addEquation : (id) sender;
- (IBAction) editEquations : (id) sender;
- (IBAction) insertEquation : (id) sender;

//- (void) tableViewSelectionDidChange: (NSNotification *) aNotification;
//- (int)numberOfRowsInTableView:(NSTableView*)table;
//- (id)tableView:(NSTableView*)table objectValueForTableColumn:(NSTableColumn*)col row:(int)rowIndex;
//- (void) tableView: (NSTableView *)aTableView setObjectValue: (id)object forTableColumn:(NSTableColumn *)inColumn row:(int) rowIndex;
//- (IBAction) addNewEquation : (id) sender;
//- (IBAction) closeEquationsSheet : (id) sender;
//- (IBAction) deleteEquation: (id) sender;

- (void) checkOSVersion;

- (IBAction) setKernel : (id) sender;


@end

@protocol EGElement

- (int)tag;
- (void)setTag:(int)aTag;
- (void)stroke;
- (NSRect)bounds;
- (void)setColor:(NSColor *)aColor;
- (NSColor *)color;

@end

#define STOP_SENDER 1
#define STOP_RECEIVER 2
#define GRAPH_TAG 1
#define AXES_TAG 2
#define GRID_TAG 3
#define LABEL_TAG 4

