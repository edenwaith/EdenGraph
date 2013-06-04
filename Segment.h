//
//  Segment.h
//  EdenGraph
//
//  Created by admin on Fri Jun 07 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EGView.h"

@interface Segment : NSObject <EGElement>
{
    NSPoint	start;
    NSPoint	end;
    NSColor	*color;
    NSColor	*axes_color;
    NSColor	*grid_color;
    int		tag;
}

- initFrom:(NSPoint)start to:(NSPoint)end;
- (void) printBounds;
- (NSPoint) segmentCenter;
- (void)setAxesColor:(NSColor *)aColor;
- (void)setGridColor:(NSColor *)aColor;
@end
