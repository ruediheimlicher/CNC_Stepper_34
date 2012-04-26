//
//  rWerkstattplan.m
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rWerkstattplan.h"

@implementation rWerkstattplan

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code here.
	RandL=30;
	RandR=5;
	RandU=2;
	
    }
    return self;
}






- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag
{
	if (StundenArray==NULL)
	{
		StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
		[StundenArray retain];
	}
	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"setTagplan Tag: %d : Nullpunkt: x: %2.2f y: %2.2f",derTag, Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	//NSLog(@"WS setTagplan: frame.height: %2.2f",[self frame].size.height);
	Ecke.x+=RandL;
	//Ecke.y+=RandU;
	Ecke.y=25;
	//	Elementhoehe: Block mit Halbstundenfeldern und AllTaste
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	Elementhoehe=[self frame].size.height/2;
	//Elementhoehe=35;
	//NSLog(@"Tag: %d Elementbreite: %d Elementhoehe: %d ",derTag, Elementbreite, Elementhoehe);
	for (i=0;i<24;i++)
	{
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"WS SetTagPlan i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		//		[NSBezierPath strokeRect:Elementfeld];
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		[ElementView setAutoresizesSubviews:NO];
		[self addSubview:ElementView];
		//		NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		//		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"werkstatt"];
		[StundenArray addObject:tempElementDic];
		//NSLog(@"setTagplan i: %d ElementDic: %@",i,[tempElementDic description]);
	}//for i
	
	
	
	//***
	tag=derTag;
	
	//NSLog(@"setTagplan Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	for (i=0;i<24;i++)
	{
		//NSLog(@"setBrennerTagplan index: %d: werkstatt: %d",i,[[[derBrennerStundenArray objectAtIndex:i]objectForKey:@"werkstatt"]intValue]);
		if ([StundenArray objectAtIndex:i])
		{
			NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
			//NSLog(@"Dic schon da fuer index: %d",i);
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"] forKey:@"werkstatt"];
		}
		else
		{
			NSLog(@"setTagplan neuer Dic index: %d",i);
			NSMutableDictionary* tempElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"] forKey:@"werkstatt"];
			[StundenArray addObject:tempElementDic];
				
		}
	}//for i
	lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];//Speicherung IST-Zustand
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setBrennerTagplan end: Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	[self setNeedsDisplay:YES];
}


- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag
{
	if (StundenArray==NULL)
	{
	StundenArray=[[NSMutableArray alloc]initWithCapacity:0];
	[StundenArray retain];
	}
//[[WerkstattScroller verticalScroller] setFloatValue:1.0];

	Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
	//NSLog(@"awakeFromNib: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	int i=0;
	
	NSPoint Ecke=NSMakePoint(0.0,0.0);
	
	Ecke.x+=RandL;
	Ecke.y+=RandU;
	Elementbreite=([self frame].size.width-RandL-RandR)/24;
	Elementhoehe=[self frame].size.height-2*RandU;

	//NSLog(@"Elementbreite: %d",Elementbreite);
	for (i=0;i<24;i++)
	{
		NSMutableDictionary* tempElementDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		NSRect Elementfeld=NSMakeRect(Ecke.x+i*Elementbreite,Ecke.y,Elementbreite-3, Elementhoehe-2);
		//NSLog(@"i: %d Eckex: %2.2f b: %2.2f",i,Elementfeld.origin.x,Elementfeld.size.width);
		NSView* ElementView=[[NSView alloc] initWithFrame:Elementfeld];
		[ElementView setAutoresizesSubviews:NO];
		//NSLog(@"ElementView: x: %2.2f y: %2.2f",[ElementView frame].origin.x,[ElementView bounds].origin.y);
		[tempElementDic setObject:ElementView forKey:@"elementrahmen"];
		[tempElementDic setObject:[NSNumber numberWithInt:i] forKey:@"elementnummer"];
		
		[tempElementDic setObject:[NSNumber numberWithInt:i%4] forKey:@"werkstatt"];
		[StundenArray addObject:tempElementDic];
	}//for i

	
	
	//***
	tag=derTag;
	
	//NSLog(@"setWerkstattplan Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	//NSLog(@"setWerkstattplan Tag: %d derStundenArray: %@",derTag, [derStundenArray description]);
	for (i=0;i<24;i++)
	{
		//NSLog(@"setWerkstattplan index: %d: werkstatt: %d",i,[[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"]intValue]);
		if ([StundenArray objectAtIndex:i])
		{
		NSMutableDictionary* tempElementDic=[StundenArray objectAtIndex:i];
		//NSLog(@"
		[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"] forKey:@"werkstatt"];
		}
		else
		{
			//NSLog(@"setrWerkstattplan neuer Dic index: %d",i);
			NSMutableDictionary* tempElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[tempElementDic setObject:[[derStundenArray objectAtIndex:i]objectForKey:@"werkstatt"] forKey:@"werkstatt"];
			[StundenArray addObject:tempElementDic];
		
		
		}
	}//for i
	lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];//Speicherung IST-Zustand
	//NSLog(@"StundenArray: %2.2f",[[[StundenArray objectAtIndex:0]objectForKey:@"elementrahmen"]frame].origin.x);
	//NSLog(@"setWerkstattplan end: Tag: %d StundenArray: %@",derTag, [StundenArray description]);
	[self setNeedsDisplay:YES];
}

- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey
{
	NSDictionary* tempDic=[StundenArray objectAtIndex:dieStunde];
	if (tempDic && [tempDic objectForKey:derKey])
	{
		return [[tempDic objectForKey:derKey]intValue];
	}
	else
	{
		return -1;
	}
}

- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey
{
NSLog(@"setStundenarraywert: %d Stunde: %d ",derWert, dieStunde);
NSMutableDictionary* tempDic=(NSMutableDictionary*)[StundenArray objectAtIndex:dieStunde];
[tempDic setObject:[NSNumber numberWithInt:derWert] forKey:derKey];
lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];
[self setNeedsDisplay:YES];
}

- (void)setNullpunkt:(NSPoint)derPunkt;
{
//Nullpunkt=derPunkt;
		Nullpunkt=[self convertPoint:NSMakePoint(0.0,0.0) toView:NULL];
		NSLog(@"setNullpunkt: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);

}

- (void)drawRect:(NSRect)dasFeld 
{
   //NSPoint     newScrollOrigin=NSMakePoint(0.0,NSMaxY([[WerkstattScroller documentView] frame])
   //                                     -NSHeight([[WerkstattScroller contentView] bounds]));
    
 
   // [[WerkstattScroller documentView] scrollPoint:newScrollOrigin];

    NSArray* Wochentage=[NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA",@"SO",nil];
	[[NSColor blackColor]set];
	//[NSBezierPath strokeRect:dasFeld];
	
	float vargray=0.8;
			//NSLog(@"sinus: %2.2f",varRed);
	NSColor* tempGrayColor=[NSColor colorWithCalibratedRed:vargray green: vargray blue: vargray alpha:0.8];
	[tempGrayColor set];
	[NSBezierPath fillRect:dasFeld];
	NSFont* StundenFont=[NSFont fontWithName:@"Helvetica" size: 9];
	NSDictionary* StundenAttrs=[NSDictionary dictionaryWithObject:StundenFont forKey:NSFontAttributeName];
	NSFont* TagFont=[NSFont fontWithName:@"Helvetica" size: 14];
	NSDictionary* TagAttrs=[NSDictionary dictionaryWithObject:TagFont forKey:NSFontAttributeName];
	NSPoint TagPunkt=NSMakePoint(0.0,0.0);
	//
	TagPunkt.x+=5;
	TagPunkt.y+=Elementhoehe/3;
	//NSLog(@"Tag: %d Tagpunkt x: %2.2f  y: %2.2f",tag, TagPunkt.x, TagPunkt.y);
	[[Wochentage objectAtIndex:tag] drawAtPoint:TagPunkt withAttributes:TagAttrs];
	
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=2;
	[[NSColor grayColor]set];
	[NSBezierPath fillRect:AllFeld];
	int i;
	for (i=0;i<24;i++)
	{
		//NSLog(@"WS drawRect: y %2.2f",[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame].origin.y);
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
		NSString* Stunde=[[NSNumber numberWithInt:i]stringValue];
		NSPoint p=StdFeld.origin;
		StdFeld.size.height-=10;
		p.y+=StdFeld.size.height;
		p.x-=4;
		if (i>9)
			p.x-=4;
		[Stunde drawAtPoint:p withAttributes:StundenAttrs];
		if (i==23)
		{
			Stunde=[[NSNumber numberWithInt:24]stringValue];
			p.x+=Elementbreite;
			[Stunde drawAtPoint:p withAttributes:StundenAttrs];
		}
		[[NSColor blueColor]set];
		StdFeld.size.height-=8;
		StdFeld.origin.y+=8;
		//NSLog(@"i: %d Eckex: %2.2f h: %2.2f b: %2.2f",i,StdFeld.origin.x,StdFeld.size.height,StdFeld.size.width);
		[NSBezierPath fillRect:StdFeld];
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		
		[[NSColor blueColor]set];
		[NSBezierPath strokeRect:StdFeldL];
		
		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		[[NSColor blueColor]set];
		[NSBezierPath strokeRect:StdFeldR];
		
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=5;
		StdFeldU.origin.y-=8;
		[[NSColor grayColor]set];
		[NSBezierPath fillRect:StdFeldU];
		
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"werkstatt"]intValue];
		switch (ON)
		{
			case 0://ganze Stunde OFF
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[NSBezierPath fillRect:StdFeldR];
				
				break;
			case 2://erste halbe Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldR];
				
				
				break;
			case 1://zweite halbe Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldR];
				[[NSColor whiteColor]set];
				[NSBezierPath fillRect:StdFeldL];
				
				break;
			case 3://ganze Stunde ON
				[[NSColor redColor]set];
				[NSBezierPath fillRect:StdFeldL];
				[NSBezierPath fillRect:StdFeldR];
				
				break;
		}
	}//for i
}

- (void)mouseDown:(NSEvent *)theEvent
{
	//NSLog(@"mouseDown: event: x: %2.2f y: %2.2f",[theEvent locationInWindow].x,[theEvent locationInWindow].y);
	//NSLog(@"mouseDown: Nullpunkt: x: %2.2f y: %2.2f",Nullpunkt.x,Nullpunkt.y);
	//NSLog(@"Bounds: x: %2.2f y: %2.2f h: %2.2f w: %2.2f ",[self frame].origin.x,[self frame].origin.y,[self frame].size.height,[self frame].size.width);
	//NSLog(@"mouseDown: modifierFlags: %",[theEvent modifierFlags]);
//		NSLog(@"mouseDown Stundenarray: %@",[[StundenArray valueForKey:@"werkstatt"] description]);
	
	unsigned int Mods=[theEvent modifierFlags];
	int modKey=0;
	if (Mods & NSCommandKeyMask)
	{
		NSLog(@"mouseDown: Command");
		modKey=1;
	}
	else if (Mods & NSControlKeyMask)
	{
		NSLog(@"mouseDown: Control");
		modKey=3;
	}
	
	else if (Mods & NSAlternateKeyMask)
	{
		NSLog(@"mouseDown: Alt");
		modKey=2;
		
	}
	
	NSRect AllFeld=[[[StundenArray objectAtIndex:23]objectForKey:@"elementrahmen"]frame];
	AllFeld.origin.x+=Elementbreite+2;
	//AllFeld.origin.y+=8;
	AllFeld.size.height-=8;
	AllFeld.size.width/=2;
	
	NSPoint globMaus=[theEvent locationInWindow];
	NSPoint Ecke=[self bounds].origin;
	NSPoint localMaus;
	localMaus=[self convertPoint:globMaus fromView:NULL];
	//NSLog(@"mouseDown: local: x: %2.2f y: %2.2f",localMaus.x,localMaus.y);
	
	//NSLog(@"lastONArray: %@",[lastONArray description]);
	int i;
	int all=-1;
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	if ([self mouse:localMaus inRect:AllFeld])
	{
	if (modKey==2)//alt
	{
		//NSLog(@"ALL-Taste mit alt");
		[NotificationDic setObject:@"alt" forKey:@"mod"];
		[NotificationDic setObject:@"Tagplan" forKey:@"quelle"];
		[NotificationDic setObject:lastONArray forKey:@"lastonarray"];
		[NotificationDic setObject:[NSNumber numberWithInt:-1] forKey:@"tag"];
		[NotificationDic setObject:[NSNumber numberWithInt:4] forKey:@"feld"];
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];

		return;
	}

		int sum=0;
		for (i=0;i<24;i++)
		{
			sum+=[[[StundenArray valueForKey:@"werkstatt"] objectAtIndex:i]intValue];
		}
		if (sum==0)//alle sind off: IST wiederherstellen
		{
			NSLog(@"IST wiederherstellen");
			all=2;
		}
		else if (sum==72)//alle sind ON,
		{
			NSLog(@"Alle OFF");
			all=0;
		}
		else if (sum && sum<72)//mehrere on: alle ON
		{
			NSLog(@"IST speichern");
			lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];//Speicherung IST-Zustand
			all=3;
		}
		
	}

	
	
	for (i=0;i<24;i++)
	{
		[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
		
		NSRect StdFeld=[[[StundenArray objectAtIndex:i]objectForKey:@"elementrahmen"]frame];
		
		StdFeld.size.height-=10;
		StdFeld.size.height-=8;
		StdFeld.origin.y+=8;
		
		NSRect StdFeldL=StdFeld;
		StdFeldL.size.width/=2;
		StdFeldL.size.width-=2;
		StdFeldL.origin.x+=1;
		NSRect StdFeldR=StdFeld;
		StdFeldR.origin.x+=(StdFeld.size.width/2)+1;
		StdFeldR.size.width/=2;
		StdFeldR.size.width-=2;
		
		NSRect StdFeldU=StdFeld;
		StdFeldU.size.height=5;
		StdFeldU.origin.y-=8;
		
		//	if ((glob.x>r.origin.x)&&(glob.x<r.origin.x+r.size.width))
		int ON=[[[StundenArray objectAtIndex:i]objectForKey:@"werkstatt"]intValue];
		if (modKey==2)//alt
		{
			[NotificationDic setObject:@"alt" forKey:@"mod"];
			[NotificationDic setObject:@"Werkstattplan" forKey:@"quelle"];
			[NotificationDic setObject:[NSNumber numberWithInt:tag] forKey:@"tag"];
		}
		if ([self mouse:localMaus inRect:StdFeldL])
		{
			
			//NSLog(@"mouse in Stunde: %d in Feld links ON: %d",i, ON);
			
			switch (ON)
			{
				case 0:// werkstatt in der ersten halben Stunde neu einschalten __ > |_
					ON=2;//Bit 2
					break;
					
				case 1:// Kessel in der ersten halbe Stunde neu einschalten _| > ||
					ON=3;
					break;

				case 2:// Kessel in der ersten halben Stunde neu ausschalten || > _|
					ON=0;
					break;
										
				case 3: // Kessel in der ersten halben Stunde neu ausschalten || > _|
					ON=1;
					break;
			}
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:@"L" forKey:@"feld"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
				
				
			}
			
			
		}
		else if ([self mouse:localMaus inRect:StdFeldR])
		{
			//NSLog(@"mouse in Stunde: %d in Feld rechts ON: %d",i,ON);
			switch (ON)
			{
				case 0:// Kessel in der zweiten halben Stunde neu einschalten
					ON=1;
					break;
				case 1://	Kessel in der zweiten halben Stunde neu ausschalten
					ON=0;
					break;
				case 2:// Kessel in der zweiten halben Stunde neu einschalten
					ON=3;
					break;
				case 3:// Kessel in der zweiten halben Stunde neu ausschalten
					ON=2;
					break;
					
			}
			
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:@"R" forKey:@"feld"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;
			
			}
			
		}
		else if ([self mouse:localMaus inRect:StdFeldU])
		{
			//NSLog(@"mouse in Stunde: %d in Feld Unten ON: %d",i, ON);
			switch (ON)
			{
				case 0://ganze Stunde ON
				case 1://	Kessel in der ersten halben Stunde schon ON
				case 2://	Kessel in der zweiten halben Stunde schon ON
					ON=3;//ganze Stunde ON
					break;
					
				case 3:// Kessel in der ganzen Stunde schon ON
					ON=0;//ganze Stunde OFF
					break;
					
			}
			if (modKey==2)//alt
			{
				[NotificationDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];
				[NotificationDic setObject:[NSNumber numberWithInt:ON] forKey:@"on"];
				[NotificationDic setObject:@"U" forKey:@"feld"];
				NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
				[nc postNotificationName:@"Modifier" object:self userInfo:NotificationDic];
				modKey=0;

			}
			
		}
		
switch (all)
{
	case 0://alle OFF schalten
	case 3://alle ON schalten
		ON=all;
		break;
	case 2://Wiederherstellen
		//NSLog(@"IST: lastONArray: %@",[lastONArray description]);
		ON=[[lastONArray objectAtIndex:i]intValue];
		break;
}//switch all		
		
		
			[[StundenArray objectAtIndex:i]setObject:[NSNumber numberWithInt:ON]forKey:@"werkstatt"];
			
			//[self setNeedsDisplay:YES];
		

		
	}//for i
	if (all<0)//kein Klick auf ALL-Taste, IST-Zustand speichern
	{
	lastONArray=[[StundenArray valueForKey:@"werkstatt"]copy];
	}
	[self setNeedsDisplay:YES];
}


@end
