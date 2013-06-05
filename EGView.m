//
//  EGView.m
//  EdenGraph
//
//  Created by admin on Thu May 30 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//

// OS Version Checking
// http://developer.apple.com/releasenotes/Cocoa/AppKit.html

#import "EGView.h"
#import "Segment.h"
#import "Label.h"
#import "EGController.h"
#import "ToolbarDelegateCategory.h"


@implementation EGView

// The chiseled text icon tutorial came from
// http://www.wdvl.com/Graphics/Tools/Photoshop/Metal/dirty2-3.html
// Also, one can search for 'Photoshop chrome'

// On-line graphing calculator
// http://people.hofstra.edu/staff/steven_r_costenoble/Graf/Graf.html

// =========================================================================
// initWithFrame:(NSRect)frame
// =========================================================================
- initWithFrame:(NSRect)frame
{
    // NSString *path;
    // NSString *mlPath;

    self = [super initWithFrame:frame];
    
    
    prefs = [[NSUserDefaults standardUserDefaults] retain];

    displayList = [ [NSMutableArray alloc] init];
    fromBuf = [ [NSMutableString alloc] init];

    // What follows is largely from MathPaper
    path  = [ [NSBundle mainBundle]
               pathForResource:@"MathCore" ofType:@""];
               
    //mlPath = [ [NSBundle mainBundle] pathForResource:@"MathKernel" ofType:@".app" inDirectory:@"/Applications/Mathematica 4.2/"];
               
    trackingRect = [self addTrackingRect: [self visibleRect] // [self visibleRect]
                         owner: self
                         userData: nil
                         assumeInside: NO ];
                         

    if (!path) 
    {
        NSLog(@"%@: Cannot find MathCore",[self description]);
    }
    else 
    {
        // MathLink initializations
/*        
        argc 	= 4;
        argv[0]	= "-linkname";
        argv[1]	= " '/Applications/Mathematica 4.2.app/Contents/MacOS/MathKernel' -mathlink";
        argv[2]	= "-linkname";
        argv[3]	= "-launch";
        argv[4] = NULL;
*/        
        toPipe   = [NSPipe pipe];
        fromPipe = [NSPipe pipe];

        toEvaluator   = [toPipe fileHandleForWriting];
        fromEvaluator = [fromPipe fileHandleForReading];

        evaluator = [ [NSTask alloc] init];
        [evaluator setLaunchPath:path];

        [evaluator setStandardOutput:fromPipe];
        [evaluator setStandardInput:toPipe];
        [evaluator launch];

        [ [NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(gotData:)
                   name:NSFileHandleReadCompletionNotification
                 object:fromEvaluator ];


        [fromEvaluator readInBackgroundAndNotify];
        
        [ [self window] setAcceptsMouseMovedEvents:YES];
        
        // set initial values for the min and max values
        temp_xmin 	= -5.0; //[xminCell doubleValue];
        temp_xmax  	= 5.0;	//[xmaxCell doubleValue];

        temp_ymin  	= -3.0;	// [yminCell doubleValue];
        temp_ymax  	= 3.0;	//[ymaxCell doubleValue];
        
        // xstep = 0.1; //[xstepCell doubleValue];
        xstep 		= 0.1; // seems to do fine here, but will probably want to 
                                // increase and decrease this value when zooming.  Make 
                                // smaller when zooming in, and make larger when zooming
                                // out.
        
        zoom_factor 	= 1.0; 
        zoom_percent	= 100;
        
        appHasLaunched 	= NO;
        isDragging	= NO;
        
        scrollwheel_delta	= 0.0;
        old_timestamp		= 0.0;
        
        
        x_string		= [[NSMutableString alloc] init];
        y_string		= [[NSMutableString alloc] init];
        
        kernelType		= [[NSMutableString alloc] init];

    
        attrs = [[NSMutableDictionary alloc] init];
        [attrs setObject: [NSFont fontWithName: @"Helvetica" size: 12] forKey: NSFontAttributeName];
        [attrs setObject: [NSColor blueColor] forKey: NSForegroundColorAttributeName];
        
        parser = [[TheParser alloc] init];
      
       [self checkOSVersion];
        
    }

    // The notification below causes the getFormAndScaleView
    // method to be invoked whenever this view is resized.
    [ [NSNotificationCenter defaultCenter]
                    addObserver:self
                       selector:@selector(getFormAndScaleView)
                           name:NSViewFrameDidChangeNotification
                         object:self];

    return self;
}


// =========================================================================
// (void) dealloc
// -------------------------------------------------------------------------
// Garfinkel & Mahoney's notes: dealloc is missing from G&M Book; does it 
// really need to be here, as it is never called?
// ========================================================================= 
- (void)dealloc
{
    [evaluator  release];
    [evaluator  terminate];
    
    [graphColor release];
    [axesColor release];
    [backgroundColor release];
    [gridColor release];

    [displayList release];
    [fromBuf    release];
    [super dealloc];
}



// =========================================================================
// (void) awakeFromNib
// -------------------------------------------------------------------------
// The last two lines are used so the NSView will respond when the mouse
// is moved and the mouseMoved: function works.  setAcceptsMouseMovedEvents
// is NO by default.
// =========================================================================
- (void) awakeFromNib
{
    int i = 0;
       
    equationsFile = [[NSString alloc] initWithString: [@"~/Library/Preferences/EdenGraph.plist" stringByExpandingTildeInPath]];
    [equationsFile retain];
    
    equationsList = [[NSMutableArray alloc] initWithContentsOfFile:equationsFile];
    
    if (nil == equationsList)
    {
        equationsList = [[NSMutableArray alloc] init];
    }
    else
    {
        if ([equationsList count] > 0)
        {
			[equationsMenu addItem: [NSMenuItem separatorItem]];
        }
        
        for (i = 0; i < [equationsList count]; i++)
        {
            [equationsMenu addItemWithTitle: [equationsList objectAtIndex: i] action:@selector(insertEquation:) keyEquivalent: @""];
        }
    }
    

    // http://wodeveloper.com/omniLists/macosx-dev/2001/February/msg00512.html
    // http://developer.apple.com/techpubs/macosx/Cocoa/Reference/ApplicationKit/ObjC_classic/Classes/NSWindow.html
    // [[self window] makeFirstResponder: self]; // don't want this now since I only
                                                 // want mouse events to be triggered
                                                 // when the mouse is over the view
                                                 
    // [[formulaField window] makeFirstResponder:self];
    // [ [self window] makeFirstResponder:formulaField];
    // [[self window] selectNextKeyView: nil];

    [[self window] setAcceptsMouseMovedEvents:YES]; // this is necessary, however
    
    [self setupToolbar];
    
    [self setString]; // initialize the x_string and y_strings
    
    
    if ([prefs floatForKey:@"Precision"] != nil)
    {

        xstep = [prefs floatForKey: @"Precision"];

        [precisionSlider setFloatValue: xstep];
        
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
        xstep = 0.1;
    }
    
    // Nudge
    if ([prefs floatForKey:@"Nudge"] != nil)
    {
        nudge_step = [prefs floatForKey: @"Nudge"];  
        [nudgeSlider setFloatValue: nudge_step];
    }
    else
    {
        [nudgeSlider setFloatValue: 1.0f];
        nudge_step = 1.0;
    }
    
    if ([prefs objectForKey: @"Axes Color"] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: @"Axes Color"];
        [axesColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [axesColorWell setColor: [NSColor lightGrayColor]];
    }
    
    if ([prefs objectForKey: @"Graph Color"] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: @"Graph Color"];
        [graphColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [graphColorWell setColor: [NSColor redColor]];
    }
    
    if ([prefs objectForKey: @"Background Color"] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: @"Background Color"];
        [backgroundColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [backgroundColorWell setColor: [NSColor whiteColor]];
    }
    
    if ([prefs objectForKey: @"Grid Color"] != nil)
    {
        NSData *colorAsData = [prefs objectForKey: @"Grid Color"];
        [gridColorWell setColor: [NSUnarchiver unarchiveObjectWithData:colorAsData]];
    }
    else
    {
        [gridColorWell setColor: [NSColor colorWithCalibratedRed: 0.8 green: 1.0 blue: 1.0 alpha:1.0]];
    }
    
    if ([prefs objectForKey: @"Kernel Type"] != nil)
    {
        NSData *textAsData = [prefs objectForKey: @"Kernel Type"];
        [kernelButton selectItemWithTitle: [NSUnarchiver unarchiveObjectWithData:textAsData]];
    }
    else
    {
        [kernelButton selectItemWithTitle: @"EdenGraph"];
    }
    
    if (xstep <= 0.001)
    {
        xstep = 0.001;
    }
            
    axesColor = [[axesColorWell color] retain];
    graphColor = [[graphColorWell color] retain];
    backgroundColor = [[backgroundColorWell color] retain];
    gridColor = [[gridColorWell color] retain];
    
    // [kernelType setString: [kernelButton titleOfSelectedItem]];
    
}

// =========================================================================
// (BOOL) acceptsFirstResponder
// -------------------------------------------------------------------------
// =========================================================================
- (BOOL)acceptsFirstResponder
{
    return YES;
}

// =========================================================================
// (BOOL) applicationShould....:(NSApplication *)theApplication
// -------------------------------------------------------------------------
// Terminate the program when the last window closes
// Need to connect File Owner to UTController as a 
// delegate for this to work correctly
// =========================================================================
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication 
{
    return YES;
}

// =========================================================================
// (void) applicationDidFinishLaunching:(NSNotification *)
// -------------------------------------------------------------------------
// Need to make the controller the delegate of Window and File Owner in the
// IB for this to work
// This is called to wait until the program has launched, then it calls
// drawGraph so it can initially draw the axes which wouldn't work if called
// from initWithFrame since some NSMutableString was nil and then crashed
// the program.  As Igor from QFG4 said: "Bad, bad, bad!"
// -------------------------------------------------------------------------
// Version: 20. May 2003 11:27 -- added the date checking for the beta
// =========================================================================
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    appHasLaunched = YES;
            
    [self drawGraph];  // initially draw the axes
}

// =========================================================================
// (void) off: (id) sender
// -------------------------------------------------------------------------
// When the Close button is pressed, the application is
// terminated
// =========================================================================
- (void)off:(id)sender
{
    [NSApp terminate:self];
}

// =========================================================================
// (IBAction) copyGraph : (id) sender
// -------------------------------------------------------------------------
// Version: 17. July 2003
// Created: 17. July 2003
// -------------------------------------------------------------------------
// This code modified from this site:
// http://www.omnigroup.com/mailman/archive/macosx-dev/2003-February/032441.html
// =========================================================================
- (IBAction) copyGraph : (id) sender
{
    NSPasteboard *thePasteboard = [NSPasteboard generalPasteboard];
    NSData *tiffData;

    tiffData = [ [[NSImage alloc] initWithData: [[self superview] dataWithPDFInsideRect: [self frame]]] TIFFRepresentation];

    [thePasteboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] 
owner:nil];
    [thePasteboard setData:tiffData forType:NSTIFFPboardType];
}

// =========================================================================
// (void) setString
// -------------------------------------------------------------------------
// Version: 20. July 2003 16:03
// -------------------------------------------------------------------------
// Initialize the x_string and y_string which are the coordinates of 
// where the mouse is on the graph.  Also added the initialization of the
// kernelType.
// =========================================================================
- (void) setString
{
    [x_string setString:@"X: -"];
    [y_string setString:@"Y: -"];
    
    [xCoordField setStringValue: x_string];
    [yCoordField setStringValue: y_string];
    
    // [kernelType setString: [kernelButton titleOfSelectedItem]];
    
    [self setNeedsDisplay:YES];
}


// =========================================================================
// (BOOL)checkBounds:(NSPoint)myPoint
// -------------------------------------------------------------------------
// Version: 11. July 2003
// -------------------------------------------------------------------------
// Check to see if the mouse is inside or outside the NSView.  If it is
// outside the NSView, then just - is printed for the x, y coordinate.
// Yet another bit of old code from the original attempt of EdenGraph.
// =========================================================================
- (BOOL) checkBounds : (NSPoint)myPoint
{
	// printf("myPoint.x: %f | myPoint.y: %f\n", myPoint.x, myPoint.y);
    if (myPoint.x < 20.0 || myPoint.x > 520.0)
    {
        return NO;
    }
    else if (myPoint.y < 100.0 || myPoint.y > 400.0)
    {
        return NO;
    }
    else  // mouse is in the NSView
    {
        return YES;
    }
}

// =========================================================================
// (NSPoint) distanceOutsideView:(NSPoint)myPoint
// -------------------------------------------------------------------------
// Version: 17. September 2005 15:21
// Created: 25. July 2004 0:34
// -------------------------------------------------------------------------
// Going to eventually need to create variables to set where the edges of 
// the view are to detect for a resizable view
// Added the default 'else' condition so that newPoint x or y is set to 0
// if the coordinate does not extend past the graph window's boundaries.
// =========================================================================
- (NSPoint) distanceOutsideView: (NSPoint) p
{
    NSPoint newPoint;
    
    if (p.x < 20.0)
    {
        newPoint.x = p.x - 20.0;
    }
    else if (p.x > 520.0)
    {
        newPoint.x = p.x - 520.0;
    }
	else
	{
		newPoint.x = 0.0;
	}
    
    if (p.y < 100.0)
    {
        newPoint.y = p.y - 100.0;
    }
    else if (p.y > 400.0)
    {
        newPoint.y = p.y - 400.0;
    }
	else
	{
		newPoint.y = 0.0;
	}
    
    return (newPoint);
}

// =========================================================================
// (void)mouseEntered: (NSEvent *) event
// -------------------------------------------------------------------------
// 
// =========================================================================
- (void)mouseEntered: (NSEvent *) event
{
    [ [self window] setAcceptsMouseMovedEvents:YES];
    [ [self window] makeFirstResponder:self];
    //NSLog(@"Entering...");
}

- (void)mouseExited: (NSEvent *) event
{
    
    // [self setString];    
    [ [self window] setAcceptsMouseMovedEvents:NO];
    
    // NSLog(@"Exiting...");
}

// =========================================================================
// (void) mouseDown:(NSEvent*)event
// -------------------------------------------------------------------------
// This function checks when the mouse button is held down and drags across 
// the screen.  When this happens, the graph is moved, which tends to be
// quicker, but not as precise as using the up/down, left/right buttons
// =========================================================================
- (void)mouseDown:(NSEvent*)event
{
    // NSPoint myPoint = [event locationInWindow];
    //printf("x: %f   y: %f\n", myPoint.x, myPoint.y);
    
    NSPoint	locationInWindow 	= [event locationInWindow];
    NSPoint	newLocation		= locationInWindow;
    double 	x				= 0.0;
    double 	y				= 0.0;
    
    double	formula_x		= 0.0;
    double	formula_y		= 0.0;
	BOOL justClicked		= YES;
    
	// NSLog(@"liw X: %f | liw Y: %f", locationInWindow.x, locationInWindow.y);
	// NSLog(@" nl X: %f |  nl Y: %f", newLocation.x, newLocation.y);
	
/*    
    NSCursor *grabCursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"Save"] hotSpot:NSMakePoint(8, 8)];
    //NSClipView * newview = [self superview];
    [[NSClipView alloc] setDocumentCursor:grabCursor];
    [grabCursor release];    
*/
    
    // Track mouse dragging around the screen
    while(1) 
    {
        NSEvent*	evt = [NSApp nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseDownMask | NSLeftMouseUpMask) untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES];
        
        isDragging = YES;
		
        if([evt type] == NSLeftMouseUp) 
        {
            break; // break out of the loop
        }
        else if ([evt type] != NSLeftMouseDragged)
        {
            // Not moving, just staying in one place.
            
			newLocation.x = locationInWindow.x;
			newLocation.y = locationInWindow.y;
        }
        else
        {
			newLocation = [evt locationInWindow]; // get new position in window
        }
		
        // Due to some odd occurrence with Mac OS 10.3 and later, need to check
        // if either of the coordinates of newLocation are null (returning nan)
        // which then causes some problems when just clicking but not moving, 
        // so the graph will jump oddly.
        if (newLocation.x == nil || newLocation.y == nil)
        {
			newLocation.x = locationInWindow.x;
			newLocation.y = locationInWindow.y;
        }

        
        // Need to locate if mouse is in the view or not.  If the mouse
        // is outside the view, scroll faster, depending on the distance
        // from the edge of the view.  Make sure to mark the distance from
        // the edge independent, not on static numbers (50, 500, etc.).
        
        // calculate the difference in movement
        x += (newLocation.x - locationInWindow.x);
        y += (newLocation.y - locationInWindow.y);
        
        // it is 50 since at 100% (starting state), the screen is 500 pixels across
        // and 50 pixels represents '1' until of space along the x axis.

		// if inside the graph window
        if ([self checkBounds:newLocation] == YES)
        {
            temp_xmax = temp_xmax - x/(50 * zoom_factor); 
            temp_xmin = temp_xmin - x/(50 * zoom_factor);
            temp_ymax = temp_ymax - y/(50 * zoom_factor);
            temp_ymin = temp_ymin - y/(50 * zoom_factor);
        }
        else // scroll faster outside of the window
        {
            NSPoint p = [self distanceOutsideView:newLocation];
                        
            // rounding is enabled to prevent any odd errors so
            // the condition works properly
            if (rint(p.x) != 0.0)
            {
                formula_x = 1.01 * ((1.0 + p.x)/(50.0 * zoom_factor));
            }
            else
            {
                formula_x = 0.0;
            }
            
            if (rint(p.y) != 0)
            {
                formula_y = 1.01 * ((1.0 + p.y)/(50.0 * zoom_factor));
            }
            else
            {
                formula_y = 0.0;
            }
            
            temp_xmax = temp_xmax - x/((50) * zoom_factor) - formula_x; 
            temp_xmin = temp_xmin - x/((50) * zoom_factor) - formula_x;
            temp_ymax = temp_ymax - y/((50) * zoom_factor) - formula_y;
            temp_ymin = temp_ymin - y/((50) * zoom_factor) - formula_y;
            
        }
        
      
        locationInWindow = newLocation;  // tell the locationInWindow to be the 'old' position
                                         // for the next cycle
      
        // reinitialize the x and y variables so it tracks a little cleaner
        x = 0.0;
        y = 0.0;
        
		if (justClicked == NO)
		{
			[self drawGraph];
		}
		else
		{
			justClicked = NO;
		}
    }
    
    [self mouseUp:event];
    
}

// =========================================================================
// (void) mouseDragged: (NSEvent *)event
// -------------------------------------------------------------------------
// Author:  Chad Armstrong
// Version: 4 September 2004 18:10
// Created: 4 September 2004 18:10
// -------------------------------------------------------------------------
// This might be useful instead of having the while loop within the
// mouseDown function.
// =========================================================================
- (void) mouseDragged: (NSEvent *) event
{}

// =========================================================================
// (void) mouseMoved:(NSEvent*)event
// -------------------------------------------------------------------------
// This function checks when the mouse is moving.  This event is not
// handled by default and needs to be set up to work.  So the last two 
// lines in the awakeFromNib function are used so the program will
// detect when the mouse has been moved.
// New note: the acceptsFirstResponder method is also needed for the
// mouseMoved method to work.  Things were originally not working, but once
// I added that three line method, things worked.
// To convert from one point of reference axis system to another, I use
// the convertPoint.  Look at page 217 of Aaron Hillegass' Cocoa Programming
// for Mac OS X for reference to this
// =========================================================================
- (void) mouseMoved:(NSEvent *)event
{
    NSPoint p = [event locationInWindow];
    NSPoint myPoint = [self convertPoint:p fromView:nil]; // convert point to refer 
                                                          // to just the view
                                                          
	// Perhaps add some option here to eventually allow some preference so
	// the user can specify the level of precision they want here.
    [x_string setString: [NSString stringWithFormat: @"X: %.3f", myPoint.x]];
    [y_string setString: [NSString stringWithFormat: @"Y: %.3f", myPoint.y]];
    
    if ([ [self window] acceptsMouseMovedEvents] == YES && [self checkBounds: p] == YES )
    {
        [xCoordField setStringValue: x_string];
        [yCoordField setStringValue: y_string];
    }
    else
    {
        [xCoordField setStringValue: @"X: -"];
        [yCoordField setStringValue: @"Y: -"];
    }
    
}

// =========================================================================
// (void) mouseUp:(NSEvent*)event
// -------------------------------------------------------------------------
// Since the dot was removed from this program, this function doesn't
// have too much use at the moment, but is kept here in case a use
// does come up
// =========================================================================
- (void) mouseUp: (NSEvent *)event
{
    if (isDragging == YES)
    {
        isDragging = NO;
        sending = NO;

        // redraw the graph after shifting
        [self drawGraph];

    }
    else
    {
        NSLog(@"in the ELSE part of mouseUp");
    }

        
}

// =========================================================================
// (void) scrollWheel:(NSEvent*)event
// -------------------------------------------------------------------------
// Version: 5. May 2003 23:30
// Created: 5. May 2003 22:00
// -------------------------------------------------------------------------
// When the mouse's scroll wheel is moved, it will zoom in or out.  If 
// a delta value of 10 or more occurs within one second, the program will 
// zoom in or out by one iteration.
// =========================================================================
- (void) scrollWheel: (NSEvent *)event
{
    float current_timestamp = [event timestamp];
    
    if ( (current_timestamp - old_timestamp) <= 1.0 )
    {
    
        scrollwheel_delta += [event deltaY];
        
        if (scrollwheel_delta > 10.0)
        {
            scrollwheel_delta = 0.0;
            [self toolZoomIn];
        }
        else if (scrollwheel_delta < -10.0)
        {
            scrollwheel_delta = 0.0;
            [self toolZoomOut];
        }
    }
    else
    {
        scrollwheel_delta = 0.0;
    }
    
    old_timestamp = current_timestamp;

}

// =========================================================================
// (BOOL) resignFirstResponder
// -------------------------------------------------------------------------
// This method is used in conjunction with becomeFirstResponder and
// performKeyEquivalent so other key strokes can be recognized.
// =========================================================================
- (BOOL) resignFirstResponder
{
    return YES;
}

// =========================================================================
// (BOOL) becomeFirstResponder
// -------------------------------------------------------------------------
// This method is used in conjunction with resignFirstResponder and
// performKeyEquivalent so other key strokes can be recognized.
// =========================================================================
- (BOOL) becomeFirstResponder
{
    return YES;
    [self setNeedsDisplay: YES];
}


// =========================================================================
// (BOOL) performKeyEquivalent:(NSEvent*)event
// -------------------------------------------------------------------------
// This is used to simulate if the Cmd and = keys were pressed, which should
// do the same if the Cmd and + keys are pressed, which will zoom in.
// Anything else, and this method will return a NO and let the normal
// built in handlers deal with other key events.
// This method is used in conjunction with resignFirstResponder and
// becomeFirstResponder so other key strokes can be recognized.
// =========================================================================
- (BOOL) performKeyEquivalent: (NSEvent *) event
{
    NSString *input = [event characters];
    unsigned int flags;
    
    flags = [event modifierFlags];
    
    if ([input isEqual: @"="] && (flags & NSCommandKeyMask))
    {
        [self toolZoomIn];
        return YES;
    }
    else // otherwise, let the default handlers deal with key events
    {
        return NO;
    }
}

// =========================================================================
// (void)keyDown: (NSEvent *) event
// -------------------------------------------------------------------------
// might not need this either because of performKeyEquivalent
// NSEvent documentation shows key code names for function keys
// http://developer.apple.com/documentation/Cocoa/Reference/ApplicationKit/ObjC_classic/Classes/NSEvent.html
// =========================================================================
- (void)keyDown: (NSEvent *) event
{
    NSString *input = [event characters];
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    unsigned int flags;
    
    flags = [event modifierFlags];
    // is it a TAB? (or an RC Cola?)
    if ([input isEqual: @"\t"])
    {
        // had to connect the view's nextKeyView (in IB) to be the text field
        // then it works OK.
        [[self window] selectNextKeyView: nil];
        //[self becomeFirstResponder];
        //return;
    }
    else if ([input isEqual: @"\r"])
    {
        [self drawGraph];
    }
    // If the equation field isn't selected, then pressing the
    // up, down, right, or left buttons will shift the graph by
    // 1 pixel.  Perhaps add an option/preference to set how much to shift
    // (or 'nudge') the graph in a particular direction.
    else if (key == NSDownArrowFunctionKey)
    {
        double x = 0.0;
        double y = - nudge_step;
        
        isDragging = YES;
        
        temp_xmax = temp_xmax - x/(50 * zoom_factor); 
        temp_xmin = temp_xmin - x/(50 * zoom_factor);
        temp_ymax = temp_ymax - y/(50 * zoom_factor);
        temp_ymin = temp_ymin - y/(50 * zoom_factor);
            
        [self drawGraph];
    }
    else if (key == NSLeftArrowFunctionKey)
    {
        double x = - nudge_step;
        double y = 0;
        
        isDragging = YES;
        
        temp_xmax = temp_xmax - x/(50 * zoom_factor); 
        temp_xmin = temp_xmin - x/(50 * zoom_factor);
        temp_ymax = temp_ymax - y/(50 * zoom_factor);
        temp_ymin = temp_ymin - y/(50 * zoom_factor);
            
        [self drawGraph];
    }
    else if (key == NSRightArrowFunctionKey)
    {
        double x = nudge_step;
        double y = 0;
        
        isDragging = YES;
        
        temp_xmax = temp_xmax - x/(50 * zoom_factor); 
        temp_xmin = temp_xmin - x/(50 * zoom_factor);
        temp_ymax = temp_ymax - y/(50 * zoom_factor);
        temp_ymin = temp_ymin - y/(50 * zoom_factor);
            
        [self drawGraph];
    }
    else if (key == NSUpArrowFunctionKey)
    {
        double x = 0.0;
        double y = nudge_step;
        
        isDragging = YES;
        
        temp_xmax = temp_xmax - x/(50 * zoom_factor); 
        temp_xmin = temp_xmin - x/(50 * zoom_factor);
        temp_ymax = temp_ymax - y/(50 * zoom_factor);
        temp_ymin = temp_ymin - y/(50 * zoom_factor);
            
        [self drawGraph];
    }
    else
    {
        NSLog(@"keyDown: %@.", input);
    }
}

- (void)keyUp: (NSEvent *) event
{
    NSLog(@"in keyUp:");
    isDragging = NO;
    [self drawGraph];
}


// =========================================================================
// (void) flagsChanged: (NSEvent *) event
// -------------------------------------------------------------------------
// This is probably not necessary since the performKeyEquivalent seems to
// do the trick for me.
// =========================================================================
- (void) flagsChanged: (NSEvent *) event
{
    unsigned int flags = [event modifierFlags];
    
    if (flags & NSCommandKeyMask)
    {
        //[self keyDown:event];
    }
}

// =========================================================================
// (IBAction) graph: (id) sender
// -------------------------------------------------------------------------
// Check to see if anything has been input for a function yet.  If not,
// do not graph yet, as this can lock up EdenGraph
// =========================================================================
- (IBAction)graph:(id)sender
{
    if ([ [formulaField stringValue] isEqual: @""] == NO)
    {
        [parser checkFormula: [formulaField stringValue]];
        [formulaField setObjectValue:[parser newFormula]];
        
        [self drawGraph];
    }
    else
    {
        NSBeep();
    }
}

// =========================================================================
// (void) drawGraph
// -------------------------------------------------------------------------
// Version: 25. August 2003 8:43
// =========================================================================
- (void) drawGraph
{
    float float_i = 0.0;
   // set instance variables from the form
   [self getFormAndScaleView];

    [self clear];

    float_i = (int)ymin;
    // Draw a background grid
    

    // This is not the most elegant hack in creating the grid system, but
    // it works well for now.  Will need to try and optimize things later,
    // such as checking if a line is in the view.
    
    float_i = 0.0; 
    
    // Draw the (positive) vertical axes
    while ( float_i < ymax)
    {
        if (float_i != 0.0)
        {
            [self addGrid: NSMakePoint(xmin, float_i)
                    to:NSMakePoint(xmax, float_i) ];
        }
                
        float_i = float_i + 1.0/zoom_factor;
    }
    
    float_i = 0.0;
    
    // Draw the (negative) horizontal axes
    while ( float_i > ymin)
    {
        if (float_i != 0.0)
        {
            [self addGrid: NSMakePoint(xmin, float_i)
                    to:NSMakePoint(xmax, float_i) ];
        }
                
        float_i = float_i - 1.0/zoom_factor; 
    }    
    
    // Draw the (positive) vertical axes
    while ( float_i < xmax)
    {
        if (float_i != 0.0)
        {
            [self addGrid: NSMakePoint(float_i, ymin)
                    to:NSMakePoint(float_i, ymax) ];
        }
                
        float_i = float_i + 1.0/zoom_factor; 
    }
    
    float_i = 0.0;
    
    // Draw the (negative) vertical axes
    while ( float_i > xmin)
    {
        if (float_i != 0.0)
        {
            [self addGrid: NSMakePoint(float_i, ymin)
                    to:NSMakePoint(float_i, ymax) ];
        }
                
        float_i = float_i - 1.0/zoom_factor;  
    }
    

    // Display the axes
    [self addAxesFrom:NSMakePoint(xmin,0.0)
                   to:NSMakePoint(xmax,0.0) ];
    [self addAxesFrom:NSMakePoint(0.0,ymin)
                   to:NSMakePoint(0.0,ymax) ];

                 
    // Add a label
    /*                   
    {
        Label *label = [ [Label alloc] initRect:
        NSMakeRect(xmin, ymin, xmax-xmin, (ymax-ymin)*.2)
                text:x_string //text:[formulaField stringValue]
                size:24.0];

	[label autorelease];
        [label setTag:LABEL_TAG];
        [self addGraphElement:label];
    }
    */

    // Added this bit of code to speed up shifting, so it doesn't seem
    // to do unnecessary looping and drawing.  This sped up the process
    // SIGNIFICANTLY.
    if (NO == isDragging)
    {
        first = YES;
        stop_sending = NO;
        sending = YES;
        receiving = YES;

        [graphButton setTitle:@"Stop"];
        [graphButton setAction:@selector(stopGraph:)];

        [NSThread detachNewThreadSelector:@selector(sendData)
              toTarget:self
              withObject:nil];
    }

}


// =========================================================================
// (void) drawRect: (NSRect) rect
// =========================================================================
-(void)drawRect:(NSRect )rect
{
    id obj = nil;
    NSEnumerator *en;
    NSSize sz;

    [backgroundColor set];
    NSRectFill(rect);

    sz = [self convertSize:NSMakeSize(1,1) fromView:nil];
    
    [NSBezierPath setDefaultLineWidth:MAX(sz.width,sz.height)];

    // perhaps I can try and ignore this loop while dragging to try and prevent
    // synchronization errors while shifting the graph.    
    en = [displayList objectEnumerator];
    while (obj = [en nextObject]) 
    {
        if (NSIntersectsRect(rect,[obj bounds]) ) 
        {
            [obj setColor: graphColor];
            [obj stroke];
        }
    }
    
    // draw the border around the view
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:[self bounds]]; // may want to create a global window_bounds
    
}


// =========================================================================
// (IBAction) stopGraph: (id)sender
// =========================================================================
- (IBAction)stopGraph:(id)sender
{
    stop_sending = YES;
}


// =========================================================================
// (IBAction) zoomIn: (id)sender
// =========================================================================
- (IBAction) zoomIn: (id)sender
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;

    temp_xmin = temp_xmin / 2.0 + xavg/2.0;
    temp_xmax = temp_xmax / 2.0 + xavg/2.0;
    temp_ymin = temp_ymin / 2.0 + yavg/2.0;
    temp_ymax = temp_ymax / 2.0 + yavg/2.0;
    
    xstep = xstep / 2.0;
    
    zoom_factor = zoom_factor * 2.0;
    zoom_percent *= 2.0;
    
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    
    [self drawGraph];
}

// =========================================================================
// (IBAction) zoomOut: (id)sender
// =========================================================================
- (IBAction) zoomOut: (id)sender
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;
    
    temp_xmin = temp_xmin * 2.0 - xavg;
    temp_xmax = temp_xmax * 2.0 - xavg;
    temp_ymin = temp_ymin * 2.0 - yavg;
    temp_ymax = temp_ymax * 2.0 - yavg;
    
    xstep = xstep * 2.0;
    
    zoom_factor = zoom_factor / 2.0;
    zoom_percent /= 2.0;
    
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    
    [self drawGraph];
}


// =========================================================================
// (void) toolZoomIn
// =========================================================================
- (void) toolZoomIn
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;

    temp_xmin = temp_xmin / 2.0 + xavg/2.0;
    temp_xmax = temp_xmax / 2.0 + xavg/2.0;
    temp_ymin = temp_ymin / 2.0 + yavg/2.0;
    temp_ymax = temp_ymax / 2.0 + yavg/2.0;
    
    xstep = xstep / 2.0;
    
    zoom_factor = zoom_factor * 2.0;
    zoom_percent *= 2.0;
    
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    
    [self drawGraph];
}

// =========================================================================
// (void) toolZoomOut
// =========================================================================
- (void) toolZoomOut
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;
    
    temp_xmin = temp_xmin * 2.0 - xavg;
    temp_xmax = temp_xmax * 2.0 - xavg;
    temp_ymin = temp_ymin * 2.0 - yavg;
    temp_ymax = temp_ymax * 2.0 - yavg;
    
    xstep = xstep * 2.0;
    
    zoom_factor = zoom_factor / 2.0;
    zoom_percent /= 2.0;
    
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    
    [self drawGraph];
}

// =========================================================================
// (IBAction) zoomToPercent: (id) sender
// -------------------------------------------------------------------------
// Version: 27. June 2004 15:10
// Created: 2. June 2004 23:50
// =========================================================================
- (IBAction) zoomToPercent: (id) sender
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;
    
    while (zoom_percent != [[sender title] floatValue])
    {
        xavg = xmax - (xmax-xmin)/2.0;
        yavg = ymax - (ymax-ymin)/2.0;
          
        if (zoom_percent < [[sender title] floatValue])
        {
            temp_xmin = temp_xmin / 2.0 + xavg/2.0;
            temp_xmax = temp_xmax / 2.0 + xavg/2.0;
            temp_ymin = temp_ymin / 2.0 + yavg/2.0;
            temp_ymax = temp_ymax / 2.0 + yavg/2.0;
            
            xstep = xstep / 2.0;
            
            zoom_factor = zoom_factor * 2.0;
            zoom_percent *= 2.0;
        }
        else if (zoom_percent > [[sender title] floatValue])
        {
            temp_xmin = temp_xmin * 2.0 - xavg;
            temp_xmax = temp_xmax * 2.0 - xavg;
            temp_ymin = temp_ymin * 2.0 - yavg;
            temp_ymax = temp_ymax * 2.0 - yavg;
            
            xstep = xstep * 2.0;
            
            zoom_factor = zoom_factor / 2.0;
            zoom_percent /= 2.0;
        }
    }
        
   
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    [self drawGraph];
}

// =========================================================================
// (IBAction) returnToOrigin: (id) sender
// -------------------------------------------------------------------------
// Version: 2. June 2004 23:20
// Created: 2. June 2004 23:20
// =========================================================================
- (IBAction) returnToOrigin: (id) sender
{
        temp_xmin 	= -5.0 / zoom_factor; 
        temp_xmax  	= 5.0 / zoom_factor;	

        temp_ymin  	= -3.0 / zoom_factor;	
        temp_ymax  	= 3.0 / zoom_factor;
        
        [self drawGraph];
}


// =========================================================================
// (IBAction) returnToOrigin: (id) sender
// -------------------------------------------------------------------------
// Reset the graph to 100% zoom and move the graph back to the origin.
// -------------------------------------------------------------------------
// Version: 20. February 2005 11:44
// Created: 20. February 2005 11:44
// =========================================================================
- (IBAction) resetGraph: (id) sender
{
    xavg = xmax - (xmax-xmin)/2.0;
    yavg = ymax - (ymax-ymin)/2.0;
    
    while (zoom_percent != 100.0)
    {
        xavg = xmax - (xmax-xmin)/2.0;
        yavg = ymax - (ymax-ymin)/2.0;
          
        if (zoom_percent < 100.0)
        {
            temp_xmin = temp_xmin / 2.0 + xavg/2.0;
            temp_xmax = temp_xmax / 2.0 + xavg/2.0;
            temp_ymin = temp_ymin / 2.0 + yavg/2.0;
            temp_ymax = temp_ymax / 2.0 + yavg/2.0;
            
            xstep = xstep / 2.0;
            
            zoom_factor = zoom_factor * 2.0;
            zoom_percent *= 2.0;
        }
        else if (zoom_percent > 100.0)
        {
            temp_xmin = temp_xmin * 2.0 - xavg;
            temp_xmax = temp_xmax * 2.0 - xavg;
            temp_ymin = temp_ymin * 2.0 - yavg;
            temp_ymax = temp_ymax * 2.0 - yavg;
            
            xstep = xstep * 2.0;
            
            zoom_factor = zoom_factor / 2.0;
            zoom_percent /= 2.0;
        }
    }
        
    [[self window] setTitle: [[NSString alloc] initWithFormat: @"EdenGraph : %1.0f%%", zoom_percent]];
    
    [self returnToOrigin: self];

}

// =========================================================================
// (void) doStop: (int) which
// -------------------------------------------------------------------------
// =========================================================================
- (void)doStop:(int)which
{
    switch (which) 
    {
		case STOP_SENDER:
			 sending = NO;
			 break;
		case STOP_RECEIVER:
			 receiving = NO;
			 break;
    }

    if (sending==NO && receiving==NO)   // Reinitialize
    {
        [graphButton setTitle:@"Graph"];
        [graphButton setAction:@selector(graph:)];
        [graphButton setEnabled:YES];
    }

    if (sending==NO && receiving==YES)  // Wait for results data
    {
        [graphButton setEnabled:FALSE];
        [graphButton setTitle:@"Drawing"];
    }

    if (sending==YES && receiving==NO)  // A problem
    {
        NSLog(@"Synchronization error");
    }
}


// =========================================================================
// (void) gotData: (NSNotification *)not
// -------------------------------------------------------------------------
// =========================================================================
- (void)gotData:(NSNotification *)not
{
    NSData      *data;
    NSString    *str;
    NSPoint      pt;
    int          num;
    NSString    *line=0;

    data = [ [not userInfo]
             objectForKey:NSFileHandleNotificationDataItem];
    str  = [ [NSString alloc] initWithData:data
                               encoding:NSASCIIStringEncoding];

    // Add the data to the end of the text buffer
    [fromBuf appendString:str];
    [str release];

    // Register to get the notification again
    [fromEvaluator readInBackgroundAndNotify];

    // Now, process all complete lines we have
    do 
    {
        NSRange r1;

        r1 = [fromBuf rangeOfString:@"\n"];
        if (r1.length<1) break;

        line = [fromBuf substringToIndex:r1.location];
        [fromBuf
             replaceCharactersInRange:NSMakeRange(0,r1.location+1)
                          withString:@""];

        num = sscanf( [line cString], "%f, %f", &pt.x, &pt.y);
        if (num!=2) 
		{
            [self doStop:STOP_RECEIVER];
            return;
        }
		
        if (!first && !stop_sending) 
        {
			// The + 0.1 was added since there seemed to be some minute
            // precision problems if it was assumed to be EXACTLY more 
            // than xstep.  Without the 0.1, the drawing became a bunch
            // of jagged lines.
            // Where [precisionSlider floatValue] is, this used to be 0.1
            if ( fabs(lastPt.x - pt.x) > ( xstep + [precisionSlider floatValue]) )
            {
                lastPt.x = pt.x;
                lastPt.y = pt.y;
            }
            
            Segment *seg = [ [Segment alloc]
                             initFrom:lastPt to:pt ];
            [seg  setTag:GRAPH_TAG];
			[seg  autorelease];
            [self addGraphElement:seg];
        }
		
        first = NO;               // No longer first
        lastPt = pt;              // Remember this point
    } 
	while (line);
    // End of data
}



// =========================================================================
// (void) sendData
// -------------------------------------------------------------------------
// =========================================================================
- (void)sendData
{
    NSAutoreleasePool *threadPool =
                     [ [NSAutoreleasePool alloc] init];
    NSString *formula_string;
    double x;
    int i;
    //BOOL is_x = FALSE;

    formula_string = [formulaField stringValue];

    for (x=xmin; stop_sending==NO && x<=xmax; x+=xstep) 
    {

        NSMutableString *fsend =
              [NSMutableString stringWithString:@"x,"];
        NSString *xString = [NSString stringWithFormat:@"%g",x];



        [fsend appendString:formula_string];
        [fsend appendString:@"\n"];

        // Now go through the formula and change
        // every 'x' to a '%g'

        for (i=[fsend length]-1; i>=0; i--) {
            if ([fsend characterAtIndex:i] == 'x') {
                [fsend replaceCharactersInRange:NSMakeRange(i,1)
                                     withString:xString];
                //is_x = TRUE;
            }
        }
        
        //NSLog(@"fsend string: %@", fsend);
        
/*        
        if (is_x == FALSE)
        {
            [fsend appendString:@"+(0)\n"];
        }

        // This is probably where I need to add the MathLink code.
        // Or in the gotData method.
        // Example type code
		
        if ( ( [kernelType isEqual: "Mathematica 4.1"] == YES ) ||
             ( [kernelType isEqual: "Mathematica 4.2"] == YES ) 
             ( [kernelType isEqual: "Mathematica 5.0"] == YES ) )
        {
            MLPutFunction(lp, "EvaluatePacket", 1);
            MLPutFunction(lp, "ToExpression", 1);
            MLPutString(lp, expr);
            MLEndPacket(lp);

            while (MLNextPacket(lp) != RETURNPKT) MLNewPacket(lp);

            MLGetFloat(lp, &sum);
        }
*/

        // Send this to the other side
        [toEvaluator writeData:
               [fsend dataUsingEncoding:NSASCIIStringEncoding
                   allowLossyConversion:YES] ];
    }
    // Now send through the termination code
    [toEvaluator writeData:[@"999\n"
         dataUsingEncoding:NSASCIIStringEncoding
      allowLossyConversion:YES] ];

    [self doStop:STOP_SENDER];

    // When this returns, our thread will die.
    [threadPool release];
}


// =========================================================================
// (void) clear
// -------------------------------------------------------------------------
// This seems to be called repeatedly, probably from some other drawing
// function to empty out the displayList before it draws again...
// =========================================================================
- (void) clear
{
    [displayList removeAllObjects];
    [self setNeedsDisplay:YES];
}

// =========================================================================
// (IBAction) clearGraph: (id) sender
// -------------------------------------------------------------------------
// Version: 19. June 2004 19:24
// -------------------------------------------------------------------------
// This is called from the menu item Clear which erases the typing in the
// formula field and then clears out the displayList and refreshes the 
// screen.  Instead of calling the clear function, the displayList was
// emptied and the drawGraph function was called so the axes will not
// disappear when the graph is cleared.
// =========================================================================
- (IBAction) clearGraph: (id) sender
{
    [ [self window] makeFirstResponder:self]; 	// try and add this so 
                                                // Clear stops locking up
    [formulaField setStringValue: @""];
    [displayList removeAllObjects];
    [self drawGraph];
}


// =========================================================================
// (void) addGraphElement: (id) element
// -------------------------------------------------------------------------
// =========================================================================
- (void)addGraphElement:(id)element
{
    [displayList addObject:element];
    [self setNeedsDisplayInRect:[element bounds]];
}


// =========================================================================
// (void) getFormAndScaleView
// -------------------------------------------------------------------------
// Author: Chad Armstrong
// Updated: 4. October 2002
// Note: needed to add these lines:
// [self removeTrackingRect:trackingRect];
// trackingRect = [self addTrackingRect: [self visibleRect] owner:self userData:nil
//                      assumeInside:NO];
// for he mouseEntered: and mouseExited: functions to work.
// =========================================================================
- (void)getFormAndScaleView
{
    xmin  = temp_xmin; // -5.0; //[xminCell doubleValue];
    xmax  = temp_xmax; // 5.0; //[xmaxCell doubleValue];
    // xstep = 0.1; //[xstepCell doubleValue];
    ymin  = temp_ymin; // -3.0; //[yminCell doubleValue];
    ymax  = temp_ymax; // 3.0; //[ymaxCell doubleValue];
    [self setBounds:(NSMakeRect(xmin, ymin, xmax-xmin,
                                            ymax-ymin) ) ];
                                            
    [self removeTrackingRect:trackingRect];
    // [self getFormAndScaleView];  // this crashes or causes errors, so don't use
                                    // it seems to work just fine without...
    trackingRect = [self addTrackingRect: [self visibleRect] owner:self userData:nil assumeInside:NO];
    [self setNeedsDisplay:YES];
}


// =========================================================================
// (BOOL) isOpaque
// -------------------------------------------------------------------------
// =========================================================================
-(BOOL)isOpaque { return YES; }   // Because GraphView is opaque


// =========================================================================
// (void) addAxesFrom: (NSPoint)pt1 to:(NSPoint)pt2
// -------------------------------------------------------------------------
// =========================================================================
- (void)addAxesFrom:(NSPoint)pt1 to:(NSPoint)pt2
{
    Segment *seg = [ [Segment alloc] initFrom:pt1 to:pt2];
    [seg  setTag:AXES_TAG];
    [seg setAxesColor: axesColor];
    [seg  autorelease];
    [self addGraphElement:seg];
}

// =========================================================================
// (void) addGrid: (NSPoint)pt1 to:(NSPoint)pt2
// -------------------------------------------------------------------------
// =========================================================================
- (void) addGrid: (NSPoint)pt1 to:(NSPoint)pt2
{
    Segment *seg = [ [Segment alloc] initFrom:pt1 to:pt2];
    [seg  setTag:GRID_TAG];
    [seg setGridColor: gridColor];
    [seg  autorelease];
    [self addGraphElement:seg];
}


// =========================================================================
// (void) setAxesColor: (id) sender
// -------------------------------------------------------------------------
// Version: 24. November 2003 11:11
// Created: 24. November 2003 11:11
// =========================================================================
- (void) setAxesColor:(id)sender
{
    [axesColor autorelease];
    axesColor = [[sender color] retain];
    
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: axesColor];
    [prefs setObject:colorAsData forKey:@"Axes Color"];
    
    [self drawGraph];    
}

// Links on working with Preferences
// http://www.macdevcenter.com/pub/a/mac/2001/09/17/cocoa.html?page=5
// http://www.projectomega.org/article.php?lg=en&php=tuts_cocoa3&p=2
// =========================================================================
// (void) setBGColor: (id) sender
// -------------------------------------------------------------------------
// =========================================================================
- (void) setBGColor:(id)sender
{
    [backgroundColor autorelease];
    backgroundColor = [[sender color] retain];
    
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: backgroundColor];
    [prefs setObject:colorAsData forKey:@"Background Color"];
    
    [self setNeedsDisplay:YES];
}

// =========================================================================
// (void) setGraphColor: (id) sender
// -------------------------------------------------------------------------
// =========================================================================
- (void) setGraphColor:(id)sender
{
    [graphColor autorelease];
    graphColor = [[sender color] retain];
    
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: graphColor];
    [prefs setObject:colorAsData forKey:@"Graph Color"];
    
    [self setNeedsDisplay:YES];
}

// =========================================================================
// (void) setGridColor: (id) sender
// -------------------------------------------------------------------------
// =========================================================================
- (void) setGridColor:(id)sender
{
    [gridColor autorelease];
    gridColor = [[sender color] retain];
    
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject: gridColor];
    [prefs setObject:colorAsData forKey:@"Grid Color"];
    
    [self drawGraph];
}

// =========================================================================
// (IBAction) setPrecision: (id) sender
// -------------------------------------------------------------------------
// Version: 28. July 2003
// Created: 11. July 2003
// -------------------------------------------------------------------------
// This isn't completely correct.  Will probably just need a multiplier
// instead of directly changing xstep, since xstep changes with zooms,
// so changing the precision when zoomed in or out mucks things up.
// =========================================================================
- (IBAction) setPrecision: (id) sender
{   
    if ([precisionSlider floatValue] < 0.1)
    {
        xstep = 0.1 + fabs([precisionSlider floatValue] - 0.1);
    }
    else
    {
        xstep = 0.1 - fabs([precisionSlider floatValue] - 0.1);
    }
    
    if (xstep <= 0.001)
    {
        xstep = 0.001;
    }
    
    [prefs setFloat: xstep forKey:@"Precision"];
    
    [self drawGraph];
}


// =========================================================================
// (IBAction) setNudge: (id) sender
// -------------------------------------------------------------------------
// Version: 28. July 2003
// Created: 11. July 2003
// -------------------------------------------------------------------------
// Set the nudge_step variable
// =========================================================================
- (IBAction) setNudge: (id) sender
{   
    nudge_step = [nudgeSlider floatValue];
    
    NSLog(@"nudge_step: %f", nudge_step);
    
    [prefs setFloat: nudge_step forKey:@"Nudge"];
    
    [self drawGraph];
}


// =========================================================================
// (void) saveDocumentTo: (id) sender
// -------------------------------------------------------------------------
// =========================================================================
- (IBAction) saveDocumentTo: (id) sender
{    
    [[NSNotificationCenter defaultCenter] 
            postNotificationName:@"SaveImageNotification" object: nil];
}


// =========================================================================
// (IBAction) checkForNewVersion: (id) sender
// -------------------------------------------------------------------------
// Version: 19. August 2003 2:54
// -------------------------------------------------------------------------
// Added some new code to check if there is no network connection present.
// This resulted when the !%@# network went down at my house.  I learned
// something, but I still want my internet!  Screw MTV!  I want the Internet!
// =========================================================================
- (IBAction) checkForNewVersion: (id) sender
{
	NSString *currentVersionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *productVersionDict = [NSDictionary dictionaryWithContentsOfURL: [NSURL URLWithString:@"http://www.edenwaith.com/version.xml"]];
    NSString *latestVersionNumber = [productVersionDict valueForKey:@"EdenGraph"];

    int button = 0;

    if ( latestVersionNumber == nil )
    {
        NSBeep();
        NSRunAlertPanel(@"Could not check for update", @"A problem arose while attempting to check for a new version of EdenGraph.  Edenwaith.com may be temporarily unavailable or your network may be down.", @"OK", nil, nil);
    }
    else if ( [latestVersionNumber isEqualTo: currentVersionNumber] )
    {
        NSRunAlertPanel(@"Software is Up-To-Date", @"You have the most recent version of EdenGraph.", @"OK", nil, nil);
    }
    else
    {
		button = NSRunAlertPanel(@"New Version is Available", @"Version %@ of EdenGraph is available.", @"Download", @"Cancel", @"More Info", latestVersionNumber);
        
        if (NSOKButton == button) // Download
        {
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://www.edenwaith.com/downloads/edengraph.php"]];
        }
        else if (NSAlertOtherReturn == button) // More Info
        {
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://www.edenwaith.com/products/edengraph/index.php"]];
        }
    }
}

// =========================================================================
// (IBAction) goToProductPage: (id) sender
// -------------------------------------------------------------------------
// Version: 10. March 2004 19:33
// Created: 10. March 2004 19:33
// -------------------------------------------------------------------------
// =========================================================================
- (IBAction) goToProductPage: (id) sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"http://www.edenwaith.com/products/edengraph/"]];
}


// =========================================================================
// (IBAction) feedBack: (id) sender
// -------------------------------------------------------------------------
// Version: 19 May 2006 21:48
// =========================================================================
- (IBAction) feedBack: (id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:support@edenwaith.com?Subject=EdenGraph%20Feedback"]];

}


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
        [delete_equation_button setEnabled: YES];
    }
    else
    {
        [delete_equation_button setEnabled: NO];
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
    int index 	= 0;
    int i	= 0;
    
    // add three since the first three slots of the Equations menu are already filled up
    index = rowIndex+3;

	// It cannot be blank
	// It cannot previously or currently exist
	// If this is new, it cannot match anything else already existing
	// if the changed/added item is not empty
	// If this is a valid item, make sure it has proper placing in the table list and menu
	if ( [object isEqualTo: @""] == NO && 
		([equationsList containsObject: object] == NO || ([equationsList containsObject: object] == YES && [equationsList indexOfObject: object] == rowIndex)) )
    {
        [equationsMenu removeItemAtIndex: index];
        [equationsMenu insertItemWithTitle: object action:@selector(insertEquation:) keyEquivalent: @"" atIndex: index];
        [equationsList replaceObjectAtIndex:rowIndex withObject:object];        
    }
    else // if the selection is empty or a duplicate equation
    {
        // check if this is a new item?
        [equationsMenu removeItemAtIndex: index];
        [equationsList removeObjectAtIndex: rowIndex];
        
        // Erase an unnecessary empty spaces in the menu
        if ( [equationsList count] == 0 )
        {
            if ( [equationsMenu numberOfItems] > 2 )
            {
                for (i = [equationsMenu numberOfItems] - 1; i >= 2; i--)
                {
                    [equationsMenu removeItemAtIndex: i];
                }
            }
        }
        
    }
    
    [equationsList writeToFile:equationsFile atomically:YES];

    [equationsTable reloadData]; // refresh the table

}

// =========================================================================
// (IBAction) addEquation: (id) sender
// -------------------------------------------------------------------------
// Version: 27. June 2004 15:19
// Created: 24 May 2006
// -------------------------------------------------------------------------
// This is called from the Save Equation menu item.
// Need to check that the item isn't already in the list.  This should be 
// a simple check through the array before adding.  Also, the equation
// shouldn't be empty.
// =========================================================================
- (IBAction) addEquation : (id) sender
{
    if ( [equationsList containsObject: [formulaField stringValue]] == NO &&
         [[formulaField stringValue] isEqual: @""] == NO)
    {
        // if there are no items yet, add a spacer into the menu
        if ([equationsList count] == 0)
        {
			[equationsMenu addItem: [NSMenuItem separatorItem]];
        }
    
        [equationsList addObject: [formulaField stringValue]];
        [equationsMenu addItemWithTitle: [formulaField stringValue] action:@selector(insertEquation:) keyEquivalent: @""];
        
        [equationsList writeToFile:equationsFile atomically:YES];
		
		[equationsTable reloadData];
    }
}


// =========================================================================
// (IBAction) addNewEquation: (id) sender
// -------------------------------------------------------------------------
// Version: 19. June 2004 19:49
// Created: 24 May 2006
// -------------------------------------------------------------------------
// Add a new equation in the Equations editor window by clicking on the +
// symbol
// =========================================================================
- (IBAction) addNewEquation : (id) sender
{
    // if there are no items yet, add a spacer into the menu
    if ([equationsList count] == 0)
    {
		[equationsMenu addItem: [NSMenuItem separatorItem]];
    }
    

    [equationsList addObject: @""];
    [equationsMenu addItemWithTitle: @"" action:@selector(insertEquation:) keyEquivalent: @""];
	
	[equationsTable reloadData];
    
	// Due to compiling as an 'older' application, this code kept jumping to the next step,
	// but it viewed this as running on Jaguar.
    if (os_version < 1030) // if using before Mac OS 10.3
    {
        [equationsTable selectRow:[equationsList count]-1 byExtendingSelection: YES];
    }
    else
    {
    #ifdef os_version >= 1030

		[equationsTable selectRow:[equationsList count]-1 byExtendingSelection: YES];
		
		// A bunch of experimental equations and such...
		// [[equationsTable selectedRowIndexes] lastIndex]
		// [[NSIndexSet alloc] initWithIndex:indexOfCompletion];
		// [equationsTable selectedRowIndexes: [[NSIndexSet alloc] initWithIndex:5] byExtendingSelection:YES];
        // [equationsTable selectedRowIndexes: el_count-1 byExtendingSelection:YES];
		// [equationsTable reloadData];
	#else
		[equationsTable selectRow:[equationsList count]-1 byExtendingSelection: YES];
    #endif
    }

	[equationsTable editColumn: 0 row:[equationsList count] - 1 withEvent: nil select: YES];
    
}


// =========================================================================
// (IBAction) editEquations: (id) sender
// -------------------------------------------------------------------------
// Created: 13. June 2004 15:41
// Version: 20 July 2006 21:53
// -------------------------------------------------------------------------
// Drop down the equations sheet to add, delete, and modify equations.
// =========================================================================
- (IBAction) editEquations : (id) sender
{

    [NSApp beginSheet:equationsSheet modalForWindow: Window
                modalDelegate:nil didEndSelector:nil contextInfo:nil];

		// Reveal the scroll bar if there are a lot (generally more than 10) of saved equations
	if ([equationsList count] > 0)
	{
		[equationsTable reloadData];
	}

    [NSApp runModalForWindow:equationsSheet];
	      
    [NSApp endSheet: equationsSheet];
    [equationsSheet orderOut:self];
    
}


// =========================================================================
// (IBAction) closeEquationsSheet: (id) sender
// -------------------------------------------------------------------------
// Version: 13. June 2004 15:44
// Created: 13. June 2004 15:44
// -------------------------------------------------------------------------
// Need to save the lists, table, etc. when closing to make sure that any
// new and/or edited data is saved.
// =========================================================================
- (IBAction) closeEquationsSheet : (id) sender
{   
    [NSApp stopModal];
	
    [equationsTable deselectAll:self];
}


// =========================================================================
// (IBAction) deleteEquation: (id) sender
// -------------------------------------------------------------------------
// Version: 27. June 2004 15:13
// Created: 17. June 2004 23:23
// =========================================================================
- (IBAction) deleteEquation: (id) sender
{
    NSEnumerator *enumerator;
    NSNumber *index;
    NSMutableArray *tempArray  = [[NSMutableArray alloc] init];
    id tempObject;
    int temp_index;
 
    if ( [equationsTable numberOfSelectedRows] > 0 )
    {
        enumerator = [equationsTable selectedRowEnumerator];
        
        while ( (index = [enumerator nextObject]) ) 
        {
            tempObject = [equationsList objectAtIndex:[index intValue]];
            [tempArray addObject:tempObject];
            
            temp_index = [equationsMenu indexOfItemWithTitle: tempObject];
            [equationsMenu removeItemAtIndex: temp_index];
        }
 
        [equationsList removeObjectsInArray:tempArray];
        [tempArray release];
        
        if ([equationsList count] == 0)
        {
            [equationsMenu removeItemAtIndex: 2]; // assume that the spacer is
                                                  // at index 2 for now.
        }
        
        [equationsList writeToFile:equationsFile atomically:YES];
        
        [equationsTable reloadData];
   }

}


// =========================================================================
// (IBAction) insertEquation: (id) sender
// -------------------------------------------------------------------------
// Version: 13. June 2004 15:44
// Created: 25. August 2005 21:47
// =========================================================================
- (IBAction) insertEquation : (id) sender
{
    [formulaField setStringValue: [sender title]];
    [ [self window] makeFirstResponder:formulaField];
    [self graph:self];	// Make this call instead of drawGraph so
                        // the equation is parsed properly.
}

// =========================================================================
// (void) checkOSVersion
// -------------------------------------------------------------------------
// Version: 22. September 2004
// Created: 15 April 2007 0:08
// -------------------------------------------------------------------------
// Might want to also check out this command: sw_vers -productVersion
// Is there a way to call this as a built in function like getuid(), or
// would I probably need to declare a new NSTask and run through those
// motions instead?
// =========================================================================
- (void) checkOSVersion
{
    if ( floor(NSAppKitVersionNumber) <= 577 )
    {
        os_version = 1000;
    }
    else if ( floor(NSAppKitVersionNumber) <= 620 )
    {
        os_version = 1010;
    }
    else if ( floor(NSAppKitVersionNumber) <= 663)
    {
        os_version = 1020;
    }
    else if ( floor(NSAppKitVersionNumber) <= 743) 
    {
        os_version = 1030;
    }
	else
	{
        os_version = 1040;
    }
}

// =========================================================================
// EXPERIMENTAL CODE
// =========================================================================

// =========================================================================
// (IBAction) setKernel : (id) sender
// -------------------------------------------------------------------------
// Experimental code used to try and use Mathematica's MathKernel as the 
// backend math processor for EdenGraph
// =========================================================================
- (IBAction) setKernel : (id) sender
{
    
    if ([kernelType isEqual: [kernelButton titleOfSelectedItem]] == YES)
    {
        NSLog(@"This is kernel is already running.");
    }
    else
    {
        NSLog(@"Old: %@ New kernel: %@", kernelType, [kernelButton titleOfSelectedItem]);
        [kernelType setString: [kernelButton titleOfSelectedItem]];
        
        NSData *textAsData = [NSArchiver archivedDataWithRootObject: [kernelButton titleOfSelectedItem]];
        [prefs setObject:textAsData forKey: @"Kernel Type"];
/*        
        if ([ [kernelButton titleOfSelectedItem] isEqual: @"EdenGraph" ])
        {
            MLClose(lp);
            MLDeinitialize(env);
        }
        else  // for now, assume some form of Mathematica
        {
            env = MLInitialize(NULL);
    
            if (env == NULL)
            {
                NSBeep();
                NSRunAlertPanel(@"Error", @"MathLink Environment could not be initialized.", @"OK", nil, nil);
                [kernelButton selectItemWithTitle:@"EdenGraph"];
                [kernelType setString: [kernelButton titleOfSelectedItem]];
            }
            else
            {
                if ([ [kernelButton titleOfSelectedItem] isEqual: @"Mathematica 4.1"] == YES)
                {
                    argv[1] = " '/Applications/Mathematica 4.1.app/Contents/MacOS/MathKernel' -mathlink";
                }
                else if ([ [kernelButton titleOfSelectedItem] isEqual: @"Mathematica 4.2"] == YES)
                {
                    argv[1] = " '/Applications/Mathematica 4.2.app/Contents/MacOS/MathKernel' -mathlink";
                }
                else if ([ [kernelButton titleOfSelectedItem] isEqual: @"Mathematica 5.0"] == YES)
                {
                    argv[1] = " '/Applications/Mathematica 5.0.app/Contents/MacOS/MathKernel' -mathlink";
                } 
                
                printf("---------------------\n");
                printf("argc: %d\n", argc);
                printf("argv[0]: %s\n", argv[0]);
                printf("argv[1]: %s\n", argv[1]);
                printf("argv[2]: %s\n", argv[2]);
                printf("argv[3]: %s\n", argv[3]);
                printf("argv[4]: %s\n", argv[4]);
                printf("---------------------\n");
    
                lp = MLOpen(argc, argv);
    
                if (lp == NULL)
                {
                    NSBeep();
                    NSRunAlertPanel(@"Error", @"MathLink could not be opened.", @"OK", nil, nil);
                    [kernelButton selectItemWithTitle:@"EdenGraph"];
                    [kernelType setString: [kernelButton titleOfSelectedItem]];
                }
            }
        }
*/        
    }

}

@end
