//
//  ToolbarDelegateCategory.h
//  EdenGraph
//
//  Created by admin on Sat 7 September 2002.
//  Copyright (c) 2002 Edenwaith. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EGView.h"

@interface EGView (ToolbarDelegateCategory)

- (void) setupToolbar;
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
    itemForItemIdentifier:(NSString *)itemIdentifier
    willBeInsertedIntoToolbar:(BOOL)flag;
- (void) toolbarWillAddItem: (NSNotification *) notif;    
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem;

@end
