/* EGController */

#import <Cocoa/Cocoa.h>
#import "EGView.h"
// IMPORTANT to add the EGView.h or else you get errors like this:
/* Compiling EGController.m (4 errors)
 * undefined type, found 'EGView'
 * undefined type, found 'EGView'
 * In file included from EGController.m:2:
 *   parse error before 'EGView'
 * parse error before 'EGView'
 */


@interface EGController : NSObject
{
    IBOutlet id egView;
    IBOutlet id saveView;
    IBOutlet id savePopUpMenu;
    NSSavePanel	*savePanel;
    int		saveType;
}

- (EGView *) egView;
- (NSData *) PDFForView:(NSView *)aView;
- (NSData *) TIFFForView: (NSView *)aView;
- (NSData *) EPSForView: (NSView *)aView;
- (IBAction) saveDocumentTo2: (id) sender;
- (void) savePanelDidEnd: (NSSavePanel *)sheet returnCode:(int) returnCode contextInfo:(void *)contextInfo;
- (IBAction) setSaveType: (id) sender;

@end
