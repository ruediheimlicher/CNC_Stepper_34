//
//  rProfilDiagramm.m
//  WebInterface
//
//  Created by Sysadmin on 2.April.10.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "rProfilDiagramm.h"


@implementation rProfilDiagramm

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		[DatenTitelArray replaceObjectAtIndex:0 withObject:@"K V"]; // Vorlauf
		[DatenTitelArray replaceObjectAtIndex:1 withObject:@"K R"];
		[DatenTitelArray replaceObjectAtIndex:2 withObject:@"B U"];
		[DatenTitelArray replaceObjectAtIndex:3 withObject:@"B M"];
		[DatenTitelArray replaceObjectAtIndex:4 withObject:@"B O"];
		[DatenTitelArray replaceObjectAtIndex:5 withObject:@"K T"];

    }
    return self;
}
- (void)setOffsetY:(int)y
{
[super setOffsetY:y];
}
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;

{

}
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic
{
	[super setEinheitenDicY:derEinheitenDic];
}

- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal
{

}
- (void)setStartWerteArray:(NSArray*)Werte
{

}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray
{
	//NSLog(@"setWerteArray WerteArray: %@",[derWerteArray description]);//,[derKanalArray description]);
	int i;
	
	float	maxSortenwert=127.5;	// Temperatur, 100° entspricht 200
	float	SortenFaktor= 1.0;
	float	maxAnzeigewert=MaxY-MinY;
	float AnzeigeFaktor= maxSortenwert/maxAnzeigewert;
	float FaktorX=1.0;
	float FaktorY=1.0;
	//NSLog(@"setWerteArray: FaktorY: %2.2f MaxY; %2.2F MinY: %2.2F maxAnzeigewert: %2.2F AnzeigeFaktor: %2.2F",FaktorY,MaxY,MinY,maxAnzeigewert, AnzeigeFaktor);
	//NSLog(@"setWerteArray:SortenFaktor: %2.2f",SortenFaktor);

	for (i=0;i<[derWerteArray count]-1;i++) // erster Wert ist Abszisse
	{
		if ([[derKanalArray objectAtIndex:i]intValue])
		{
			//NSLog(@"+++			Temperatur  setWerteArray: Kanal: %d	x: %2.2f",i,[[derWerteArray objectAtIndex:0]floatValue]);
			NSPoint neuerPunkt=DiagrammEcke;
			neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue]*Zoom;	//	Zeit, x-Wert, erster Wert im Array
			float InputZahl=[[derWerteArray objectAtIndex:i+1]floatValue];	// Input vom HC, 0-255
			
			switch (i)
			{
				case 2: // Kollektortemperatur 8 Bit
				//	InputZahl -= 163;
					break;
					
			}// switch i	
			
														
			float graphZahl=(InputZahl-2*MinY)*FaktorY;								// Red auf reale Diagrammhoehe
			
			float rawWert=graphZahl*SortenFaktor;							// Wert fuer Anzeige des ganzen Bereichs
			
			float DiagrammWert=(rawWert)*AnzeigeFaktor;
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F",i,InputZahl,graphZahl,rawWert,DiagrammWert);
			
			neuerPunkt.y += DiagrammWert;
			//neuerPunkt.y=InputZahl;
			//NSLog(@"setWerteArray: Kanal: %d MinY: %2.2F FaktorY: %2.2f",i,MinY, FaktorY);
			
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F FaktorY: %2.2f graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F ",i,InputZahl,FaktorY, graphZahl,rawWert,DiagrammWert);
			
			NSString* tempWertString=[NSString stringWithFormat:@"%2.1f",InputZahl/2.0];
			//NSLog(@"neuerPunkt.y: %2.2f tempWertString: %@",neuerPunkt.y,tempWertString);
			
			NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:neuerPunkt.x],[NSNumber numberWithFloat:neuerPunkt.y],tempWertString,nil];
			NSDictionary* tempWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"ax",@"ay",@"wert",nil]];
			[[ProfilDatenArray objectAtIndex:i] addObject:tempWerteDic];
			
			NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
			if ([[GraphArray objectAtIndex:i]isEmpty]) // Anfang
			{
				neuerPunkt.x=DiagrammEcke.x;
				[neuerGraph moveToPoint:neuerPunkt];
				[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
				
			}
			else
			{
				[neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
				[neuerGraph lineToPoint:neuerPunkt];
				[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			}		
		}// if Kanal
	} // for i
	[derKanalArray retain];
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray retain];
//	[self setNeedsDisplay:YES];
}

- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben
{
	//NSLog(@"setWerteArray WerteArray: %@",[derWerteArray description]);//,[derKanalArray description]);
	int i;
	float faktorX=1.0;
	float FaktorY=1.0;

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
	
	float	maxSortenwert=127.5;	// Temperatur, 100° entspricht 200
	float	SortenFaktor= 1.0;
	float	maxAnzeigewert=MaxY-MinY;
	float AnzeigeFaktor= maxSortenwert/maxAnzeigewert;
	//NSLog(@"setWerteArray: FaktorY: %2.2f MaxY; %2.2F MinY: %2.2F maxAnzeigewert: %2.2F AnzeigeFaktor: %2.2F",FaktorY,MaxY,MinY,maxAnzeigewert, AnzeigeFaktor);
	//NSLog(@"setWerteArray:SortenFaktor: %2.2f",SortenFaktor);

	for (i=0;i<[derWerteArray count]-1;i++) // erster Wert ist Abszisse
	{
		if ([[derKanalArray objectAtIndex:i]intValue])
		{
			//NSLog(@"+++			Temperatur  setWerteArray: Kanal: %d	x: %2.2f",i,[[derWerteArray objectAtIndex:0]floatValue]);
			NSPoint neuerPunkt=DiagrammEcke;
			neuerPunkt.x+=[[derWerteArray objectAtIndex:0]floatValue]*Zoom;	//	Zeit, x-Wert, erster Wert im Array
			float InputZahl=[[derWerteArray objectAtIndex:i+1]floatValue];	// Input vom IOW, 0-255
			
			// Korrektur bei i=2: Aussentemperatur um 20 reduzieren
			if (i==2)
			{
				InputZahl -= 40;
			}
			if (i==6)
			{
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F",i,InputZahl);
	//		InputZahl=80;
			}
			
			float graphZahl=(InputZahl-2*MinY)*FaktorY;								// Red auf reale Diagrammhoehe
			
			float rawWert=graphZahl*SortenFaktor;							// Wert fuer Anzeige des ganzen Bereichs
			
			float DiagrammWert=(rawWert)*AnzeigeFaktor;
			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F",i,InputZahl,graphZahl,rawWert,DiagrammWert);

			neuerPunkt.y += DiagrammWert;
			//neuerPunkt.y=InputZahl;
			//NSLog(@"setWerteArray: Kanal: %d MinY: %2.2F FaktorY: %2.2f",i,MinY, FaktorY);

			//NSLog(@"setWerteArray: Kanal: %d InputZahl: %2.2F FaktorY: %2.2f graphZahl: %2.2F rawWert: %2.2F DiagrammWert: %2.2F ",i,InputZahl,FaktorY, graphZahl,rawWert,DiagrammWert);

			NSString* tempWertString=[NSString stringWithFormat:@"%2.1f",InputZahl/2.0];
			//NSLog(@"neuerPunkt.y: %2.2f tempWertString: %@",neuerPunkt.y,tempWertString);

			NSArray* tempDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:neuerPunkt.x],[NSNumber numberWithFloat:neuerPunkt.y],tempWertString,nil];
			NSDictionary* tempWerteDic=[NSDictionary dictionaryWithObjects:tempDatenArray forKeys:[NSArray arrayWithObjects:@"ax",@"ay",@"wert",nil]];
			[[ProfilDatenArray objectAtIndex:i] addObject:tempWerteDic];
			
			NSBezierPath* neuerGraph=[NSBezierPath bezierPath];
			if ([[GraphArray objectAtIndex:i]isEmpty]) // Anfang
			{
				neuerPunkt.x=DiagrammEcke.x;
				[neuerGraph moveToPoint:neuerPunkt];
				[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
				
			}
			else
			{
				[neuerGraph moveToPoint:[[GraphArray objectAtIndex:i]currentPoint]];//last Point			
				[neuerGraph lineToPoint:neuerPunkt];
				[[GraphArray objectAtIndex:i]appendBezierPath:neuerGraph];
			}		
		}// if Kanal
	} // for i
	[derKanalArray retain];
	[GraphKanalArray setArray:derKanalArray];
	//[GraphKanalArray retain];
//	[self setNeedsDisplay:YES];
}
- (void)drawRect:(NSRect)rect
{
	//NSLog(@"MKDiagramm drawRect");
	NSRect NetzBoxRahmen=[self bounds];//NSMakeRect(NetzEcke.x,NetzEcke.y,200,100);
	NetzBoxRahmen.size.height-=10;
	NetzBoxRahmen.size.width-=15;
	//NetzBoxRahmen.origin.x+=0.2;
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	
	[[NSColor greenColor]set];
	//[NSBezierPath strokeRect:NetzBoxRahmen];
	
	NSBezierPath* SenkrechteLinie=[NSBezierPath bezierPath];
	int i;
	NSPoint untenV=DiagrammEcke;
	NSPoint obenV=untenV;
	NSPoint links=untenV;
	obenV.x=untenV.x;
	obenV.y+=NetzBoxRahmen.size.height;
	NSPoint mitteH=DiagrammEcke;
	mitteH.y+=(NetzBoxRahmen.size.height)/256*NullpunktY;
	
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
	NSPoint linksH=untenH;
	rechtsH.x=untenH.x;
	rechtsH.x+=NetzBoxRahmen.size.width-5;
	/*
	 [WaagrechteLinie moveToPoint:untenH];
	 [WaagrechteLinie lineToPoint:rechtsH];
	 [WaagrechteLinie stroke];
	 */
	
	
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
			NSPoint cP=[[GraphArray objectAtIndex:i]currentPoint];
			//cP.x+=2;
			cP.y-=12;
			[[DatenFeldArray objectAtIndex:i]setFrameOrigin:cP];
			//NSLog(@"drawRect: %@",[[ProfilDatenArray objectAtIndex:i]description]);
			
			NSString* AnzeigeString=[NSString stringWithFormat:@"%@: %@",[DatenTitelArray objectAtIndex:i],[[[ProfilDatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
			[[DatenFeldArray objectAtIndex:i]setStringValue:AnzeigeString];
			//		[[DatenFeldArray objectAtIndex:i]setStringValue:[[[DatenArray objectAtIndex:i]lastObject]objectForKey:@"wert"]];
		}
	}
	
	
	
}
@end
