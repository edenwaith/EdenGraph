/* EGController */

#import <Cocoa/Cocoa.h>
#import "EGView.h"

@interface EGController : NSObject
{
    IBOutlet id egView;
    IBOutlet id saveView;
    IBOutlet id savePopUpMenu;
    NSSavePanel	*savePanel;
    int		saveType;
}

- (EGView *) egView;
- (NSData *) PDFForView: (NSView *) aView;
- (NSData *) TIFFForView: (NSView *)aView;
- (NSData *) EPSForView: (NSView *) aView;
- (NSData *) imageForView: (NSView *) aView usingType: (NSBitmapImageFileType) imageType;

- (IBAction) saveDocumentTo2: (id) sender;
- (void) savePanelDidEnd: (NSSavePanel *)sheet returnCode:(int) returnCode contextInfo:(void *)contextInfo;
- (IBAction) setSaveType: (id) sender;

@end
