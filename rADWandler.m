#import "rADWandler.h"
#import "rUtils.h"

@implementation rADWandler
extern int			SystemNummer;

- (void)Alert:(NSString*)derFehler
{
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

- (id) init
{
    //if ((self = [super init]))
//	[self Alert:@"ADWandler init vor super"];

	self = [super initWithWindowNibName:@"ADWandler"];
	//NSLog(@"ADWandler init");
//	[self Alert:@"ADWandler init nach super"];

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
	
	DatenTitelArray=[[[NSMutableArray alloc] initWithCapacity: 0]autorelease];
	[DatenTitelArray retain];
//	[self Alert:@"ADWandler init nach DatenTitelArray"];

	sendAllDelay=0.1;
	sendKanalDelay=0.001;
	sendStartBitDelay=0.001;
	sendReadBitDelay=0.001;
	sendInputDelay=0.001;
	sendResetDelay=0.001;
	LaunchZeit=[NSDate date];
	lastDir=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//	NSLog(@"lastDir: %@",lastDir);
	[lastDir retain];
//	[self Alert:@"ADWandler init nach lastDir"];

//	[[self window]setDelegate:self];
//	[self Alert:@"ADWandler init nach setDelegate"];

	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(Read1KanalNotificationAktion:)
			   name:@"ADRead1Kanal"
			 object:NULL];
//	[self Alert:@"ADWandler init vor random"];
//	double rr=fabs(random());
//	 [self Alert:@"ADWandler init nach random"];
	//NSLog(@"\n\nrandom(): %u								fabs(Random()): %u\n",rr);
//	float y=	(float)random() / RAND_MAX * (255);
//	int i=(int)(random() / RAND_MAX * (255));
//	 [self Alert:@"showADWandler vor SSRandomIntBetween"];
//	i=SSRandomIntBetween(0,255);
//	 [self Alert:@"showADWandler nach SSRandomIntBetween"];
//	NSLog(@"y: %2.2f i: %d",y,i);
	return self;
}

- (void) logRect:(NSRect)r
{
NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}

- (void)awakeFromNib
{
//	[self Alert:@"ADWandler awake start"];

	NSLog(@"ADWandler awake SystemVersion  Nummer: %d",SystemNummer);


	NSNumber *number;
	NSString *hexString;
	number = [NSNumber numberWithInt:245];
	hexString = [NSString stringWithFormat:@"0x%x", [number intValue]];
//	NSLog(@"hexString: %@",[hexString uppercaseString]);
	//NSLog(@"ADWandler awake: window: %@",[[[self window]contentView] description]);
	//[NetzBox init];
	NSRect NetzBoxFeld=[ADTab contentRect];
	NetzBoxFeld.size.width*=0.6;
	NetzBoxFeld.size.height-=20;
	
	NetzBox=[[rNetzBox alloc] initWithFrame:NetzBoxFeld];
	
	[NetzBox retain];
	
	
	
	[[[ADTab tabViewItemAtIndex:0]view]addSubview:NetzBox];
	//NSLog(@"ADTab: %@ superview: %@",[ADTab description],[[ADTab superview] description]);
	
	NSRect NetzBoxRahmen=[NetzBox frame];
	//NetzBoxRahmen.origin.x+=10;
	
	//NSLog(@"NetzBox: %@ superview: %@",[NetzBox description],[[NetzBox superview] description]);
	//NSLog(@"NetzBox Titel: %@",[NetzBox title]);
	//NSLog(@"NetzBoxRahmen x: %f y: %f h: %f w: %f",NetzBoxRahmen.origin.x,NetzBoxRahmen.origin.y,NetzBoxRahmen.size.height,NetzBoxRahmen.size.width);
	NSPoint NetzEcke=NSMakePoint(5.5,5.5);
	//NSPoint NetzEcke=NSMakePoint(0.5,0.5);
	//NetzEcke.x+=5.5;
	//NetzEcke.y+=5.5;
	Kolonnenbreite=(NetzBoxRahmen.size.width-11)/8;
	//NSLog(@"Kolonnenbreite: %2.2f",Kolonnenbreite);
	int i=0;
	for (i=0;i<8;i++)
	{
		//KolonnenVektor[i]=NetzEcke.x+i*Kolonnenbreite;
		KolonnenVektor[i]=i*Kolonnenbreite;
		[KanalKolonnenArray addObject:[NSNumber numberWithFloat:KolonnenVektor[i]]];
		//NSLog(@"ADWandler KolonnenVektor: i: %d x: %2.2f",i,KolonnenVektor[i]);
		
	}//for i
	 //[NetzBox setKolonnenVektor:KanalKolonnenArray];
	[NetzBox setNetzBox];
//	[self Alert:@"ADWandler awake: nach setNetzBox"];
	[NetzBox setTitle:@"NetzBox"];
	
	
	//NSLog(@"NetzBox Titel: %@",[NetzBox title]);
	//NSLog(@"NetzBox Typ: %d",[NetzBox boxType]);
	
	NSArray* TastenTitelArray=[NSArray arrayWithObjects:@"Lesen",@"Lesen",@"Lesen",@"Lesen",@"Lesen",@"Lesen",@"Lesen",@"Lesen",nil];
	NSString* HexString=@"0 1 2 3 4 5 6 7 8 9 A B C D E F";
	
	HexSet=[NSCharacterSet characterSetWithCharactersInString:HexString];
//	[self Alert:@"ADWandler awake: nach characterSetWithCharactersInString"];
	[HexSet retain];
	HexArray=[[HexString componentsSeparatedByString:@" "]retain];
	

	[EinkanalDiagrammScroller setLineScroll: 2.0];
	EinkanalDaten=[[NSMutableDictionary alloc]initWithCapacity:0];
	[EinkanalDaten retain];
	NSMutableArray* tempArray=[[NSMutableArray alloc]initWithCapacity:0];
	[tempArray retain];
	[EinkanalDaten setObject:tempArray forKey:@"datenarray"];
	
	ZeitFormatter=[[NSNumberFormatter alloc] init];
	[ZeitFormatter retain];
	DatenFormatter=[[NSNumberFormatter alloc] init];;
	[DatenFormatter retain];
//	NSString* ADSysVersion=SystemVersion();
//	NSLog(@"SystemVersion aus Funktion: %@",ADSysVersion);
//	[self Alert:@"ADWandler awake: vor systemVersion"];

	NSString *systemVersion = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];    
//	NSLog(@"systemVersion: %@",systemVersion);
		NSArray* VersionArray=[systemVersion componentsSeparatedByString:@"."];
	NSLog(@"VersionArray: %@ num: %d",[VersionArray description],[[VersionArray objectAtIndex:1]intValue]);
	BOOL isTiger=([[VersionArray objectAtIndex:1]intValue]==4);
	if (isTiger)
	{
//		[ZeitFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
   	[DatenFormatter setFormat:@"##0"];
	[ZeitFormatter setFormat:@"##0.00"];

//		[DatenFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	}
//	[self Alert:@"ADWandler awake: vor Datenformatter"];
//	[self Alert:@"ADWandler awake: nach Datenformatter"];

//	NSLog(@"Zero: %@", [DatenFormatter stringFromNumber:[NSNumber  numberWithFloat:4.012345]]);
	float wert1tab=60;
	float wert2tab=100;
	int Textschnitt=12;
	NSFont* TextFont;
	TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
	
	NSMutableParagraphStyle* TabellenKopfStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[TabellenKopfStil setTabStops:[NSArray array]];
	NSTextTab* TabellenkopfWert1Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert1tab]autorelease];
	[TabellenKopfStil addTabStop:TabellenkopfWert1Tab];
	NSTextTab* TabellenkopfWert2Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert2tab]autorelease];
	[TabellenKopfStil addTabStop:TabellenkopfWert2Tab];
	NSMutableParagraphStyle* TabelleStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[TabelleStil setTabStops:[NSArray array]];
//	[self Alert:@"ADWandler awake: nach TabelleStil setTabStops"];
	NSMutableString* TabellenkopfString=[NSMutableString stringWithCapacity:0];
	[TabellenkopfString retain];
	NSArray* TabellenkopfArray=[[NSArray arrayWithObjects:@"Zeit",@"Wert",nil]retain];
	int index;
	for (index=0;index<[TabellenkopfArray count];index++)
	{
		NSString* tempKopfString=[TabellenkopfArray objectAtIndex:index];
		//NSLog(@"tempKopfString: %@",tempKopfString);
		//Kommentar als Array von Zeilen
		[TabellenkopfString appendFormat:@"\t%@",tempKopfString];
		//NSLog(@"KommentarString: %@  index:%d",KommentarString,index);
		
	}
//	[self Alert:@"ADWandler awake: vor TabellenkopfString appendStrin"];
	[TabellenkopfString appendString:@"\n"];
	NSMutableAttributedString* attrKopfString=[[[NSMutableAttributedString alloc] initWithString:TabellenkopfString] autorelease]; 
	[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
	[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
	[[EinkanalDatenFeld textStorage]appendAttributedString:attrKopfString];
	[EinkanalDatenFeld setString:TabellenkopfString];
//	[self logRect:[EinkanalDiagramm frame]];
	
	NSRect OrdinatenFeld=[EinkanalDiagrammScroller frame];
//	[self logRect:OrdinatenFeld];
	OrdinatenFeld.size.width=30;
	OrdinatenFeld.size.height-=16;
	OrdinatenFeld.origin.x-=30;
	OrdinatenFeld.origin.y+=16;
//	[self Alert:@"ADWandler awake: vor EinkanalOrdinate"];
	EinkanalOrdinate=[[rOrdinate alloc]initWithFrame:OrdinatenFeld];
	int EinkanalTabIndex=[ADTab indexOfTabViewItemWithIdentifier:@"einkanal"];
	NSLog(@"EinkanalTabIndex: %d",EinkanalTabIndex);
	[[[ADTab tabViewItemAtIndex:EinkanalTabIndex]view]addSubview:EinkanalOrdinate];

	MehrkanalDaten=[[NSMutableDictionary alloc]initWithCapacity:8];
	[MehrkanalDiagrammScroller setLineScroll: 2.0];
	[MehrkanalDaten retain];
	NSMutableArray* tempMehrkanalArray=[[NSMutableArray alloc]initWithCapacity:0];
	[tempMehrkanalArray retain];
	[MehrkanalDaten setObject:tempMehrkanalArray forKey:@"datenarray"];

	float zeittab=40;
	float werttab=38;
	
	int MKTextschnitt=11;
	NSFont* MKTextFont;
	MKTextFont=[NSFont fontWithName:@"Helvetica" size: MKTextschnitt];
	NSMutableString* MKTabellenkopfString=[NSMutableString stringWithCapacity:0];
	[MKTabellenkopfString retain];
	NSMutableParagraphStyle* MKTabellenKopfStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[MKTabellenKopfStil setTabStops:[NSArray array]];
	NSTextTab* TabellenkopfZeitTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab]autorelease];
	[MKTabellenKopfStil addTabStop:TabellenkopfZeitTab];
	[MKTabellenkopfString appendFormat:@"\t%@",@"Zeit"];
	for (i=0;i<8;i++)
	{
	NSTextTab* TabellenkopfWertTab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:zeittab+(i+1)*werttab]autorelease];
	[MKTabellenKopfStil addTabStop:TabellenkopfWertTab];
	[MKTabellenkopfString appendFormat:@"\t%@",[[NSNumber numberWithInt:i]stringValue]];
	}
	NSMutableParagraphStyle* MKTabelleStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
	[MKTabelleStil setTabStops:[NSArray array]];
	
	[MKTabellenkopfString appendString:@"\n"];
	NSMutableAttributedString* MKattrKopfString=[[[NSMutableAttributedString alloc] initWithString:MKTabellenkopfString] autorelease]; 
	[MKattrKopfString addAttribute:NSParagraphStyleAttributeName value:MKTabellenKopfStil range:NSMakeRange(0,[MKTabellenkopfString length])];
	[MKattrKopfString addAttribute:NSFontAttributeName value:MKTextFont range:NSMakeRange(0,[MKTabellenkopfString length])];
	[[MehrkanalDatenFeld textStorage]appendAttributedString:MKattrKopfString];
	
	[[MKWertView textStorage]appendAttributedString:MKattrKopfString];
	[MehrkanalDatenFeld setString:MKTabellenkopfString];


	NSRect MehrkanalOrdinatenFeld=[MehrkanalDiagrammScroller frame];
//	[self logRect:MehrkanalOrdinatenFeld];
	MehrkanalOrdinatenFeld.size.width=30;
	MehrkanalOrdinatenFeld.size.height-=16;
	MehrkanalOrdinatenFeld.origin.x-=30;
	MehrkanalOrdinatenFeld.origin.y+=16;
	MehrkanalOrdinate=[[rOrdinate alloc]initWithFrame:MehrkanalOrdinatenFeld];
	int MehrkanalTabIndex=[ADTab indexOfTabViewItemWithIdentifier:@"mehrkanal"];
//	NSLog(@"MehrkanalTabIndex: %d",MehrkanalTabIndex);
	[[[ADTab tabViewItemAtIndex:MehrkanalTabIndex]view]addSubview:MehrkanalOrdinate];
	
	NSDictionary* EinheitenDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:2]forKey:@"minorteile"];
	[EinkanalDiagramm setEinheitenDicY: EinheitenDic];
	[EinkanalOrdinate setAchsenDic:EinheitenDic];
	[MehrkanalOrdinate setAchsenDic:EinheitenDic];
	NSDictionary* NullpunktDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:32]forKey:@"nullpunkt"];
	[EinkanalOrdinate setAchsenDic: NullpunktDic];
	[EinkanalDiagramm setEinheitenDicY: NullpunktDic];
//	[self Alert:@"ADWandler awake Schluss"];
}

- (NSArray*)TastenArrayAnEcke:(NSPoint)dieEcke
					mitHoehe:(float)dieHoehe
			mitKolonnenArray:(NSArray*)derKolonnenArray
			   mitTitelArray:(NSArray*)derTitelArray
			   mitTippTasten:(BOOL)derTyp
{
	NSMutableArray* tempTastenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	float breite=[[derKolonnenArray objectAtIndex:1]floatValue]-[[derKolonnenArray objectAtIndex:0]floatValue];
	NSPoint tempEcke=dieEcke;
	for (i=0;i<8;i++)
	{
		tempEcke.x=[[derKolonnenArray objectAtIndex:i]floatValue];
		//NSLog(@"tempEcke: x: %2.2f y: %2.2f  breite: %2.2f",tempEcke.x,tempEcke.y,breite);
		NSRect r=NSMakeRect(tempEcke.x,tempEcke.y,breite-5,dieHoehe-0.5);
		NSButton* tempTaste=[[NSButton alloc]initWithFrame:r];
		//NSLog(@"Typ: %d",derTyp);
		if (derTyp)
		{
		NSLog(@"Typ: 1");
			[tempTaste setButtonType:NSMomentaryPushInButton];
			//[tempTaste setBezelStyle:NSCellLightsByGray];
			[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];


		}
		else
		{
		NSLog(@"Typ: 0");
			//[tempTaste setBezelStyle:NSCellLightsByGray];
			[tempTaste setButtonType:NSPushOnPushOffButton];
			//[[tempTaste cell]setShowsStateBy:NSChangeGrayCellMask|NSContentsCellMask];
			[[tempTaste cell]setBezelStyle:NSShadowlessSquareBezelStyle];
		}
		[tempTaste setTitle:[derTitelArray objectAtIndex:i]];
		[tempTaste setTag:i];
		[tempTaste setAction:@selector(TastenArrayAktion:)];
		[tempTaste retain];
		[tempTastenArray addObject:tempTaste];
	}//for
	
	return tempTastenArray;
}

-(void)TastenArrayAktion:(id)sender
{
NSLog(@"TastenArrayAktion: i: %d state: %d",[sender tag],[sender state]);
}

- (IBAction)reportCancel:(id)sender
{
NSLog(@"ADWandler reportCancel");
[[self window]orderOut:0];
}

- (IBAction)reportClose:(id)sender
{
   //NSLog(@"ADWandler reportClose");
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

[[self window]orderOut:0];
}

- (IBAction)reportRead1Kanal:(id)sender
{
	NSLog(@"ADWandler reportRead1Kanal: %d",[KanalWahlTaste selectedSegment]);
	if (Track1KanalTimer)
	{
		[Track1KanalTimer invalidate];
	}
	
	int Kanal=[KanalWahlTaste selectedSegment];
	float Zoom=[[EinkanalZoomTaste titleOfSelectedItem]floatValue];
	if (Kanal<0)
	{
		NSLog(@"Kein Kanal");
		return;
	}
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
		[NotificationDic setObject:[NSNumber numberWithInt:Kanal] forKey:@"kanal"];
		[NotificationDic setObject:[NSNumber numberWithFloat:Zoom] forKey:@"Zoom"];
		[NotificationDic setObject:[NSNumber numberWithInt:Kanal] forKey:@"tag"];
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"state"];
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
		[self Read1KanalAktion:NotificationDic];
}

- (IBAction)reportTrack1Kanal:(id)sender
{
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

	NSLog(@"ADWandler reportTrack1Kanal state: %d",[sender state]);
	float Trackdauer=[[TrackZeitTaste titleOfSelectedItem]floatValue];
	NSLog(@"Trackdauer: %2.2f",Trackdauer);
	int Kanal=[KanalWahlTaste selectedSegment];
	float Zoom=[[EinkanalZoomTaste titleOfSelectedItem]floatValue];
	NSLog(@"Zoom: %2.2f",Zoom);
	if (Kanal<0)
	{
	NSLog(@"Kein Kanal");
	NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@"Abbrechen"];
	[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Kein Kanal"]];
	
	NSString* s1=@"Mindestens ein Kanal muss ausgewehlt sein.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	int antwort=[Warnung runModal];

	return;
	}
	if ([sender state])
	{
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:Kanal] forKey:@"kanal"];
	[NotificationDic setObject:[NSNumber numberWithFloat:Zoom] forKey:@"Zoom"];
	[NotificationDic setObject:[NSNumber numberWithInt:Kanal] forKey:@"tag"];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"state"];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
	
	Track1KanalTimer=[[NSTimer scheduledTimerWithTimeInterval:Trackdauer 
													  target:self 
													selector:@selector(Track1KanalTimerFunktion:) 
													userInfo:NotificationDic 
													 repeats:YES]retain];
	}
	else
	{
	[Track1KanalTimer invalidate];
	}
	

}

- (void)Track1KanalTimerFunktion:(NSTimer*)derTimer
{
	
	if ([TrackTaste state])
	{
		if ([derTimer userInfo])
		{
			
			[self Read1KanalAktion:[derTimer userInfo]];
		}
	}
	else
	{
		[derTimer invalidate];
	}
	
	
}


- (IBAction)reportClear1Kanal:(id)sender
{
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}
	[EinkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
	[[EinkanalDaten objectForKey:@"datenarray"]removeAllObjects];
	[Track1KanalTimer invalidate];
	NSLog(@"ADWandler reportClear1Kanal");
	NSView* tempContentView=[EinkanalDiagrammScroller contentView];
	[EinkanalDiagramm setFrame:[[EinkanalDiagrammScroller contentView]frame]];	
	[[EinkanalDiagrammScroller documentView] setFrame:[[EinkanalDiagrammScroller contentView]frame]];
	NSMutableString* TabellenkopfString=[NSMutableString stringWithCapacity:0];
	[TabellenkopfString retain];
	NSArray* TabellenkopfArray=[[NSArray arrayWithObjects:@"Zeit",@"Wert",nil]retain];
	int index;
	for (index=0;index<[TabellenkopfArray count];index++)
	{
		NSString* tempKopfString=[TabellenkopfArray objectAtIndex:index];
		//NSLog(@"tempKopfString: %@",tempKopfString);
		//Kommentar als Array von Zeilen
		[TabellenkopfString appendFormat:@"\t%@",tempKopfString];
		//NSLog(@"KommentarString: %@  index:%d",KommentarString,index);
		
	}
	[TabellenkopfString appendString:@"\n"];
	[EinkanalDatenFeld setString:TabellenkopfString];
	[EinkanalDiagramm clear1Kanal];
	
}

- (IBAction)reportReadAll:(id)sender
{
	NSLog(@"ADWandler reportReadAll");
		if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

	readAllIndex=0;
		
	NSTimer* readAllTimer=[[NSTimer scheduledTimerWithTimeInterval:sendAllDelay 
													  target:self 
													selector:@selector(readAllTimerFunktion:) 
													userInfo:[NSNumber numberWithInt:readAllIndex] 
													 repeats:YES]retain];

		
		
}

- (IBAction)reportEinkanalOffset:(id)sender
{
//NSLog(@"ADWandler reportEinkanalKanalOffset: %d",[sender intValue]);
[EinkanalDiagramm setOffsetY:[sender intValue]];
}

- (void)readAllTimerFunktion:(NSTimer*)derTimer
{
	if (readAllIndex<8)
	{
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"readall"];

		[NotificationDic setObject:[NSNumber numberWithInt:readAllIndex] forKey:@"kanal"];
		[NotificationDic setObject:[NSNumber numberWithFloat:1.0] forKey:@"Zoom"];
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"state"];


			
		[NotificationDic setObject:[NSNumber numberWithInt:readAllIndex] forKey:@"tag"];//tag
		NSNotification* readAllNote=[NSNotification notificationWithName:@"reportReadAll" object:NULL userInfo:NotificationDic];
		[readAllNote retain];
			//NSLog(@"ADWandler readAllTimerFunktion:readAllIndex: %d  NotificationDic: %@ ",readAllIndex,[NotificationDic description]);
			//NSLog(@"ADWandler readAllTimerFunktion: readAllNote: %@ ",[readAllNote description]);
			//NSLog(@"ADWandler readAllTimerFunktion:  readAllIndex: %d",readAllIndex);
		//	[self Read1KanalNotificationAktion:readAllNote];
			
		[self Read1KanalAktion:NotificationDic];

		readAllIndex++;
	}
	else
	{
		[derTimer invalidate];
		NSTimer* resetTimer=[[NSTimer scheduledTimerWithTimeInterval:sendResetDelay 
															  target:self 
															selector:@selector(resetTimerFunktion:) 
															userInfo:[NSNumber numberWithInt:readAllIndex] 
															 repeats:NO]retain];
		
		
		
	}
	
}

- (void)resetTimerFunktion:(NSTimer*)derTimer
{

[self resetADWandler:NULL];	
}



- (NSArray*)BitArray3AusInt:(int)dieZahl
{
	NSMutableArray* tempAdresseArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int tempZahl=dieZahl;
	int i;
	for (i=0;i<3;i++)
	{
	
	[tempAdresseArray addObject:[NSNumber numberWithInt:tempZahl%2]];
	tempZahl/=2;
	//NSLog(@"tempAdresseArray: %@",[tempAdresseArray description]);
	}
	//NSLog(@"tempAdresseArray fertig: %@",[tempAdresseArray description]);
	return tempAdresseArray;
}

- (void)Read1KanalAktion:(NSDictionary*)derDatenDic
{
	//NSLog(@"ADWandler Read1KanalAktion");
	start=[NSDate date];
	[start retain];
	NSMutableArray* tempAdresseArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
	[NotificationDic setObject:[derDatenDic objectForKey:@"Zoom"] forKey:@"Zoom"];//Zoom
	if ([[derDatenDic objectForKey:@"readall"]intValue])
	{
		[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"readall"];
	}
	else
	{
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"readall"];
	}
	int InterfaceNummer=[InterfaceNummerTaste selectedSegment];
	if (InterfaceNummer>=0)//Bit 0-2 mit Interface-Adresse setzen
	{
		[tempAdresseArray setArray:[self BitArray3AusInt:InterfaceNummer]]; 
	}
//	NSLog(@"ADWandler Read1KanalAktion: tempAdresseArray: %@",[tempAdresseArray description]);
	while ([tempAdresseArray count]<8)
	{
		[tempAdresseArray addObject:[NSNumber numberWithInt:0]];//Array erstellen
	}
	
	//NSLog(@"ADWandler Read1KanalAktion: tempAdresseArray nach init: %@",[tempAdresseArray description]);
	//NSLog(@"ADWandler Read1KanalAktion: derDatenDic: %@",[derDatenDic description]);
	int state=0;
	if ([derDatenDic objectForKey:@"state"])
	{
		state=[[derDatenDic objectForKey:@"state"]intValue];
	}//state
	if ([derDatenDic objectForKey:@"tag"])
	{
		int KanalNummer=[[derDatenDic objectForKey:@"tag"]intValue]%10;
		[NotificationDic setObject:[NSNumber numberWithInt:KanalNummer] forKey:@"kanalnummer"];//Kanal
		NSArray* tempKanalArray=[self BitArray3AusInt:KanalNummer];
		int i;
		for(i=0;i<3;i++)
		{
			[tempAdresseArray replaceObjectAtIndex:i+5 withObject:[tempKanalArray objectAtIndex:i]];//Kanal-Bits setzen

		}
	//NSLog(@"ADWandler Read1KanalAktion: tempAdresseArray nach tag: %@",[tempAdresseArray description]);
	}//if tag
	
	[NotificationDic setObject:tempAdresseArray forKey:@"adressearray"];//Adresse als Array
	[NotificationDic setObject:start forKey:@"startzeit"];
	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler Read1KanalAktion: Read1HexString: %@\n",Read1HexString);

	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse

	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];//Kanalnummer setzen
	start=[NSDate date];
	[start retain];

	//NSLog(@"ADWandler Read1KanalAktion:  readAllIndex: %d",readAllIndex);
	NSTimer* sendKanalNummerTimer=[[NSTimer scheduledTimerWithTimeInterval:sendKanalDelay 
														   target:self 
														 selector:@selector(sendKanalNummerTimerFunktion:) 
														 userInfo:NotificationDic 
														  repeats:NO]retain];
	



}


- (void)reportRead8Kanal:(id)sender
{
NSLog(@"reportRead8Kanal");
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

[self reportReadAll:sender];

}

- (IBAction)reportTrack8Kanal:(id)sender
{
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

	NSLog(@"ADWandler reportTrack8Kanal state: %d",[sender state]);
	float Trackdauer=[[MehrkanalTrackZeitTaste titleOfSelectedItem]floatValue];
	NSLog(@"Trackdauer: %2.2f",Trackdauer);
	int Kanal=[MehrkanalWahlTaste selectedSegment];
	float Zoom=[[MehrkanalZoomTaste titleOfSelectedItem]floatValue];
	NSLog(@"Zoom: %2.2f",Zoom);
	if (Kanal<0)
	{
	NSLog(@"Kein Kanal");
	NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@"Abbrechen"];
	[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Kein Kanal"]];
	
	NSString* s1=@"Mindestens ein Kanal muss ausgewŠhlt sein.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	int antwort=[Warnung runModal];

	return;
	}
	if ([sender state])
	{
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"kanalnummer"];
	[NotificationDic setObject:[NSNumber numberWithFloat:Zoom] forKey:@"Zoom"];
	[NotificationDic setObject:[NSNumber numberWithInt:Kanal] forKey:@"tag"];
	[NotificationDic setObject:[NSNumber numberWithInt:[sender state]] forKey:@"state"];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"readall"];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
	
	Track8KanalTimer=[[NSTimer scheduledTimerWithTimeInterval:Trackdauer 
													  target:self 
													selector:@selector(Track8KanalTimerFunktion:) 
													userInfo:NotificationDic 
													 repeats:YES]retain];
	}
	else
	{
	
	[Track8KanalTimer invalidate];
	}
	

}



- (void)Track8KanalTimerFunktion:(NSTimer*)derTimer
{
//	NSLog(@"Track8KanalTimerFunktion: note: %@",[[derTimer  userInfo]description]);
	if ([MehrkanalTrackTaste state])
	{
		{
		
//			NSLog(@"Track8KanalTimerFunktion: Timer Valid");
				readAllIndex=0;
		
	NSTimer* readAllTimer=[[NSTimer scheduledTimerWithTimeInterval:sendAllDelay 
													  target:self 
													selector:@selector(readAllTimerFunktion:) 
													userInfo:[NSNumber numberWithInt:readAllIndex] 
													 repeats:YES]retain];


		}
	}
	else
	{
		[derTimer invalidate];
	}
	
	
}



- (void)reportClear8Kanal:(id)sender
{
NSLog(@"reportClear8Kanal");
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[MehrkanalDatenFeld string]];//Vorhandene Daten im Wertfeld
	//NSLog(@"reportClear8Kanal tempZeilenString: %@",tempZeilenString);
	[self printMehrkanalDaten:NULL];
	[self saveMehrkanalDaten:NULL];
	
	[MehrkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
	NSMutableString* MKTabellenkopfString=[NSMutableString stringWithCapacity:0];//Tabellenkopf retten
	[MKTabellenkopfString retain];
	[MKTabellenkopfString appendFormat:@"\t%@",@"Zeit"];
	int i;
	for (i=0;i<8;i++)
	{
	[MKTabellenkopfString appendFormat:@"\t%@",[[NSNumber numberWithInt:i]stringValue]];
	}

	
	[[MehrkanalDaten objectForKey:@"datenarray"]removeAllObjects];
	
//	[[MehrkanalDaten objectForKey:@"datenarray"]addObject:TabellenkopfString];
	//NSLog(@"ADWandler reportClear8Kanal");
	//NSView* tempContentView=[MehrkanalDiagrammScroller contentView];
	[MehrkanalDiagramm setFrame:[[MehrkanalDiagrammScroller contentView]frame]];	
	[[MehrkanalDiagrammScroller documentView] setFrame:[[MehrkanalDiagrammScroller contentView]frame]];
	
	int index;
	
	[MKTabellenkopfString appendString:@"\n"];
	
	[MehrkanalDatenFeld setString:MKTabellenkopfString];
	[MKWertFeld setStringValue:@""];
	[MehrkanalDiagramm clear8Kanal];
	

}

- (void)reportAllChannels:(id)sender//alle Kanaele aktivieren oder deaktivieren
{
	NSLog(@"reportAllChannels stae: %d",[sender state]);
	int i;
	for (i=0;i<8;i++)
	{
		[MehrkanalWahlTaste setSelected:[sender state] forSegment:i];
		
	}
	
}

- (void)sendKanalNummerTimerFunktion:(NSTimer*)derTimer
{
//	NSTimeInterval now=[[NSDate date]timeIntervalSinceDate:start];
//	NSLog(@"sendKanalNummerTimerFunktion Zeit: %f",[[NSDate date]timeIntervalSinceDate:start]);
	if ([derTimer userInfo])
	{
	NSMutableDictionary* NotificationDic=(NSMutableDictionary*)[derTimer userInfo];
	NSMutableArray* tempAdresseArray=(NSMutableArray*)[NotificationDic objectForKey:@"adressearray"];
	[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:1]];//Start-Bit setzen
	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler sendKanalNummerTimerFunktion: Read1HexString: %@",Read1HexString);
	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];//Kanalnummer setzen
	
	NSTimer* sendStartBitTimer=[[NSTimer scheduledTimerWithTimeInterval:sendStartBitDelay 
														   target:self 
														 selector:@selector(sendStartBitTimerFunktion:) 
														 userInfo:NotificationDic 
														  repeats:NO]retain];

	}


}//sendKanalNummerTimerFunktion

- (void)sendStartBitTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"sendStartBitTimerFunktion");
//	NSTimeInterval now=[[NSDate date]timeIntervalSinceDate:start];
//	NSLog(@"sendStartBitTimerFunktion Zeit: %f",[[NSDate date]timeIntervalSinceDate:start]);

	if ([derTimer userInfo])
	{
	NSMutableDictionary* NotificationDic=(NSMutableDictionary*)[derTimer userInfo];
	NSMutableArray* tempAdresseArray=(NSMutableArray*)[NotificationDic objectForKey:@"adressearray"];
	[tempAdresseArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:1]];//Read-Bit setzen
	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler sendStartBitTimerFunktion: Read1HexString: %@",Read1HexString);
	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];//Kanalnummer setzen
	NSTimer* sendStartBitTimer=[[NSTimer scheduledTimerWithTimeInterval:sendReadBitDelay 
														   target:self 
														 selector:@selector(sendReadBitTimerFunktion:) 
														 userInfo:NotificationDic 
														  repeats:NO]retain];

	}
}//sendStartBitTimerFunktion

- (void)sendReadBitTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"sendReadBitTimerFunktion Zeit: %f",[[NSDate date]timeIntervalSinceDate:start]);

	//NSLog(@"sendReadBitTimerFunktion");
	if ([derTimer userInfo])
	{
	
	//Input-Aufforderung fuer Kanal an Interface senden
	NSMutableDictionary* tempInputDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	[tempInputDic setObject:[[derTimer userInfo]objectForKey:@"kanalnummer"] forKey:@"kanalnummer"];//Kanal
	[tempInputDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse		
	[tempInputDic setObject:[[derTimer userInfo]objectForKey:@"Zoom"] forKey:@"Zoom"];//Zoom
	[tempInputDic setObject:[[derTimer userInfo]objectForKey:@"readall"] forKey:@"readall"];//Datenserie von allen Kanaelen?
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"InputAktion" object:self userInfo:tempInputDic];
	
//Timer fuer reset
	NSTimer* sendStartBitTimer=[[NSTimer scheduledTimerWithTimeInterval:sendInputDelay 
														   target:self 
														 selector:@selector(sendResetTimerFunktion:) 
														 userInfo:[derTimer userInfo] 
														  repeats:NO]retain];

	}
}//sendReadBitTimerFunktion

- (void)sendResetTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"sendResetTimerFunktion Zeit: %f",[[NSDate date]timeIntervalSinceDate:start]);

	//NSLog(@"sendResetTimerFunktion");
	if ([derTimer userInfo])
	{
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//Reset senden
	NSMutableDictionary* NotificationDic=(NSMutableDictionary*)[derTimer userInfo];
	NSMutableArray* tempAdresseArray=(NSMutableArray*)[NotificationDic objectForKey:@"adressearray"];
	[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:0]];//Start-Bit zuruecksetzen
	NSString* Read1ResetHexString=[self HexStringAusBitArray:tempAdresseArray];
	[NotificationDic setObject:Read1ResetHexString forKey:@"hexstring"];//Adresse
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];//reset setzen

	}
}//sendResetTimerFunktion




- (void)Read1KanalNotificationAktion:(NSNotification*)note
{
	NSMutableArray* tempAdresseArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
	int InterfaceNummer=[InterfaceNummerTaste selectedSegment];
	if (InterfaceNummer>=0)//Bit 0-2 mit Interface-Adresse setzen
	{
	[tempAdresseArray setArray:[self BitArray3AusInt:InterfaceNummer]]; 
	}
	//NSLog(@"ADWandler Read1KanalNotificationAktion: tempAdresseArray: %@",[tempAdresseArray description]);
	while ([tempAdresseArray count]<8)
	{
	[tempAdresseArray addObject:[NSNumber numberWithInt:0]];//Array erstellen
	}
	
	//NSLog(@"ADWandler Read1KanalNotificationAktion: tempAdresseArray nach init: %@",[tempAdresseArray description]);
	//NSLog(@"ADWandler Read1KanalNotificationAktion: userInfo: %@",[[note userInfo] description]);
	int state=0;
	if ([[note userInfo]objectForKey:@"state"])
	{
		state=[[[note userInfo]objectForKey:@"state"]intValue];
	}//state
	if ([[note userInfo]objectForKey:@"tag"])
	{
		int KanalNummer=[[[note userInfo]objectForKey:@"tag"]intValue]%10;
		[NotificationDic setObject:[NSNumber numberWithInt:KanalNummer] forKey:@"kanalnummer"];//Kanal
		NSArray* tempKanalArray=[self BitArray3AusInt:KanalNummer];
		int i;
		for(i=0;i<3;i++)
		{
			[tempAdresseArray replaceObjectAtIndex:i+5 withObject:[tempKanalArray objectAtIndex:i]];//Kanal-Bits setzen

		}
		switch([[[note userInfo]objectForKey:@"tag"]intValue]/10)//row
		{
			case 0://Erste Tastenreihe: read
			{
				//NSLog(@"ADWandler Read1KanalNotificationAktion: read Kanal: %d",KanalNummer);
				[tempAdresseArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:1]];//Read-Bit setzen
				[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:1]];//Start-Bit setzen
				
				//NSLog(@"ADWandler Read1KanalNotificationAktion: tempAdresseArray read: %@",[tempAdresseArray description]);
			}break;
				
			case 1://Zweite Tastenreihe: track
			{
				
				//NSLog(@"ADWandler Read1KanalNotificationAktion: track Kanal: %d state: %d",KanalNummer,state);
				[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:1]];//Start-Bit setzen
				[NotificationDic setObject:tempAdresseArray forKey:@"adressearray"];
				
				[self track1Kanal:NotificationDic];
				
				
			}break;
		}//switch row
	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler Read1KanalNotificationAktion: Read1HexString: %@",Read1HexString);

	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse

	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];
		
	[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:0]];//Start-Bit zuruecksetzen
	NSString* Read1ResetHexString=[self HexStringAusBitArray:tempAdresseArray];
	[NotificationDic setObject:Read1ResetHexString forKey:@"resetstring"];//Adresse
	if ([sendTimer isValid])
	{
	//NSLog(@"Read1KanalNotificationAktion sendTimer invalidate");
	[sendTimer invalidate];
	}
	sendTimer=[[NSTimer scheduledTimerWithTimeInterval:sendAllDelay 
													  target:self 
													selector:@selector(sendTimerFunktion:) 
													userInfo:NotificationDic 
													 repeats:NO]retain];

	}//tag
}

- (void)track1Kanal:(NSDictionary*)derKanalDic
{
	if (Track1KanalTimer)
	{
		[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
		[Track8KanalTimer invalidate];
	}
	
	NSMutableArray* tempAdresseArray=(NSMutableArray*)[derKanalDic objectForKey:@"adressearray"];
	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler track1Kanal: Read1HexString: %@",Read1HexString);
	NSMutableDictionary* NotificationDic=(NSMutableDictionary*)derKanalDic;
	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];
	NSTimer* readTimer=[[NSTimer scheduledTimerWithTimeInterval:sendReadBitDelay 
														 target:self 
													   selector:@selector(sendStartBitTimerFunktion:) 
													   userInfo:NotificationDic 
														repeats:NO]retain];

}

- (void)sendTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"sendTimerFunktion");
	if ([derTimer userInfo])
	{
		NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
		NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
		int tempKanal=[[[derTimer userInfo]objectForKey:@"kanalnummer"]intValue];

		//NSLog(@"sendTimerFunktion userInfo: %@",[[derTimer userInfo] description]);
		[NotificationDic setObject:[NSNumber numberWithInt:tempKanal] forKey:@"kanalnummer"];//Kanal
		[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
		[NotificationDic setObject:[[derTimer userInfo]objectForKey:@"resetstring"] forKey:@"hexstring"];//Adresse mit Reset fuer Start
		
		[nc postNotificationName:@"InputAktion" object:self userInfo:NotificationDic];
//		[nc postNotificationName:@"InputAktion" object:self userInfo:[derTimer userInfo]];

//		[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];
		[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];
			
	}
}


- (void)setHexDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
[NetzBox setHexDaten:dieDaten forKanal:derKanal];
}



- (void)setIntDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
[NetzBox setIntDaten:dieDaten forKanal:derKanal];
}

- (void)setAnzeigeDaten:(NSString*)dieDaten forKanal:(int)derKanal
{
	[NetzBox setAnzeigeDaten:dieDaten forKanal:derKanal];
}

- (void)setGraphDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic
{
	
	//NSLog(@"setGraphDaten: %@  *Zeit: %@ Kanal: %d VorgabenDic: %@",dieDaten, [dieZeit description], derKanal, [derVorgabenDic description]);
	
	if ([[derVorgabenDic objectForKey:@"readall"]intValue])//Datenserie
	{
	//NSLog(@"setGraphDaten readall: %@ Zeit: %@ Kanal: %d",dieDaten, [dieZeit description], derKanal );
	[self setMehrkanalDaten:dieDaten zurZeit:dieZeit forKanal:derKanal mitVorgaben:derVorgabenDic];
	}
	else//Daten fŸr einen Kanal
	{
	[self setEinkanalDaten:dieDaten zurZeit:dieZeit forKanal:derKanal mitVorgaben:derVorgabenDic];
	}
	
	//[EinkanalDiagramm setGraphDaten:dieDaten forKanal:derKanal];

}

- (void)setEinkanalDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic
{
	NSScanner *scanner;
	int tempWert;
	scanner = [NSScanner scannerWithString:dieDaten];
	[scanner scanHexInt:&tempWert];
//	NSLog(@"setEinkanalDaten: %@ Zeit: %@ Kanal: %d",dieDaten, dieZeit, derKanal );
	float Zoom=1.0;
	if ([derVorgabenDic objectForKey:@"Zoom"])
	{
		Zoom=[[derVorgabenDic objectForKey:@"Zoom"]floatValue];
	}
	//NSLog(@"setEinkanalDaten Zoom: %2.2f",Zoom);

	float y=(float)tempWert;
	float tempZeit=0.0;
	NSMutableArray* tempDatenArray=(NSMutableArray*)[EinkanalDaten objectForKey:@"datenarray"];
	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler setEinkanalDaten tempDatenArray: %@",[tempDatenArray description]);		
		tempZeit=[dieZeit timeIntervalSinceDate:DatenserieStartZeit]*Zoom;		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler setEinkanalDaten                    leer  tempDatenArray: %@",[tempDatenArray description]);
		DatenserieStartZeit=[NSDate date];
		[DatenserieStartZeit retain];
		[EinkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		[EinkanalDiagramm setStartwertMitY:y];
			
	}
	
	
	NSView* tempContentView=[EinkanalDiagrammScroller contentView];
	NSPoint tempOrigin=[[EinkanalDiagrammScroller documentView] frame].origin;
	//NSLog(@"tempClipRect x: %f y: %f h: %f w: %f",tempClipRect.origin.x,tempClipRect.origin.y,tempClipRect.size.height,tempClipRect.size.width);
	[EinKanalDiagrammWertFeld setIntValue: y];
	NSRect tempFrame=[EinkanalDiagramm frame];
	[EinkanalDatenFeld scrollRangeToVisible:NSMakeRange ([[EinkanalDatenFeld string] length], 0)];
	//[EinkanalDatenFeld scrollRectToVisible:[[EinkanalDatenFeld enclosingScrollView] visibleRect]];

	float rest=tempFrame.size.width-tempZeit;
	if (rest<100)
	{
		if (rest<0)//Wert hat nicht Platz
		{
			tempFrame.size.width=tempZeit+100;
			tempOrigin.x=tempZeit-100;
		}
		else
		{
			tempFrame.size.width+=200;
			tempOrigin.x-=200;
		}
	[EinkanalDiagramm setFrame:tempFrame];	
	[[EinkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];
}


	[EinKanalDiagrammWertFeld setIntValue: y];//Wert an Feld schicken
	

	NSArray*tempEinkanalDatenArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	[tempDatenArray addObject:tempEinkanalDatenArray];
	
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[EinkanalDatenFeld string]];
//	NSLog(@"tempZeilenString vor: %@",tempZeilenString);
//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
//	NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
	NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];
	NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];
//	NSLog(@"tempZeitString: %@",tempZeitString);
//	NSLog(@"tempWertString: %@",tempWertString);
	[tempZeilenString appendFormat:@"\t%@\t%@\n",tempZeitString,tempWertString];
//	NSLog(@"tempZeilenString nach: %@",tempZeilenString);
	[EinkanalDatenFeld setString:tempZeilenString];
	[EinkanalDatenFeld scrollRangeToVisible:NSMakeRange ([[EinkanalDatenFeld string] length], 0)];

	
	
	//NSLog(@"ADWandler setEinkanalDaten                    tempDatenArray: %@",[tempDatenArray description]);
	[EinkanalDiagramm setWertMitX:tempZeit  mitY:y];
	
}

- (void)setMehrkanalDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic
{
	//NSLog(@"\n\n");
	//NSLog(@"setMehrkanalDaten Daten: %@ Kanal: %d",dieDaten, derKanal);
	float Zoom=1.0;
	//Dic fuer die neuen Vorgaben des Diagramms
	NSMutableDictionary* tempVorgabenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
	if ([derVorgabenDic objectForKey:@"Zoom"])
	{
		Zoom=[[derVorgabenDic objectForKey:@"Zoom"]floatValue];
	}
	Zoom=[[MehrkanalZoomTaste titleOfSelectedItem]floatValue];
	
	[tempVorgabenDic setObject:[NSNumber numberWithFloat:Zoom] forKey:@"faktorx"];
	NSScanner *scanner;
	int tempWert;
	scanner = [NSScanner scannerWithString:dieDaten];
	[scanner scanHexInt:&tempWert];
	float y=(float)tempWert;//Momentanwert fuer y
	//NSLog(@"setMehrkanalDaten Eingabedaten y: %2.2f",y);
		
	//Array mit ev schon vorhandenen DatensŠtzen holen
	NSMutableArray* tempDatenArray=(NSMutableArray*)[MehrkanalDaten objectForKey:@"datenarray"];
		
	NSPoint tempOrigin=[[MehrkanalDiagrammScroller documentView] frame].origin;//origin des DocView
	NSRect tempFrame=[MehrkanalDiagramm frame];//frame des Diagramms
				
	//Array fuer Zeit und Daten einer Zeile
	NSMutableArray* tempKanalDatenArray;

	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[MehrkanalDatenFeld string]];//Vorhandene Daten im Datenfeld
	//NSLog(@"tempZeilenString start: %@",tempZeilenString);
	//	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[MehrkanalDatenFeld string]];//Vorhandene Daten im Wertfeld

	if (derKanal==0)//Vorgaben fŸr Serie vom ersten kanal
	{
		//NSLog(@"setMehrkanalDaten Zoom: %2.2f",Zoom);
		
		//Dic fuer die neuen Kanaldatenserie einrichten
		//		tempKanalDatenDic=[[NSMutableDictionary alloc]initWithCapacity:0];
		
		//Array fŸr die Kanaldaten einrichten
		tempKanalDatenArray=[[[NSMutableArray alloc]initWithCapacity:9]autorelease];
		NSMutableArray* tempKanalSelektionArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];
		
		float tempZeit=0.0;
		int Kanal=[MehrkanalWahlTaste selectedSegment];
	
		if (Kanal<0)//kein Kanal
		{
			NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
			[Warnung addButtonWithTitle:@"OK"];
	//		[Warnung addButtonWithTitle:@""];
	//		[Warnung addButtonWithTitle:@""];
	//		[Warnung addButtonWithTitle:@"Abbrechen"];
			[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Kein Kanal"]];
		
			NSString* s1=@"Mindestens ein Kanal muss ausgewŠhlt sein.";
			NSString* s2=@"";
			NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
			[Warnung setInformativeText:InformationString];
			[Warnung setAlertStyle:NSWarningAlertStyle];
		
			int antwort=[Warnung runModal];

		}


		//Lesezeit fixieren	
		if ([tempDatenArray count])//schon Datenserien  im Array "mehrkanaldaten" im Dic MehrkanalDaten
		{
			//NSLog(@"ADWandler setMehrkanalDaten Kanal: %d tempDatenArray: %@",derKanal,[tempDatenArray description]);
			tempZeit=[dieZeit timeIntervalSinceDate:DatenserieStartZeit];//*Zoom;
			
		}
		else						//Leerer Datenarray im Array "mehrkanaldaten" im Dic MehrkanalDaten
		{
			NSLog(@"ADWandler setMehrkanalDaten   noch leer. Kanal: %d   tempDatenArray: %@",derKanal,[tempDatenArray description]);
			DatenserieStartZeit=[NSDate date];
			[DatenserieStartZeit retain];
			[MehrkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
			//		[MehrkanalDiagramm setStartwertMitY:y];
			NSMutableArray* tempStartWerteArray=[[NSMutableArray alloc]initWithCapacity:8];
			int i;
			for (i=0;i<8;i++)
			{
				//float y=(float)random() / RAND_MAX * (255);
				float starty=127.0;
				[tempStartWerteArray addObject:[NSNumber numberWithInt:(int)starty]];
			}
			[MehrkanalDiagramm setStartWerteArray:tempStartWerteArray];
			
		}
		
		//
		[ZeitFormatter setFormat:@"##0.00"];

//		NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
		NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];

//		NSLog(@"setMehrkanalDaten  Kanal 0: tempZeitString: %@",tempZeitString);
		
	
		//Erstes Element im String: Zeit
		[tempZeilenString appendFormat:@"\t%@",tempZeitString];
			
		//Array fuer Daten der Kanaele anlegen, Zeit und ersten Kanal einsetzen
		[tempKanalDatenArray addObject:tempZeitString];
		
		[tempKanalDatenArray addObject:[NSNumber numberWithFloat:y]];
		//NSLog(@"Kanal 0:  tempKanalDatenArray: %@",[tempKanalDatenArray description]);
		
//		NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];		
		NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];

		NSLog(@"tempWertString: %@",tempWertString);
		[tempZeilenString appendFormat:@"\t%@",tempWertString];
		//NSLog(@"tempZeilenString: %@",tempZeilenString);

		//Datenarray mit Zeit und Kanal 0 einsetzen
		[tempDatenArray addObject:tempKanalDatenArray];
			
			//Datenarray in Dic einsetzen
			//		[tempKanalDatenDic setObject:tempKanalDatenArray forKey:@"datenarray"]; 
			
			
			//DocumentView des Diagramms:  Laenge anpassen
			float rest=tempFrame.size.width-tempZeit*Zoom;
			if (rest<100)
			{
				//NSLog(@"rest zu klein",rest);
				if (rest<0)//Wert hat nicht Platz
				{
					tempFrame.size.width=(tempZeit*Zoom+100);
					tempOrigin.x=(tempZeit*Zoom-100);
				}
				else
				{
					tempFrame.size.width+=200;
					tempOrigin.x-=200;
				}
				//NSLog(@"tempFrame: neu origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
				//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
				
				[MehrkanalDiagramm setFrame:tempFrame];	
				[[MehrkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			}	
			
			
	}//Kanal 0
	else
	{
		//NSLog(@"Kanal: %d: tempKanalDatenArray: %@",derKanal);
		//Daten des Kanals in tempDatenArray y einsetzen
		tempKanalDatenArray =[tempDatenArray lastObject];
		[tempKanalDatenArray addObject:[NSNumber numberWithFloat:y]];		
		
		
		//Daten in String einsetzen
		   [DatenFormatter setFormat:@"##00"];

//		NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
		NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];
		
		//NSLog(@"tempWertString: %@",tempWertString);
		[tempZeilenString appendFormat:@"\t%@",tempWertString];
//		NSLog(@"tempZeilenString: %@",tempZeilenString);

	}	
	
	
	//NSLog(@"MehrkanalDaten: %@",[MehrkanalDaten description]);	
	if (derKanal==7)
	{
		NSLog(@"Kanal: %d: tempKanalDatenArray: %@",derKanal,[tempKanalDatenArray description]);
		NSString* DiagrammWertFeldString=[tempKanalDatenArray componentsJoinedByString:@"\t"];
		[MKWertFeld setStringValue:DiagrammWertFeldString];
		[MKWertView setString:DiagrammWertFeldString];
		//Array der selektierten Kanaele
		//NSLog(@"setMehrkanalDaten: Segment: %d:",[MehrkanalWahlTaste selectedSegment]);
		NSMutableArray* tempKanalSelektionArray=[[NSMutableArray alloc]initWithCapacity:8];
		int i;
		for(i=0;i<8;i++)
		{
			//Array der Daten einer Zeile: Element i der Datenleseaktion
			
			
			BOOL KanalSelektiert=[MehrkanalWahlTaste isSelectedForSegment:i];//Kanal aktiviert	
																			 //NSLog(@"setMehrkanalDaten:i: %d: selektiert%d",i,KanalSelektiert);		
			[tempKanalSelektionArray addObject:[NSNumber numberWithBool:KanalSelektiert]];
			
		}
		
		
		//[MehrkanalDiagramm setWerteArray:tempKanalDatenArray mitKanalArray:tempKanalSelektionArray];
		[MehrkanalDiagramm setWerteArray:tempKanalDatenArray mitKanalArray:tempKanalSelektionArray mitVorgabenDic:tempVorgabenDic];
		
		//neue Zeile
		[tempZeilenString appendFormat:@"\n"];//Zeilenende
		//NSLog(@"tempZeilenString schluss: %@",tempZeilenString);
		}
	[MehrkanalDatenFeld setString:tempZeilenString];
	[MehrkanalDatenFeld scrollRangeToVisible:NSMakeRange ([[MehrkanalDatenFeld string] length], 0)];

}


- (void)reportRead1RandomKanal:(id)sender
{
	[TrackRandomTaste setState:0];
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

	float y=	(float)random() / RAND_MAX * (255);
	float tempZeit=0.0;
	int Kanal=[KanalWahlTaste selectedSegment];
	NSLog(@"reportRead1RandomKanal: %d",[KanalWahlTaste selectedSegment]);
	if (Kanal<0)//kein Kanal
	{
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@"Abbrechen"];
	[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Kein Kanal"]];
	
	NSString* s1=@"Mindestens ein Kanal muss ausgewŠhlt sein.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	int antwort=[Warnung runModal];

	}
//	[self Alert:@"ADWandler reportRead1RandomKanal 1"];
	float Zoom=[[EinkanalZoomTaste titleOfSelectedItem]floatValue];

	NSMutableArray* tempDatenArray=(NSMutableArray*)[EinkanalDaten objectForKey:@"datenarray"];

	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler setEinkanalDaten tempDatenArray: %@",[tempDatenArray description]);
		
		tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit]*Zoom;
		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler setEinkanalDaten                    leer  tempDatenArray: %@",[tempDatenArray description]);

		DatenserieStartZeit=[NSDate date];
		[DatenserieStartZeit retain];
		[EinkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		[EinkanalDiagramm setStartwertMitY:y];
		
		
	}

//	[self Alert:[NSString stringWithFormat:@"Zeit: %2.2f",tempZeit]];

//	NSView* tempContentView=[EinkanalDiagrammScroller contentView];
	NSPoint tempOrigin=[[EinkanalDiagrammScroller documentView] frame].origin;

	//NSRect tempClipRect=[tempContentView frame];
	//NSLog(@"tempClipRect x: %f y: %f h: %f w: %f",tempClipRect.origin.x,tempClipRect.origin.y,tempClipRect.size.height,tempClipRect.size.width);
	NSRect tempFrame=[EinkanalDiagramm frame];
//	NSLog(@"tempFrame: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
	//NSLog(@"tempOrigin x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);

	float rest=tempFrame.size.width-tempZeit;
	if (rest<100)
	{
		if (rest<0)//Wert hat nicht Platz
		{
			tempFrame.size.width=tempZeit+100;
			tempOrigin.x=tempZeit-100;
		}
		else
		{
			tempFrame.size.width+=200;
			tempOrigin.x-=200;
		}
	[EinkanalDiagramm setFrame:tempFrame];	
	[[EinkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];
	NSLog(@"report nach Anpassen: EinkanalDiagrammScroller documentView origin: \n  x: %2.2f y: %2.2f",[[EinkanalDiagrammScroller documentView]frame].origin.x,[[EinkanalDiagrammScroller documentView]frame].origin.y);

	}
//	[self Alert:[NSString stringWithFormat:@"y: %2.2f",y]];

	NSArray*tempArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	[tempDatenArray addObject:tempArray];
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[EinkanalDatenFeld string]];
	//NSLog(@"tempZeilenString vor: %@",tempZeilenString);

//	[self Alert:[NSString stringWithFormat:@"tempzeilenstring: %@",tempZeilenString]];

//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
	NSString* tempZeitString=[NSString stringWithFormat: @"%2.2f",tempZeit];
//	NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
	NSString* tempWertString=[NSString stringWithFormat: @"%2.0f",y];
//	NSLog(@"tempZeitString: %@",tempZeitString);
	//NSLog(@"tempWertString: %@",tempWertString);
	[tempZeilenString appendFormat:@"\t%@\t%@\n",tempZeitString,tempWertString];
//	NSLog(@"tempZeilenString nach: %@",tempZeilenString);

	[EinkanalDatenFeld setString:tempZeilenString];
//	[self Alert:[NSString stringWithFormat:@"tempzeilenstring: %@",tempZeilenString]];


	[EinKanalDiagrammWertFeld setIntValue: y];
	//NSLog(@"ADWandler reportRead1RandomKanal       tempZeit: %2.2f  Wert: %d",tempZeit,y);
	[EinkanalDiagramm setWertMitX:tempZeit  mitY:y];
	

}

- (void)reportTrack1RandomKanal:(id)sender
{
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}
if ([sender state])
{
float Trackdauer=[[TrackZeitTaste titleOfSelectedItem]floatValue];

NSLog(@"ADWandler reportTrack1RandomKanal       Trackdauer: %2.2f ",Trackdauer);
[self Track1RandomKanalTimerFunktion:NULL];
	NSTimer* Track1KanalTimer=[[NSTimer scheduledTimerWithTimeInterval:Trackdauer 
													  target:self 
													selector:@selector(Track1RandomKanalTimerFunktion:) 
													userInfo:NULL 
													 repeats:YES]retain];
}
else
{
[Track1KanalTimer invalidate];
}
}

- (void)Track1RandomKanalTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"ADWandler Track1RandomKanalTimerFunktion");
	NSString* tabSeparator=@"\t";
	NSString* crSeparator=@"\r";

if ([TrackRandomTaste state])
{
		

	float y=	(float)random() / RAND_MAX * (255);
	float tempZeit=0.0;
	int Kanal=[KanalWahlTaste selectedSegment];
	float Zoom=[[EinkanalZoomTaste titleOfSelectedItem]floatValue];

	NSMutableArray* tempDatenArray=(NSMutableArray*)[EinkanalDaten objectForKey:@"datenarray"];

	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler Track1RandomKanalTimerFunktion tempDatenArray: %@",[tempDatenArray description]);
		
		tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit]*Zoom;
		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler Track1RandomKanalTimerFunktion     leer  tempDatenArray: %@",[tempDatenArray description]);
/*	
			float wert1tab=60;
		float wert2tab=100;
		int Textschnitt=12;
		NSFont* TextFont;
		TextFont=[NSFont fontWithName:@"Helvetica" size: Textschnitt];
		
		NSMutableParagraphStyle* TabellenKopfStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
		[TabellenKopfStil setTabStops:[NSArray array]];
		NSTextTab* TabellenkopfWert1Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert1tab]autorelease];
		[TabellenKopfStil addTabStop:TabellenkopfWert1Tab];
		NSTextTab* TabellenkopfWert2Tab=[[[NSTextTab alloc]initWithType:NSRightTabStopType location:wert2tab]autorelease];
		[TabellenKopfStil addTabStop:TabellenkopfWert2Tab];
		NSMutableParagraphStyle* TabelleStil=[[[NSMutableParagraphStyle alloc]init]autorelease];
		[TabelleStil setTabStops:[NSArray array]];
*/		
		DatenserieStartZeit=[NSDate date];
		[DatenserieStartZeit retain];
		[EinkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		[EinkanalDiagramm setStartwertMitY:y];
/*
		NSMutableString* TabellenkopfString=[NSMutableString stringWithCapacity:0];
		[TabellenkopfString retain];
		NSArray* TabellenkopfArray=[[NSArray arrayWithObjects:@"Zeit",@"Wert",nil]retain];
		int index;
		for (index=0;index<[TabellenkopfArray count];index++)
		{
			NSString* tempKopfString=[TabellenkopfArray objectAtIndex:index];
			//NSLog(@"tempKopfString: %@",tempKopfString);
			//Kommentar als Array von Zeilen
			[TabellenkopfString appendFormat:@"\t%@",tempKopfString];
			//NSLog(@"KommentarString: %@  index:%d",KommentarString,index);
			
		}
		[TabellenkopfString appendString:crSeparator];
		NSMutableAttributedString* attrKopfString=[[[NSMutableAttributedString alloc] initWithString:TabellenkopfString] autorelease]; 
		[attrKopfString addAttribute:NSParagraphStyleAttributeName value:TabellenKopfStil range:NSMakeRange(0,[TabellenkopfString length])];
		[attrKopfString addAttribute:NSFontAttributeName value:TextFont range:NSMakeRange(0,[TabellenkopfString length])];
		[[DatenFeld textStorage]appendAttributedString:attrKopfString];
		
		[DatenFeld setString:TabellenkopfString];
*/
	}
	
	NSArray*tempArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	[tempDatenArray addObject:tempArray];
	
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[EinkanalDatenFeld string]];
	NSLog(@"tempZeilenString vor: %@",tempZeilenString);
//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
//	NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
	NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];
	NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];


//	NSLog(@"tempZeitString: %@",tempZeitString);
//	NSLog(@"tempWertString: %@",tempWertString);
	[tempZeilenString appendFormat:@"\t%@\t%@\n",tempZeitString,tempWertString];
	NSLog(@"tempZeilenString nach: %@",tempZeilenString);
	[EinkanalDatenFeld setString:tempZeilenString];
	//[EinkanalDatenFeld scrollRangeToVisible:NSMakeRange(0, 0)];
	[EinkanalDatenFeld scrollRangeToVisible:NSMakeRange ([[EinkanalDatenFeld string] length], 0)];

/*
	NSString* tempDatenString=[NSString stringWithFormat:@"%@\t%@\n",tempZeitString,tempWertString];
	NSLog(@"tempDatenString: %@",tempDatenString);
	NSString* tempDatenFeldString=[DatenFeld string];
	NSLog(@"tempDatenFeldString vor: %@",tempDatenFeldString);
	tempDatenFeldString=[tempDatenFeldString stringByAppendingString:tempDatenString];
	NSLog(@"tempDatenFeldString nach: %@",tempDatenFeldString);
	[DatenFeld setString:tempDatenFeldString];
*/
	NSView* tempContentView=[EinkanalDiagrammScroller contentView];
	NSPoint tempOrigin=[[EinkanalDiagrammScroller documentView] frame].origin;
	//NSRect tempClipRect=[tempContentView frame];
	//NSLog(@"tempClipRect x: %f y: %f h: %f w: %f",tempClipRect.origin.x,tempClipRect.origin.y,tempClipRect.size.height,tempClipRect.size.width);
	[EinKanalDiagrammWertFeld setIntValue: y];
	NSRect tempFrame=[EinkanalDiagramm frame];
	float rest=tempFrame.size.width-tempZeit;
	if (rest<100)
	{
		if (rest<0)//Wert hat nicht Platz
		{
			tempFrame.size.width=tempZeit+100;
			tempOrigin.x=tempZeit-100;
		}
		else
		{
			tempFrame.size.width+=200;
			tempOrigin.x-=200;
		}
	[EinkanalDiagramm setFrame:tempFrame];	
	[[EinkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];

	}
	//NSLog(@"ADWandler reportRead1RandomKanal       tempZeit: %2.2f  Wert: %d",tempZeit,y);
	[EinkanalDiagramm setWertMitX:tempZeit  mitY:y];

													 
 }
 else
 {
 if (derTimer)//Beim ersten Aufruf mit NULL aufgerufen
 {
 [derTimer invalidate];
 }
 }

}


- (void)reportRead8RandomKanal:(id)sender
{
	NSLog(@"\n\n                       ADWandler reportRead8RandomKanal");
	//NSView* tempContentView=[MehrkanalDiagrammScroller contentView];
		if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

	NSPoint tempOrigin=[[MehrkanalDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[MehrkanalDiagramm frame];

//	NSLog(@"tempFrame: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
//	NSLog(@"tempOrigin x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
	
	//Array fuer Zeit und Daten einer Zeile
	NSMutableArray* tempKanalDatenArray=[[NSMutableArray alloc]initWithCapacity:9];
	NSMutableArray* tempKanalSelektionArray=[[NSMutableArray alloc]initWithCapacity:8];
	
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[MehrkanalDatenFeld string]];//Vorhandene Daten im Wertfeld

	float tempZeit=0.0;
	int Kanal=[MehrkanalWahlTaste selectedSegment];
	if (Kanal<0)//kein Kanal
	{
		NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
	[Warnung addButtonWithTitle:@"OK"];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@""];
//	[Warnung addButtonWithTitle:@"Abbrechen"];
	[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Kein Kanal"]];
	
	NSString* s1=@"Mindestens ein Kanal muss ausgewŠhlt sein.";
	NSString* s2=@"";
	NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
	[Warnung setInformativeText:InformationString];
	[Warnung setAlertStyle:NSWarningAlertStyle];
	
	int antwort=[Warnung runModal];

	}
	
	float Zoom=[[MehrkanalZoomTaste titleOfSelectedItem]floatValue];
	NSMutableArray* tempDatenArray=(NSMutableArray*)[MehrkanalDaten objectForKey:@"datenarray"];

	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler setEinkanalDaten tempDatenArray: %@",[tempDatenArray description]);
		tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit]*Zoom;
		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler setEinkanalDaten                    leer  tempDatenArray: %@",[tempDatenArray description]);

		DatenserieStartZeit=[NSDate date];
		[DatenserieStartZeit retain];
		[MehrkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		NSMutableArray* tempStartWerteArray=[[NSMutableArray alloc]initWithCapacity:8];

		int i;
		for (i=0;i<8;i++)
		{
		float y=(float)random() / RAND_MAX * (255);
		y=127.0;
		[tempStartWerteArray addObject:[NSNumber numberWithInt:(int)y]];
		}
		[MehrkanalDiagramm setStartWerteArray:tempStartWerteArray];
	}
	
//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
	NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];

//	NSLog(@"reportReadRandom8  tempZeitString: %@",tempZeitString);
	[tempZeilenString appendFormat:@"\t%@",tempZeitString];
	
	
	int i;
	for (i=0;i<8;i++)
	{
		float y=(float)random() / RAND_MAX * (255);
		[tempKanalDatenArray addObject:[NSNumber numberWithInt:(int)y]];
		
//		NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
		NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];
		
		//NSLog(@"tempWertString: %@",tempWertString);
		[tempZeilenString appendFormat:@"\t%@",tempWertString];
		
		//Array der Daten einer Zeile: Element i der Datenleseaktion
		BOOL KanalSelektiert=[MehrkanalWahlTaste isSelectedForSegment:i];//Kanal aktiviert
			
			[tempKanalSelektionArray addObject:[NSNumber numberWithBool:KanalSelektiert]];
			
			if (i==0)
			{	
				float rest=tempFrame.size.width-tempZeit;
				if (rest<100)
				{
					//NSLog(@"rest zu klein",rest);
					if (rest<0)//Wert hat nicht Platz
					{
						tempFrame.size.width=tempZeit+100;
						tempOrigin.x=tempZeit-100;
					}
					else
					{
						tempFrame.size.width+=200;
						tempOrigin.x-=200;
					}
					//NSLog(@"tempFrame: neu origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
					//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
					
					[MehrkanalDiagramm setFrame:tempFrame];	
					[[MehrkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			
					
				}
			}//i=0;
			
	}
		
	//NSLog(@"tempZeilenString: %@",tempZeilenString);
	{
	[tempZeilenString appendFormat:@"\n"];//Zeilenende
	}
	NSArray* ZeilenArray=[tempZeilenString componentsSeparatedByString:@"\n"];
	//NSLog(@"ZeilenArray: %@",[ZeilenArray description]);

	NSString* neueZeile=[ZeilenArray objectAtIndex:[ZeilenArray count]-2];
//	NSLog(@"neueZeile: %@",neueZeile);
	[MKWertFeld setStringValue: neueZeile];
	
	
	[MehrkanalDatenFeld setString:tempZeilenString];
	
			
	//Array der Daten einer Zeile: erstes Element: Zeit der Datenleseaktion
	[tempKanalDatenArray insertObject:[NSNumber numberWithFloat:tempZeit] atIndex:0];
	//	NSArray*tempArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	[tempDatenArray addObject:tempKanalDatenArray];
	//NSLog(@"tempZeilenString vor: %@",tempZeilenString);
	
	//NSLog(@"Mehrkanal tempZeilenString nach: %@",tempZeilenString);
	
	
	//[MehrkanalDatenFeld setString:tempZeilenString];
	
	
		
	//NSLog(@"ADWandler reportRead8RandomKanal       tempZeit: %2.2f  Werte: %@",tempZeit,[tempKanalDatenArray description]);
	
	[MehrkanalDiagramm setWerteArray:tempKanalDatenArray mitKanalArray:tempKanalSelektionArray];
	
		
		
}

- (void)reportTrack8RandomKanal:(id)sender
{
	if (Track1KanalTimer)
	{
	[Track1KanalTimer invalidate];
	}
	if (Track8KanalTimer)
	{
	[Track8KanalTimer invalidate];
	}

float Trackdauer=[[MehrkanalTrackZeitTaste titleOfSelectedItem]floatValue];

	//NSLog(@"ADWandler reportTrack8RandomKanal       Trackdauer: %2.2f ",Trackdauer);
[self Track1RandomKanalTimerFunktion:NULL];
	NSTimer* Track8KanalTimer=[[NSTimer scheduledTimerWithTimeInterval:Trackdauer 
													  target:self 
													selector:@selector(Track8RandomKanalTimerFunktion:) 
													userInfo:NULL 
													 repeats:YES]retain];

}


- (void)Track8RandomKanalTimerFunktion:(NSTimer*)derTimer
{
	//NSLog(@"ADWandler Track8RandomKanalTimerFunktion");
	NSString* tabSeparator=@"\t";
	NSString* crSeparator=@"\r";
	
	NSMutableString* tempZeilenString=[NSMutableString stringWithString:[MehrkanalDatenFeld string]];//Vorhandene Daten im Wertfeld
	//NSLog(@"tempZeilenString: %@",tempZeilenString);
	//Array fuer Zeit und Daten einer Zeile
	NSMutableArray* tempKanalDatenArray=[[NSMutableArray alloc]initWithCapacity:9];
	NSMutableArray* tempKanalSelektionArray=[[NSMutableArray alloc]initWithCapacity:8];
	NSPoint tempOrigin=[[MehrkanalDiagrammScroller documentView] frame].origin;
	NSRect tempFrame=[MehrkanalDiagramm frame];

if ([MehrkanalTrackRandTaste state])
{
	float y=	(float)random() / RAND_MAX * (255);
	float tempZeit=0.0;
	int Kanal=[MehrkanalWahlTaste selectedSegment];
	float Zoom=[[EinkanalZoomTaste titleOfSelectedItem]floatValue];

	NSMutableArray* tempDatenArray=(NSMutableArray*)[MehrkanalDaten objectForKey:@"datenarray"];

	if ([tempDatenArray count])//schon Daten im Array
	{
		//NSLog(@"ADWandler Track1RandomKanalTimerFunktion tempDatenArray: %@",[tempDatenArray description]);
		
		tempZeit=[[NSDate date] timeIntervalSinceDate:DatenserieStartZeit]*Zoom;
		
	}
	else //Leerer Datenarray
	{
		//NSLog(@"ADWandler Track1RandomKanalTimerFunktion     leer  tempDatenArray: %@",[tempDatenArray description]);
		DatenserieStartZeit=[NSDate date];
		[DatenserieStartZeit retain];
		[MehrkanalDaten setObject:[NSDate date] forKey:@"datenseriestartzeit"];
		NSMutableArray* tempStartWerteArray=[[NSMutableArray alloc]initWithCapacity:8];

		int i;
		for (i=0;i<8;i++)
		{
		float y=(float)random() / RAND_MAX * (255);
		y=127.0;
		[tempStartWerteArray addObject:[NSNumber numberWithInt:(int)y]];
		}
		[MehrkanalDiagramm setStartWerteArray:tempStartWerteArray];
	}
	
//	NSString* tempZeitString=[ZeitFormatter stringFromNumber:[NSNumber numberWithFloat:tempZeit]];
	NSString* tempZeitString=[NSString stringWithFormat:@"%2.2f",tempZeit];

//	NSLog(@"tempZeitString: %@",tempZeitString);
	[tempZeilenString appendFormat:@"\t%@",tempZeitString];
	
	
	int i;
	for (i=0;i<8;i++)
	{
		float y=(float)random() / RAND_MAX * (255);
		[tempKanalDatenArray addObject:[NSNumber numberWithInt:(int)y]];
		
//		NSString* tempWertString=[DatenFormatter stringFromNumber:[NSNumber numberWithFloat:y]];
		NSString* tempWertString=[NSString stringWithFormat:@"%2.0f",y];
		
		//NSLog(@"tempWertString: %@",tempWertString);
		[tempZeilenString appendFormat:@"\t%@",tempWertString];
		
		//Array der Daten einer Zeile: Element i der Datenleseaktion
		BOOL KanalSelektiert=[MehrkanalWahlTaste isSelectedForSegment:i];//Kanal aktiviert
			
			[tempKanalSelektionArray addObject:[NSNumber numberWithBool:KanalSelektiert]];
			
			if (i==0)
			{	
				float rest=tempFrame.size.width-tempZeit;
				if (rest<100)
				{
					//NSLog(@"rest zu klein",rest);
					if (rest<0)//Wert hat nicht Platz
					{
						tempFrame.size.width=tempZeit+100;
						tempOrigin.x=tempZeit-100;
					}
					else
					{
						tempFrame.size.width+=200;
						tempOrigin.x-=200;
					}
					//NSLog(@"tempFrame: neu origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.height, tempFrame.size.width);
					//NSLog(@"tempOrigin neu  x: %2.2f y: %2.2f",tempOrigin.x,tempOrigin.y);
					
					[MehrkanalDiagramm setFrame:tempFrame];	
					[[MehrkanalDiagrammScroller documentView] setFrameOrigin:tempOrigin];
			
					
				}
			}//i=0;
			
	}
		
	//NSLog(@"tempZeilenString: %@",tempZeilenString);
	{
	[tempZeilenString appendFormat:@"\n"];//Zeilenende
	}
	NSArray* ZeilenArray=[tempZeilenString componentsSeparatedByString:@"\n"];
	//NSLog(@"ZeilenArray: %@",[ZeilenArray description]);

	NSString* neueZeile=[ZeilenArray objectAtIndex:[ZeilenArray count]-2];
//	NSLog(@"neueZeile: %@",neueZeile);
	[MKWertFeld setStringValue: neueZeile];
	[MKWertView setString: neueZeile];

	[MehrkanalDatenFeld setString:tempZeilenString];
	[MehrkanalDatenFeld scrollRangeToVisible:NSMakeRange ([[MehrkanalDatenFeld string] length], 0)];

			
	//Array der Daten einer Zeile: erstes Element: Zeit der Datenleseaktion
	[tempKanalDatenArray insertObject:[NSNumber numberWithFloat:tempZeit] atIndex:0];
	//	NSArray*tempArray=[NSArray arrayWithObjects:[NSNumber numberWithFloat:tempZeit],[NSNumber numberWithFloat:y],nil];
	//NSLog(@"Zeile: %d tempKanalDatenArray: %@",[tempDatenArray count],[tempKanalDatenArray description]);
	[tempDatenArray addObject:tempKanalDatenArray];
	//NSLog(@"tempZeilenString vor: %@",tempZeilenString);
	
	//NSLog(@"Mehrkanal tempZeilenString nach: %@",tempZeilenString);
	
	//[MehrkanalDatenFeld setString:tempZeilenString];
	
	//NSLog(@"ADWandler reportRead8RandomKanal       tempZeit: %2.2f  Werte: %@",tempZeit,[tempKanalDatenArray description]);
	
	[MehrkanalDiagramm setWerteArray:tempKanalDatenArray mitKanalArray:tempKanalSelektionArray];
													 
 }
 else
 {
 if (derTimer)//Beim ersten Aufruf mit NULL aufgerufen
 {
	[derTimer invalidate];
 }
 }

}

- (void)resetADWandler:(id)sender
{
	NSMutableArray* tempAdresseArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"paketnummer"];//Adresse
	int InterfaceNummer=[InterfaceNummerTaste selectedSegment];
	if (InterfaceNummer>=0)//Bit 0-2 mit Interface-Adresse setzen
	{
//	[tempAdresseArray setArray:[self BitArray3AusInt:InterfaceNummer]]; 
	}
	//NSLog(@"ADWandler resetADWandler: tempAdresseArray: %@",[tempAdresseArray description]);
	while ([tempAdresseArray count]<8)
	{
	[tempAdresseArray addObject:[NSNumber numberWithInt:0]];//Array erstellen
	}
	
	//NSLog(@"ADWandler resetADWandler: tempAdresseArray nach init: %@",[tempAdresseArray description]);
	
//	[tempAdresseArray replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:0]];//Read-Bit zuruecksetzen
	[tempAdresseArray replaceObjectAtIndex:4 withObject:[NSNumber numberWithInt:0]];//Start-Bit zuruecksetzen

	NSString* Read1HexString=[self HexStringAusBitArray:[tempAdresseArray retain]];
	//NSLog(@"ADWandler Read1KanalNotificationAktion: Read1HexString: %@",Read1HexString);

	[NotificationDic setObject:Read1HexString forKey:@"hexstring"];//Adresse

	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"SendAktion" object:self userInfo:NotificationDic];
		
//	[EinkanalDiagramm setWertMitX:tempZeit  mitY:y];

}

- (NSString*)HexStringAusBitArray:(NSArray*)derBitArray
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
- (IBAction)saveMehrkanalDaten:(id)sender
{
	//NSString* Pfad=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSSavePanel* SichernPanel=[NSSavePanel savePanel];
	[SichernPanel setDelegate:self];
	[SichernPanel setCanCreateDirectories:YES];
	[SichernPanel runModalForDirectory:lastDir file:@"Mehrkanaldaten.xls"];
	NSLog(@"saveMehrkanalDaten: %@ Dir: %@",[SichernPanel filename],[SichernPanel directory]);
	
	int saveOK=[[MehrkanalDatenFeld string] writeToFile:[SichernPanel filename] atomically:YES];
}

- (void)printMehrkanalDaten:(id)sender
{
	NSPrintInfo* PrintInfo=[NSPrintInfo sharedPrintInfo];
	 [PrintInfo setOrientation:NSPortraitOrientation];


	[PrintInfo setVerticalPagination: NSAutoPagination];

	[PrintInfo setHorizontallyCentered:NO];
	[PrintInfo setVerticallyCentered:NO];
	NSRect bounds=[PrintInfo imageablePageBounds];
	
	int x=bounds.origin.x;int y=bounds.origin.y;int h=bounds.size.height;int w=bounds.size.width;
	//NSLog(@"Bounds 1 x: %d y: %d  h: %d  w: %d",x,y,h,w);
	NSSize Papiergroesse=[PrintInfo paperSize];
	int leftRand=(Papiergroesse.width-bounds.size.width)/2;
	int topRand=(Papiergroesse.height-bounds.size.height)/2;
	int platzH=(Papiergroesse.width-bounds.size.width);
		
	int freiLinks=60;
	int freiOben=30;
	//int DruckbereichH=bounds.size.width-freiLinks+platzH*0.5;
	int DruckbereichH=Papiergroesse.width-freiLinks-leftRand;
	
	int DruckbereichV=bounds.size.height-freiOben;

	int platzV=(Papiergroesse.height-bounds.size.height);
	
	//NSLog(@"platzH: %d  platzV %d",platzH,platzV);

	int botRand=(Papiergroesse.height-topRand-bounds.size.height-1);
	
	[PrintInfo setLeftMargin:freiLinks];
	[PrintInfo setRightMargin:leftRand];
	[PrintInfo setTopMargin:freiOben];
	[PrintInfo setBottomMargin:botRand];

	NSPrintOperation* DruckOperation;
	DruckOperation=[NSPrintOperation printOperationWithView: MehrkanalDatenFeld
												  printInfo:PrintInfo];
	[DruckOperation setShowPanels:YES];
	[DruckOperation runOperation];

}

- (void)setEinkanalWahlTaste:(int)dieTaste
{
if (dieTaste>=0)
{
	NSLog(@"setEinkanalWahlTaste: %d",dieTaste);
	[KanalWahlTaste setSelected:YES forSegment:dieTaste];
	}
}

- (int)EinkanalWahlTastensegment
{
return [KanalWahlTaste selectedSegment];
}

- (NSArray*)MehrkanalTastenArray
{
int i;
NSMutableArray* tempKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
for(i=0;i<8;i++)
{
	int index=[MehrkanalWahlTaste isSelectedForSegment:i];
	[tempKanalArray addObject:[NSNumber numberWithInt:index]];
}//for i
return tempKanalArray;
}

- (void)setMehrkanalWahlTasteMitArray:(NSArray*)derTastenArray
{
NSLog(@"derTastenArray: %@",[derTastenArray description]);
int i;
for(i=0;i<8;i++)
{
	int index=[[derTastenArray objectAtIndex:i]intValue];
	if ([[derTastenArray objectAtIndex:i]intValue])
	{
//	[MehrkanalWahlTaste selectSegmentWithTag:i];
	[MehrkanalWahlTaste setSelected:YES forSegment:i];
	}
}//for i

}

- (void)setInterfaceNummer:(int)dieNummer
{
if (dieNummer>=0)
{
	lastInterfaceNummer=dieNummer;
//	[InterfaceNummerTaste selectSegmentWithTag:dieNummer];
	[InterfaceNummerTaste setSelected:YES forSegment:dieNummer ];
	}
}

- (int)lastInterfaceNummer
{
return [InterfaceNummerTaste selectedSegment];
}

- (void)setTabIndex:(int)derIndex
{
	NSLog(@"setTabIndex: %d",derIndex);
	
	if(derIndex>=0)
	{
	lastTabIndex=derIndex;
	[ADTab selectTabViewItemAtIndex:derIndex];
	}
}


- (int)lastTabIndex
{
return lastTabIndex;
}


- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
NSLog(@"didSelectTabViewItem: %@",[tabViewItem identifier]);
lastTabIndex=[ADTab indexOfTabViewItem:tabViewItem];
NSLog(@"didSelectTabViewItem: %@ index: %d",[tabViewItem identifier],lastTabIndex);

}
- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"windowShouldClose");
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];

	
	
	return YES;
}

@end
