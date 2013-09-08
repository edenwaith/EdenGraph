//
//  CustomSlider.h
//  EdenGraph
//
//  Created by Chad Armstrong on 5/9/09.
//  Copyright 2009 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomSliderCell.h"

@interface CustomSlider : NSSlider 
{

}

- (void) scrollWheel:(NSEvent *) event;

@end
