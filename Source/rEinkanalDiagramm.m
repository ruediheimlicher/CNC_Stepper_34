#import "rEinkanalDiagramm.h"

@implementation rEinkanalDiagramm

- (id)initWithFrame:(NSRect)frameRect
{
//NSLog(@"EinkanalDiagramm init");
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		NSRect Diagrammfeld=frameRect;
//		Diagrammfeld.size.width+=400;
		[self setFrame:Diagrammfeld];
		DiagrammEcke=NSMakePoint(5.5,5.5);
		NetzlinienX=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[NetzlinienX retain];
		
		
		
		NetzlinienY=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
		[NetzlinienY retain];

		Graph=[NSBezierPath bezierPath];
		[Graph retain];
		
		[Graph moveToPoint:DiagrammEcke];
		lastPunkt=DiagrammEcke;
		GraphFarbe=[NSColor blueColor]; 
		OffsetY=0;
		MinorTeileY=4;
		MajorTeileY=8;
		MaxY=256.0;
		MinY=0.0;
		NullpunktY=0.0;
	}
	return self;
}

- (void)setEinheitenYArray:(NSDictionary*)derEinheitenDic;
{
	
	if ([derEinheitenDic objectForKey:@"minorteile"])
	{
		MinorTeileY=[[derEinheitenDic objectForKey:@"minorteile"]intValue];
	}
		
	if ([derEinheitenDic objectForKey:@"majorteile"])
	{
		MajorTeileY=[[derEinheitenDic objectForKey:@"maiorteile"]intValue];
	}
	if ([derEinheitenDic objectForKey:@"max"])
	{
		MaxY=[[derEinheitenDic objectForKey:@"max"]floatValue];
	}
	if ([derEinheitenDic objectForKey:@"min"])
	{
		MinY=[[derEinheitenDic objectForKey:@"min"]floatValue];
	}
}

- (void)setWert:(NSPoint)derWert
{
//NSLog(@"EinkanalDiagramm setWert: x: %2.2f y: %2.2f",derWert.x,derWert.y);
//NSLog(@"EinkanalDiagramm setWert lastPunkt: x: %2.2f y: %2.2f",lastPunkt.x,lastPunkt.y);
NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
[neuerGraph moveToPoint:lastPunkt];
NSPoint neuerPunkt=DiagrammEcke;
neuerPunkt.x+=derWert.x;
neuerPunkt.y+=derWert.y;
//NSLog(@"EinkanalDiagramm setWert neuerPunkt: x: %2.2f y: %2.2f",neuerPunkt.x,neuerPunkt.y);

[neuerGraph lineToPoint:neuerPunkt];
[Graph appendBezierPath:neuerGraph];
lastPunkt=neuerPunkt;
}

- (void)setStartwertMitY:(float)y
{
lastPunkt=NSMakePoint(DiagrammEcke.x,DiagrammEcke.y+y);
[NetzlinienX addObject:[NSNumber numberWithFloat:DiagrammEcke.x]];
[NetzlinienY addObject:[NSNumber numberWithFloat:DiagrammEcke.y]];

}

- (void)setWertMitX:(float)x mitY:(float)y
{
	NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
	[neuerGraph moveToPoint:lastPunkt];
	NSPoint neuerPunkt=DiagrammEcke;
	neuerPunkt.x+=x;
	neuerPunkt.y+=y;
//	NSLog(@"EinkanalDiagramm setWertMitX neuerPunkt: x: %2.2f y: %2.2f",neuerPunkt.x,neuerPunkt.y);
	
	[neuerGraph lineToPoint:neuerPunkt];
	[Graph appendBezierPath:neuerGraph];
	
	[NetzlinienX addObject:[NSNumber numberWithFloat:neuerPunkt.x]];
	[NetzlinienY addObject:[NSNumber numberWithFloat:neuerPunkt.y]];
//	NSBezierPath* tempSenkrechteLinie=[NSBezierPath bezierPath];
	NSPoint untenV=DiagrammEcke;
	untenV.x+=x;
	NSPoint obenV=untenV;
	obenV.x=untenV.x;
	obenV.y+=[self bounds].size.height-5;
	
	//NSLog(@"EinkanalDiagramm untenV.x: %2.2f y: %2.2f",untenV.x,untenV.y);
	//NSLog(@"EinkanalDiagramm obenV.x: %2.2f y: %2.2f",obenV.x,obenV.y);

	
	lastPunkt=neuerPunkt;
	[self setNeedsDisplay:YES];

}

- (void)setOffsetY:(int)y
{
	OffsetY=y;
//	[self 
}

- (void)clear1Kanal
{
	NSLog(@"EinkanalDiagramm clear1Kanal");
//	[Graph release];
	[Graph removeAllPoints];
	[Graph moveToPoint:DiagrammEcke];
	[NetzlinienX setArray:[NSArray array]];
	[NetzlinienY setArray:[NSArray array]];
	lastPunkt=DiagrammEcke;
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
	NSLog(@"waagrechteLinienZeichnen  MajorTeile: %d MinorTeile: %d ",MajorTeileY,MinorTeileY);
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
//	NSPoint links=untenV;
	obenV.x=untenV.x;
	obenV.y+=NetzBoxRahmen.size.height-5;
	NSPoint mitteH=DiagrammEcke;
//	mitteH.y+=(NetzBoxRahmen.size.height-5)/256*128;
	NSLog(@"drawRect NullpunktY: %d",NullpunktY);
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
//	[WaagrechteLinie stroke];
	
	
	
	
	
	NSBezierPath* WaagrechteMittelLinie=[NSBezierPath bezierPath];
	
	NSPoint mitterechtsH=mitteH;
	mitterechtsH.y=mitteH.y;
	mitterechtsH.x+=NetzBoxRahmen.size.width-5;

	[WaagrechteMittelLinie moveToPoint:mitteH];
	[WaagrechteMittelLinie lineToPoint:mitterechtsH];
//	[WaagrechteMittelLinie stroke];
	
	[self waagrechteLinienZeichnen];
	untenH.y=mitteH.y+128;
	rechtsH.y=mitterechtsH.y+128;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
//	[WaagrechteLinie stroke];

	untenH.y=mitteH.y-128;
	rechtsH.y=mitterechtsH.y-128;
	[WaagrechteLinie moveToPoint:untenH];
	[WaagrechteLinie lineToPoint:rechtsH];
//	[WaagrechteLinie stroke];

	[GraphFarbe set];
	[Graph stroke];

}

@end
