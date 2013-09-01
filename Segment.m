//
//  Segment.m
//  EdenGraph
//
//  Created by admin on Fri Jun 07 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//

#import "Segment.h"


@implementation Segment

// Accessor methods

- initFrom: (NSPoint)theStart to:(NSPoint)theEnd
{
    [super init];  // initialize the NSObject superclass
    
    start = theStart;
    end = theEnd;
    color = [ [NSColor redColor] retain];
    grid_color = [[NSColor colorWithCalibratedRed: 0.8 green: 1.0 blue: 1.0 alpha:1.0] retain];
    axes_color = [[NSColor lightGrayColor] retain];

    return self;
}


// =========================================================================
// (int) tag
// =========================================================================
- (int) tag
{
    return (tag);
}


// =========================================================================
// (void) setTag: (int) aTag
// =========================================================================
- (void) setTag: (int) aTag
{
    tag = aTag;
}


// =========================================================================
// (void) setColor : (NSColor *) aColor
// =========================================================================
- (void)setColor:(NSColor *)aColor
{
    [color release];
    color = [aColor retain];
}

// =========================================================================
// (NSColor *) color
// =========================================================================
- (NSColor *)color
{
    return (color);
}

// =========================================================================
// (void) setAxesColor : (NSColor *) aColor
// -------------------------------------------------------------------------
// Version: 13. November 2003 13:35
// Created: 13. November 2003 13:35
// -------------------------------------------------------------------------
// =========================================================================
- (void)setAxesColor:(NSColor *)aColor
{
    [axes_color release];
    axes_color = [aColor retain];
}


// =========================================================================
// (NSColor *) axesColor
// -------------------------------------------------------------------------
// Version: 13. November 2003 13:35
// Created: 13. November 2003 13:35
// -------------------------------------------------------------------------
// =========================================================================
- (NSColor *)axesColor
{
    return (axes_color);
}


// =========================================================================
// (void) setGridColor : (NSColor *) aColor
// -------------------------------------------------------------------------
// Version: 13. November 2003 13:35
// Created: 13. November 2003 13:35
// -------------------------------------------------------------------------
// =========================================================================
- (void)setGridColor:(NSColor *)aColor
{
    [grid_color release];
    grid_color = [aColor retain];
}


// =========================================================================
// (NSColor *) gridColor
// -------------------------------------------------------------------------
// Version: 13. November 2003 13:35
// Created: 13. November 2003 13:35
// -------------------------------------------------------------------------
// =========================================================================
- (NSColor *)gridColor
{
    return (grid_color);
}


// Methods that derive info for the caller
- (NSRect)bounds
{
    return NSMakeRect( MIN(start.x, end.x), 
                       MIN(start.y, end.y), 
                       fabs(start.x-end.x) + FLT_MIN,
                       fabs(start.y-end.y) + 1.0 ); // 1.0 used to be FLT_MIN
}


// =========================================================================
// (void) printBounds
// -------------------------------------------------------------------------
// Version: 2. July 2004 19:23
// Created: 2. July 2004 19:00
// -------------------------------------------------------------------------
// =========================================================================
- (void) printBounds
{
    NSLog(@"FLT_MIN: %f Pt1: %f Pt2: %f Pt3: %f Pt4: %f", 
                        FLT_MIN, MIN(start.x, end.x), 
                        MIN(start.y, end.y), 
                        fabs(start.x-end.x) + FLT_MIN,
                        fabs(start.y-end.y) + FLT_MIN + 0.1);
}


// =========================================================================
// (NSPoint) segmentCenter
// =========================================================================
- (NSPoint) segmentCenter
{
    return NSMakePoint((start.x+end.x)/2.0, (start.y+end.y)/2.0);
}

// =========================================================================
// (void) stroke
// Reference on using -setCachesBezierPath
// http://www.oomori.com/cocoafw/ApplicationKit/NSBezierPath/cachesBezierPath.html
// =========================================================================
- (void)stroke
{
   //NSBezierPath *thePath = [NSBezierPath bezierPath];

    // Note that this program seems to loop A LOT after shifting, perhaps
    // more than it should, which might explain the 'slow downs' in tracking
    // after shifting.
    if ( [self tag] == AXES_TAG )
    {
        [ axes_color set];
//		[NSBezierPath setLineWidth: 0.05];
    }
    else if ( [self tag] == GRID_TAG )
    {
		
        [ grid_color set];
//		[NSBezierPath setLineWidth: 0.025];
    }
    else
    {
        [color set];
//		[NSBezierPath setLineWidth: 0.025];
    }
    
    //[NSBezierPath setLineJoinStyle: NSRoundLineJoinStyle];
    //[NSBezierPath setLineWidth: 1];
    [NSBezierPath strokeLineFromPoint:start toPoint:end];
    //[thePath moveToPoint: start];
    //[thePath lineToPoint: end];
    // [thePath setCachesBezierPath];
}

@end
