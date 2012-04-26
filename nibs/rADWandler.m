#import "rADWandler.h"

@implementation rADWandler

- (id) init
{
    //if ((self = [super init]))
	self = [super initWithWindowNibName:@"ADWandler"];
	NSLog(@"ADWandler init");
	KanalDatenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalDatenArray retain];
	KanalTitelArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalTitelArray retain];
	KanalHexDatenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalHexDatenArray retain];
	KanalFloatDatenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalFloatDatenArray retain];
	KanalLevelArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalLevelArray retain];
	KanalNetzArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalNetzArray retain];
	
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(Read1KanalNotificationAktion:)
			   name:@"read1kanal"
			 object:NULL];
Kolonnenbreite=0;
	return self;
}

- (void)awakeFromNib
{
NSLog(@"ADWandler awake");
NSRect NetzBoxRahmen=[NetzBox frame];
NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
NSPoint NetzEcke=NetzBoxRahmen.origin;
NetzEcke.x+=5;
NetzEcke.y+=10;
Kolonnenbreite=(NetzBoxRahmen.size.width-10)/8;

}

- (IBAction)reportCancel:(id)sender
{
NSLog(@"ADWandler reportCancel");
[[self window]orderOut:0];
}

- (IBAction)reportClose:(id)sender
{
NSLog(@"ADWandler reportClose");
[[self window]orderOut:0];
}

- (void)Read1KanalNotificationAktion:(NSNotification*)note
{

}
@end
