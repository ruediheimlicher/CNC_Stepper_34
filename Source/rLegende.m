#import "rLegende.h"

@implementation rLegende
- (void) logRect:(NSRect)r
{
NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}


- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		//NSLog(@"rOrdinate Init");
		AchsenEcke=NSMakePoint(0.0,0.0);
		AchsenSpitze=AchsenEcke;
		AchsenSpitze.y+=[self frame].size.height-0.5;
		InhaltArray=[[NSMutableArray alloc] initWithCapacity: 0];
		[InhaltArray retain];
		Einheit=@"";
		Schriftgroesse=9;
		//InhaltArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		//[InhaltArray retain];
		anzBalken=4;
		BalkenlageArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[BalkenlageArray retain];
	}
	return self;
}

- (void)setTag:(int)derTag
{
	Tag= derTag;
}

- (void) setAnzahlBalken:(int)dieAnzahl
{
	anzBalken=dieAnzahl;
	NSRect BalkenArrayRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	BalkenArrayRahmen.size.height-=4.9;
	BalkenArrayRahmen.origin.x+=5.1;
	BalkenArrayRahmen.origin.y+=2.1;
	float delta=BalkenArrayRahmen.size.height/anzBalken;
	[BalkenlageArray removeAllObjects];
	int i=0;
	for (i=0;i<anzBalken;i++)
	{	
		//NSLog(@"setAnzahlBalken: %2.2f",i*delta + delta);
		[BalkenlageArray addObject:[NSNumber numberWithFloat:i*delta + delta]];
		[InhaltArray addObject:[NSString string]];
	}
	//NSLog(@"[Legende BalkenlageArray: %@",[BalkenlageArray description]);
	[self setNeedsDisplay:YES];
}

- (void)setInhaltArray:(NSArray*)derInhaltArray
{
	//NSLog(@"Legende setInhaltArray: %@",[derInhaltArray description]);
	[InhaltArray release];
	[derInhaltArray retain];
	InhaltArray=(NSMutableArray*)derInhaltArray;

}

- (void)drawRect:(NSRect)rect
{
[self AchseZeichnen];
	NSRect BalkenArrayRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	BalkenArrayRahmen.size.height-=4.9;
	BalkenArrayRahmen.origin.x+=5.1;
	BalkenArrayRahmen.origin.y+=2.1;
	//[[NSColor redColor] set];
	//[NSBezierPath fillRect:BalkenArrayRahmen];
}

- (void)AchseZeichnen
{
	NSFont* AchseTextFont=[NSFont fontWithName:@"Helvetica" size: Schriftgroesse];

	NSMutableDictionary* AchseTextDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[AchseTextDic setObject:AchseTextFont forKey:NSFontAttributeName];
	NSMutableParagraphStyle* AchseStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[AchseStil setAlignment:NSRightTextAlignment];
	[AchseTextDic setObject:AchseStil forKey:NSParagraphStyleAttributeName];
	//NSLog(@"AchseTextDic: %@",[AchseTextDic description]);
	NSRect BalkenArrayRahmen=[self frame];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	BalkenArrayRahmen.size.height-=4.9;
	BalkenArrayRahmen.origin.x+=5.1;
	BalkenArrayRahmen.origin.y+=2.1;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor grayColor]set];
	//[NSBezierPath strokeRect:BalkenArrayRahmen];
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	int i;
	NSPoint unten=AchsenEcke;
	unten.x+=BalkenArrayRahmen.size.width-1;
	unten.y+=4.1;
	NSPoint oben=unten;
	oben.x=unten.x;
	oben.y+=BalkenArrayRahmen.size.height;//-10;
	//NSLog(@"Ordinate: height: %2.2f",AchsenRahmen.size.height-5.1);
	oben.y=AchsenSpitze.y;
	[SenkrechteLinie moveToPoint:unten];
	[SenkrechteLinie lineToPoint:oben];
	[SenkrechteLinie stroke];

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.2];
	
	NSPoint rechts=unten;//
	NSPoint links=unten;
	
	//Nullpunkt += Offset*Zoom;
	float markbreite=6;
	float submarkbreite=3;
	
	//float Schrittweite=Bereich/(MajorTeile*MinorTeile);

	float delta=BalkenArrayRahmen.size.height/anzBalken;	//NSLog(@"MKDiagramm	MajorTeile: %d MinorTeile: %d delta: %2.2f",MajorTeile,MinorTeile,delta);
	
	//rechts.x+=NetzBoxRahmen.size.width-10.0;
	//NSLog(@"rechts: %f",rechts.x);
	NSNumber* Zahl=[NSNumber numberWithInt:0];
	NSPoint MarkPunkt=links;
	NSRect Zahlfeld=NSMakeRect(links.x-70,links.y,60,10);
	//NSLog(@"MajorTeile: %d MinorTeile: %d ",MajorTeile,MinorTeile);
	for (i=0;i<(anzBalken);i++)
	{
		MarkPunkt.x=links.x;
		float aktuellY=[[BalkenlageArray objectAtIndex:i]floatValue];
		rechts.y=aktuellY;
		MarkPunkt.y=aktuellY;
		Zahlfeld.origin.y=aktuellY+2;

		//NSLog(@"i: %d rest: %d",i,i%MajorTeile);
		{
			MarkPunkt.x-=markbreite;
			[WaagrechteLinie moveToPoint:MarkPunkt];
			//	[NSBezierPath strokeRect: Zahlfeld];
			
			//NSString* ZahlString=[NSString stringWithFormat:@"%@%@",[Zahl stringValue], Einheit];
			switch (i)
			{
			case 0:
			{
			//NSString* ZahlString=@"Brenner";
			
			NSString* ZahlString=[InhaltArray objectAtIndex:0];
			[ZahlString drawInRect:Zahlfeld withAttributes:AchseTextDic];
			
			}break;
			
			case 1:
			{
			//NSString* ZahlString=@"Uhr";
			NSString* ZahlString=[InhaltArray objectAtIndex:1];

			[ZahlString drawInRect:Zahlfeld withAttributes:AchseTextDic];
			}break;
			case 2:
			{
			//NSString* ZahlString=@"";
			NSString* ZahlString=[InhaltArray objectAtIndex:2];
			[ZahlString drawInRect:Zahlfeld withAttributes:AchseTextDic];
			}break;
			
			case 3:
			{
			//NSString* ZahlString=@"";
			NSString* ZahlString=[InhaltArray objectAtIndex:3];
			[ZahlString drawInRect:Zahlfeld withAttributes:AchseTextDic];
			}break;
			
			}// switch i

			
				
			/*
			if (i==0)
			{
			NSString* ZahlString=@"Brenner";
			[ZahlString drawInRect:Zahlfeld withAttributes:AchseTextDic];
			}
			*/
		}
		[WaagrechteLinie lineToPoint:rechts];
		[WaagrechteLinie stroke];
		
	}

}

- (void)setAchsenDic:(NSDictionary*)derAchsenDic
{
	//NSLog(@"setAchsenDic: %@",[derAchsenDic description]);
	NSRect AchsenRahmen=[self bounds];
if ([derAchsenDic objectForKey:@"einheit"])
{
	Einheit=[derAchsenDic objectForKey:@"einheit"];
}







 [self setNeedsDisplay:YES];
}

@end
