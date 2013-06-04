//
//  TheParser.h
//  EGParser
//
//  Created by Chad Armstrong on Wed Jun 04 2003.
//  Copyright (c) 2003 Edenwaith. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ctype.h>


@interface TheParser : NSObject 
{
    NSMutableString *newFormula;
}

- (NSString *) newFormula;
- (void) checkFormula: (id) formula;
- (BOOL) recurse: (id) formula index: (int) index inc: (int) inc;

@end
