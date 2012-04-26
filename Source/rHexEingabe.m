//
//  rHexEingabe.m
//  IOWarriorProber
//
//  Created by Sysadmin on 26.01.06.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rHexEingabe.h"

int kSendTag=10;
int kAllTag=11;
int kClearTag=12;


@implementation rHexFeld
- (void)Alert:(NSString*)derFehler
{
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

-(id) initWithFrame:(NSRect)derRahmen
{
//[self Alert:@"vor initWithFrame"];
self=[super initWithFrame:derRahmen];
//[self Alert:@"nach initWithFrame"];

NSLog(@"initWithFrame");
return self;
}
- (void)keyDown:(NSEvent *)theEvent
{
NSLog(@"keyDown  ");
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
NSLog(@"control textShouldBeginEditing");
return YES;
}
 -(BOOL)textShouldBeginEditing:(NSText *)textObject
 {
 NSLog(@"textShouldBeginEditing");
 [self selectText:nil];
 return YES;
 }


@end

@implementation rHexEingabe
- (void)Alert:(NSString*)derFehler
{
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

- (id)initWithFrame:(NSRect)frame 
{
//[self Alert:@"vor initWithFrame"];
    self = [super initWithFrame:frame];
//	[self Alert:@"nach initWithFrame"];

    if (self) 
	{
	
		NSNotificationCenter * nc;
		nc=[NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(EingabeFertigAktion:)
				   name:@"EingabeFertig"
				 object:nil];

	[nc addObserver:self
		   selector:@selector(InputArrayAktion:)
			   name:@"InputArray"
			 object:nil];

		
	
		NSString* HexString=@"0 1 2 3 4 5 6 7 8 9 A B C D E F";
		HexSet=[NSCharacterSet characterSetWithCharactersInString:HexString];
		[HexSet retain];
		HexArray=[[HexString componentsSeparatedByString:@" "]retain];
//		[self Alert:@"nach HexArray"];
		//[HexSet addCharactersInString:HexString];
		//NSLog(@"HexArray: %@ Anz:%d",[HexArray description],[HexArray count]);
		BitArray=[[[NSMutableArray alloc]initWithCapacity:8]retain];
//		[self Alert:@"nach BitArray"];
		KolonnenRaster =(int)(frame.size.width)/10;
		ZeilenRaster=(int)(frame.size.height)/10;
		Nullpunkt=frame.origin;
		Nullpunkt=NSMakePoint(2,2);
		Nullpunkt.x+=2;
		Nullpunkt.y+=2;
		Rahmen.origin=Nullpunkt;
		Rahmen.size.width=8*KolonnenRaster;
		Rahmen.size.height=4*ZeilenRaster;
		
		NSRect Tastenrahmen;
		Tastenrahmen.origin=Nullpunkt;
		Tastenrahmen.size=NSMakeSize(KolonnenRaster-4,ZeilenRaster-4);
		Tastenrahmen.origin.x=Nullpunkt.x+7*KolonnenRaster;
		
		TastenArray=[[NSMutableArray alloc]initWithCapacity:8];
		TextfeldArray=[[NSMutableArray alloc]initWithCapacity:8];
//	[self Alert:@"nach TextfeldArray"];
		NSRect Anzeigerahmen=Tastenrahmen;
		Anzeigerahmen.origin.x=Nullpunkt.x+6*ZeilenRaster;
		AnzeigenArray=[[NSMutableArray alloc]initWithCapacity:8];
//		[self Alert:@"nach AnzeigenArray"];
		NSRect Textrahmen=Tastenrahmen;
		Textrahmen.origin.x=Nullpunkt.x;
		Textrahmen.size=NSMakeSize(6*KolonnenRaster-4,ZeilenRaster-4);
		
		
		
		NSRect Hexfeldrahmen;
		Hexfeldrahmen.origin=Nullpunkt;
		Hexfeldrahmen.origin.x+=6*KolonnenRaster-2;
		Hexfeldrahmen.origin.y+=9*ZeilenRaster-2;
		Hexfeldrahmen.size.width=2*KolonnenRaster-2;
		Hexfeldrahmen.size.height=ZeilenRaster-4;
		HexFeld=[[rHexView alloc]initWithFrame:Hexfeldrahmen];
//		[self Alert:@"nach HexFeld"];
		[HexFeld setEditable:YES];
		[HexFeld setSelectable:YES];
		[HexFeld setAlignment:NSCenterTextAlignment];
		[HexFeld setBackgroundColor:[NSColor cyanColor]];
//		[self Alert:@"nach HexFeld setBackgroundColor"];
		[HexFeld setDelegate:self];
		//[HexFeld setTarget:self];
		[self addSubview:HexFeld ];
//		[self Alert:@"nach addSubview:HexFeld"];
		NSRect SendTastenrahmen;
		SendTastenrahmen.origin=Nullpunkt;
		SendTastenrahmen.origin.x+=8*KolonnenRaster;
		SendTastenrahmen.origin.y+=1*ZeilenRaster-2;
		SendTastenrahmen.size.width=1*KolonnenRaster-2;
		SendTastenrahmen.size.height=8*ZeilenRaster-2;
		SendTaste=[[NSButton alloc]initWithFrame:SendTastenrahmen];
//		[self Alert:@"nach initWithFrame:SendTastenrahmen"];
		[SendTaste setButtonType:NSMomentaryLightButton];
//		[self Alert:@"nach setButtonType:NSMomentaryLightButton"];
		[SendTaste setTarget:self];
		[SendTaste setAlignment:NSCenterTextAlignment];
//		[self Alert:@"nach setAlignment:NSCenterTextAlignment"];
//		[[SendTaste cell]setBackgroundColor:[NSColor greenColor]];
//		[self Alert:@"nach setBackgroundColor:[NSColor greenColor] "];
		[SendTaste setAction:@selector(SendTastenAktion:)];
//		[self Alert:@"nach setAction:@selector(SendTastenAktion:)"];
		[SendTaste setTitle:@"S\ne\nn\nd"];
//		[self Alert:@"nach setTitle"];
		[SendTaste setTag:kSendTag];
//		[self Alert:@"nach setTag:kSendTag"];
		[self addSubview:SendTaste ];

//	[self Alert:@"nach addSubview:SendTaste"];


		NSRect ClearTastenrahmen;
		ClearTastenrahmen.origin=Nullpunkt;
		ClearTastenrahmen.origin.x+=6*KolonnenRaster;
		ClearTastenrahmen.origin.y-=2;
		ClearTastenrahmen.size.width=3*KolonnenRaster-2;
		ClearTastenrahmen.size.height=ZeilenRaster-2;
		ClearTaste=[[NSButton alloc]initWithFrame:ClearTastenrahmen];
		[ClearTaste setButtonType:NSMomentaryLightButton];
		[ClearTaste setTarget:self];
		[ClearTaste setAlignment:NSCenterTextAlignment];
//		[self Alert:@"vor ClearTaste cell]setDrawsBackground"];
		NSCell* ClearZelle=[ClearTaste cell];
		//NSLog(@"ClearZelle: %@",[ClearZelle description]);
//		[[ClearTaste cell]setDrawsBackground:YES];
//		[self Alert:@"nach ClearTaste cell]setDrawsBackground"];

//		[[ClearTaste cell]setBackgroundColor:[NSColor redColor]];
//		[self Alert:@"nach ClearTaste cell]setBackgroundColord"];
		[ClearTaste setAction:@selector(ClearTastenAktion:)];
		[ClearTaste setTitle:@"Clear"];
		[SendTaste setTag:kClearTag];
		[self addSubview:ClearTaste ];
//		[self Alert:@"nach addSubview:ClearTaste"];
		NSRect AllTastenrahmen;
		AllTastenrahmen.origin=Nullpunkt;
		AllTastenrahmen.origin.x+=8*KolonnenRaster;
		AllTastenrahmen.origin.y+=9*ZeilenRaster-3;
		AllTastenrahmen.size.width=1*KolonnenRaster-2;
		AllTastenrahmen.size.height=1*ZeilenRaster-2;
		AllTaste=[[NSButton alloc]initWithFrame:AllTastenrahmen];
		[AllTaste setButtonType:NSMomentaryLightButton];
		[AllTaste setTarget:self];
		[AllTaste setAlignment:NSCenterTextAlignment];
//		[[AllTaste cell]setBackgroundColor:[NSColor greenColor]];
		[AllTaste setAction:@selector(AllTastenAktion:)];
		[AllTaste setTitle:@"A"];
		[SendTaste setTag:kAllTag];
		[self addSubview:AllTaste ];
//		[self Alert:@"nach addSubview:AllTaste"];		

		int i;
		int Tastenoffset=2;
		for (i=0;i<8;i++)
		{
			Tastenrahmen.origin.y=(i+1)*ZeilenRaster+Tastenoffset;
			NSButton*  Taste=[[NSButton alloc]initWithFrame:Tastenrahmen];
			[Taste setTag:i];
			[Taste setButtonType:NSOnOffButton];
			[Taste setState:0];
			[Taste setTarget:self];
			[[Taste cell] setShowsStateBy:NSChangeGrayCell|NSPushInCellMask];
			
			[Taste setAlignment:NSCenterTextAlignment];
//			[[Taste cell]setBackgroundColor:[NSColor lightGrayColor]];
			[Taste setAction:@selector(TastenAktion:)];
			[Taste setTitle:[[NSNumber numberWithInt:i]stringValue]];

			[self addSubview:Taste ];
			[TastenArray addObject:Taste];
			
			Anzeigerahmen.origin.y=(i+1)*KolonnenRaster+Tastenoffset;
			NSView*	LEDView=[[NSView alloc]initWithFrame:Anzeigerahmen];
			[AnzeigenArray addObject:LEDView];
			
			Textrahmen.origin.y=(i+1)*KolonnenRaster+Tastenoffset;
			NSTextField* Textfeld=[[NSTextField alloc]initWithFrame:Textrahmen];
			[TextfeldArray addObject:Textfeld];
			[self addSubview:Textfeld ];
			[BitArray insertObject:[NSNumber numberWithInt:0]atIndex:i];

		}//for i
		//NSLog(@"BitArray: %@ Anz:%d",[BitArray description],[BitArray count]);
//		[self Alert:@"nach Tastenarray-Schleife"];
		NSRect PortTastenrahmen;
		PortTastenrahmen.origin=Nullpunkt;
		PortTastenrahmen.origin.x+=8*KolonnenRaster-2;
		PortTastenrahmen.size.width=7*KolonnenRaster-2;
		PortTastenrahmen.size.height=ZeilenRaster-2;
				
		NSRect PaketPoprahmen;
		PaketPoprahmen.origin=Nullpunkt;
		PaketPoprahmen.origin.x+=3.6*KolonnenRaster;
		PaketPoprahmen.origin.y+=9*ZeilenRaster-4;
		PaketPoprahmen.size.width=2.4*KolonnenRaster-2;
		PaketPoprahmen.size.height=ZeilenRaster-2;
		PaketNummerPop=[[NSPopUpButton alloc]initWithFrame:PaketPoprahmen];
//		[self Alert:@"nach initWithFrame:PaketPoprahmen"];
		[[PaketNummerPop cell]setFont:[NSFont labelFontOfSize:10]];
//		[self Alert:@"nach PaketNummerPop cell]setFont"];
		[PaketNummerPop addItemWithTitle:@"0"];
		[PaketNummerPop addItemWithTitle:@"1"];
		[[PaketNummerPop cell] setControlSize:NSMiniControlSize];
		[self addSubview:PaketNummerPop ];
//		[self Alert:@"nach addSubview:PaketNummerPop"];
		NSRect PaketTitelrahmen;
		PaketTitelrahmen.origin=Nullpunkt;
		PaketTitelrahmen.origin.x+=0*KolonnenRaster;
		PaketTitelrahmen.origin.y+=9*ZeilenRaster-6;
		PaketTitelrahmen.size.width=4*KolonnenRaster-2;
		PaketTitelrahmen.size.height=ZeilenRaster-2;
		PaketNummerTitelFeld=[[NSTextField alloc]initWithFrame:PaketTitelrahmen];
//		[self Alert:@"nach PaketNummerTitelFeld"];
		[PaketNummerTitelFeld setStringValue:@"Paketnummer:"];
		[PaketNummerTitelFeld setEditable:NO];
		[PaketNummerTitelFeld setDrawsBackground:NO];
		[PaketNummerTitelFeld setBordered:NO];
		[PaketNummerTitelFeld setSelectable:NO];
		[[PaketNummerTitelFeld cell]setFont:[NSFont labelFontOfSize:10]];

		[self addSubview:PaketNummerTitelFeld ];
//		[self Alert:@"nach addSubview:PaketNummerTitelFeld "];
    }//if self
	
	
    return self;
}

- (void)setPaketNummer:(int)dieNummer
{
PaketNummer =dieNummer;
[PaketNummerPop selectItemWithTitle:[[NSNumber numberWithInt:dieNummer]stringValue]];
}


- (void)drawRect:(NSRect)rect 
{
    [NSBezierPath strokeRect:[self bounds]];
	int i;
	for (i=0;i<8;i++)
		{
		[NSBezierPath strokeRect:[[TastenArray objectAtIndex:i]frame]];
		//[[TastenArray objectAtIndex:i]setNeedsDisplay];
		NSRect LEDRect=NSInsetRect([[AnzeigenArray objectAtIndex:i]frame],2.0,2.0);
		if ([[TastenArray objectAtIndex:i]state])
		{
		[[NSColor orangeColor]set];
		}
		else
		{
		[[NSColor whiteColor]set];
		}
		[[NSBezierPath bezierPathWithOvalInRect:LEDRect]fill];
		[[NSColor grayColor]set];
		[[NSBezierPath bezierPathWithOvalInRect:LEDRect]stroke];
		[[NSColor blackColor]set];
		//[NSBezierPath strokeRect:[[HexfeldArray objectAtIndex:i]frame]];
		//[NSBezierPath fillRect:[[TastenArray objectAtIndex:i]frame]];
		}//for i
	
	//senkrechte Linie
	NSPoint p1=NSMakePoint(rect.origin.x+6*KolonnenRaster+0.5,rect.origin.y+10*ZeilenRaster);
	NSPoint p2=NSMakePoint(rect.origin.x+6*KolonnenRaster+0.5,rect.origin.y+0*ZeilenRaster);
	//[NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
	
	//waagrechte Linie
	NSPoint p3=NSMakePoint(rect.origin.x,rect.origin.y+9*ZeilenRaster+0.5);
	NSPoint p4=NSMakePoint(rect.origin.x+8*KolonnenRaster+0.5,rect.origin.y+9*ZeilenRaster+0.5);
	//[NSBezierPath strokeLineFromPoint:p3 toPoint:p4];
	
	

	
}
- (void)setState:(BOOL)derStatus forTaste:(int)dieTaste
{
[[TastenArray objectAtIndex:dieTaste]setState:derStatus];
[BitArray replaceObjectAtIndex:dieTaste withObject:[NSNumber numberWithBool:derStatus]];
[[AnzeigenArray objectAtIndex:dieTaste]display];
if (derStatus)
{
		[[NSColor orangeColor]set];

}
else
{
		[[NSColor whiteColor]set];


}
NSRect LEDRect=NSInsetRect([[AnzeigenArray objectAtIndex:dieTaste]frame],2.0,2.0);
[[AnzeigenArray objectAtIndex:dieTaste]display];

		[[NSBezierPath bezierPathWithOvalInRect:LEDRect]fill];
		[[NSColor grayColor]set];
		[[NSBezierPath bezierPathWithOvalInRect:LEDRect]stroke];
		[[NSColor blackColor]set];


}

- (void)InputArrayAktion:(NSNotification*)note
{
	//NSLog(@"InputArrayAktion note: %@",[[note userInfo]description]);
	[HexFeld setString:[[[note userInfo]objectForKey:@"inputarray"]objectAtIndex:PaketNummer]];
	BitArray=(NSMutableArray*)[self BitArrayAusHex:[HexFeld string]];
	[self setBitAnzeigeMitArray:BitArray];
	[self display];
	//NSLog(@"InputArrayAktion:	BitArray: %@",[BitArray description]);
}

- (void)EingabeFertigAktion:(NSNotification*)note
{
	NSLog(@"EingabeFertigAktion note: %@",[[note userInfo]description]);
	NSLog(@"[HexFeld string]: %@",[HexFeld string]);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	PaketNummer=[[PaketNummerPop titleOfSelectedItem]intValue];
	[NotificationDic setObject:[NSNumber numberWithInt:PaketNummer] forKey:@"paketnummer"];
	[NotificationDic setObject:[HexFeld string] forKey:@"hexstring"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Tastenaktion" object:self userInfo:NotificationDic];
	BitArray=(NSMutableArray*)[self BitArrayAusHex:[HexFeld string]];
	[self setBitAnzeigeMitArray:BitArray];

}


-(IBAction)TastenAktion:(id)sender
{
//NSLog(@"TastenAktion tag: %d state: %d",[sender tag],[sender state]);
[self display];
[BitArray replaceObjectAtIndex:[sender tag]withObject:[NSNumber numberWithBool:[sender state]]];
NSString* HexString=[self HexAusBitArray:BitArray];
[HexFeld setString:HexString];
NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
PaketNummer=[[PaketNummerPop titleOfSelectedItem]intValue];
[NotificationDic setObject:[NSNumber numberWithInt:PaketNummer] forKey:@"paketnummer"];
[NotificationDic setObject:HexString forKey:@"hexstring"];
[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"taste"];
NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
[nc postNotificationName:@"Einzeltastenaktion" object:self userInfo:NotificationDic];
}

-(IBAction)ClearTastenAktion:(id)sender
{
	//NSLog(@"ClearTastenAktion tag: %d",[sender tag]);
	int i;
	for (i=0;i<8;i++)
	{
		
		[[TastenArray objectAtIndex:i]setState:0];
		[BitArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
		
	}
	//[HexFeld setStringValue:@"00"];
	[HexFeld setString:@"00"];
	[self display];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"clear"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Tastenaktion" object:self userInfo:NotificationDic];
	
}

-(IBAction)SendTastenAktion:(id)sender
{
	NSLog(@"SendTastenAktion tag: %d",[sender tag]);
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	PaketNummer=[[PaketNummerPop titleOfSelectedItem]intValue];
	[NotificationDic setObject:[NSNumber numberWithInt:PaketNummer] forKey:@"paketnummer"];
	[NotificationDic setObject:[HexFeld string] forKey:@"hexstring"];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender tag]] forKey:@"taste"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendTastenAktion" object:self userInfo:NotificationDic];

}

-(NSString*)HexFeld
{
return [HexFeld string];
}


-(IBAction)AllTastenAktion:(id)sender
{
	NSLog(@"AllTastenAktion tag: %d",[sender tag]);
	int i;
	for(i=0;i<8;i++)
	{
		
		[[TastenArray objectAtIndex:i]setState:1];
		[BitArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
		
	}//for i
	//NSString* HexString=[self HexAusBitArray:BitArray];
	[HexFeld setString:@"FF"];
	[self display];
}


- (NSString*)HexAusBitArray:(NSArray*)derBitArray
{
	int i;
	int h=0;
	int l=0;
	//NSLog(@"BitArray: %@ Anz:%d",[derBitArray description],[derBitArray count]);

	for (i=0;i<4;i++)
	{
		if ([[derBitArray objectAtIndex:i]intValue])
		{
			l=l+pow(2,i);
			//NSLog(@"HexAusBitArray: i %d l: %d",i,l);
		}
		if ([[derBitArray objectAtIndex:i+4]intValue])
		{
			h=h+pow(2,i);
			//NSLog(@"HexAusBitArray: i %d h: %d",i,h);
		}
		
	}//for i
	NSString* lsb=[HexArray objectAtIndex:l];
	NSString* msb=[HexArray objectAtIndex:h];
	//NSLog(@"msb: %@ lsb: %@",msb,lsb);
	return [msb stringByAppendingString:lsb];
}

- (NSArray*)BitArrayAusHex:(NSString*)derHexString
{
//NSLog(@"BitArrayAusHex: %@",derHexString);
NSMutableArray* tempBitArray=[[[NSMutableArray alloc]initWithCapacity:8]retain];
int i;
for(i=0;i<8;i++)
{
[tempBitArray addObject:@"0"];
}

if ([derHexString length]==0)
{
return tempBitArray;
}

//NSLog(@"MSB: %@",[derHexString substringToIndex:1]);

int indexMSB=[HexArray indexOfObject:[[derHexString substringToIndex:1]uppercaseString]];
int ii=indexMSB;
//NSLog(@"ii: %d",ii);

//NSLog(@"LSB: %@",[derHexString substringFromIndex:1]);
int indexLSB=[HexArray indexOfObject:[[derHexString substringFromIndex:1]uppercaseString]];
int kk=indexLSB;
//NSLog(@"kk: %d",kk);
int bitIndex=7;

while(kk>0)
{
int r=kk%2;
//NSLog(@"bitIndex: %d	r: %d",bitIndex,r);
[tempBitArray replaceObjectAtIndex:bitIndex withObject:[[NSNumber numberWithInt:r]stringValue]];
kk=kk/2;
//NSLog(@"kk: %d	r: %d",kk,r);
bitIndex--;
}



bitIndex=3;
while(ii>0)
{
int r=ii%2;
//NSLog(@"bitIndex: %d	r: %d",bitIndex,r);
[tempBitArray replaceObjectAtIndex:bitIndex withObject:[[NSNumber numberWithInt:r]stringValue]];
ii=ii/2;
//NSLog(@"ii: %d	r: %d",ii,r);
bitIndex--;
}
//[tempBitArray addObject:[[NSNumber numberWithInt:ii]stringValue]];//letztes Bit
//NSLog(@"tempBitArray : %@",[tempBitArray description]);

return tempBitArray;
}

- (void)setBitAnzeigeMitArray:(NSArray*)derBitArray
{
if ([derBitArray count]==8)
{
int i;
for (i=0;i<[derBitArray count];i++)
{
if (i<8)
{
[self setState:[[derBitArray objectAtIndex:i]intValue] forTaste:i];

}//if <8
}//for i
}
}

- (BOOL)textShouldBeginEditing:(NSText *)textObject
{
NSLog(@"textShouldBeginEditing");
}

- (void)textDidBeginEditing:(NSNotification *)aNotification
{
NSLog(@"textDidBeginEditing");

}
- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
NSLog(@"controlTextDidBeginEditing");

}
- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString **)newString errorDescription:(NSString **)error
{
NSLog(@"isPartialStringValid");
return YES;
}
@end
