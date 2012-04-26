#import "rOrdinate.h"

@implementation rOrdinate

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) 
	{
		//// Add initialization code here
		NSLog(@"rOrdinate Init");
		AchsenEcke=NSMakePoint(0.5,0.5);
		AchsenSpitze=AchsenEcke;
		AchsenSpitze.y+=[self frame].size.height-0.5;
		EinheitenArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
		[EinheitenArray retain];
		MajorTeile=8;
		MinorTeile=4;
		Max=256.0;
		Min=0.0;
		Nullpunkt=32.0;
		Einheit=@"";
	}
	return self;
}

- (void)drawRect:(NSRect)rect
{
[self AchseZeichnen];
}

- (void)AchseZeichnen
{
	NSFont* AchseTextFont=[NSFont fontWithName:@"Helvetica" size: 10];

	NSMutableDictionary* AchseTextDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[AchseTextDic setObject:AchseTextFont forKey:NSFontAttributeName];
	NSMutableParagraphStyle* AchseStil=[[NSMutableParagraphStyle alloc]init];
	[AchseStil setAlignment:NSRightTextAlignment];
	[AchseTextDic setObject:AchseStil forKey:NSParagraphStyleAttributeName];
	//NSLog(@"AchseTextDic: %@",[AchseTextDic description]);
	NSRect AchsenRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	AchsenRahmen.size.height-=5;
	//NetzBoxRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
//	[NSBezierPath strokeRect:AchsenRahmen];
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	
	int i;
	NSPoint unten=AchsenEcke;
	unten.x+=AchsenRahmen.size.width-1;
	unten.y+=5.5;
	NSPoint oben=unten;
	oben.x=unten.x;
	oben.y+=AchsenRahmen.size.height;//-10;

	[SenkrechteLinie moveToPoint:unten];
	[SenkrechteLinie lineToPoint:oben];
	[SenkrechteLinie stroke];

	NSBezierPath* WaagrechteLinie=[NSBezierPath bezierPath];
	[WaagrechteLinie setLineWidth:0.2];
	
	NSPoint rechts=unten;//
	NSPoint links=unten;
	
	float markbreite=6;
	float submarkbreite=3;
	float Bereich=Max-Min;
	float Schrittweite=Bereich/(MajorTeile*MinorTeile);
	
	float delta=(AchsenRahmen.size.height-10)/255*Schrittweite;
//	float delta=AchsenRahmen.size.height/(MajorTeile*MinorTeile);
	//rechts.x+=NetzBoxRahmen.size.width-10.0;
	//NSLog(@"rechts: %f",rechts.x);
	NSNumber* Zahl=[NSNumber numberWithInt:0];
	NSPoint MarkPunkt=links;
	NSRect Zahlfeld=NSMakeRect(links.x-40,links.y-2,30,10);
	//NSLog(@"MajorTeile: %d MinorTeile: %d ",MajorTeile,MinorTeile);
	for (i=0;i<(MajorTeile*MinorTeile+1);i++)
	{
		MarkPunkt.x=links.x;
		//NSLog(@"i: %d rest: %d",i,i%MajorTeile);
		if (i%MinorTeile)//Zwischenraum
		{
			//NSLog(@"i: %d ",i);
			MarkPunkt.x-=submarkbreite;
			[WaagrechteLinie moveToPoint:MarkPunkt];
		}
		
		else
		{
			MarkPunkt.x-=markbreite;
			[WaagrechteLinie moveToPoint:MarkPunkt];
			//	[NSBezierPath strokeRect: Zahlfeld];
			//NSLog(@"i: %d Zahl: %2.2f",i,Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt);
			Zahl=[NSNumber numberWithFloat:Bereich/(MajorTeile*MinorTeile)*i-Nullpunkt];
			[[Zahl stringValue]drawInRect:Zahlfeld withAttributes:AchseTextDic];
		}
		[WaagrechteLinie lineToPoint:rechts];
		[WaagrechteLinie stroke];
		rechts.y+=delta;
		MarkPunkt.y+=delta;
		Zahlfeld.origin.y+=delta;
	}

}

- (void)setAchsenDic:(NSDictionary*)derAchsenDic
{
	NSLog(@"setAchsenDic: %@",[derAchsenDic description]);
	NSRect AchsenRahmen=[self bounds];
if ([derAchsenDic objectForKey:@"einheit"])
{
	Einheit=[derAchsenDic objectForKey:@"einheit"];
	

}

if ([derAchsenDic objectForKey:@"majorteile"])
{
	MajorTeile=[[derAchsenDic objectForKey:@"majorteile"]intValue];
	

}



if ([derAchsenDic objectForKey:@"minorteile"])
{
	MinorTeile=[[derAchsenDic objectForKey:@"minorteile"]intValue];
	

}

if ([derAchsenDic objectForKey:@"nullpunkt"])
{
	Nullpunkt=[[derAchsenDic objectForKey:@"nullpunkt"]floatValue];
	

}

if ([derAchsenDic objectForKey:@"max"])
{
	Max=[[derAchsenDic objectForKey:@"max"]floatValue];
	

}

if ([derAchsenDic objectForKey:@"min"])
{
	Min=[[derAchsenDic objectForKey:@"min"]floatValue];
	

}

}

@end
