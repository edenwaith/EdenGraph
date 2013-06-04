#import "EGController.h"

@implementation EGController

- (id) init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self 
            selector:@selector(saveDocumentTo2:) 
            name:@"SaveImageNotification" 
            object:nil];
    }
    
    return self;
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self name: @"SaveImageNotification" object: nil];
}


- (EGView *)egView
{
        return egView;
}


- (NSData *) PDFForView:(NSView *)aView
{
    NSData *pdf;
    
    pdf = [[aView superview] dataWithPDFInsideRect: [aView frame]];     

    return pdf;
}


- (NSData *) TIFFForView: (NSView *)aView
{
    NSImage *image = [[NSImage alloc] initWithData: [self PDFForView:aView]];
    
    [image autorelease];
    
    return [image TIFFRepresentation];
}

- (NSData *) EPSForView: (NSView *)aView
{
    NSData *eps;

    eps = [[aView superview] dataWithEPSInsideRect: [aView frame]]; 
    
    return eps;
}

// To be able to get both the 'Format: ' string and the NSPopUpButton to be in the 
// save panel, I needed to select both the string and the pop up button, then go to
// Layout -> Make Subview Of -> Custom View.  This way, I can put the entire view
// into the save panel.
- (IBAction) saveDocumentTo2: (id) sender
{

    saveType = 2; // TIFF
        
    savePanel = [[NSSavePanel savePanel] retain];
    [savePanel setTitle:@"Save Graph"];
    [savePanel setRequiredFileType: [ [ [savePopUpMenu selectedCell] title] lowercaseString] ];
    
    [savePanel setAccessoryView: saveView];
    
    [saveView retain];
    
    [savePanel beginSheetForDirectory: nil
               file: @"Untitled" // nil
               modalForWindow: [egView window]
               modalDelegate: self
               didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:)
               contextInfo:nil];
}


- (void) savePanelDidEnd: (NSSavePanel *)sheet returnCode:(int) returnCode contextInfo:(void *)contextInfo
{
    
    NSData *image;
    NSString *fileType = [[[savePopUpMenu selectedCell] title] lowercaseString]; 
    
    if (0 == returnCode) return; // User did not click on OK, so do nothing
    
    if ([fileType isEqualToString:@"pdf"])
    {
        image =  [self PDFForView:egView];
    }
    else if ([fileType isEqualToString:@"tiff"])
    {
        image = [self TIFFForView:egView];
    }
    else if ([fileType isEqualToString:@"eps"])
    {
        image = [self EPSForView:egView];
    }
    else
    {
        image = [self TIFFForView:egView];
    }
    
    if ([image writeToFile:[sheet filename] atomically:NO]==NO)
    {
        NSRunAlertPanel(nil, @"Cannot save file '%@': %s", nil, nil, nil, [sheet filename], strerror(errno));
    }
    
}


- (IBAction) setSaveType: (id) sender
{
    [savePanel setRequiredFileType: [ [ [ sender selectedCell] title] lowercaseString] ];
}


@end
