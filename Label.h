//
//  Label.h
//  EdenGraph
//
//  Created by admin on Fri Jun 07 2002.
//

#import <Cocoa/Cocoa.h>
#import "EGView.h"

@interface Label:NSObject <EGElement>
{
    NSRect bounds;
    NSMutableAttributedString *text;
    NSColor             *color;
    int                  tag;
    NSFont              *font;
    NSMutableDictionary *dict;
}

- initRect:(NSRect)bounds text:(NSString *)aText
                          size:(float)aSize;
@end
