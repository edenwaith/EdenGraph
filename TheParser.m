//
//  TheParser.m
//  EGParser
//
//  Created by Chad Armstrong on Wed Jun 04 2003.
//  Copyright (c) 2003 Edenwaith. All rights reserved.
//
//  Version 0.6
//  This parser corrects a user's mistakes when typing in a
//  mathematical formula so EdenGraph's Evaluator can interpret
//  the expression properly.
//
//  Version 0.6 allows expressions like 3x, 4 x, or even 3 x 9
//  to be evaluated and corrected properly.
//
//  Version 1.0 will be able to correctly find any missing
//  multiplication signs and try to identify odd errors.
//  To declare: TheParser *parser;
//  To call: [parser checkFormula: [[formulaField stringValue] lowercaseString]];

#import "TheParser.h"


@implementation TheParser

// =========================================================================
// (id) init 
// -------------------------------------------------------------------------
//
// -------------------------------------------------------------------------
// Version: 4. June 2003
// Created: 4. June 2003
// =========================================================================
- (id) init
{
    newFormula = [[NSMutableString alloc] init];
    
    return self;
}

// =========================================================================
// (void) dealloc 
// -------------------------------------------------------------------------
//
// -------------------------------------------------------------------------
// Version: 4. June 2003
// Created: 4. June 2003
// =========================================================================
- (void) dealloc
{
    [super dealloc];
}

// =========================================================================
// (NSString *) newFormula 
// -------------------------------------------------------------------------
//
// -------------------------------------------------------------------------
// Version: 4. June 2003
// Created: 4. June 2003
// =========================================================================
- (NSString *) newFormula
{
    return newFormula;
}

// =========================================================================
// (void) checkFormula: (id) formula 
// -------------------------------------------------------------------------
// use something like this...
// [newFormula insertString:@" * " atIndex:i];
//
// Changed newFormula = [formula lowercaseString]; to
// [newFormula setString: [formula lowercaseString]]; to avoid Mac OS 10.1
// incompatability errors.
// -------------------------------------------------------------------------
// Version: 13. November 2003 1:06
// Created: 4. June 2003
// =========================================================================
- (void) checkFormula: (id) formula
{
    int i 	= 0;
    int sLength = 0;
    
    [newFormula setString: [formula lowercaseString]];
    
    sLength = [newFormula length];
   
    for (i = 0; i < sLength; i++)
    {
        
        if ([newFormula characterAtIndex:i] == 'x')
        {           
            if (i > 0 &&
            [self recurse: newFormula index: i-1 inc: -1] == YES )
            {
                [newFormula insertString:@"*" atIndex:i];
                i++;
                sLength++;
            }

            // Remember: arrays start at index 0, but the
            // sLength starts at 1.  So sLength needs to be
            // offset by 1 to prevent out of array bound errors.
            if (i < sLength-1 && 
               [self recurse: newFormula index: i+1 inc: +1] == YES )
            {
                [newFormula insertString:@"*" atIndex:i+1];
                i++;
                sLength++;
            }
            
        }
    }
    
    for (i = 0; i < sLength; i++)
    {
        // Need to have a check that i+1 doesn't go out of bounds.
        if ([newFormula characterAtIndex:i] == 'x')
        {
            if (i-1 < 0 || i+1 >= sLength)
            {
                [newFormula insertString:@"(" atIndex:i];
                [newFormula insertString:@")" atIndex:i+2];
                i++;
                sLength = sLength + 2;
            }
            else if ([newFormula characterAtIndex:i-1] != '(' &&
            [newFormula characterAtIndex:i+1] != ')')
            {
                [newFormula insertString:@"(" atIndex:i];
                [newFormula insertString:@")" atIndex:i+2];
                i++;
                sLength = sLength + 2;
            }
        }
    }
    

}


// =========================================================================
// (BOOL) recurse: (NSString *) formula index: (int) index inc: (int) inc 
// -------------------------------------------------------------------------
//
// -------------------------------------------------------------------------
// Version: 13. November 2003 1:07
// Created: 10. June 2003
// =========================================================================
- (BOOL) recurse: (NSString *) formula index: (int) index inc: (int) inc
{
    
    if ([formula characterAtIndex:index] == ' ' )
    {
        if ( (index+inc >= 0) && (index+inc <= [formula length] - 1) )
        {
            return [self recurse: formula index: index+inc inc: inc];
        }
        else
        {
            return NO;
        }
    }
    else if ([formula characterAtIndex:index] <= '9' && 
             [formula characterAtIndex:index] >= '0')
    {
        return YES;
    }
    else if ([formula characterAtIndex:index] == 'x')
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    return NO;
}


@end
