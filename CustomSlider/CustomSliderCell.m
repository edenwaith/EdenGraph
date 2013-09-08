//
//  CustomSliderCell.m
//  EdenGraph
//
//  Created by Chad Armstrong on 5/9/09.
//  Copyright 2009 Edenwaith. All rights reserved.
//
// Code referenced from: http://www.cocoabuilder.com/archive/message/cocoa/2005/7/11/141445

#import "CustomSliderCell.h"

static NSImage * _knobOff;
static NSImage * _knobOn;

@implementation CustomSliderCell

-(id)init
{
    self = [super init];
	_knobOff = [[NSImage imageNamed:@"volumeslider_normal"] retain];
	_knobOn = [[NSImage imageNamed:@"volumeslider_blue"] retain];
    return self;
}

- (void)dealloc
{
    [_knobOff release];
    [_knobOn release];
    [super dealloc];
}

- (void)drawKnob:(NSRect)knobRect
{
    NSImage * knob;
	
    if (isDown)
        knob = _knobOn;
    else
        knob = _knobOff;
	
    [[self controlView] lockFocus];
    [knob  compositeToPoint:NSMakePoint(knobRect.origin.x, knobRect.origin.y+knobRect.size.height) 
				  operation:NSCompositeSourceOver];
    [[self controlView] unlockFocus];
}

- (void) stopTracking: (NSPoint)lastPoint at: (NSPoint)stopPoint inView: (NSView *)controlView mouseIsUp:(BOOL)flag
{
    isDown = NO;
    [self drawKnob];
    [super stopTracking:lastPoint at:stopPoint inView:controlView  
			  mouseIsUp:flag];
}

- (BOOL) startTrackingAt: (NSPoint)startPoint inView: (NSView *)controlView
{
    isDown = YES;
    [self drawKnob];
    return [super startTrackingAt:startPoint inView:controlView];
}

@end
