#import "rNetzBox.h"

@implementation rNetzBox
- (id)initWithFrame:(NSRect)frame
{
	self =[super initWithFrame:frame];
	//NSLog(@"NetzBox initWithFrame");
	NetzEcke=NSMakePoint(0.5,0.5);
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
	KanalKolonnenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[KanalKolonnenArray retain];
	NetzArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[NetzArray retain];
	int offsetlinks=5;
	Kolonnenbreite=(int)([self frame].size.width-11.0)/8;
	int i;
	for (i=0;i<8;i++)
	{
		//KolonnenVektor[i]=NetzEcke.x+i*Kolonnenbreite;
		[KanalKolonnenArray addObject:[NSNumber numberWithFloat:i*Kolonnenbreite+offsetlinks]];
		//NSLog(@"NetzBox KolonnenVektor: i: %d x: %d",i,i*Kolonnenbreite);
		
	}//for i

	
	
return self;
}

- (void)setNetzBox
{

NSArray* TippTastenTitelArray=[NSArray arrayWithObjects:@"Read",@"Read",@"Read",@"Read",@"Read",@"Read",@"Read",@"Read",nil];
NSMutableArray* TippTastenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
[TippTastenArray retain];
TippTastenArray=(NSMutableArray*)[self TastenArrayAnEcke:NSMakePoint(0.0,0.0)
								mitHoehe:20.0
						mitKolonnenArray:KanalKolonnenArray
						   mitTitelArray:TippTastenTitelArray
							mitTippTasten:YES];
//NSLog(@"KanalTastenArray: %@",[KanalTastenArray description]);
int i;
for (i=0;i<8;i++)
{
	[self addSubview:[TippTastenArray objectAtIndex:i]];
}
[NetzArray addObject:TippTastenArray];

NSArray* TrackTitelArray=[NSArray arrayWithObjects:@"Track",@"Track",@"Track",@"Track",@"Track",@"Track",@"Track",@"Track",nil];

NSMutableArray* TrackTastenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
[TrackTastenArray retain];

TrackTastenArray=(NSMutableArray*)[self TastenArrayAnEcke:NSMakePoint(0.0,24.0)
								mitHoehe:20.0
						mitKolonnenArray:KanalKolonnenArray
						   mitTitelArray:TrackTitelArray
							mitTippTasten:NO];
//NSLog(@"KanalTastenArray: %@",[KanalTastenArray description]);

for (i=0;i<8;i++)
{
	[self addSubview:[TrackTastenArray objectAtIndex:i]];
}
[NetzArray addObject:TrackTastenArray];

NSMutableArray* HexFeldArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
[HexFeldArray retain];

HexFeldArray=(NSMutableArray*)[self HexFeldArrayAnEcke:NSMakePoint(0.0,48.0)
								mitHoehe:20.0
						mitKolonnenArray:KanalKolonnenArray];
//NSLog(@"KanalTastenArray: %@",[KanalTastenArray description]);

for (i=0;i<8;i++)
{
	[self addSubview:[HexFeldArray objectAtIndex:i]];
}
[NetzArray addObject:HexFeldArray];


NSMutableArray* IntFeldArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
[IntFeldArray retain];

IntFeldArray=(NSMutableArray*)[self IntFeldArrayAnEcke:NSMakePoint(0.0,72.0)
								mitHoehe:20.0
						mitKolonnenArray:KanalKolonnenArray];
//NSLog(@"KanalTastenArray: %@",[KanalTastenArray description]);

for (i=0;i<8;i++)
{
	[self addSubview:[IntFeldArray objectAtIndex:i]];
}
[NetzArray addObject:IntFeldArray];


NSMutableArray* AnzeigenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
[AnzeigenArray retain];

AnzeigenArray=(NSMutableArray*)[self AnzeigenArrayAnEcke:NSMakePoint(0.0,96.0)
								mitHoehe:127.0
						mitKolonnenArray:KanalKolonnenArray
						 mitTitelArray:TrackTitelArray
						mitHold:NO
						mitHoldZeit:0];
//NSLog(@"AnzeigenArray: %@",[AnzeigenArray description]);

for (i=0;i<8;i++)
{
	[self addSubview:[AnzeigenArray objectAtIndex:i]];
}
[NetzArray addObject:AnzeigenArray];


int z,k;
for (z=0;z<[NetzArray count];z++)
{
for (k=0;k<8;k++)
{
	[[[NetzArray objectAtIndex:z]objectAtIndex:k]setTag:10*z+k];

}
}//for Z
}




- (NSArray*)TastenArrayAnEcke:(NSPoint)dieEcke
					mitHoehe:(float)dieHoehe
			mitKolonnenArray:(NSArray*)derKolonnenArray
			   mitTitelArray:(NSArray*)derTitelArray
			   mitTippTasten:(BOOL)derTyp
{
	NSMutableArray* tempTastenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	NSPoint tempEcke=dieEcke;
	for (i=0;i<8;i++)
	{
		tempEcke.x=[[derKolonnenArray objectAtIndex:i]floatValue];
		//NSLog(@"NetzBox tempEcke: x: %2.2f y: %2.2f  breite: %d",tempEcke.x,tempEcke.y,Kolonnenbreite);
		NSRect r=NSMakeRect(tempEcke.x-2,tempEcke.y,Kolonnenbreite-10,dieHoehe-0.5);
		NSButton* tempTaste=[[NSButton alloc]initWithFrame:r];
		//NSLog(@"Typ: %d",derTyp);
		if (derTyp)
		{
		//NSLog(@"Typ: 1");
			[tempTaste setButtonType:NSMomentaryPushInButton];
			//[tempTaste setBezelStyle:NSCellLightsByGray];
			[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];


		}
		else
		{
		//NSLog(@"Typ: 0");
			//[tempTaste setBezelStyle:NSCellLightsByGray];
			[tempTaste setButtonType:NSPushOnPushOffButton];
			//[[tempTaste cell]setShowsStateBy:NSChangeGrayCellMask|NSContentsCellMask];
			[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
		}
		[tempTaste setTitle:[derTitelArray objectAtIndex:i]];
		[tempTaste setTag:i];
		[tempTaste setTarget:self];
		[tempTaste setAction:@selector(NetzBoxTastenArrayAktion:)];
		[tempTastenArray addObject:tempTaste];
		[tempTaste release];

	}//for
	
	return tempTastenArray;
}

- (NSArray*)AnzeigenArrayAnEcke:(NSPoint)dieEcke
					   mitHoehe:(float)dieHoehe
			   mitKolonnenArray:(NSArray*)derKolonnenArray
				  mitTitelArray:(NSArray*)derTitelArray
						mitHold:(BOOL)mitHold
					mitHoldZeit:(int)dieZeit
{
	NSMutableArray* tempAnzeigenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	NSPoint tempEcke=dieEcke;
	for (i=0;i<8;i++)
	{
		tempEcke.x=[[derKolonnenArray objectAtIndex:i]floatValue];
		//NSLog(@"NetzBox tempEcke: x: %2.2f y: %2.2f  breite: %d hoehe: %f",tempEcke.x,tempEcke.y,Kolonnenbreite,dieHoehe);
		NSRect r=NSMakeRect(tempEcke.x-2,tempEcke.y,Kolonnenbreite-10,dieHoehe-0.5);
		rVertikalanzeige* tempAnzeige=[[rVertikalanzeige alloc]initWithFrame:r];
		//NSLog(@"Typ: %d",derTyp);
		if (mitHold)
		{
		//NSLog(@"Typ: 1");
		}
		else
		{
		//NSLog(@"Typ: 0");
		}
//		[tempAnzeige setTitle:[derTitelArray objectAtIndex:i]];
		//[tempAnzeige setLevel:i*20];
		[tempAnzeigenArray addObject:tempAnzeige];
		[tempAnzeige release];

	}//for
	
	return tempAnzeigenArray;
}


- (NSArray*)HexFeldArrayAnEcke:(NSPoint)dieEcke
					  mitHoehe:(float)dieHoehe
			  mitKolonnenArray:(NSArray*)derKolonnenArray
{
	NSMutableArray* tempFeldArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	NSPoint tempEcke=dieEcke;
	for (i=0;i<8;i++)
	{
		tempEcke.x=[[derKolonnenArray objectAtIndex:i]floatValue];
		//NSLog(@"NetzBox tempEcke: x: %2.2f y: %2.2f  breite: %d",tempEcke.x,tempEcke.y,Kolonnenbreite);
		NSRect r=NSMakeRect(tempEcke.x-2,tempEcke.y,Kolonnenbreite-10,dieHoehe-0.5);
		NSTextField* tempHexFeld=[[NSTextField alloc]initWithFrame:r];
		NSFont* HexFont=[NSFont fontWithName:@"Helvetica" size: 14];
		[tempHexFeld setEditable:NO];
		[tempHexFeld setSelectable:NO];
		[tempHexFeld setStringValue:@""];
		[tempHexFeld  setAlignment:NSCenterTextAlignment];
		[tempHexFeld setFont:HexFont];

		[tempFeldArray addObject:tempHexFeld];
		[tempHexFeld release];
	}
return tempFeldArray;
}


- (NSArray*)IntFeldArrayAnEcke:(NSPoint)dieEcke
					  mitHoehe:(float)dieHoehe
			  mitKolonnenArray:(NSArray*)derKolonnenArray
{
	NSMutableArray* tempFeldArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	NSPoint tempEcke=dieEcke;
	for (i=0;i<8;i++)
	{
		tempEcke.x=[[derKolonnenArray objectAtIndex:i]floatValue];
		//NSLog(@"NetzBox tempEcke: x: %2.2f y: %2.2f  breite: %d",tempEcke.x,tempEcke.y,Kolonnenbreite);
		NSRect r=NSMakeRect(tempEcke.x-2,tempEcke.y,Kolonnenbreite-10,dieHoehe-0.5);
		NSTextField* tempIntFeld=[[NSTextField alloc]initWithFrame:r];
		NSFont* IntFont=[NSFont fontWithName:@"Helvetica" size: 14];
		[tempIntFeld setEditable:NO];
		[tempIntFeld setSelectable:NO];
		[tempIntFeld setStringValue:@""];
		[tempIntFeld  setAlignment:NSRightTextAlignment];
		[tempIntFeld setFont:IntFont];

		[tempFeldArray addObject:tempIntFeld];
		[tempIntFeld release];
	}
return tempFeldArray;
}

- (void)setHexDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
	[[[NetzArray objectAtIndex:2]objectAtIndex:derKanal]setStringValue:dieDaten];
}


- (void)setIntDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
	[[[NetzArray objectAtIndex:3]objectAtIndex:derKanal]setStringValue:dieDaten];
}

- (void)setAnzeigeDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
	[[[NetzArray objectAtIndex:4]objectAtIndex:derKanal]setStringLevel:dieDaten];
}

-(void)NetzBoxTastenArrayAktion:(id)sender
{
	//NSLog(@"NetzBox TastenArrayAktion: tag: %d state: %d",[sender tag],[sender state]);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]%10] forKey:@"kanal"];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"tag"];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender state]] forKey:@"state"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"ADRead1Kanal" object:self userInfo:NotificationDic];



}


- (void)drawRect:(NSRect)rect
{
//NSLog(@"NetzBox drawRect");
	[self GitterZeichnen];
}

- (void)GitterZeichnen
{

	//NSLog(@"NetzBox GitterZeichnen");

	
	NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=20;
	//NetzBoxRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
	[NSBezierPath strokeRect:NetzBoxRahmen];

	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int k;
	NSPoint unten=NetzEcke;
	unten.x+=5.5;
	unten.y+=5;
	NSPoint oben=unten;
	NSPoint links=unten;
	oben.x=unten.x;
	oben.y+=NetzBoxRahmen.size.height-10;

	[SenkrechteLinie moveToPoint:unten];
	[SenkrechteLinie lineToPoint:oben];
	[SenkrechteLinie stroke];
	
	for (k=0;k<8;k++)
	{
		//NSLog(@"k: %d unten.x: %f unten.y: %f oben.x: %f oben.y: %f",k,unten.x,unten.y,oben.x,oben.y);
		unten.x=[[KanalKolonnenArray objectAtIndex:k]floatValue]+Kolonnenbreite;
		oben.x=unten.x;
		[SenkrechteLinie moveToPoint:unten];
		[SenkrechteLinie lineToPoint:oben];
		[SenkrechteLinie stroke];
	}
	
	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];

	NSPoint rechts=unten;//letzter Wert aus Schlaufe
	//rechts.x+=NetzBoxRahmen.size.width-10.0;
	//NSLog(@"rechts: %f",rechts.x);
	[WaagrechteLinie moveToPoint:links];
	[WaagrechteLinie lineToPoint:rechts];
	[WaagrechteLinie stroke];
	
}

@end
