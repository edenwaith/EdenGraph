//
//  CustomSlider.m
//  EdenGraph
//
//  Created by Chad Armstrong on 5/9/09.
//  Copyright 2009 Edenwaith. All rights reserved.
//
// Code referenced from: http://www.cocoabuilder.com/archive/message/cocoa/2005/7/11/141522

#import "CustomSlider.h"

@implementation CustomSlider

- (void)awakeFromNib
{	
    if ([[self cell] class] != [CustomSliderCell class]) {
        // replace cell
        NSSliderCell *oldCell = [self cell];
        NSSliderCell *newCell = [[[CustomSliderCell alloc] init]  autorelease];
		
        [newCell setTag:[oldCell tag]];
        [newCell setTarget:[oldCell target]];
        [newCell setAction:[oldCell action]];
        [newCell setControlSize:[oldCell controlSize]];
        [newCell setType:[oldCell type]];
        [newCell setState:[oldCell state]];
        [newCell setAllowsTickMarkValuesOnly:[oldCell  
											  allowsTickMarkValuesOnly]];
        [newCell setAltIncrementValue:[oldCell altIncrementValue]];
        [newCell setControlTint:[oldCell controlTint]];
        [newCell setKnobThickness:[oldCell knobThickness]];
        [newCell setMaxValue:[oldCell maxValue]];
        [newCell setMinValue:[oldCell minValue]];
        [newCell setDoubleValue:[oldCell doubleValue]];
        [newCell setNumberOfTickMarks:[oldCell numberOfTickMarks]];
        [newCell setSliderType:[oldCell sliderType]];
        [newCell setEditable:[oldCell isEditable]];
        [newCell setEnabled:[oldCell isEnabled]];
        [newCell setEntryType:[oldCell entryType]];
        [newCell setFocusRingType:[oldCell focusRingType]];
        [newCell setHighlighted:[oldCell isHighlighted]];
        [newCell setTickMarkPosition:[oldCell tickMarkPosition]];
		
        [self setCell:newCell];
    }	
}

#pragma mark -
#pragma mark Scroll Wheel Method

- (void) scrollWheel:(NSEvent *) event
{
	float range = [self maxValue] - [self minValue];
	float increment = (range * [event deltaY]) / 100;
	float val = [self floatValue] + increment;
	
	BOOL wrapValue = ([[self cell] sliderType] == NSCircularSlider);
	
	if (wrapValue)
	{
		if (val < [self minValue])
			val = [self maxValue] - fabs(increment);
		
		if (val > [self maxValue])
			val = [self minValue] + fabs(increment);
	}
	
	[self setFloatValue:val];
	[self sendAction:[self action] to:[self target]];		  
}

@end
