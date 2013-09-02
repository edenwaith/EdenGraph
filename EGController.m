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
	
	[super dealloc];
}

- (EGView *) egView
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

// Create and generate an image for any of the following NSBitmapImageFileType types: BMP, GIF, JPG, PNG
- (NSData *) imageForView: (NSView *) aView usingType: (NSBitmapImageFileType) imageType
{
	NSImage *image = [[NSImage alloc] initWithData: [self PDFForView:aView]];
	[image autorelease];
	
    // Cache the reduced image
    NSData *imageData = [image TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:imageType properties:imageProps];  
	
	return imageData;
}

#pragma mark -

// To be able to get both the 'Format: ' string and the NSPopUpButton to be in the 
// save panel, I needed to select both the string and the pop up button, then go to
// Layout -> Make Subview Of -> Custom View.  This way, I can put the entire view
// into the save panel.
- (IBAction) saveDocumentTo2: (id) sender
{
    saveType = 5; // PNG
        
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
	else if ([fileType isEqualToString:@"eps"])
    {
        image = [self EPSForView:egView];
    }
    else if ([fileType isEqualToString:@"tiff"])
    {
        image = [self TIFFForView:egView];
    }
	else if ([fileType isEqualToString:@"bmp"])
    {
        image = [self imageForView:egView usingType:NSBMPFileType];
    }
	else if ([fileType isEqualToString:@"gif"])
    {
        image = [self imageForView:egView usingType:NSGIFFileType];
    }
	else if ([fileType isEqualToString:@"jpg"])
    {
        image = [self imageForView:egView usingType:NSJPEGFileType];
    }
	else if ([fileType isEqualToString:@"png"])
    {
        image = [self imageForView:egView usingType:NSPNGFileType];
    }
    else
    {
        image = [self TIFFForView:egView];
    }
    
    if ([image writeToFile:[sheet filename] atomically:NO]==NO)
    {
		NSString *errorMsg = NSLocalizedString(@"Cannot save file", @"Cannot save file");
        NSRunAlertPanel(nil, @"%@ '%@': %s", nil, nil, nil, errorMsg, [sheet filename], strerror(errno));
    }
}

- (IBAction) setSaveType: (id) sender
{
    [savePanel setRequiredFileType: [ [ [ sender selectedCell] title] lowercaseString] ];
}


@end
