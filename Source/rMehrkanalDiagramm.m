#import "rMehrkanalDiagramm.h"

@implementation rMehrkanalDiagramm

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
		NSRect Diagrammfeld=frameRect;
		//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
		DiagrammEcke=NSMakePoint(5.5,5.5);
		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		[Graph moveToPoint:DiagrammEcke];
		lastPunkt=DiagrammEcke;
		GraphFarbe=[NSColor blueColor]; 
		OffsetY=0;
		GraphArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[GraphArray retain];
		GraphFarbeArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[GraphFarbeArray retain];
		GraphKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[GraphKanalArray retain];
		int i;
		for (i=0;i<8;i++)
		{
			NSBezierPath* tempGraph=[NSBezierPath bezierPath];
			[tempGraph retain];
			float varRed=sin(i+(float)i/10.0)/2.0+0.5;
			float varGreen=sin(2*i+(float)i/10.0)/2.0+0.5;
			float varBlue=sin(5*i+(float)i/10.0)/2.0+0.5;
			//NSLog(@"sinus: %2.2f",varRed);
			NSColor* tempColor=[NSColor colorWithCalibratedRed:varRed green: varGreen blue: varBlue alpha:1.0];
			//NSLog(@"Farbe Kanal: %d Color: %@",i,[tempColor description]);
			[tempColor retain];
			[GraphFarbeArray addObject:tempColor];
			[GraphArray addObject:tempGraph];
			[GraphKanalArray addObject:[NSNumber numberWithInt:0]];

		}//for i
		//NSLog(@"Farbe Kanal:  ColorArray: %@",[GraphFarbeArray description]);
				MinorTeileY=4;
		MajorTeileY=8;
		MaxY=256.0;
		MinY=0.0;
		NullpunktY=0.0;

	}
	return self;
}
- (void)setOffsetY:(int)y
{


}

- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal
{


}

- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal
{


}

- (void)setStartWerteArray:(NSArray*)Werte
{
//NSLog(@"setStartWerteArray: %@ ",[Werte description]);
float x=DiagrammEcke.x;
int i;
for (i=0;i<8;i++)
{
	float y=[[Werte objectAtIndex:i]floatValue];
	[[GraphArray objectAtIndex:i]moveToPoint:NSMakePoint(x,y)];

}
}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
	//NSLog(@"setWerteArray: %@ KanalArray: %@",[derWerteArray description],[derKanalArray description]);
	int i;
	for (i=0;i<8;i++)
	{
		//NSLog(@"setWerteArray: Kanal: %d",i);
		NSPoint neuerPunkt=DiagrammEcke;
		neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue];
		neuerPunkt.y+=[[derWerteArray objectAtIndex:i+1]floatValue];
		//NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);

		NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
		[neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
		[neuerGraph lineToPoint:neuerPunkt];
		[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];			
	}
	[derKanalArray retain];
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray retain];
	[self setNeedsDisplay:YES];
}


- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben
{
//	NSLog(@"setWerteArray: %@ KanalArray: %@ dieVorgaben: %@",[derWerteArray description],[derKanalArray description],[dieVorgaben description] );
	int i;
	float faktorX=1.0;
	if ([dieVorgaben objectForKey:@"faktorx"])
	{
		faktorX=[[dieVorgaben objectForKey:@"faktorx"]floatValue];
	}
	float faktorY=1.0;
	if ([dieVorgaben objectForKey:@"faktory"])
	{
		faktorY=[[dieVorgaben objectForKey:@"faktory"]floatValue];
	}
	float offsetY=0.0;
	if ([dieVorgaben objectForKey:@"offsety"])
	{
		offsetY=[[dieVorgaben objectForKey:@"offsety"]floatValue];
	}
//	NSLog(@"setWerteArray: faktorX: %2.2f faktorY: %2.2f ",faktorX,faktorY);
	for (i=0;i<8;i++)
	{
		//NSLog(@"setWerteArray: Kanal: %d",i);
		NSPoint neuerPunkt=DiagrammEcke;
		neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue]*faktorX;
		neuerPunkt.y+=([[derWerteArray objectAtIndex:i+1]floatValue]*faktorY)+offsetY;
		//NSLog(@"setWerteArray: Kanal: %d x: %2.2f y: %2.2f",i,neuerPunkt.x,neuerPunkt.y);

		NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
		[neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
		[neuerGraph lineToPoint:neuerPunkt];
		[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];			
	}
	[derKanalArray retain];
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray release];
	[self setNeedsDisplay:YES];
}


- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
   NSLog(@"setEinheitenDicY: %@",[derEinheitenDic description]);
   if ([derEinheitenDic objectForKey:@"majorteile"])
   {
      MajorTeileY=[[derEinheitenDic objectForKey:@"majorteile"]intValue];
   }
   if ([derEinheitenDic objectForKey:@"minorteile"])
   {
      MinorTeileY=[[derEinheitenDic objectForKey:@"minorteile"]intValue];
   }
   if ([derEinheitenDic objectForKey:@"max"])
   {
      MaxY=[[derEinheitenDic objectForKey:@"max"]floatValue];
   }
   if ([derEinheitenDic objectForKey:@"max"])
   {
      MaxY=[[derEinheitenDic objectForKey:@"max"]floatValue];
   }
   if ([derEinheitenDic objectForKey:@"nullpunkt"])
   {
      NullpunktY=[[derEinheitenDic objectForKey:@"nullpunkt"]intValue];
      
      NSLog(@"EinheitenDicY %d  NullpunktY: %d",[[derEinheitenDic objectForKey:@"nullpunkt"]intValue],NullpunktY);
      
   }
   
}

- (void)clear8Kanal
{
	//NSLog(@"MehrkanalDiagramm clear8Kanal");
	[Graph moveToPoint:DiagrammEcke];
	int i;
	for (i=0;i<8;i++)
	{
	
	[[GraphArray objectAtIndex:i]removeAllPoints];
	[[GraphArray objectAtIndex:i]moveToPoint:DiagrammEcke];
	}
	
	[NetzlinienX setArray:[NSArray array]];
	[NetzlinienY setArray:[NSArray array]];
	lastPunkt=DiagrammEcke;
	[self setNeedsDisplay:YES];
}


- (void)waagrechteLinienZeichnen
{
	NSRect AchsenRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	AchsenRahmen.size.height-=2.0;
	AchsenRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
//	[NSBezierPath strokeRect:AchsenRahmen];
//	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	int i;
	NSPoint unten=DiagrammEcke;
	unten.x+=AchsenRahmen.size.width-1;
//	unten.y+=0.2;
	NSPoint oben=unten;
	oben.x=unten.x;
	oben.y+=AchsenRahmen.size.height;//-10;


	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.2];
	
	NSPoint rechts=unten;//
	NSPoint links=unten;
	
	float breiteY=AchsenRahmen.size.width-1;
	float Bereich=MaxY-MinY;
	float Schrittweite=Bereich/(MajorTeileY*MinorTeileY);
	
	float delta=(AchsenRahmen.size.height-10)/255.0*Schrittweite;
	NSPoint MarkPunkt=links;
	//NSRect Zahlfeld=NSMakeRect(links.x-40,links.y-2,30,10);
	//NSLog(@"MajorTeile: %d MinorTeile: %d ",MajorTeileY,MinorTeileY);
	for (i=0;i<(MajorTeileY*MinorTeileY+1);i++)
	{
		MarkPunkt.x=links.x;
		//NSLog(@"i: %d rest: %d",i,i%MajorTeile);
		if (i%MinorTeileY)//Zwischenraum
		{
			//NSLog(@"i: %d ",i);
			//MarkPunkt.x-=breiteY;
			//[WaagrechteLinie moveToPoint:MarkPunkt];
		}
		
		else
		{
			MarkPunkt.x-=breiteY;
			[WaagrechteLinie moveToPoint:MarkPunkt];
			//	[NSBezierPath strokeRect: Zahlfeld];
			//NSLog(@"i: %d Zahl: %2.2f",i,Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt);
//			Zahl=[NSNumber numberWithFloat:Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt];
//			[[Zahl stringValue]drawInRect:Zahlfeld withAttributes:AchseTextDic];
		}
		[WaagrechteLinie lineToPoint:rechts];
		[WaagrechteLinie stroke];
		rechts.y+=delta;
		MarkPunkt.y+=delta;
	}

}

- (void)drawRect:(NSRect)rect
{
	NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=5;
	NetzBoxRahmen.size.width-=5;
	//NetzBoxRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
//	[NSBezierPath strokeRect:NetzBoxRahmen];

	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int i;
	NSPoint untenV=DiagrammEcke;
	NSPoint obenV=untenV;
	//NSPoint links=untenV;
	obenV.x=untenV.x;
	obenV.y+=NetzBoxRahmen.size.height-5;
	NSPoint mitteH=DiagrammEcke;
	mitteH.y+=(NetzBoxRahmen.size.height-5)/256*NullpunktY;

	[SenkrechteLinie moveToPoint:untenV];
	[SenkrechteLinie lineToPoint:obenV];
	[SenkrechteLinie stroke];

	for (i=0;i<[NetzlinienX count];i++)
	{
	untenV.x=[[NetzlinienX objectAtIndex:i]floatValue];
	untenV.y=mitteH.y;
	obenV.x=untenV.x;
	obenV.y=[[NetzlinienY objectAtIndex:i]floatValue];
	[SenkrechteLinie moveToPoint:untenV];
	[SenkrechteLinie lineToPoint:obenV];
	[SenkrechteLinie stroke];
	}

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	int k;
	NSPoint untenH=DiagrammEcke;
	NSPoint rechtsH=untenH;
	//NSPoint linksH=untenH;
	rechtsH.x=untenH.x;
	rechtsH.x+=NetzBoxRahmen.size.width-5;

	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
	[WaagrechteLinie stroke];
	
	
	NSBezierPath* WaagrechteMittelLinie=[NSBezierPath bezierPath];
	
	NSPoint mitterechtsH=mitteH;
	mitterechtsH.y=mitteH.y;
	mitterechtsH.x+=NetzBoxRahmen.size.width-5;

	[WaagrechteMittelLinie moveToPoint:mitteH];
	[WaagrechteMittelLinie lineToPoint:mitterechtsH];
//	[WaagrechteMittelLinie stroke];
	
	[self waagrechteLinienZeichnen];
	
	untenH.y=mitteH.y+100;
	rechtsH.y=mitterechtsH.y+100;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
//	[WaagrechteLinie stroke];

	untenH.y=mitteH.y-100;
	rechtsH.y=mitterechtsH.y-100;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
//	[WaagrechteLinie stroke];
	
	for (i=0;i<8;i++)
	{
	//NSLog(@"drawRect Farbe Kanal: %d Color: %@",i,[[GraphFarbeArray objectAtIndex:i] description]);
	if ([[GraphKanalArray objectAtIndex:i]intValue])
	{
	[[GraphFarbeArray objectAtIndex:i]set];
	[[GraphArray objectAtIndex:i]stroke];
	}
	}



}

@end
