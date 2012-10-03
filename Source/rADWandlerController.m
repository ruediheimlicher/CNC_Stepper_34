#import "USBWindowController.h"



@implementation IOWarriorWindowController(rADWandlerController)
- (void)Alert:(NSString*)derFehler
{
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

- (void)drawRect:(NSRect)rect 
{
NSLog(@"drawRect");
    // Drawing code here.
}

/*
- (IBAction)showADWandler:(id)sender
{
 //	[self Alert:@"showADWandler start init"];
	if (!ADWandler)
	  {
	  //[self Alert:@"showADWandler vor init"];
		//NSLog(@"showADWandler");
		ADWandler=[[rADWandler alloc]init];
		//[self Alert:@"showADWandler nach init"];
		//[ADWandler retain];
	  }
	  //[self Alert:@"showADWandler nach init"];
//	NSMutableArray* 
	EinkanalDaten=[[NSMutableArray alloc]initWithCapacity:0];
	[EinkanalDaten retain];
	//NSLog(@"showADWandler vor showWindow: %@",[[[ADWandler window]contentView]description]);
	//[self Alert:@"showADWandler vor showWindow"];
	 
//	if ([ADWandler window]) ;
	{
//	[self Alert:@"showADWandler window da"];

	[ADWandler showWindow:NULL];
	}
//	 [self Alert:@"showADWandler nach showWindow"];
	//NSLog(@"showADWandler nach showWindow %@",[[ADWandler window]description]);
//	[[ADWandler window]makeKeyAndOrderFront:self];
}

- (IBAction)saveMehrkanalDaten:(id)sender
{
	NSSavePanel* SichernPanel=[NSSavePanel savePanel];
	[SichernPanel setDelegate:self];
	[SichernPanel setCanCreateDirectories:YES];
	[SichernPanel beginSheetForDirectory:NSHomeDirectory() 
									file:@"MehrkanalDaten" 
									modalForWindow:[ADWandler  window] 
						   modalDelegate:self 
						  didEndSelector:@selector(MehrkanalDatenPanelDidEnd:)
							 contextInfo:NULL];
		
}
 */
- (void)MehrkanalDatenPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
{
NSLog(@"MehrkanalDatenPanelDidEnd ret code: %d",returnCode);
}
@end
