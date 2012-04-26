/* rADWandler */

#import <Cocoa/Cocoa.h>

@interface rADWandler : NSWindowController
{
    IBOutlet id ADTab;
    IBOutlet id CancelTaste;
    IBOutlet id NetzBox;
    IBOutlet id SchliessenTaste;
	
	
	NSMutableArray*				KanalDatenArray;
	NSMutableArray*				KanalTitelArray;
	NSMutableArray*				KanalHexDatenArray;
	NSMutableArray*				KanalFloatDatenArray;
	NSMutableArray*				KanalLevelArray;
	NSMutableArray*				KanalNetzArray;
	
}

- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
@end
