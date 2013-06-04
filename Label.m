//
//  Label.m
//  EdenGraph
//
//  Created by admin on Fri Jun 07 2002.
//

#import "Label.h"

@implementation Label

- initRect:(NSRect)aBounds text:(NSString *)aText
                           size:(float)aSize
{
    [super init];
    bounds = aBounds;

    font  = [NSFont fontWithName:@"Times-Roman" size:aSize];
    dict  = [ [NSMutableDictionary alloc] init];
    [dict setObject:font forKey:NSFontAttributeName];

    text  = [ [NSMutableAttributedString alloc]
               initWithString:aText attributes:dict];
    [self  setColor:[NSColor blackColor] ];
    return self;
}


- (void)dealloc
{
    [dict release];
    [text release];
    [super dealloc];
}


- (NSRect)bounds
{
	return bounds;
}


- (int) tag
{
	return tag;
}


- (void) setTag: (int) aTag
{
	tag=aTag;
}


- (void) setColor: (NSColor *) aColor
{
    [dict setObject:aColor forKey:NSForegroundColorAttributeName];
    [text setAttributes:dict range:NSMakeRange(0,[text length])];

    // Now reapply the alignment because of a Cocoa bug
    [text setAlignment:NSCenterTextAlignment
          range:NSMakeRange(0,[text length])];
}


- (NSColor *)color
{
    return color;
}


// This one works, but it requires a subview
// Note: Modified from G&M first edition so that subview isn't
// recreated each time the view is drawn
- (void) stroke
{
    NSView *fv = [NSView focusView];
    NSView *tempView = nil;

    tempView = [ [NSView alloc] initWithFrame:bounds];

    [fv addSubview:tempView];		// put the subview in

    // Scale the tempView to screen coordinates
    [tempView setBounds:
              [tempView convertRect:[self bounds] toView:nil] ];

    [tempView lockFocus];
    [color set];
    [text drawInRect:[tempView bounds] ];
    [tempView unlockFocus];
    [tempView removeFromSuperviewWithoutNeedingDisplay]; // remove the subview
    [tempView release];
}


@end