//
//  AVR.m
//  USBInterface
//
//  Created by Sysadmin on 01.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rAVR.h"
#import "rElement.h"

extern int usbstatus;


//#define MO 0
//#define DI 1

//#define TAGPLANBREITE		0x40	// 64 Bytes, 2 page im EEPROM

//#define RAUMPLANBREITE		0x200	// 512 Bytes

#define PFEILSCHRITT 4

#define LINE         0
#define MANRIGHT     1
#define MANUP        2
#define MANLEFT      3
#define MANDOWN      4

#define STEPEND_A          0x00        // Motor A hat Ende der Steps erreicht
#define STEPEND_B          0x10
#define STEPEND_C          0x20
#define STEPEND_D          0x30



#define FIRST_BIT       0 // in 'position' von reportStopKnopf: Abschnitt ist first
#define LAST_BIT        1 // in 'position' von reportStopKnopf: Abschnitt ist last

/*
@implementation rPfeiltasteCell

- (id)init
{
   if ([super init])
   {
      richtung=0;
      return self;
   }
   return NULL;
}

- (void)setRichtung:(int)dieRichtung
{
   richtung=dieRichtung;
}

- (IBAction)mouseDown:(NSEvent*)theEvent
{
    NSLog(@"PfeiltasteCell mouseDown");
}

@end
*/

int max_value(float * p_array,unsigned int values_in_array,float * p_max_value)
{
   int position;
   
   position = 0;
   *p_max_value = p_array[position];
   for (position = 1; position < values_in_array; ++position)
   {
      if (p_array[position] > *p_max_value)
      {
         *p_max_value = p_array[position];
         break;
      }
   }
   return position;
}

int min_value(float * p_array,unsigned int values_in_array,float * p_min_value)
{
   int position;
   
   position = 0;
   *p_min_value = p_array[position];
   for (position = 1; position < values_in_array; ++position)
   {
      if (p_array[position] < *p_min_value)
      {
         *p_min_value = p_array[position];
         break;
      }
   }
   return position;
}



@implementation  rPfeiltaste  



- (void)awakeFromNib
{
   //NSLog(@"Pfeiltaste awakeFromNib");
   //richtung=1;
//- (void)setPeriodicDelay:(float)delay interval:(float)interval
   //[self setPeriodicDelay:1 interval:1];
}

- (void)mouseUp:(NSEvent *)event
{
  // NSLog(@"up");
   richtung=[self tag];
   NSLog(@"Pfeiltaste mouseUp richtung: %d",richtung);
   [self setState:NSOffState];
   
   NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:richtung] forKey:@"richtung"];
	
   int aktpwm=0;
   
   [NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"push"];
      
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Pfeil" object:self userInfo:NotificationDic];


}

  - (void)mouseDown:(NSEvent *)theEvent
{
   
   richtung=[self tag];

   //NSLog(@"Pfeiltaste mouseDown richtung: %d",richtung);
   [self setState:NSOnState];
	
   
   NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:richtung] forKey:@"richtung"];
	[NotificationDic setObject:[NSNumber numberWithInt:1] forKey:@"push"];// Start, nur fuer AVR
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Pfeil" object:self userInfo:NotificationDic];
   [super mouseDown:theEvent];
   
   [self mouseUp:theEvent];

}


/*
- (void)mouseUp:(NSEvent *)theEvent
{
   richtung=[self tag];
   NSLog(@"Pfeiltaste mouseUp richtung: %d",richtung);
   [self setState:NSOffState];
   
   NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:richtung] forKey:@"richtung"];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"push"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"Pfeil" object:self userInfo:NotificationDic];
   [super mouseDown:theEvent];
   
}
 */

- (void)setRichtung:(int)dieRichtung
{
   richtung=dieRichtung;
}

- (int)Tastestatus
{
   return [Taste state];
}



- (int)Richtung
{
   return richtung;
}
@end


@implementation rAVR
@synthesize Kote = KoteWert;


- (NSDictionary*)maxminWertVonArray:(NSArray*) WerteArray
{
   int position;
   int minpos = 0;
   int maxpos = 0;
   position = 0;
   
   float maxWert = [[WerteArray objectAtIndex:position]floatValue];
   float minWert = [[WerteArray objectAtIndex:position]floatValue];
   for (position = 1; position < [WerteArray  count]; position++)
   {
      float tempwert = [[WerteArray objectAtIndex:position]floatValue];
      //fprintf(stderr, "%d \twert: %.5f\n",position,tempwert);

      if (tempwert > maxWert)
      {
         maxWert = tempwert;
         maxpos = position;
      }
      if (tempwert < minWert)
      {
         minWert = tempwert;
         minpos = position;
      }
      
   }
   NSDictionary* returnDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:maxWert], @"maxwert",[NSNumber numberWithFloat:minWert], @"minwert",[NSNumber numberWithInt:maxpos], @"maxpos",[NSNumber numberWithInt:minpos], @"minpos",nil];
   return returnDic;
}

- (void)Alert:(NSString*)derFehler
{

	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

- (NSString*)IntToBin:(int)dieZahl
{
   int rest=0;
   int zahl=dieZahl;
   NSString* BinString=[NSString string];;
   while (zahl)
   {
      rest=zahl%2;
      if (rest)
      {
         BinString=[@"1" stringByAppendingString:BinString];
      }
      else
      {
         BinString=[@"0" stringByAppendingString:BinString];
      }
      zahl/=2;
      //NSLog(@"BinString: %@",BinString);
   }
   return BinString;
}

- (int)HexStringZuInt:(NSString*) derHexString
{
	int returnInt=-1;
	NSScanner* theScanner = [NSScanner scannerWithString:derHexString];
	
	if ([theScanner scanHexInt:&returnInt])
	{
		NSLog(@"HexStringZuInt string: %@ int: %x	",derHexString,returnInt);
		return returnInt;
	}

return returnInt;
}

- (NSMutableDictionary*)readCNC_PList
{
	BOOL CNCDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"]retain];
   NSString* PListName=@"CNC.plist";
   NSString* PListPfad;
   PListPfad=[USBPfad stringByAppendingPathComponent:PListName];

   
   CNCDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    USBPfad: %@",USBPfad);	
   if (CNCDatenDa)
	{

		
		//NSLog(@"\n\n");
		//NSLog(@"readCNC_PList: PListPfad: %@ ",PListPfad);
		if (PListPfad)		
		{
         //NSMutableDictionary* tempPListDic;// = [[NSMutableDictionary alloc]initWithCapacity:0];

			//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			if ([Filemanager fileExistsAtPath:PListPfad])
			{
            
				NSMutableDictionary* tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
				//NSLog(@"readCNC_PList: tempPListDic: %@",[tempPListDic description]);
            
				if ([tempPListDic objectForKey:@"koordinatentabelle"])
				{
					//NSArray* PListKoordTabelle=[tempPListDic objectForKey:@"koordinatentabelle"];
               //NSLog(@"readCNC_PList: PListKoordTabelle: %@",[PListKoordTabelle description]);
            }
            
            if ([tempPListDic objectForKey:@"pwm"])
            {
               [DC_PWM setIntValue:[[tempPListDic objectForKey:@"pwm"]intValue]];
               [DC_Stepper setIntValue:[[tempPListDic objectForKey:@"pwm"]intValue]];
               
            }
            else
            {
               [DC_PWM setIntValue:1];
            }
            
            if ([tempPListDic objectForKey:@"speed"])
            {
               [SpeedFeld setIntValue:[[tempPListDic objectForKey:@"speed"]intValue]];
               [SpeedStepper setIntValue:[[tempPListDic objectForKey:@"speed"]intValue]];
            }
            else
            {
               [SpeedFeld setIntValue:12];
            }

            if ([tempPListDic objectForKey:@"abbranda"])
            {
               //NSLog(@"abbranda: %2.2f",[[tempPListDic objectForKey:@"abbranda"]floatValue]);
               [AbbrandFeld setFloatValue:[[tempPListDic objectForKey:@"abbranda"]floatValue]];
               
            }
            else
            {
               [AbbrandFeld setFloatValue:1.7];
            }
            
            // Profilname A
            if ([tempPListDic objectForKey:@"profilnamea"])
            {
               //NSLog(@"profilnamea: %@",[tempPListDic objectForKey:@"profilnamea"]);
               [ProfilNameFeldA setStringValue:[tempPListDic objectForKey:@"profilnamea"]];
               
            }
            else
            {
               [ProfilNameFeldA setStringValue:@"*"];
            }
           
            // Profilname B
            if ([tempPListDic objectForKey:@"profilnameb"])
            {
               //NSLog(@"profilnameb: %@",[tempPListDic objectForKey:@"profilnameb"]);
               [ProfilNameFeldB setStringValue:[tempPListDic objectForKey:@"profilnameb"]];
               
            }
            else
            {
               [ProfilNameFeldB setStringValue:@"*"];
            }
            

            // Profiltiefe
            if ([tempPListDic objectForKey:@"profiltiefea"])
            {
               //NSLog(@"profiltiefea: %d",[[tempPListDic objectForKey:@"profiltiefea"]intValue]);
               [ProfilTiefeFeldA setIntValue:[[tempPListDic objectForKey:@"profiltiefea"]intValue]];
               
            }
            else
            {
               [ProfilTiefeFeldA setIntValue:101];
            }
            
            if ([tempPListDic objectForKey:@"profiltiefeb"])
            {
               //NSLog(@"profiltiefeb: %d",[[tempPListDic objectForKey:@"profiltiefeb"]intValue]);
               [ProfilTiefeFeldB setIntValue:[[tempPListDic objectForKey:@"profiltiefeb"]intValue]];
               
            }
            else
            {
               [ProfilTiefeFeldB setIntValue:91];
            }
            
            // Offset Profil B
            if ([tempPListDic objectForKey:@"profilboffsetx"])
            {
               //NSLog(@"profilboffsetx: %d",[[tempPListDic objectForKey:@"profilboffsetx"]intValue]);
               [ProfilBOffsetXFeld setIntValue:[[tempPListDic objectForKey:@"profilboffsetx"]intValue]];
               
            }
            else
            {
               [ProfilBOffsetXFeld setIntValue:0];
            }
            
            if ([tempPListDic objectForKey:@"profilboffsety"])
            {
               //NSLog(@"profilboffsety: %d",[[tempPListDic objectForKey:@"profilboffsety"]intValue]);
               [ProfilBOffsetYFeld setIntValue:[[tempPListDic objectForKey:@"profilboffsety"]intValue]];
               
            }
            else
            {
               [ProfilBOffsetYFeld setIntValue:0];
            }

            
            // Wrench Profil B
            if ([tempPListDic objectForKey:@"profilwrench"])
            {
               //NSLog(@"profilwrench: %2.2f",[[tempPListDic objectForKey:@"profilwrench"]floatValue]);
               [ProfilWrenchFeld setFloatValue:[[tempPListDic objectForKey:@"profilwrench"]floatValue]];
               
            }
            else
            {
               [ProfilWrenchFeld setFloatValue:0];
            }
           

            // Geometrie
            if ([tempPListDic objectForKey:@"einlauflaenge"])
            {
               //NSLog(@"einlauflaenge: %d",[[tempPListDic objectForKey:@"einlauflaenge"]intValue]);
               [Einlauflaenge setIntValue:[[tempPListDic objectForKey:@"einlauflaenge"]intValue]];
               
            }
            else
            {
               [Einlauflaenge setIntValue:20];
            }

            if ([tempPListDic objectForKey:@"einlauftiefe"])
            {
               //NSLog(@"einlauftiefe: %d",[[tempPListDic objectForKey:@"einlauftiefe"]intValue]);
               [Einlauftiefe setIntValue:[[tempPListDic objectForKey:@"einlauftiefe"]intValue]];
               
            }
            else
            {
               [Einlauftiefe setIntValue:16];
            }
            
            if ([tempPListDic objectForKey:@"auslauflaenge"])
            {
               //NSLog(@"auslauflaenge: %d",[[tempPListDic objectForKey:@"auslauflaenge"]intValue]);
               [Auslauflaenge setIntValue:[[tempPListDic objectForKey:@"auslauflaenge"]intValue]];
            }
            else
            {
               [Auslauflaenge setIntValue:20];
            }
            
            if ([tempPListDic objectForKey:@"auslauftiefe"])
            {
               //NSLog(@"auslauftiefe: %d",[[tempPListDic objectForKey:@"auslauftiefe"]intValue]);
               [Auslauftiefe setIntValue:[[tempPListDic objectForKey:@"auslauftiefe"]intValue]];
               
            }
            else
            {
               [Auslauftiefe setIntValue:16];
            }

            if ([tempPListDic objectForKey:@"basisabstand"])
            {
               //NSLog(@"basisabstand: %d",[[tempPListDic objectForKey:@"basisabstand"]intValue]);
               [Basisabstand setIntValue:[[tempPListDic objectForKey:@"basisabstand"]intValue]];
            }
            else
            {
               [Basisabstand setIntValue:100];
            }

            if ([tempPListDic objectForKey:@"portalabstand"])
            {
               //NSLog(@"portalabstand: %d",[[tempPListDic objectForKey:@"portalabstand"]intValue]);
               [Portalabstand setIntValue:[[tempPListDic objectForKey:@"portalabstand"]intValue]];
               
            }
            else
            {
               [Portalabstand setIntValue:1000];
            }
            
            if ([tempPListDic objectForKey:@"spannweite"])
            {
               //NSLog(@"spannweite: %d",[[tempPListDic objectForKey:@"spannweite"]intValue]);
               [Spannweite setIntValue:[[tempPListDic objectForKey:@"spannweite"]intValue]];
               
            }
            else
            {
               [Spannweite setIntValue:750];
            }
            
            if ([tempPListDic objectForKey:@"minimaldistanz"])
            {
               //NSLog(@"minimaldistanz: %d",[[tempPListDic objectForKey:@"minimaldistanz"]floatValue]);
               //[Spannweite setIntValue:[[tempPListDic objectForKey:@"minimaldistanz"]intValue]];
               minimaldistanz = [[tempPListDic objectForKey:@"minimaldistanz"]floatValue];
               [MinimaldistanzFeld setFloatValue:[[tempPListDic objectForKey:@"minimaldistanz"]floatValue]];
            }
            else
            {
               minimaldistanz = 0.8;
               [MinimaldistanzFeld setFloatValue:0.8];
            }
            
            
            if ([tempPListDic objectForKey:@"redpwm"])
            {
               //NSLog(@"redpwm: %2.2f",[[tempPListDic objectForKey:@"redpwm"]floatValue]);
               //[Spannweite setIntValue:[[tempPListDic objectForKey:@"minimaldistanz"]intValue]];
              [red_pwmFeld setFloatValue: [[tempPListDic objectForKey:@"redpwm"]floatValue]];
            }
            else
            {
               [red_pwmFeld setFloatValue:0.4];
            }
            
            return tempPListDic;
            [tempPListDic release];
         }
         
		
      }    
      

      NSLog(@"readCNC_PList: pwm: %2.2f speed: %d",[DC_PWM floatValue],[SpeedFeld  intValue]);
		//	NSLog(@"PListOK: %d",PListOK);
		
	
   }//USBDatenDa
   [USBPfad release];
//   
   return NULL;
}


- (id) init
{
    //if ((self = [super init]))
//	[self Alert:@"ADWandler init vor super"];
	//NSArray* Wochentage=[[NSArray arrayWithObjects:@"MO",@"DI", @"MI", @"DO", @"FR", @"SA", @"SO",nil]retain];
	//NSArray* Raumnamen=[[NSArray arrayWithObjects:@"Heizung", @"Werkstatt", @"WoZi", @"Buero", @"Labor", @"OG1", @"OG2", @"Estrich", nil]retain];

	self = [super initWithWindowNibName:@"AVR"];
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
	
		[nc addObserver:self
		   selector:@selector(MausGraphAktion:)
			   name:@"mauspunkt"
			 object:nil];

	
	
		[nc addObserver:self
		   selector:@selector(MausDragAktion:)
			   name:@"mausdrag"
			 object:nil];

	
		[nc addObserver:self
		   selector:@selector(MausKlickAktion:)
			   name:@"mausklick"
			 object:nil];

	
		[nc addObserver:self
		   selector:@selector(PfeiltasteAktion:)
			   name:@"pfeiltaste"
			 object:nil];


	
	[nc addObserver:self
		   selector:@selector(ModifierAktion:)
			   name:@"Modifier"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(ReportHandlerCallbackAktion:)
			   name:@"ReportHandlerCallback"
			 object:nil];

	[nc addObserver:self
		   selector:@selector(I2CAktion:)
			   name:@"i2c"
			 object:nil];
			 
	[nc addObserver:self
		   selector:@selector(WriteStandardAktion:)
			   name:@"WriteStandard"
			 object:nil];
			 
	[nc addObserver:self
		   selector:@selector(WriteModifierAktion:)
			   name:@"WriteModifier"
			 object:nil];
			 
   [nc addObserver:self
          selector:@selector(USBReadAktion:)
              name:@"usbread"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(MausAktion:)
              name:@"mausdaten"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(PfeilAktion:)
              name:@"Pfeil"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(ElementeingabeAktion:)
              name:@"Elementeingabe"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(LibElementeingabeAktion:)
              name:@"LibElementeingabe"
            object:nil];
   
	 
   [nc addObserver:self
          selector:@selector(LibProfileingabeAktion:)
              name:@"LibProfileingabe"
            object:nil];
		 
   [nc addObserver:self
          selector:@selector(FormeingabeAktion:)
              name:@"Formeingabe"
            object:nil];
   
	
   [nc addObserver:self
          selector:@selector(BlockeingabeAktion:)
              name:@"Blockeingabe"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(FigElementeingabeAktion:)
              name:@"FigElementeingabe"
            object:nil];
   

	

	CNCdataPfad=[NSHomeDirectory() stringByAppendingPathComponent:@"documents/CNCData"];
	//NSLog(@"CNCdataPfad: %@",CNCdataPfad);
   //CNC_PList = [[NSMutableDictionary alloc]initWithCapacity:0];
   
   
	n=0;
	aktuellerTag=0;
	IOW_busy=0;
	aktuelleMark=(uint8_t)NSNotFound;
	//NSLog(@"HomebusAnlegen 2");
	
   
   AnschlagDic = [[NSMutableDictionary alloc]initWithCapacity:0];
	CNCDatenArray= [[NSMutableArray alloc]initWithCapacity:0];
	KoordinatenTabelle = [[NSMutableArray alloc]initWithCapacity:0];
	UndoKoordinatenTabelle = [[NSMutableArray alloc]initWithCapacity:0];
   //BlockKoordinatenTabelle = [[NSMutableArray alloc]initWithCapacity:0];
   SchnittdatenArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	GraphEnd=0;
	CNC=[[[rCNC alloc]init]retain];
	ProfilDatenOA=[[[NSArray alloc]init]retain];
	ProfilDatenUA=[[[NSArray alloc]init]retain];
   
   mitOberseite =1;
   mitUnterseite=1;
   mitEinlauf=1;
   mitAuslauf=1;
   flipV=0;
   flipH=0;
   reverse=0;
   
	startwert=0;
	cncstatus=0;
   cncposition=0;
   
   AVR_USBStatus=0;
   
   BlockKoordinatenTabelle=[[[NSMutableArray alloc]initWithCapacity:0]retain];
	
   return self;
}	//init

- (void)awakeFromNib
{
   /*
   char* versionstringraw = VERSIONSLAVE;
   char* versionstring = (char*) malloc(4);
   //strncpy(versionstring, versionstringraw+9, 3);
   strncpy(versionstring, VERSIONSLAVE+9, 3);

   versionstring[3]='\0';
   uint16_t versionint = atoi(versionstring);
   uint8_t versionintl = versionint & 0x00FF;
   uint8_t versioninth = (versionint&0xFF00)>>8;

   NSLog(@"Version versionstringraw: %s versionstring: %s versionint: %X versionintl: %X versioninth: %X",versionstringraw,versionstring,versionint,versionintl,versioninth);
   free(versionstring);
	//NSLog(@"awake");
   */
	int i;
	NSMutableArray* tempArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",nil];
	
	
	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	for (i=0;i<8;i++)
	{
		NSNumber* Hexint=[NSNumber numberWithInt:4*i];
		NSString* hexString = [NSString stringWithFormat:@"%X", [Hexint intValue]];
		if ([hexString length] <2)
		{
			hexString=[@"0" stringByAppendingString:hexString];
		}
		//NSLog(@"hexString: %@",hexString);
		// Hexadecimal NSString to NSNumber:
		
		NSScanner *scanner;
		unsigned int tempInt;
		
		scanner = [NSScanner scannerWithString:hexString];
		[scanner scanHexInt:&tempInt];
		Hexint = [NSNumber numberWithInt:tempInt];
		
		[tempDic setObject:hexString forKey:[bitnummerArray objectAtIndex:i%6]];
	}
	[tempArray addObject:tempDic];
	
	CNC_PList = [[NSMutableDictionary alloc]initWithDictionary:[self readCNC_PList]];
   //CNC_PList = [self readCNC_PList];
   
	
	NSRect RaumViewFeld;
	RaumViewFeld=[ProfilFeld  frame]; 
	ProfilGraph =[[rProfilGraph alloc] initWithFrame:RaumViewFeld];	
	
	NSRect RaumScrollerFeld=RaumViewFeld;	//	Feld fuer Scroller, in dem der RaumView liegt
	
	// Feld im Scroller ist abhaengig von Anzahl Tagbalken
	RaumViewFeld.size.height -=10; // Hoehe vergroessern
	//	NSLog(@"RaumTagplanAbstand: %d	",RaumTagplanAbstand);
	
	NSScrollView* RaumScroller = [[NSScrollView alloc] initWithFrame:RaumScrollerFeld];
	
	
	//NSView* ProfilView=[[NSView alloc] initWithFrame:RaumScrollerFeld];
	//[[[StepperTab tabViewItemAtIndex:0]view]addSubview:ProfilView];
	// View-Hierarchie 	
	
	[RaumScroller setDocumentView:ProfilGraph];
	[RaumScroller setBorderType:NSLineBorder];
	[RaumScroller setHasVerticalScroller:NO];
	[RaumScroller setHasHorizontalScroller:NO];
	[RaumScroller setLineScroll:10.0];
	[RaumScroller setAutohidesScrollers:YES];
	//[RaumTabView addSubview:RaumScroller];
	[[[StepperTab tabViewItemAtIndex:0]view]addSubview:RaumScroller];
	
	NSPoint   newRaumScrollOrigin=NSMakePoint(0.0,NSMaxY([[RaumScroller documentView] frame])
															-NSHeight([[RaumScroller contentView] bounds]));
	[[RaumScroller documentView] scrollPoint:newRaumScrollOrigin];
	//[RaumScroller addSubview:ProfilTable];
	
	[CNC_Starttaste setState:0];
	[CNC_Stoptaste setState:0];
	//[ProfilTiefeFeldA setIntValue:100];
	//[ProfilBOffsetYFeld setIntValue:0];
   //[ProfilTiefeFeldB setIntValue:90];
	//[ProfilBOffsetXFeld setIntValue:0];
   
   NSNumberFormatter* SimpleFormatter=[[[NSNumberFormatter alloc] init] autorelease];;
   [SimpleFormatter setFormat:@"###0.0;0.0;(##0.0)"];
   
   //   [ProfilWrenchFeld setFormatter:SimpleFormatter];
   //   [ProfilWrenchFeld setFloatValue:0];
   
	ProfilDaten = [[[NSMutableArray alloc]initWithCapacity:0]retain];
	
	//Profil_DS=[[rProfil_DS alloc]init];
	//[ProfilTable setDataSource: self];
	//[[[ProfilTable tableColumnWithIdentifier:@"ax"]dataCell]setAlignment:NSRightTextAlignment];
	//[[[ProfilTable tableColumnWithIdentifier:@"ay"]dataCell]setAlignment:NSRightTextAlignment];
   
   
   //[ProfilTable setDelegate:self];
	Utils = [[[rUtils alloc]init]retain];
   
   
	NSRect SegFeld=RaumViewFeld;
	SegFeld.origin.y-=40;
	SegFeld.size.height=50;
	NSSegmentedControl* ObjektSeg=[[[NSSegmentedControl alloc]initWithFrame:SegFeld]autorelease];
	[ObjektSeg setSegmentCount:8];
	[[ObjektSeg cell] setTrackingMode:1];
	NSFont* SegFont=[NSFont fontWithName:@"Helvetica" size: 10];
	[[ObjektSeg cell] setFont:SegFont];
	[[ObjektSeg cell] setControlSize:NSMiniControlSize];
	[ObjektSeg setTarget:self];
	[ObjektSeg setAction:@selector(ObjektSegAktion:)];
	
	[ProfilGraph setScale:[[ScalePop selectedItem]tag]];
   [ProfilGraph setGraphOffset:0];
//	[[self window]makeKeyAndOrderFront:self];
   [[self window]makeFirstResponder:ProfilGraph];
	NSString* logString=[NSString string];
	logString=[logString stringByAppendingString:[NSString stringWithFormat:@"%02X ",0x02]];
	logString=[logString stringByAppendingString:[NSString stringWithFormat:@"%02X ",161]];
	//NSLog(@"logString: %@",logString);
	
	
	//NSLog(@"Bitschieber");
	uint16_t StepCounterA;
	uint8_t dataL=0;
	uint8_t dataH=0;
   
	dataL=164;
	dataH=4;
   //	dataH &= (0x7F);
   //	StepCounterA= dataH;		// HByte
   //	StepCounterA <<= 8;		// shift 8
   //	StepCounterA += dataL;	// +LByte
   
	StepCounterA= (dataH<<8) + dataL;
   
	//NSLog(@"StepCounterA hex: %X int: %d",StepCounterA,StepCounterA);
   
	NSString* VersionString=[NSString stringWithUTF8String:VERSION];
   
	[VersionFeld setStringValue:[NSString stringWithFormat:@"%@ %@",@"Stepperversion:",VersionString]];
	NSString* DatumString=[NSString stringWithUTF8String:DATUM];
	[DatumFeld setStringValue:[NSString stringWithFormat:@"%@ %@",@"Datum:",DatumString]];
   NSLog(@"Stepperversion: %@ Datum: %@",VersionString,DatumString);
	cncposition =0;
	[WertFeld setIntValue:10];
   quelle=0; // line
   
   [TestPfeiltaste setContinuous:YES];
   [TestPfeiltaste setTarget:self];
   [TestPfeiltaste setPeriodicDelay:0.1 interval:1];
   
   NSNumberFormatter* Koordinatenformatter=[[[NSNumberFormatter alloc] init] autorelease];;
   [Koordinatenformatter setFormat:@"###.00;0.00;(##0.00)"];
   
   
   [CNCTable setDataSource: self];
   [CNCTable setDelegate: self];
   [CNCTable setGridStyleMask:NSTableViewSolidVerticalGridLineMask];
   [[[CNCTable tableColumnWithIdentifier:@"index"]dataCell]setAlignment:NSCenterTextAlignment];
	[[[CNCTable tableColumnWithIdentifier:@"ax"]dataCell]setAlignment:NSRightTextAlignment];
	[[[CNCTable tableColumnWithIdentifier:@"ay"]dataCell]setAlignment:NSRightTextAlignment];
	[[[CNCTable tableColumnWithIdentifier:@"bx"]dataCell]setAlignment:NSRightTextAlignment];
	[[[CNCTable tableColumnWithIdentifier:@"by"]dataCell]setAlignment:NSRightTextAlignment];
   
   
   [[[CNCTable tableColumnWithIdentifier:@"ax"] dataCell]
    setFormatter:Koordinatenformatter];
   [[[CNCTable tableColumnWithIdentifier:@"ay"] dataCell]
    setFormatter:Koordinatenformatter];
   
   [[[CNCTable tableColumnWithIdentifier:@"bx"] dataCell]
    setFormatter:Koordinatenformatter];
   [[[CNCTable tableColumnWithIdentifier:@"by"] dataCell]
    setFormatter:Koordinatenformatter];
   
   
   
   [CNCTable setDataSource:self];
   [WertAXFeld setFormatter:Koordinatenformatter];
   [WertAXFeld setAlignment:NSRightTextAlignment];
   [WertAXFeld setDelegate:self];
   //   [WertAXFeld setFloatValue:220];
   [WertAYFeld setFormatter:Koordinatenformatter];
   [WertAYFeld setAlignment:NSRightTextAlignment];
   [WertAYFeld setDelegate:self];
   //   [WertAYFeld setFloatValue:50];
   NSRect r=[WertAXStepper frame];
   r.size.width = r.size.height+5;
   //  [WertAXStepper setFrame:r];
   //   [WertAXStepper  rotateByAngle:-90.0]; 
   [WertAXStepper setNeedsDisplay:YES];
   
   
   [WertBXFeld setFormatter:Koordinatenformatter];
   [WertBXFeld setAlignment:NSRightTextAlignment];
   [WertBXFeld setDelegate:self];
   //   [WertBXFeld setFloatValue:220];
   [WertBYFeld setFormatter:Koordinatenformatter];
   [WertBYFeld setAlignment:NSRightTextAlignment];
   [WertBYFeld setDelegate:self];
   //   [WertBYFeld setFloatValue:50];
   
   r=[WertBXStepper frame];
   r.size.width = r.size.height+5;
   //   [WertBXStepper setFrame:r];
   //   [WertBXStepper  rotateByAngle:-90.0];
   [WertBXStepper setNeedsDisplay:YES];
   
   [PWMFeld setAlignment:NSCenterTextAlignment];
   
   UndoSet = [[NSMutableIndexSet indexSet]retain];
   
   [Blockoberkante setIntValue:50];
   [OberkantenStepper setIntValue:[Blockoberkante intValue]];
   [Blockbreite setIntValue:100];
   [Blockdicke setIntValue:40];;
   
   
   einlauflaenge = 15;
   einlauftiefe = 15;
   einlaufrand = 15;
   
   auslauflaenge = 15;
   auslauftiefe = 15;
   auslaufrand = 15;
   
   [Einlaufrand setIntValue:einlaufrand];
   [Auslaufrand setIntValue:auslaufrand];
   
   //[[NSColor redColor]set];
   
   [AnschlagLinksIndikator setBoxType: NSBoxCustom];
   [AnschlagLinksIndikator setBorderType: NSLineBorder];
   [AnschlagLinksIndikator setFillColor:[NSColor redColor]];
   [AnschlagLinksIndikator setTransparent:YES];
   
   [AnschlagUntenIndikator setBoxType: NSBoxCustom];
   [AnschlagUntenIndikator setBorderType: NSLineBorder];
   [AnschlagUntenIndikator setFillColor:[NSColor redColor]];
   [AnschlagUntenIndikator setTransparent:YES];
   
   [RechtsLinksRadio setSelectedSegment:0];
   [ProfilWrenchEinheitRadio setState:1 atRow:0 column:0];
   
   [AbbrandFeld setFormatter:SimpleFormatter];
   [AbbrandFeld setDelegate:self];
   
   [red_pwmFeld setFormatter:SimpleFormatter];
   [red_pwmFeld setDelegate:self];
   
   [MinimaldistanzFeld setFormatter:SimpleFormatter];
   [MinimaldistanzFeld setDelegate:self];
   
   
   [DC_PWM setDelegate:self];
   [SpeedFeld setDelegate:self];
   //   [SpeedStepper setIntValue:12];
   [PWMFeld setDelegate:self];
   int motorstatus=0;
   for (i=0;i<4;i++)
   {
      int motor=i;
      int aktuellermotor = motor;
      
      //motorstatus |= (1<<4);
      //aktuellermotor <<=6;
      //motorstatus |= aktuellermotor;
      int neuermotor = aktuellermotor;
      //neuermotor >>=6;
      // motor += aktuellermotor;
      
      
      //
      //NSLog(@"i: %d motor: %d aktuellermotor: %d neuermotor: %d motorstatus: %d",i,motor, aktuellermotor,neuermotor,motorstatus);
      
   }
   
   [ProfilPop removeAllItems];
   [ProfilPop addItemWithTitle:@"Profil waehlen"];
   NSArray* ProfilnamenArray = [self readProfilLib];
   [ProfilPop addItemsWithTitles:ProfilnamenArray];
   
   
   motorstatus |= (1<<2);
   motorstatus |= STEPEND_A;
   //NSLog(@"motorstatus: %X",motorstatus);
   motorstatus &= ~STEPEND_A;
   motorstatus |= STEPEND_B;
   //NSLog(@"motorstatus: %X",motorstatus);
   motorstatus &= ~STEPEND_B;
   motorstatus |= STEPEND_C;
   //NSLog(@"motorstatus: %X",motorstatus);
   motorstatus &= ~STEPEND_C;
   motorstatus |= STEPEND_D;
   //NSLog(@"motorstatus: %X",motorstatus);
   motorstatus &= ~STEPEND_D;
   
   self.Kote = 5;
   
   //[[self window]makeFirstResponder: ProfilGraph];
   //[[self window]setInitialFirstResponder: ProfilGraph];
   [[self window]setInitialFirstResponder:[[StepperTab tabViewItemAtIndex:0]view]];
   //[[self window]setInitialFirstResponder: CNC_Starttaste];
   
   //NSLog(@"awake end");
}

- (NSArray*)readProfilLib
{
   NSMutableArray* tempLibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	BOOL LibOK=NO;
	BOOL istOrdner;
   
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString*  ProfilLibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ProfilLib"];
   [ProfilLibPfad retain];
   //NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:ProfilLibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"readProfilLib:    LibPfad: %@ LibOK: %d",ProfilLibPfad, LibOK );
   if (LibOK)
   {
      ;
   }
   else
   {
      //Lib ist noch leer
      
      
   }
   
   //NSLog(@"LibPfad: %@",LibPfad);
	if (LibOK)
	{
      NSMutableArray* ProfilnamenArray = (NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:ProfilLibPfad error:NULL];
      [ProfilnamenArray removeObject:@".DS_Store"];
      [ProfilnamenArray removeObject:@" Profile ReadMe.txt"];
		//NSLog(@"readProfilLib ProfilnamenArray: %@",[ProfilnamenArray description]);
      
      return ProfilnamenArray;
      
		
	}//LIBOK
   return tempLibElementArray;
}

- (void)ReportHandlerCallbackAktion:(NSNotification*)note
{
	//NSLog(@"ReportHandlerCallbackAktion note: %@",[[note userInfo]description]);
	if ([[note userInfo]objectForKey:@"datenarray"]&&[[[note userInfo]objectForKey:@"datenarray"] count])
	{
		
		NSArray* Datenarray=[[note userInfo]objectForKey:@"datenarray"];//Array der Reports
		NSString* byte0=[Datenarray objectAtIndex:0]; // ReportID
		NSString* byte1=[Datenarray objectAtIndex:1];
		
		//NSLog(@"ReportHandlerCallbackAktion byte0: %@ byte1: %@",byte0,byte1);
		NSScanner* ErrScanner = [NSScanner scannerWithString:byte1];
		unsigned int scanWert=0;
		if ([ErrScanner scanHexInt:&scanWert]) //intwert derDaten
		{
			//NSLog(@"byte1: %@ scanWert: %02X",byte0,scanWert);
			if (scanWert&0x80)
			{
				NSLog(@"I2C Fehler");
				
				NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
				[Warnung addButtonWithTitle:@"OK"];
				//	[Warnung addButtonWithTitle:@""];
				//	[Warnung addButtonWithTitle:@""];
				//	[Warnung addButtonWithTitle:@"Abbrechen"];
				[Warnung setMessageText:[NSString stringWithFormat:@"%@",@"TWI-Fehler"]];
				
				NSString* s1=@"Moeglicherweise ist die Adresse des Slave falsch.";
				NSString* s2=@"Der Slave mit dieser Adresse ist eventuell nicht eingesteckt";
				NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
				[Warnung setInformativeText:InformationString];
				[Warnung setAlertStyle:NSWarningAlertStyle];
				
				int antwort=[Warnung runModal];
				
				return;
			}
			
		}
		
		int anzBytes=0;
		int i=0;
		switch ([byte0 intValue]) // Report ID 
		{
			case 1: // Callback wird nicht angesprochen
			{
				//NSLog(@"Report ID: %d",[byte0 intValue]);
				
			}break;
			case 2:		//	write-Report
				[Eingangsdaten removeAllObjects];
				//NSLog(@"write Report");
				break;
				
			case 3:		//	read-Report		
				anzBytes=[byte1 intValue];	//Anz Daten im Report
				NSLog(@"read Report: anzBytes: %d",anzBytes);
				for (i=0;i<anzBytes;i++)
				{
					
					[Eingangsdaten addObject:[Datenarray objectAtIndex:i+2]];
					
				}
				
				break;
				
		}//byte0
		
		
		
		if ([Eingangsdaten count])//&&[Eingangsdaten count]==AnzahlDaten)
		{
			
			NSArray* bitnummerArray=[NSArray arrayWithObjects: @"null", @"eins",@"zwei",@"drei",@"vier",@"fuenf",@"++",@"++",nil];
			NSLog(@"CallBackAktion Eingangsdaten: %@ \nAnz: %d",[Eingangsdaten description],[Eingangsdaten count]);
			
			// EEPROMbalken der letzten Zeile anzeigen. Meist ist nur eine Zeile vorhanden.
			NSMutableArray* tempEEPROMArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
			
			
			int k,bit;
			bit=0;
			//		for (k=0;k<[Eingangsdaten count]/6+1;k++)
			for (k=0;k<[Eingangsdaten count]/6;k++)
			{
				NSMutableDictionary* tempReportDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
				[tempReportDic setObject:[Datenarray objectAtIndex:0] forKey:@"report"];
				[tempEEPROMArray removeAllObjects];
				for (bit=0;bit<6;bit++)
				{
					if (k*6+bit<[Eingangsdaten count])
					{
						[tempReportDic setObject:[Eingangsdaten objectAtIndex:k*6+bit] forKey:[bitnummerArray objectAtIndex:bit]];
						[tempEEPROMArray addObject:[Eingangsdaten objectAtIndex:k*6+bit]];
					}
					else           // Auffüllen
					{
						
					}
				}
				NSLog(@"k: %d tempReportDic: %@",k,[tempReportDic description]);
				[EEPROMArray addObject:tempReportDic];
				
			}
			//NSLog(@"ReportHandlerCallbackAktion EEPROMArray: %@",[EEPROMArray description]);
			
            
         [ProfilTable reloadData];
			
			for (k=0;k<6;k++)
			{
				//[tempEEPROMArray addObject:
			}
			NSTabView* tempTabview= StepperTab;
//			int Raum=[(NSPopUpButton*)[tempTabview viewWithTag:10090]indexOfSelectedItem];
			IOW_busy=0;
		}
		
	}
	//NSLog(@"ReportHandlerCallbackAktion end");
}

- (IBAction)showEinstellungen:(id)sender
{
   NSLog(@"showEinstellungenFenster");
	if (!CNC_Eingabe)
	{
		//[self Alert:@"showEinstellungenFenster vor init"];
		NSLog(@"showEinstellungenFenster neu");
		
		CNC_Eingabe=[[rEinstellungen alloc]init];
		
		//[EinstellungenFenster showWindow:self];
      
		//[self Alert:@"showEinstellungenFenster nach init"];
	}
   
	[CNC_Eingabe showWindow:NULL];
      
}

/*
- (IBAction)reportCNC_Eingabe:(id)sender
{
   NSLog(@"reportCNC_Eingabe ");
   if (!CNC_Eingabe)
   {
      CNC_Eingabe =[[rEinstellungen alloc]init];
   }
   [self showEinstellungen:NULL]; 
}
*/
- (NSArray*)readLib
{
   NSMutableArray* LibElementArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	BOOL LibOK=NO;
	BOOL istOrdner;
   
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* LibPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"]retain];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //   NSLog(@"readLib:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      //Lib ist noch leer
      
      
   }
   
   //		NSLog(@"LibPfad: %@",LibPfad);	
	if (LibOK)
	{
		
		//NSLog(@"readLib: %@",[tempPListDic description]);
		
		NSString* LibName=@"Element.plist";
		NSString* LibElementPfad;
		//NSLog(@"\n\n");
		LibElementPfad=[LibPfad stringByAppendingPathComponent:LibName];
		NSLog(@"awake: PListPfad: %@ ",LibElementPfad);
		if (LibElementPfad)		
		{
			
			if ([Filemanager fileExistsAtPath:LibElementPfad])
			{
				NSArray* rawLibElementArray=[NSArray arrayWithContentsOfFile:LibElementPfad];
				int i;
            for(i=0;i<[rawLibElementArray count];i++)
            {
               if ([[rawLibElementArray objectAtIndex:i]objectForKey:@"name"])
               {
                  [LibElementArray addObject:[rawLibElementArray objectAtIndex:i]];
               }
            }
            
            //NSLog(@"readLib: tempElementArray: %@",[[LibElementArray valueForKey:@"name"]description]);
            
			}
			
		}
		//	NSLog(@"PListOK: %d",PListOK);
		
	}//LIBOK
   [LibPfad release];
   return LibElementArray;
}

- (void)setUSBDaten:(NSDictionary*)datendic
{
   if ([datendic objectForKey:@"prod"] && [[datendic objectForKey:@"prod"]length])
   {
   [ProductFeld setStringValue:[datendic objectForKey:@"prod"]];
   }
   else 
   {
      NSLog(@"kein prod");
      [ProductFeld setStringValue:@"-"];
   }
   if ([datendic objectForKey:@"manu"] && [[datendic objectForKey:@"manu"]length])
   {
      [ManufactorerFeld setStringValue:[datendic objectForKey:@"manu"]];
   }
}

- (IBAction)reportHorizontalSchieber:(id)sender
{
	NSLog(@"reportHorizontalSchieber pos: %d",[sender intValue]);
	[HorizontalSchieberFeld setIntValue:[sender intValue]];
}

- (IBAction)reportVertikalSchieber:(id)sender
{
	NSLog(@"reportVertikalSchieber pos: %d",[sender intValue]);
	[VertikalSchieberFeld setIntValue:[sender intValue]];

}

- (IBAction)reportDrehgeber:(id)sender
{
	NSLog(@"reportDrehgeber pos: %2.2f",[sender floatValue]);
	[DrehgeberFeld setFloatValue:[sender floatValue]];

}

- (IBAction)reportStartKnopf:(id)sender
{
   
   //NSArray* tempLinienArray = [CNC LinieVonPunkt:NSMakePoint(25,25) mitLaenge:15 mitWinkel:30];
   //NSLog(@"tempLinienArray: %@",tempLinienArray);
   	//NSLog(@"reportStartKnopf state: %d",[sender state]);
	
   if ([sender state])
	{
	
	}
	else
	{
      //NSLog(@"reportStartKnopf start: %@",[KoordinatenTabelle description]);
      if ([KoordinatenTabelle count]==0)
      {
         //NSLog(@"reportStartKnopf count 0");
         NSPoint tempStartPunkt=NSMakePoint(0, 0);
         [WertAXFeld setFloatValue:(10.0+ einlauflaenge)];
         [WertAYFeld setFloatValue:50.0];
         
         [WertAXStepper setFloatValue:[WertAXFeld intValue]];
         [WertAYStepper setFloatValue:[WertAYFeld intValue]];

         [WertBXFeld setFloatValue:(10.0+ einlauflaenge)];
         [WertBYFeld setFloatValue:50.0];
         
         [WertBXStepper setFloatValue:[WertBXFeld intValue]];
         [WertBYStepper setFloatValue:[WertBYFeld intValue]];

         
         
         [IndexStepper setIntValue:0];
        
         [PositionFeld setIntValue:0];
         [PositionFeld setStringValue:@""];
         
         NSNumber* KoordinateAX=[NSNumber numberWithFloat:[WertAXFeld floatValue]];
         NSNumber* KoordinateAY=[NSNumber numberWithFloat:[WertAYFeld floatValue]];
         float offsetx = [ProfilBOffsetXFeld floatValue];
         float offsety = [ProfilBOffsetYFeld floatValue];
         //NSNumber* KoordinateBX=[NSNumber numberWithFloat:offsetx];
         //NSNumber* KoordinateBY=[NSNumber numberWithFloat:offsety];
         NSNumber* KoordinateBX=[NSNumber numberWithFloat:offsetx+[WertBXFeld floatValue]];
         NSNumber* KoordinateBY=[NSNumber numberWithFloat:offsety+[WertBYFeld floatValue]];
         int nowpwm = [DC_PWM intValue]; // Standardwert wenn nichts anderes angegeben

         
         NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:KoordinateAX, @"ax",KoordinateAY,@"ay",KoordinateBX, @"bx",KoordinateBY,@"by" ,[NSNumber numberWithInt:nowpwm],@"pwm",[NSNumber numberWithInt:0],@"index", nil];
         
         [KoordinatenTabelle addObject:tempDic];

        	[CNCDatenArray removeAllObjects];
         [CNCTable reloadData];
         if ([KoordinatenTabelle count])
         {
            [ProfilGraph setDatenArray:KoordinatenTabelle];
         
            [ProfilGraph setNeedsDisplay:YES];
         }
         [SchnittdatenArray removeAllObjects];
         [NeuesElementTaste setEnabled:YES];
         
      }
      else 
      {
         [NeuesElementTaste setEnabled:YES];
      }
   //   [DC_Taste setState:0];
      [CNC_Stoptaste setEnabled:YES];
      [CNC_Halttaste setState:0];
      [CNC_Halttaste setEnabled:NO];
      
      [self setStepperstrom:1];
   }
		//NSLog(@"reportStartKnopf end: %@",[KoordinatenTabelle description]);
	/*
	if ([StopKnopf state])
	{
	[StopKnopf setState:NO]; 
	}
	*/
}



- (IBAction)reportStopKnopf:(id)sender
{
   
	//NSLog(@"reportStopKnopf state: %d",[sender state]);
	if ([CNC_Starttaste state])
	{
		[CNC_Starttaste setState:NO]; 
		GraphEnd=1;
	}
	else 
	{
		GraphEnd=0;
	}
	float zoomfaktor=[ProfilTiefeFeldA floatValue]/1000;
	zoomfaktor=1;
	//Schnittdaten aus Mausklicktabelle
	int i;
   [CNCDatenArray removeAllObjects];
   [HomeTaste setState:0];
   [DC_Taste setState:0];
   [CNC setSpeed:[SpeedFeld intValue]];
   [CNC setredpwm:[red_pwmFeld floatValue]];
   //NSLog(@"reportStopKnopf [KoordinatenTabelle count]: %d",[KoordinatenTabelle count]);
   if ([KoordinatenTabelle count]<=1)
   {
      NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
      //[Warnung addButtonWithTitle:@"Einstecken und einschalten"];
      [Warnung addButtonWithTitle:@"OK"];
      //	[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@"Abbrechen"];
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"Zuwenig Elemente"]];
      
      NSString* s1=@"";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      int antwort=[Warnung runModal];
      [CNC_Stoptaste setState:0];
      //[CNC_Stoptaste setEnabled:NO];
      
      
      return;
   }
   
   NSMutableArray* tempKoordinatenTabelle = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   int  anzaxplus=0;
   int  anzaxminus=0;
   int  anzayplus=0;
   int  anzayminus=0;
   
   int  anzbxplus=0;
   int  anzbxminus=0;
   int  anzbyplus=0;
   int  anzbyminus=0;
   
   //NSLog(@"reportStopKnopf KoordinatenTabelle data: %@",[[KoordinatenTabelle valueForKey:@"data"]description]);
   
   // Werte des ersten Datensatzes
   NSDictionary* tempPrevDic=[KoordinatenTabelle objectAtIndex:0];
   float prevax = [[tempPrevDic objectForKey:@"ax"]floatValue];
   float prevay = [[tempPrevDic objectForKey:@"ay"]floatValue];
   float prevbx = [[tempPrevDic objectForKey:@"bx"]floatValue];
   float prevby = [[tempPrevDic objectForKey:@"by"]floatValue];
   
   float prevabrax=0;
   float prevabray=0;
   float prevabrbx=0;
   float prevabrby=0;
   
   float nowabrax=0;
   float nowabray=0;
   float nowabrbx=0;
   float nowabrby=0;
   
   float wegaoben=0, wegaunten = 0;
   float wegboben=0, wegbunten = 0;
   
   if ([tempPrevDic objectForKey:@"abrax"])
   {
      prevabrax=[[tempPrevDic objectForKey:@"abrax"]floatValue];
      prevabray=[[tempPrevDic objectForKey:@"abray"]floatValue];
      prevabrbx=[[tempPrevDic objectForKey:@"abrbx"]floatValue];
      prevabrby=[[tempPrevDic objectForKey:@"abrby"]floatValue];
      
   }
   
   [tempKoordinatenTabelle addObject:[KoordinatenTabelle objectAtIndex:0]];
	
   //   for (i=0;i<[KoordinatenTabelle count]-1;i++)
   
   int cncindex=0;
   minimaldistanz = [MinimaldistanzFeld floatValue];
   NSLog(@"minimaldistanz: %2.2f",minimaldistanz);

   for (i=0;i<[KoordinatenTabelle count]-1;i++)
	{
      //NSLog(@"i: %d teil: %d",i,[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"teil"]intValue] );
      // Dic des aktuellen Datensatzes
      NSDictionary* tempNowDic=[KoordinatenTabelle objectAtIndex:i+1];
      float nowax = [[tempNowDic objectForKey:@"ax"]floatValue];
      float noway = [[tempNowDic objectForKey:@"ay"]floatValue];
      float nowbx = [[tempNowDic objectForKey:@"bx"]floatValue];
      float nowby = [[tempNowDic objectForKey:@"by"]floatValue];
      
      if ([tempNowDic objectForKey:@"abrax"])
      {
         nowabrax=[[tempNowDic objectForKey:@"abrax"]floatValue];
         nowabray=[[tempNowDic objectForKey:@"abray"]floatValue];
         nowabrbx=[[tempNowDic objectForKey:@"abrbx"]floatValue];
         nowabrby=[[tempNowDic objectForKey:@"abrby"]floatValue];
         
      }
      else 
      {
         //nowabrax = nowax;
         //nowabray = noway;
      }
      // Dic des naechsten Datensatzes
      
      //      NSDictionary* tempNextDic=[KoordinatenTabelle objectAtIndex:i+1];
      
      /*
       
       float nextax = [[tempNowDic objectForKey:@"ax"]floatValue];
       float nextay = [[tempNowDic objectForKey:@"ay"]floatValue];
       float nextbx = [[tempNowDic objectForKey:@"bx"]floatValue];
       float nextby = [[tempNowDic objectForKey:@"by"]floatValue];
       */
      
      // Distanzen zum vorherigen Punkt
      float distA = hypot(nowax-prevax,noway-prevay); 
      float distB = hypot(nowbx-prevbx,nowby-prevby);
      
      
      
      if ([[tempNowDic objectForKey:@"teil"]intValue]==20)
      {
        // fprintf(stderr,"oben   %d\t%2.3f\t%2.3f\t%2.3f\t%2.3f\n",i,distA,distB,wegaoben,wegboben);
         wegaoben += distA;
         wegboben += distB;
         
      }

      if ([[tempNowDic objectForKey:@"teil"]intValue]==30)
      {
         //fprintf(stderr,"unten   %d\t%2.3f\t%2.3f\t%2.3f\t%2.3f\n",i,distA,distB,wegaunten,wegbunten);
         wegaunten += distA;
         wegbunten += distB;
      }
      
      
      float distabrA = hypot(nowabrax-prevabrax,nowabray-prevabray); 
      float distabrB = hypot(nowabrbx-prevabrbx,nowabrby-prevabrby);
      
      //      fprintf(stderr,"original   %d\t%2.3f\t%2.3f\t%2.3f\t%2.3f\n",i,distA,distB,distabrA,distabrB);
      
      NSPoint tempStartPunktA= NSMakePoint(0,0);
      NSPoint tempStartPunktB= NSMakePoint(0,0);
      NSPoint tempEndPunktA= NSMakePoint(0,0);
      NSPoint tempEndPunktB= NSMakePoint(0,0);
      
      // Soll der Datensatz geladen werden?
      int datensatzok = 0;
      if (distA > minimaldistanz || distB > minimaldistanz) // Eine der Distanzen ist genügend gross
      {
         datensatzok = 1;
         //[tempKoordinatenTabelle addObject:[KoordinatenTabelle objectAtIndex:i]];
         //NSLog(@"cncindex: %d distanz OK. distA: %2.2f distB: %2.2f",cncindex,distA,distB);

      }
      else 
      {
         //NSLog(@"cncindex: %d *** distanz zu kurz. distA: %2.2f distB: %2.2f",cncindex,distA,distB);

      }
      
      if ([AbbrandCheckbox state])
      {
         if ([tempNowDic objectForKey:@"abrax"])
         {
            if(distabrA > minimaldistanz || distabrB > minimaldistanz) // Eine der Distanzen ist genügend gross
            {
               datensatzok =1;
            }
            else 
            {
               //NSLog(@"cncindex: %d abbrandistanz zu kurz. distabrA: %2.2f distabrB: %2.2f",cncindex,distabrA,distabrB);
               datensatzok = 0;
            }
         }
      }
      
      
      
      if (datensatzok)
      {
         NSMutableDictionary* tempOKDic = [NSMutableDictionary dictionaryWithDictionary:[KoordinatenTabelle objectAtIndex:i+1]];
         [tempKoordinatenTabelle addObject:tempOKDic];
         //[tempKoordinatenTabelle addObject:[KoordinatenTabelle objectAtIndex:i]];
      }
      
      else 
      {
         //NSLog(@"i: %d distanz zu kurz",i);
         // [tempKoordinatenTabelle addObject:[KoordinatenTabelle objectAtIndex:cncindex]];
         continue;
      }
      
      int nowpwm = [DC_PWM intValue]; // Standardwert wenn nichts anderes angegeben
      
      if ([tempNowDic objectForKey:@"pwm"])
      {
          //NSLog(@"i: %d pwm da: %d",i,[[tempPrevDic objectForKey:@"pwm"]intValue]);
         nowpwm = [[tempNowDic objectForKey:@"pwm"]intValue];
      }
      
      if (i<10)
      {
         //fprintf(stderr,"akzeptiert %d\t%2.3f\t%2.3f\t%2.3f\t%2.3f\t%d\n",i,nowax,noway,nowbx,nowby,nowpwm);
      }
      
      // Abbrandpunkt einfuegen sofern vorhanden
      if ([AbbrandCheckbox state]&& [tempPrevDic objectForKey:@"abrax"]) //
      {
         // Seite A
         //tempStartPunktA= NSMakePoint([[tempNowDic objectForKey:@"abrax"]floatValue]*zoomfaktor,[[tempNowDic objectForKey:@"abray"]floatValue]*zoomfaktor);
         tempStartPunktA= NSMakePoint(prevabrax*zoomfaktor, prevabray*zoomfaktor);
         // Seite B
         //tempStartPunktB= NSMakePoint([[tempNowDic objectForKey:@"abrbx"]floatValue]*zoomfaktor,[[tempNowDic objectForKey:@"abrby"]floatValue]*zoomfaktor);
         tempStartPunktB= NSMakePoint(prevabrbx*zoomfaktor, prevabrby*zoomfaktor);
      }
      else
      {
         // Seite A
         //tempStartPunktA= NSMakePoint([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
         tempStartPunktA= NSMakePoint(prevax, prevay);
         
         // Seite B
         //tempStartPunktB= NSMakePoint([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
         tempStartPunktB= NSMakePoint(prevbx, prevby);
      }
      
      if ([AbbrandCheckbox state]&& [tempNowDic objectForKey:@"abrax"])
      {
         // Seite A
         // tempEndPunktA= NSMakePoint([[tempNextDic objectForKey:@"abrax"]floatValue]*zoomfaktor,[[tempNextDic objectForKey:@"abray"]floatValue]*zoomfaktor);
         tempEndPunktA= NSMakePoint(nowabrax, nowabray);
         // Seite B
         //tempEndPunktB= NSMakePoint([[tempNextDic objectForKey:@"abrbx"]floatValue]*zoomfaktor,[[tempNextDic objectForKey:@"abrby"]floatValue]*zoomfaktor);
         tempEndPunktB= NSMakePoint(nowabrbx, nowabrby);
      }
      else
      {
         // Seite A
         //tempEndPunktA= NSMakePoint([[tempNextDic objectForKey:@"ax"]floatValue]*zoomfaktor,[[tempNextDic objectForKey:@"ay"]floatValue]*zoomfaktor);
         tempEndPunktA= NSMakePoint(nowax, noway);
         // Seite B
         //tempEndPunktB= NSMakePoint([[tempNextDic objectForKey:@"bx"]floatValue]*zoomfaktor,[[tempNextDic objectForKey:@"by"]floatValue]*zoomfaktor);
         tempEndPunktB= NSMakePoint(nowbx, nowby);
      }
      
      prevax = nowax;
      prevay = noway;
      prevbx = nowbx;
      prevby = nowby;
      
      prevabrax = nowabrax;
      prevabray = nowabray;
      prevabrbx = nowabrbx;
      prevabrby = nowabrby;
      tempPrevDic = tempNowDic;
      
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
      
      
      NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
      
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);      
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      
      
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      //     [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      //     [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      
      
      //      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      [tempDic setObject:[NSNumber numberWithInt:cncindex] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      
      int position=0;
      if (cncindex==0)
      {
         position |= (1<<FIRST_BIT);
      }
      /*
       // verschoben ans Ende der Loop
       if (cncindex==[KoordinatenTabelle count]-2)
       {
       position |= (1<<LAST_BIT);
       }
       
       */
      
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      //[tempDic setObject:[NSNumber numberWithBool:(i==[KoordinatenTabelle count]-2)] forKey:@"last"];
      
      
		//NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:tempStartPunktString,@"startpunkt",tempEndPunktString,@"endpunkt",[NSNumber numberWithFloat:zoomfaktor], @"zoomfaktor",NULL];
		
      if (cncindex==0 || cncindex==[KoordinatenTabelle count]-1)
      {
         //NSLog(@"reportStop i: %d \ntempDic: %@",i,[tempDic description]);
      }
      
      //     if ([DC_Taste state])
      {
         
         [tempDic setObject:[NSNumber numberWithInt:nowpwm]forKey:@"pwm"];
      }
      //      else
      //      {
      //         [tempDic setObject:[NSNumber numberWithInt:0]forKey:@"pwm"];
      //      }
      if (i<8)
      {
         // NSLog(@"reportStop i: %d \ntempDic: %@",i,[tempDic description]);
      }
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      if (i<8)
      {
         // NSLog(@"reportStop i: %d \ntempSteuerdatenDic: %@",i,[tempSteuerdatenDic description]);
      }
      
      
      if([tempSteuerdatenDic objectForKey:@"anzaxplus"])
      {
         anzaxplus += [[tempSteuerdatenDic objectForKey:@"anzaxplus"]intValue];
         anzayplus += [[tempSteuerdatenDic objectForKey:@"anzayplus"]intValue];
         anzbxplus += [[tempSteuerdatenDic objectForKey:@"anzbxplus"]intValue];
         anzbyplus += [[tempSteuerdatenDic objectForKey:@"anzbyplus"]intValue];
         
         anzaxminus += [[tempSteuerdatenDic objectForKey:@"anzaxminus"]intValue];
         anzayminus += [[tempSteuerdatenDic objectForKey:@"anzayminus"]intValue];
         anzbxminus += [[tempSteuerdatenDic objectForKey:@"anzbxminus"]intValue];
         anzbyminus += [[tempSteuerdatenDic objectForKey:@"anzbyminus"]intValue];
      }
      
      if (i==0 || i==[KoordinatenTabelle count]-1)
      {
         //NSLog(@"reportStop i: %d \ntempSteuerdatenDic: %@",i,[tempSteuerdatenDic description]);
      }
		
      [CNCDatenArray addObject:tempSteuerdatenDic];
      //NSArray* tempSchnittdatenArray = [CNC SchnittdatenVonDic:tempSteuerdatenDic];
      //NSLog(@"tempSchnittdatenArray: %@",[tempSchnittdatenArray description]);
		
      [SchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      //NSLog(@"tempSteuerdatenDic: %@",[tempSteuerdatenDic description]);
      cncindex++;
   }
 //  NSLog(@"CNCDatenArray: %@",[[CNCDatenArray valueForKey:@"pwm"]description]);

   
   //NSLog(@"wegaoben: %2.2f wegaunten: %2.2f wegboben: %2.2f wegbunten: %2.2f",wegaoben,wegaunten, wegboben, wegbunten);
   
   //anzaxminus,anzayminus ,anzbxminus, anzbyminus;
   //anzaxplus,anzayplus ,anzbxplus, anzbyplus;
   
   // code am Anfang und Schluss einfuegen
   int lastposition = 0;
   lastposition |= (1<<LAST_BIT);

   [[SchnittdatenArray lastObject]replaceObjectAtIndex:17 withObject: [NSNumber numberWithInt:lastposition]];
   
   float wegax=0, wegay=0, wegbx=0, wegby=0;
    float distanzax=0, distanzay=0, distanzbx=0, distanzby=0;
   float zeitax=0, zeitay=0,zeitbx=0,zeitby=0;
   int steps = 48;
   //fprintf(stderr, "index: \t zeitax:\tzeitay:\tzeitbx:\tzeitby:\t\n");

   for (i=0;i<[CNCDatenArray count];i++)
   {
      NSDictionary* tempDic = [CNCDatenArray objectAtIndex:i];
      //NSLog(@"index: %d tempDic pwm: %2.2f",i,[[tempDic objectForKey:@"pwm"]floatValue]);
      wegax += [[tempDic objectForKey:@"schritteax"]floatValue]/steps*[[tempDic objectForKey:@"delayax"]floatValue]/1000;
      wegay += [[tempDic objectForKey:@"schritteay"]floatValue]/steps*[[tempDic objectForKey:@"delayay"]floatValue]/1000;
      wegbx += [[tempDic objectForKey:@"schrittebx"]floatValue]/steps*[[tempDic objectForKey:@"delaybx"]floatValue]/1000;
      wegby += [[tempDic objectForKey:@"schritteby"]floatValue]/steps*[[tempDic objectForKey:@"delayby"]floatValue]/1000;
      
      float deltazeitax = [[tempDic objectForKey:@"schritteax"]floatValue]*[[tempDic objectForKey:@"delayax"]floatValue]/1000;
      float deltazeitay = [[tempDic objectForKey:@"schritteay"]floatValue]*[[tempDic objectForKey:@"delayay"]floatValue]/1000;
      float deltazeitbx = [[tempDic objectForKey:@"schrittebx"]floatValue]*[[tempDic objectForKey:@"delaybx"]floatValue]/1000;
      float deltazeitby = [[tempDic objectForKey:@"schritteby"]floatValue]*[[tempDic objectForKey:@"delayby"]floatValue]/1000;
      
      zeitax += [[tempDic objectForKey:@"schritteax"]floatValue]*[[tempDic objectForKey:@"delayax"]floatValue]/1000;
      zeitay += [[tempDic objectForKey:@"schritteay"]floatValue]*[[tempDic objectForKey:@"delayay"]floatValue]/1000;
      zeitbx += [[tempDic objectForKey:@"schrittebx"]floatValue]*[[tempDic objectForKey:@"delaybx"]floatValue]/1000;
      zeitby += [[tempDic objectForKey:@"schritteby"]floatValue]*[[tempDic objectForKey:@"delayby"]floatValue]/1000;

    // fprintf(stderr, "%d\t%2.8f\t%2.8f \t%2.8f\t%2.8f\n",i,deltazeitax, deltazeitay, deltazeitbx, deltazeitby);
      
      distanzax += [[tempDic objectForKey:@"distanzax"]floatValue];
      distanzay += [[tempDic objectForKey:@"distanzay"]floatValue];

      distanzbx += [[tempDic objectForKey:@"distanzbx"]floatValue];
      distanzby += [[tempDic objectForKey:@"distanzby"]floatValue];

   }
//   NSLog(@"index: %d \twegax:\t%2.4f\twegay:\t%2.4f \twegbx:\t%2.4f\twegby:\t%2.4f",i,wegax, wegay, wegbx, wegby);
//  NSLog(@"index: %d \tdistanzax:\t%2.4f\tdistanzay:\t%2.4f \tdistanzbx:\t%2.4f\tdistanzby:\t%2.4f",i,distanzax, distanzay, distanzbx, distanzby);
  // NSLog(@"zeitax:\t%2.4f\tzeitay:\t%2.4f \tzeitbx:\t%2.4f\tzeitby:\t%2.4f",zeitax, zeitay, zeitbx, zeitby);
   
   //   [self updateIndex];
   //NSLog(@"Seite A: anzaxplus:%d anzaxminus:%d anzayplus:%d anzayminus:%d",anzaxplus, anzaxminus, anzayplus, anzayminus);
   //NSLog(@"Seite B: anzbxplus:%d anzbxminus:%d anzbyplus:%d anzbyminus:%d",anzbxplus, anzbxminus, anzbyplus, anzbyminus);
   //NSLog(@"Diff A x: %d y: %d",anzaxplus+anzaxminus,anzayplus+anzayminus);
   //NSLog(@"Diff B x: %d y: %d",anzbxplus+anzbxminus,anzbyplus + anzbyminus);
	
   
   cncposition =0;
   if (i==0 || i==[KoordinatenTabelle count]-1)
   {
      //NSLog(@"reportStopKnopf SchnittdatenArray: %@",[SchnittdatenArray description]);
   }
   
	//NSLog(@"reportStopKnopf CNCDatenArray: %@",[CNCDatenArray description]);
	//NSLog(@"reportStopKnopf SchnittdatenArray: %@",[SchnittdatenArray description]);
   //NSLog(@"reportStopKnopf KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   
   
	[CNCPositionFeld setIntValue:0];
   [PositionFeld setStringValue:@""];
   
	[CNCStepXFeld setIntValue:[[[CNCDatenArray objectAtIndex:0]objectForKey:@"schrittex"]intValue]];
	[CNCStepYFeld setIntValue:[[[CNCDatenArray objectAtIndex:0]objectForKey:@"schrittey"]intValue]];
   
   [KoordinatenTabelle setArray:tempKoordinatenTabelle];
   [self updateIndex];
   [ProfilGraph setStepperposition:0];
   [ProfilGraph setNeedsDisplay:YES];
   
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:KoordinatenTabelle forKey:@"koordinatentabelle"];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"CNCaktion" object:self userInfo:NotificationDic];
	[CNC_Sendtaste setEnabled:YES];
	[CNC_Terminatetaste setEnabled:YES];
	[self setStepperstrom:0];
   //[DC_Taste setState:0];
   
   //NSLog(@"reportStopKnopf tempKoordinatenTabelle: %@ count: %d ",[tempKoordinatenTabelle description],[tempKoordinatenTabelle count]);
   //NSLog(@"reportStopKnopf tempKoordinatenTabelle count: %d ",[tempKoordinatenTabelle count]);
   //NSLog(@"reportStopKnopf KoordinatenTabelle count: %d",[KoordinatenTabelle count]);
   //NSLog(@"reportStopKnopf KoordinatenTabelle neu count: %d",[KoordinatenTabelle count]);
   int anzDaten=[KoordinatenTabelle count]-1;
   //NSLog(@"reportStopKnopf anzDaten: %d",anzDaten);
   //[PositionFeld setIntValue:[KoordinatenTabelle count]-1];
   [IndexFeld setIntValue:anzDaten];
   [IndexStepper setIntValue:anzDaten];
   //NSLog(@"reportStopKnopf KoordinatenTabelle count: %d",[KoordinatenTabelle count]);
}

   

   


- (IBAction)reportDC_Stepper:(id)sender
{
   //NSLog(@"reportDC_Stepper Wert: %d ",[sender intValue]); 
   
   [DC_PWM setIntValue:[sender intValue]];
   if (CNC_busy == 0) // Weiterleiten an AVRController nur im Stillstand
   {
      if ([DC_Taste state])
      {
         [self DC_ON:[sender intValue]];
      }
      else
      {
         [self DC_ON:0];
      }
   }
}



- (IBAction)reportDC_Taste:(id)sender
{
   NSLog(@"reportDC_Taste state: %d pwm: %d",[sender state],[DC_PWM intValue]); 
  
   if ([sender state])
   {
      [self DC_ON:[DC_PWM intValue]];
   }
   else
   {
      [self DC_ON:0];
   }

}

- (IBAction)reportSpeedStepper:(id)sender
{
   NSLog(@"reportSpeedStepper state: %d ",[sender intValue]); 
   [SpeedFeld setIntValue:[sender intValue]];
   [CNC setSpeed:[sender intValue]];
   //[self saveSpeed];
   
}


- (void)DC_ON:(int)pwmwert
{
   if (pwmwert==0)
   {
      [DC_Taste setState:0];
   }
   NSMutableDictionary* DCDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   
   [DCDic setObject:[NSNumber numberWithInt:pwmwert] forKey:@"pwm"]; // DC ein/aus, nur fuer AVRController
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"DC_pwm" object:self userInfo:DCDic];
   
}

- (void)setPWM:(int)pwm
{
   NSLog(@"setPWM pwm: %d",pwm);
   [DC_PWM setIntValue:pwm];
   [DC_Stepper setIntValue:pwm];
}

// von 32

- (int)pwm
{
   if ([DC_Taste state])
   {
      return [DC_PWM intValue];
   }
   else
   {
      return 0;
   }
}


- (int)pwm2save
{
   return [DC_PWM intValue];
}



- (int)speed
{
      return [SpeedFeld intValue];
}



- (void)setBusy:(int)busy
{
   CNC_busy=busy;
   if (busy)
   {
      
      [CNC_busySpinner startAnimation:NULL];
   }
   else
   {
      [CNC_busySpinner stopAnimation:NULL];
      [CNC_Halttaste setState:0];
      [CNC_Halttaste setEnabled:NO];

      //[DC_Taste setState:0];
     
   }
   
}
- (int)busy
{
   return CNC_busy;
}


// end von 32

- (int)savePWM
{
   //NSLog(@"reportPWMSichern");
   //NSLog(@"reportPWMSichern PWM: %d",[DC_PWM intValue]);
   
   int erfolg=0;
   //NSLog(@"PWM Sichern");
   BOOL LibOK=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"ElementSichern:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtURL:LibURL  withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
   }
   NSString* PListPfad;
   NSString* PListName = @"CNC.plist";
   
   //NSLog(@"\n\n");
   PListPfad=[LibPfad stringByAppendingPathComponent:PListName];
   NSURL* PListURL = [NSURL fileURLWithPath:PListPfad];
   //NSLog(@"reportPWMSichern: PListPfad: %@ ",PListPfad);
   //NSMutableDictionary* saveElementDic = nil;
   
   if (PListPfad)
   {
      //NSLog(@"reportPWMSichern: PListPfad: %@ ",PListPfad);
      
      NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      if ([Filemanager fileExistsAtPath:PListPfad])
      {
         tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
         //NSLog(@"reportPWMSichern: vorhandener PListDic: %@",[tempPListDic description]);
      }
      
      else
      {
         tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //NSLog(@"reportPWMSichern: neuer PListDic");
      }
      [tempPListDic setObject:[NSNumber numberWithInt:[DC_PWM intValue]] forKey:@"pwm"];
      
      //NSLog(@"reportPWMSichern: gesicherter PListDic: %@",[tempPListDic description]);
      
      erfolg=[tempPListDic writeToURL:PListURL atomically:YES];
      //NSLog(@"reportPWMSichern erfolg: %d",erfolg);
   }
   return erfolg;
}

- (int)saveMinimaldistanz
{
   //NSLog(@"saveMinimaldistanz");
   //NSLog(@"saveMinimaldistanz PWM: %d",[DC_PWM intValue]);

   int erfolg=0;
   //NSLog(@"saveMinimaldistanz");
   BOOL LibOK=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"ElementSichern:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtURL:LibURL  withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
   }
   NSString* PListPfad;
   NSString* PListName = @"CNC.plist";
   
   //NSLog(@"\n\n");
   PListPfad=[LibPfad stringByAppendingPathComponent:PListName];
   NSURL* PListURL = [NSURL fileURLWithPath:PListPfad];
   //NSLog(@"reportPWMSichern: PListPfad: %@ ",PListPfad);
   //NSMutableDictionary* saveElementDic = nil;
   
   if (PListPfad)
   {
      //NSLog(@"reportPWMSichern: PListPfad: %@ ",PListPfad);
      
      NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      if ([Filemanager fileExistsAtPath:PListPfad])
      {
         tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
         //NSLog(@"reportPWMSichern: vorhandener PListDic: %@",[tempPListDic description]);
      }
      
      else
      {
         tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //NSLog(@"reportPWMSichern: neuer PListDic");
      }
      [tempPListDic setObject:[NSNumber numberWithFloat:[MinimaldistanzFeld floatValue]] forKey:@"minimaldistanz"];
      
      //NSLog(@"saveMinimaldistanz: gesicherter PListDic: %@",[tempPListDic description]);
      
      erfolg=[tempPListDic writeToURL:PListURL atomically:YES];
      //NSLog(@"saveMinimaldistanz erfolg: %d",erfolg);
   }
   return erfolg;
}

- (void)setStepperstrom:(int)ein
{
   NSMutableDictionary* StromDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [StromDic setObject:[NSNumber numberWithInt:ein] forKey:@"ein"]; // Stepperstrom ein/aus, nur fuer AVRController
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"stepperstrom" object:self userInfo:StromDic];
   
}


- (int)saveSpeed
{
   //NSLog(@"saveSpeed");
   //NSLog(@"saveSpeed speed: %d",[SpeedFeld intValue]);
   int erfolg=0;
   BOOL LibOK=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"saveSpeed:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtURL:LibURL  withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
      
      
   }
   NSString* PListPfad;
   NSString* PListName = @"CNC.plist";
   
   //NSLog(@"\n\n");
   PListPfad=[LibPfad stringByAppendingPathComponent:PListName];
   NSURL* PListURL = [NSURL fileURLWithPath:PListPfad];
   //NSLog(@"saveSpeed: PListPfad: %@ ",PListPfad);
   //NSMutableDictionary* saveElementDic = nil;
   
   if (PListPfad)
   {
      //NSLog(@"saveSpeed: PListPfad: %@ ",PListPfad);
      
      NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      if ([Filemanager fileExistsAtPath:PListPfad])
      {
         tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
         //NSLog(@"saveSpeed: vorhandener PListDic: %@",[tempPListDic description]);
      }
      
      else
      {
         tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //NSLog(@"saveSpeed: neuer PListDic");
      }
      [tempPListDic setObject:[NSNumber numberWithInt:[SpeedFeld intValue]] forKey:@"speed"];
      
      //NSLog(@"saveSpeed: gesicherter PListDic: %@",[tempPListDic description]);
      
      erfolg=[tempPListDic writeToURL:PListURL atomically:YES];
      //NSLog(@"saveSpeed erfolg: %d",erfolg);
   }
   
   return erfolg;
}

- (int)saveProfileinstellungen
{
   //NSLog(@"saveProfileinstellungen");
   
   
   
   int erfolg=0;
   BOOL LibOK=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"saveSpeed:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtURL:LibURL  withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
      
      
   }
   NSString* PListPfad;
   NSString* PListName = @"CNC.plist";
   
   //NSLog(@"\n\n");
   PListPfad=[LibPfad stringByAppendingPathComponent:PListName];
   NSURL* PListURL = [NSURL fileURLWithPath:PListPfad];
   //NSLog(@"saveSpeed: PListPfad: %@ ",PListPfad);
   //NSMutableDictionary* saveElementDic = nil;
   
   if (PListPfad)
   {
      //NSLog(@"saveSpeed: PListPfad: %@ ",PListPfad);
      
      NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSFileManager *Filemanager=[NSFileManager defaultManager];
      if ([Filemanager fileExistsAtPath:PListPfad])
      {
         tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
         //NSLog(@"saveSpeed: vorhandener PListDic: %@",[tempPListDic description]);
      }
      
      else
      {
         tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         //NSLog(@"saveSpeed: neuer PListDic");
      }
      
      NSDictionary* tempEinstellungenDic=[NSMutableDictionary dictionaryWithDictionary:[CNC_Eingabe PList]];
      [tempPListDic addEntriesFromDictionary:tempEinstellungenDic];
      [tempPListDic setObject:[NSNumber numberWithInt:[SpeedFeld intValue]] forKey:@"speed"];
      [tempPListDic setObject:[NSNumber numberWithInt:[DC_PWM intValue]] forKey:@"pwm"];
      
      // Geometriedaten
      [tempPListDic setObject:[ProfilNameFeldA stringValue] forKey:@"profilnamea"];
      [tempPListDic setObject:[ProfilNameFeldB stringValue] forKey:@"profilnameb"];
      [tempPListDic setObject:[NSNumber numberWithFloat:[ProfilWrenchFeld floatValue]] forKey:@"profilwrench"];
      [tempPListDic setObject:[NSNumber numberWithInt:[ProfilTiefeFeldA intValue]] forKey:@"profiltiefea"];
      [tempPListDic setObject:[NSNumber numberWithInt:[ProfilTiefeFeldB intValue]] forKey:@"profiltiefeb"];
      [tempPListDic setObject:[NSNumber numberWithInt:[ProfilBOffsetXFeld intValue]] forKey:@"profilboffsetx"];
      [tempPListDic setObject:[NSNumber numberWithInt:[ProfilBOffsetYFeld intValue]] forKey:@"profilboffsety"];
      [tempPListDic setObject:[NSNumber numberWithInt:[Basisabstand intValue]] forKey:@"basisabstand"];
      [tempPListDic setObject:[NSNumber numberWithInt:[Spannweite intValue]] forKey:@"spannweite"];
      [tempPListDic setObject:[NSNumber numberWithInt:[Portalabstand intValue]] forKey:@"portalabstand"];
      [tempPListDic setObject:[NSNumber numberWithFloat:[AbbrandFeld floatValue]] forKey:@"abbranda"];

      [tempPListDic setObject:[NSNumber numberWithFloat:[red_pwmFeld floatValue]] forKey:@"redpwm"];

      //NSLog(@"saveSpeed: gesicherter PListDic: %@",[tempPListDic description]);
      
      erfolg=[tempPListDic writeToURL:PListURL atomically:YES];
      //NSLog(@"saveSpeed erfolg: %d",erfolg);
   }
   
   
   
   return erfolg;
}




- (IBAction)reportOberseiteTaste:(id)sender
{
	NSLog(@"reportOberseiteTaste state: %d",[sender state]);
	if ([sender state]&&ProfilDatenOA&&[ProfilDatenOA count])
	{
		[UnterseiteTaste setState:NO];
		[ProfilGraph setDatenArray:ProfilDatenOA];
		[ProfilGraph setNeedsDisplay:YES];
	}
		else 
	{
		if ([UnterseiteTaste state]==NO)
		{
		[ProfilGraph setDatenArray:ProfilDaten];
		[ProfilGraph setNeedsDisplay:YES];
		}
	}

}
- (IBAction)reportUnterseiteTaste:(id)sender
{
	NSLog(@"reportUnterseiteTaste state: %d",[sender state]);
	if ([sender state]&&ProfilDatenUA&&[ProfilDatenUA count])
	{
		[OberseiteTaste setState:NO];
		[ProfilGraph setDatenArray:ProfilDatenUA];
		[ProfilGraph setNeedsDisplay:YES];
	}
	else 
	{
		if ([OberseiteTaste state]==NO)
		{
		[ProfilGraph setDatenArray:ProfilDaten];
		[ProfilGraph setNeedsDisplay:YES];
		}
	}

}

- (IBAction)reportClearProfilTabelle:(id)sender
{
		[ProfilDaten removeAllObjects];
		ProfilDatenUA = [NSArray array];
		ProfilDatenOA = [NSArray array];
		[ProfilGraph setDatenArray:ProfilDaten];
		[ProfilGraph setNeedsDisplay:YES];
		[ProfilTable reloadData];

}

- (IBAction)reportScalePop:(id)sender
{
	[ProfilGraph setScale:[[sender selectedItem]tag]];
	[ProfilGraph setNeedsDisplay:YES];
}

- (IBAction)reportIndexStepper:(id)sender;
{
	[IndexFeld setIntValue:[sender intValue]];
	//NSLog(@"reportIndexStepper index: %d Mausklick obj: %@",[sender intValue], [[KoordinatenTabelle objectAtIndex:[sender intValue]] description]);
	//float X=[[[KoordinatenTabelle objectAtIndex:[sender intValue]] objectForKey:@"ax"]floatValue];
	//NSLog(@"X: %2.2f",X);
	NSIndexSet* StepperIndexSet=[NSIndexSet indexSetWithIndex:[sender intValue]];
   [self setDatenVonZeile:[sender intValue]];
   
   [CNCTable selectRowIndexes:StepperIndexSet byExtendingSelection:NO];
   
//   [WertAXFeld setFloatValue:[[[KoordinatenTabelle objectAtIndex:[sender intValue]] objectForKey:@"ax"]floatValue]];
//	[WertAYFeld setFloatValue:[[[KoordinatenTabelle objectAtIndex:[sender intValue]] objectForKey:@"ay"]floatValue]];
   [CNCTable scrollRowToVisible:[sender intValue]];
   [ProfilGraph setKlickpunkt:[IndexFeld intValue]];
   [ProfilGraph setNeedsDisplay:YES];

   [CNCTable reloadData];
   
}

- (IBAction)reportWertAXStepper:(id)sender
{
   if ([CNCTable numberOfSelectedRows]==0) // keine Zeile aktiviert
      {return;};

	[WertAXFeld setStringValue:[NSString stringWithFormat:@"%.2f", [sender floatValue]]];
	int index=[IndexFeld intValue];
   NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
   id wertax = [oldDic objectForKey:@"ax"];
   id wertay = [oldDic objectForKey:@"ay"];
   id wertbx = [oldDic objectForKey:@"bx"];
   id wertby = [oldDic objectForKey:@"by"];
   id wertindex=[oldDic objectForKey:@"index"];
   id wertpwm = [NSNumber numberWithInt:[DC_PWM intValue]];
   if ([oldDic objectForKey:@"pwm"])
   {
    wertpwm = [oldDic objectForKey:@"pwm"];
   }
   
   float deltax = [sender floatValue] - [wertax floatValue]; // Differenz zum vorherigen Wert
   
   wertax = [NSNumber numberWithFloat:[sender floatValue]]; // Neuer Wert fuer wertax
   
   if ([ABBindCheck state])
   {
      wertbx = [NSNumber numberWithFloat:[wertbx floatValue] + deltax]; // Diff zu wertbx hinzufuegen
   }
   
	//NSLog(@"reportWertAXStepper index: %d wertax: %2.2F wertay: %2.2F wertbx: %2.2F wertby: %2.2F",index, [wertax floatValue], [wertay floatValue],[wertbx floatValue], [wertby floatValue]);
	
   
   NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                            wertbx, @"bx",wertby, @"by",wertindex,@"index",
                            wertpwm,@"pwm",NULL];
 	
		
	//NSLog(@"tempDic: %@",[tempDic description]);

	//NSLog(@"Dic vorher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
	
	[KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
	//NSLog(@"Dic nachher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);

	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];

}

- (IBAction)reportWertAYStepper:(id)sender
{
   NSLog(@"reportWertAYStepper CNCTable numberOfSelectedRows: %d",[CNCTable numberOfSelectedRows]);
   if ([CNCTable numberOfSelectedRows]==0) // keine Zeile aktiviert
   {
      return;
   };

	[WertAYFeld setStringValue:[NSString stringWithFormat:@"%.2f", [sender floatValue]]];
   int index=[IndexFeld intValue];
   NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
   id wertax = [oldDic objectForKey:@"ax"];
   id wertay = [oldDic objectForKey:@"ay"];
   id wertbx = [oldDic objectForKey:@"bx"];
   id wertby = [oldDic objectForKey:@"by"];
   id wertindex=[oldDic objectForKey:@"index"];
   id wertpwm = [NSNumber numberWithInt:[DC_PWM intValue]];
   if ([oldDic objectForKey:@"pwm"])
   {
      wertpwm = [oldDic objectForKey:@"pwm"];
   }
   float deltay = [sender floatValue] - [wertby floatValue]; // Differenz zum vorherigen Wert
   
   wertay = [NSNumber numberWithFloat:[sender floatValue]]; // Neuer Wert fuer wertax

   if ([ABBindCheck state])
   {
      wertby = [NSNumber numberWithFloat:[wertby floatValue] + deltay]; // Diff zu wertby hinzufuegen
   }

   NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                            wertbx, @"bx",wertby, @"by",wertindex,@"index",
                            wertpwm,@"pwm",NULL];
		
	//NSLog(@"tempDic: %@",[tempDic description]);
	[KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];

	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
}

- (IBAction)reportWertBXStepper:(id)sender
{
   if ([CNCTable numberOfSelectedRows]==0) // keine Zeile aktiviert
   {
      return;
   };
   
	[WertBXFeld setStringValue:[NSString stringWithFormat:@"%.2f", [sender floatValue]]];
	int index=[IndexFeld intValue];
   NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
   id wertax = [oldDic objectForKey:@"ax"];
   id wertay = [oldDic objectForKey:@"ay"];
   id wertbx = [oldDic objectForKey:@"bx"];
   id wertby = [oldDic objectForKey:@"by"];
   id wertindex=[oldDic objectForKey:@"index"];
   id wertpwm = [NSNumber numberWithInt:[DC_PWM intValue]];
   if ([oldDic objectForKey:@"pwm"])
   {
      wertpwm = [oldDic objectForKey:@"pwm"];
   }
   float deltax = [sender floatValue] - [wertbx floatValue]; // Differenz zum vorherigen Wert
   
   wertbx = [NSNumber numberWithFloat:[sender floatValue]]; // Neuer Wert fuer wertax
   if ([ABBindCheck state])
   {
      wertax = [NSNumber numberWithFloat:[wertbx floatValue] + deltax]; // Diff zu wertbx hinzufuegen
   }
	//NSLog(@"reportWertAXStepper index: %d wertax: %2.2F wertay: %2.2F wertbx: %2.2F wertby: %2.2F",index, [wertax floatValue], [wertay floatValue],[wertbx floatValue], [wertby floatValue]);
	
   NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                            wertbx, @"bx",wertby, @"by",wertindex,@"index",
                            wertpwm,@"pwm",NULL];
 	
   
	
	[KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
	//NSLog(@"Dic nachher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
   
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
   
}

- (IBAction)reportWertBYStepper:(id)sender
{
   NSLog(@"reportWertBYStepper CNCTable numberOfSelectedRows: %d",[CNCTable numberOfSelectedRows]);
   if ([CNCTable numberOfSelectedRows]==0) // keine Zeile aktiviert
   {return;}
   
	[WertBYFeld setStringValue:[NSString stringWithFormat:@"%.2f", [sender floatValue]]];
   int index=[IndexFeld intValue];
   NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
   id wertax = [oldDic objectForKey:@"ax"];
   id wertay = [oldDic objectForKey:@"ay"];
   id wertbx = [oldDic objectForKey:@"bx"];
   id wertby = [oldDic objectForKey:@"by"];
   id wertindex=[oldDic objectForKey:@"index"];
   id wertpwm = [NSNumber numberWithInt:[DC_PWM intValue]];
   if ([oldDic objectForKey:@"pwm"])
   {
      wertpwm = [oldDic objectForKey:@"pwm"];
   }
   float deltay = [sender floatValue] - [wertby floatValue]; // Differenz zum vorherigen Wert
   
   wertby = [NSNumber numberWithFloat:[sender floatValue]]; // Neuer Wert fuer wertax
   if ([ABBindCheck state])
   {
      wertay = [NSNumber numberWithFloat:[wertay floatValue] + deltay]; // Diff zu wertby hinzufuegen
   }
   NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                            wertbx, @"bx",wertby, @"by",wertindex,@"index",
                            wertpwm,@"pwm",NULL];
   
   
	//NSLog(@"tempDic: %@",[tempDic description]);
   
	//NSLog(@"Dic vorher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
	
	[KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
	//NSLog(@"Dic nachher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
   
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
   
}


- (IBAction)reportPWMStepper:(id)sender
{
   NSLog(@"reportPWMStepper CNCTable numberOfSelectedRows: %d",[CNCTable numberOfSelectedRows]);
   if ([CNCTable numberOfSelectedRows]==0) // keine Zeile aktiviert
   {
      return;
   };

	[PWMFeld setIntValue:[sender intValue]];
	int index=[IndexFeld intValue];
   NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
   id wertax = [oldDic objectForKey:@"ax"];
   id wertay = [oldDic objectForKey:@"ay"];
   id wertbx = [oldDic objectForKey:@"bx"];
   id wertby = [oldDic objectForKey:@"by"];
   id wertindex=[oldDic objectForKey:@"index"];
	//NSLog(@"reportPWMStepper index: %d wertax: %2.2F wertay: %2.2F wertbx: %2.2F wertby: %2.2F",index, [wertax floatValue], [wertay floatValue],[wertbx floatValue], [wertby floatValue]);
	
	NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                            wertbx, @"bx",wertby, @"by",wertindex,@"index",
                            [NSNumber numberWithInt:[sender intValue]],@"pwm",NULL];
   
   
	//NSLog(@"tempDic: %@",[tempDic description]);
   
	//NSLog(@"Dic vorher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
	
	[KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
	//NSLog(@"Dic nachher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
   
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
   
}

- (void)ManRichtung:(int)richtung
{
   {
      NSLog(@"AVR  manRichtung richtung: %d",richtung);
      
      if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
      {
         return;
      }
      
      int aktpwm=0;
      if ([DC_Taste state])
      {
         aktpwm = [DC_PWM intValue];
      }
      NSLog(@"AVR  manRichtung aktpwm: %d",aktpwm);
      [self setStepperstrom:aktpwm];
      NSMutableArray* ManArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
      
      // Startpunkt ist aktuelle Position. Lage: 2: Home horizontal
      NSPoint PositionA = NSMakePoint(0, 0);
      NSPoint PositionB = NSMakePoint(0, 0);
      int index=0;
      [ManArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
      
      //Horizontal bis Anschlag
     switch (richtung)
      {
         case 1: // right
         {
            PositionA.x += 500; // sicher ist sicher
            PositionB.x += 500;

         }break;
            
         case 2: // up
         {
            PositionA.y += 500; // sicher ist sicher
            PositionB.y += 500;

         }break;
            
         case 3: // left
         {
            PositionA.x -= 500; // sicher ist sicher
            PositionB.x -= 500;
            
         }break;
            
         case 4: // down
         {
            PositionA.y -= 500; // sicher ist sicher
            PositionB.y -= 500;

         }break;
            
      } // switch richtung
     
      
      
 //     NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      index++;
      [ManArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
      //NSLog(@"A");
      // von reportOberkanteAnfahren
      int i=0;
      int zoomfaktor=1.0;
      NSMutableArray* HomeSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
      
      for (i=0;i<[ManArray count]-1;i++)
      {
         //NSLog(@"B i: %d",i);
         // Seite A
         NSPoint tempStartPunktA= NSMakePoint([[[ManArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
         NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
         
         //NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
         NSPoint tempEndPunktA= NSMakePoint([[[ManArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
         NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
         //NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
         
         // Seite B
         NSPoint tempStartPunktB= NSMakePoint([[[ManArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
         NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
         
         NSPoint tempEndPunktB= NSMakePoint([[[ManArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
         NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
         
         //NSLog(@"C i: %d",i);
         // Dic zusammenstellen
         NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         
         // AB
         if ([CNC_Seite1Check state])
         {
            [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
            [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
         }
         if ([CNC_Seite2Check state])
         {
            [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];         
            [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
         }
         
         [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
         
         [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
         int code=0;
         
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
         
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
         
         int position=0;
         if (i==0)
         {
            position |= (1<<FIRST_BIT);
         }
         if (i==[ManArray count]-2)
         {
            position |= (1<<LAST_BIT);
         }
         [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
         
         NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
         //NSLog(@"D i: %d",i);
         [HomeSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
         //NSLog(@"E i: %d",i);
      } // for i
      
      NSMutableDictionary* HomeSchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [HomeSchnittdatenDic setObject:HomeSchnittdatenArray forKey:@"schnittdatenarray"];
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
      //NSLog(@"AVR  reportManLeft HomeSchnittdatenDic: %@",[HomeSchnittdatenDic description]);
      
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
      
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"art"]; // 
      //NSLog(@"reportManLeft SchnittdatenDic: %@",[HomeSchnittdatenDic description]);
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"usbschnittdaten" object:self userInfo:HomeSchnittdatenDic];
      
      
   }

}


- (IBAction)reportManLeft:(id)sender
{
   /*
    tag:
    right:  1
    up:     2
    left:   3
    down:   4
    */
   {
      NSLog(@"AVR  reportManLeft tag: %d",[sender tag]);
      
      [self ManRichtung:3];
      return;
      
      if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
      {
         return;
      }
      
      NSMutableArray* ManArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
      
      // Startpunkt ist aktuelle Position. Lage: 2: Home horizontal
      NSPoint PositionA = NSMakePoint(0, 0);
      NSPoint PositionB = NSMakePoint(0, 0);
      int index=0;
      [ManArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
      
      //Horizontal bis Anschlag
      PositionA.x -= 500; // sicher ist sicher
      PositionB.x -= 500;
      //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      index++;
      [ManArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
      
      // von reportOberkanteAnfahren
      int i=0;
      int zoomfaktor=1.0;
      NSMutableArray* HomeSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
      
      for (i=0;i<[ManArray count]-1;i++)
      {
         // Seite A
         NSPoint tempStartPunktA= NSMakePoint([[[ManArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
         NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
         
         //NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
         NSPoint tempEndPunktA= NSMakePoint([[[ManArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
         NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
         //NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
         
         // Seite B
         NSPoint tempStartPunktB= NSMakePoint([[[ManArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
         NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
         
         NSPoint tempEndPunktB= NSMakePoint([[[ManArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[ManArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
         NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
         
         // Dic zusammenstellen
         NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         
         // AB
         if ([CNC_Seite1Check state])
         {
            [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
            [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
         }
         if ([CNC_Seite2Check state])
         {
            [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];         
            [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
         }
         
         [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
         
         [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
         int code=0;
         
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
         
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
         [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
         
         int position=0;
         if (i==0)
         {
            position |= (1<<FIRST_BIT);
         }
         if (i==[ManArray count]-2)
         {
            position |= (1<<LAST_BIT);
         }
         [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
         
         NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
         
         [HomeSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
         
      } // for i
      
      NSMutableDictionary* HomeSchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [HomeSchnittdatenDic setObject:HomeSchnittdatenArray forKey:@"schnittdatenarray"];
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
      //NSLog(@"AVR  reportManLeft HomeSchnittdatenDic: %@",[HomeSchnittdatenDic description]);
      
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
      
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"art"]; // 
      //NSLog(@"reportManLeft SchnittdatenDic: %@",[HomeSchnittdatenDic description]);
      
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      [nc postNotificationName:@"usbschnittdaten" object:self userInfo:HomeSchnittdatenDic];
      
   }
   
}

- (IBAction)reportManRight:(id)sender
{
   /*
    tag:
    right:  1
    up:     2
    left:   3
    down:   4
    */
   [self ManRichtung:1];
   [CNC_Lefttaste setEnabled:YES];
   [AnschlagLinksIndikator setTransparent:YES];
   
   if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
   {
      return;
   }
   //NSLog(@"reportManRight: %d",[sender tag]);
   return;
   
   //NSPoint Startpunkt = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
   NSPoint Startpunkt = NSMakePoint(0,0);
   NSArray* PfeilArray = [CNC PfeilvonPunkt:Startpunkt mitLaenge:50 inRichtung:0];
   
   NSMutableArray* PfeilSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   float zoomfaktor=1;
   int i;
   for (i=0;i<[PfeilArray count]-1;i++)
   {
      NSPoint tempStartPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i]objectForKey:@"y"]floatValue]*zoomfaktor);
		NSString* tempStartPunktString= NSStringFromPoint(tempStartPunkt);
		//NSString* tempStartPunktString= [[KoordinatenTabelle objectAtIndex:i]objectForKey:@"punktstring"];
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i+1]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i+1]objectForKey:@"y"]floatValue]*zoomfaktor);
      
		//NSString* tempEndPunktString=[[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSString* tempEndPunktString= NSStringFromPoint(tempEndPunkt);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      if ([CNC_Seite1Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunkta"];
         [tempDic setObject:tempEndPunktString forKey:@"endpunkta"];
      }
      if ([CNC_Seite2Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunktb"];         
         [tempDic setObject:tempEndPunktString forKey:@"endpunktb"];
      }

      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[PfeilArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
       
		[PfeilSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   }
   
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:PfeilSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
}

- (IBAction)reportManUp:(id)sender
{
   /*
    tag:
    right:  1
    up:     2
    left:   3
    down:   4
    */
   [self ManRichtung:2];
   [CNC_Downtaste setEnabled:YES];
   [AnschlagUntenIndikator setTransparent:YES];

   return;

   if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
      {
         return;
      }
	NSLog(@"reportManUp: %d",[sender tag]);
   //NSPoint Startpunkt = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
   NSPoint Startpunkt = NSMakePoint(0,0);
   NSArray* PfeilArray = [CNC PfeilvonPunkt:Startpunkt mitLaenge:50 inRichtung:1];
   
   NSMutableArray* PfeilSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   float zoomfaktor=1;
   int i;
   for (i=0;i<[PfeilArray count]-1;i++)
   {
      NSPoint tempStartPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i]objectForKey:@"y"]floatValue]*zoomfaktor);
		NSString* tempStartPunktString= NSStringFromPoint(tempStartPunkt);
		//NSString* tempStartPunktString= [[KoordinatenTabelle objectAtIndex:i]objectForKey:@"punktstring"];
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i+1]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i+1]objectForKey:@"y"]floatValue]*zoomfaktor);
      
		//NSString* tempEndPunktString=[[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSString* tempEndPunktString= NSStringFromPoint(tempEndPunkt);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      if ([CNC_Seite1Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunkta"];
         [tempDic setObject:tempEndPunktString forKey:@"endpunkta"];
      }
      if ([CNC_Seite2Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunktb"];         
         [tempDic setObject:tempEndPunktString forKey:@"endpunktb"];
      }
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[PfeilArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      if (i==0)
      {
         //NSLog(@"reportManUp i: %d \ntempSteuerdatenDic: %@",i,[tempSteuerdatenDic description]);
         //NSLog(@"reportManUp i: %d \ntempDic: %@",i,[tempDic description]);
      }
		[PfeilSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   }
   
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:PfeilSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];

}

- (IBAction)reportManDown:(id)sender
{
   /*
    tag:
    right:  1
    up:     2
    left:   3
    down:   4
    */
   [self ManRichtung:4];
   return;

   if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
   {
      return;
   }
   
   //NSLog(@"reportManDown");
   //NSPoint Startpunkt = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
   NSPoint Startpunkt = NSMakePoint(0,0);
   NSArray* PfeilArray = [CNC PfeilvonPunkt:Startpunkt mitLaenge:50 inRichtung:3];
   
   NSMutableArray* PfeilSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   float zoomfaktor=1;
   int i;
   for (i=0;i<[PfeilArray count]-1;i++)
   {
      NSPoint tempStartPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i]objectForKey:@"y"]floatValue]*zoomfaktor);
		NSString* tempStartPunktString= NSStringFromPoint(tempStartPunkt);
		//NSString* tempStartPunktString= [[KoordinatenTabelle objectAtIndex:i]objectForKey:@"punktstring"];
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunkt= NSMakePoint([[[PfeilArray objectAtIndex:i+1]objectForKey:@"x"]floatValue]*zoomfaktor,[[[PfeilArray objectAtIndex:i+1]objectForKey:@"y"]floatValue]*zoomfaktor);
      
		//NSString* tempEndPunktString=[[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSString* tempEndPunktString= NSStringFromPoint(tempEndPunkt);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      if ([CNC_Seite1Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunkta"];
         [tempDic setObject:tempEndPunktString forKey:@"endpunkta"];
      }
      if ([CNC_Seite2Check state])
      {
         [tempDic setObject:tempStartPunktString forKey:@"startpunktb"];         
         [tempDic setObject:tempEndPunktString forKey:@"endpunktb"];
      }
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[PfeilArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      //NSLog(@"reportManLeft i: %d \ntempDic: %@",i,[tempDic description]);
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      //  NSLog(@"reportStop i: %d \ntempSteuerdatenDic: %@",i,[tempSteuerdatenDic description]);
      
		[PfeilSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   }
   
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:PfeilSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
}

- (IBAction)reportDauerpfeilTaste:(id)sender
{
   NSLog(@"reportDauerpfeilTaste");
 //  [self reportManDown:NULL];
}

- (IBAction)reportQuadrat:(id)sender
{
   // IOW_Stepper 10_0 (RAM)
   
   if ([WertFeld intValue]==0)
   {
		[WertFeld setIntValue:15];
   }
   
   //NSLog(@"[WertFeld intValue]: %d",[WertFeld intValue]);
	NSPoint Startpunkt = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
	NSArray* tempQuadratArray=[CNC QuadratVonPunkt:Startpunkt mitSeite:[WertFeld floatValue] mitLage:[LagePop indexOfSelectedItem]];
	NSLog(@"tempQuadratArray: %@",[tempQuadratArray description]);
	int anzDaten=0x20;
	
	// Array mit Schnittdaten
	NSMutableArray*  AVR_SchnittdatenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	int i=0;
	for(i=0;i<[tempQuadratArray count];i++)
	{
      NSMutableDictionary* tempDic = (NSMutableDictionary*)[tempQuadratArray objectAtIndex:i];
		//NSLog(@"[tempQuadratArray objectAtIndex:%d]: %@",i,[[tempQuadratArray objectAtIndex:i] description]);
      [KoordinatenTabelle addObject:[tempQuadratArray objectAtIndex:i]];
      
      // Neu in USB
      
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[tempQuadratArray count]-1)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      //
      
      NSDictionary*	tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
		//NSLog(@"tempSteuerdatenDic: %@",[tempSteuerdatenDic description]);
		NSArray* tempSchnittdatenArray = [CNC SchnittdatenVonDic:tempSteuerdatenDic];
		//NSLog(@"tempSchnittdatenArray: %@",[tempSchnittdatenArray description]);
      
      [AVR_SchnittdatenArray addObject:tempSchnittdatenArray];
      
      
	} // for k
   
   //NSLog(@"AVR_SchnittdatenArray: %@",[AVR_SchnittdatenArray description]);
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:AVR_SchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:cncposition] forKey:@"cncposition"];
   // [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
	
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[ProfilTable reloadData];

   
   [CNC_Sendtaste setEnabled:YES];
	
   //[SchnittdatenArray addObjectsFromArray:AVR_SchnittdatenArray];
   
   
   [SchnittdatenArray setArray:AVR_SchnittdatenArray];
   
   
}



- (IBAction)reportKreis:(id)sender
{
	/*
	 Lage: 
	 0: ueber Startpunkt
	 1: links von Startpunkt
	 2: unter Startpunkt
	 3: rechts von Startpunkt
	 */
    if ([WertFeld intValue]==0)
    {
		[WertFeld setIntValue:15];
    }
	[ProfilGraph setScale:[[ScalePop selectedItem]tag]];
    
	NSPoint Startpunkt = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
	NSArray* tempKreisArray=[CNC KreisVonPunkt:Startpunkt mitRadius:[WertFeld floatValue] mitLage:[LagePop indexOfSelectedItem]];
	//NSLog(@"tempKreisArray: %@",[tempKreisArray description]);
	float radius=10;
   if ([WertFeld floatValue])
   {
      radius=[WertFeld floatValue];
   }
    
   NSArray* tempKreisKoordinatenArray=[CNC KreisKoordinatenMitRadius:radius mitLage:[LagePop indexOfSelectedItem]];
	NSLog(@"tempKreisKoordinatenArray vor: %@",[tempKreisKoordinatenArray description]);
   
   // TODO: Kreispunkte mit ax,ay,bx,by einfuegen
   // neu fuer A,B
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
   
   NSDictionary* oldPosDic = nil;
   
   float oldax= 0;//MausPunkt.x;
   float olday=0;//MausPunkt.y;
   float oldbx=0;//oldax + offsetx;
   float oldby=0;//olday + offsety;
   
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
   }
   else // Start
   {
      oldbx += offsetx;
      oldby += offsety;
   }

   int i=0;
   
   for (i=0;i<[tempKreisKoordinatenArray count];i++)
   {
      float dx = [[[tempKreisKoordinatenArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      float dy = [[[tempKreisKoordinatenArray objectAtIndex:i]objectForKey:@"y"]floatValue];
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax+dx],@"ax",[NSNumber numberWithFloat:olday+dy],@"ay",[NSNumber numberWithFloat:oldbx+dx],@"bx",[NSNumber numberWithFloat:oldby+dy],@"by",[NSNumber numberWithInt:i],@"index", nil];
      [KoordinatenTabelle addObject: tempDic];
      
   }
   //[KoordinatenTabelle setArray:tempKreisKoordinatenArray];
   
   // Letzten Punkt der Koordinatentabelle entfernen, wird zu erstem Punkt des Kreises
   
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];

   [WertBXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue]];
   [WertBYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue]];


   //NSLog(@"tempKreisKoordinatenArray: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];
   
   
   return;
   
	// Array mit Schnittdaten
	NSMutableArray*  AVR_SchnittdatenArray=[[NSMutableArray alloc]initWithCapacity:0];
	
	for(i=0;i<[tempKreisArray count];i++)
	{
		NSLog(@"[tempKreisArray objectAtIndex:i=%d]: %@",i,[[tempKreisArray objectAtIndex:i] description]);
      NSMutableDictionary* tempDic = (NSMutableDictionary*)[tempKreisArray objectAtIndex:i];
     
      // Neu in USB
      
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[tempKreisArray count]-1)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      //

      
      
		//NSDictionary*	tempSteuerdatenDic=[CNC SteuerdatenVonDic:[tempKreisArray objectAtIndex:i]];
 		NSDictionary*	tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
		//NSLog(@"tempSteuerdatenDic: %@",[tempSteuerdatenDic description]);
		NSArray* tempSchnittdatenArray = [CNC SchnittdatenVonDic:tempSteuerdatenDic];
		//NSLog(@"tempSchnittdatenArray: %@",[tempSchnittdatenArray description]);
		
		
		[AVR_SchnittdatenArray addObject:tempSchnittdatenArray];
		
        // Mausklicktabelle fuellen
		NSPoint tempPunkt=NSPointFromString([[tempKreisArray objectAtIndex:i]objectForKey:@"startpunkt"]);
		NSDictionary*	tempMausDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempPunkt.x], @"ax",
                                   [NSNumber numberWithFloat:tempPunkt.y], @"ay" ,NULL];
		[KoordinatenTabelle addObject:tempMausDic];
        
		
	} // for k
	
	// Kreis schliessen
	NSPoint tempPunkt=NSPointFromString([[tempKreisArray objectAtIndex:0]objectForKey:@"startpunkt"]);
	NSDictionary*	tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempPunkt.x], @"ax",
                               [NSNumber numberWithFloat:tempPunkt.y], @"ay" ,NULL];
	[KoordinatenTabelle addObject:tempDic];
   
   
	
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[ProfilTable reloadData];
   [CNCTable reloadData];
	
	
	
	NSMutableDictionary* writeInfoDic=[[NSMutableDictionary alloc]initWithCapacity:0];
	[writeInfoDic setObject:AVR_SchnittdatenArray forKey:@"schnittdatenarray"];
	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"writeschnittdatenarray" object:self userInfo:writeInfoDic];
   [CNC_Sendtaste setEnabled:YES];
   [SchnittdatenArray setArray:AVR_SchnittdatenArray];
   NSLog(@"reportKreis SchnittdatenArray: %@",[SchnittdatenArray description]);

}

- (void)updateIndex
{
   if ([KoordinatenTabelle count])
   {
      int i=0;
      for (i=0;i<[KoordinatenTabelle count];i++)
      {
         NSMutableDictionary* tempDic=[NSMutableDictionary dictionaryWithDictionary:[KoordinatenTabelle objectAtIndex:i]];
         [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
         [KoordinatenTabelle replaceObjectAtIndex:i withObject:tempDic];
      }
      [ProfilGraph setNeedsDisplay:YES];
      [CNCTable reloadData];
      [IndexStepper setMaxValue:[KoordinatenTabelle count]-1];
   }
}

- (IBAction)reportNeueZeile:(id)sender // Neuen Punkt einfügen
{
   NSLog(@"reportNeueZeile Zeile: %d",[IndexFeld intValue]);
   if ([KoordinatenTabelle count]&& [CNCTable numberOfSelectedRows])
   {
      int aktuelleZeile=[IndexFeld intValue];
      int index=[IndexFeld intValue];
      float wertax=[WertAXFeld floatValue];
      float wertay=[WertAYFeld floatValue];

      float wertbx=[WertBXFeld floatValue];
      float wertby=[WertBYFeld floatValue];

      
      NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertax], @"ax",[NSNumber numberWithFloat:wertay], @"ay",[NSNumber numberWithFloat:wertbx], @"bx",[NSNumber numberWithFloat:wertby], @"by",[NSNumber numberWithInt:index+1],@"index",NULL];
      
      [ProfilGraph setKlickpunkt:index+1];
      //NSLog(@"tempDic: %@",[tempDic description]);
      [KoordinatenTabelle insertObject:tempDic atIndex:index];
      
      //
      [self updateIndex];
      
      [IndexFeld setIntValue:index+1];
      [IndexStepper setIntValue:[IndexFeld intValue]];
      [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index+1] byExtendingSelection:NO];
      
      //
      
      [ProfilGraph setDatenArray:KoordinatenTabelle];
      [ProfilGraph setKlickpunkt:index+1];
      [ProfilGraph setKlickrange:NSMakeRange(index+1, 1)];
      [ProfilGraph setNeedsDisplay:YES];
      
      [CNCTable reloadData];
      [[self window]makeFirstResponder: ProfilGraph];
      
   }
}

- (IBAction)reportZeileWeg:(id)sender
{
   //NSLog(@"ZeileWeg Zeile: %d",[IndexFeld intValue]);
   if (([KoordinatenTabelle count]>1)&& [CNCTable numberOfSelectedRows])
   {
      int aktuelleZeile=[IndexFeld intValue];
      int index=[IndexFeld intValue];
      if (aktuelleZeile == 0) // erster Punkt weg
      {
         [KoordinatenTabelle removeObjectAtIndex:0];
         [[StartKoordinate cellAtIndex:0]setFloatValue:[[[KoordinatenTabelle objectAtIndex:1]objectForKey:@"ax"]floatValue]];
         [[StartKoordinate cellAtIndex:1]setFloatValue:[[[KoordinatenTabelle objectAtIndex:1]objectForKey:@"ay"]floatValue]];
         [[StartKoordinate cellAtIndex:0]setFloatValue:[[[KoordinatenTabelle objectAtIndex:1]objectForKey:@"bx"]floatValue]];
         [[StartKoordinate cellAtIndex:1]setFloatValue:[[[KoordinatenTabelle objectAtIndex:1]objectForKey:@"by"]floatValue]];
      
      
      
      }
      else if (aktuelleZeile == [KoordinatenTabelle count]-1) // letzter Punkt weg
      {
         [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1];
         [[StopKoordinate cellAtIndex:0]setFloatValue:[[[KoordinatenTabelle objectAtIndex:[KoordinatenTabelle count]-2]objectForKey:@"ax"]floatValue]];
         [[StopKoordinate cellAtIndex:1]setFloatValue:[[[KoordinatenTabelle objectAtIndex:[KoordinatenTabelle count]-2]objectForKey:@"ay"]floatValue]];
         [[StopKoordinate cellAtIndex:0]setFloatValue:[[[KoordinatenTabelle objectAtIndex:[KoordinatenTabelle count]-2]objectForKey:@"bx"]floatValue]];
         [[StopKoordinate cellAtIndex:1]setFloatValue:[[[KoordinatenTabelle objectAtIndex:[KoordinatenTabelle count]-2]objectForKey:@"by"]floatValue]];

      
      }
      else
      {
         [KoordinatenTabelle removeObjectAtIndex:aktuelleZeile];
      }
      [self updateIndex];
   }
}

- (void)MausGraphAktion:(NSNotification*)note
{
	//NSLog(@"MausGraphAktion note: %@",[[note userInfo]description]);
   //NSLog(@"MausGraphAktion note: %@",[[note userInfo]objectForKey:@"mauspunkt"]);
   [CNCTable deselectAll:NULL];
	[[self window]makeFirstResponder: ProfilGraph];
	NSPoint MausPunkt = NSPointFromString([[note userInfo]objectForKey:@"mauspunkt"]);

	[WertAXFeld setFloatValue:MausPunkt.x];
	[WertAYFeld setFloatValue:MausPunkt.y];
   	
	[WertAXStepper setFloatValue:[WertAXFeld floatValue]];
	[WertAYStepper setFloatValue:[WertAYFeld floatValue]];
   
	[WertBXFeld setFloatValue:MausPunkt.x];
	[WertBYFeld setFloatValue:MausPunkt.y];

  	[WertBXStepper setFloatValue:[WertBXFeld floatValue]];
	[WertBYStepper setFloatValue:[WertBYFeld floatValue]];
 
   
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   NSDictionary* oldPosDic = nil;
   
   float oldax=MausPunkt.x;
   float olday=MausPunkt.y;
   float oldbx=oldax + offsetx;
   float oldby=olday + offsety;
   float oldpwm = [DC_PWM floatValue];
   
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      if ([[KoordinatenTabelle lastObject]objectForKey:@"pwm"])
      {
         //NSLog(@"oldpwm VOR: %d",oldpwm);
         float temppwm = [[[KoordinatenTabelle lastObject]objectForKey:@"pwm"]floatValue];
         if (temppwm == oldpwm)
         {
            oldpwm = temppwm;
         }
         //NSLog(@"oldpwm: %d temppwm: %d",oldpwm,temppwm);
      }
   }
   else // Start
   {
     // oldbx += offsetx;
      //oldby += offsety;
   }
   
   [PWMStepper setFloatValue:oldpwm];
   [PWMFeld setFloatValue:oldpwm];
   
   //NSLog(@"oldax: %1.1f olday: %1.1f",oldax,olday);
   
   float deltax = MausPunkt.x-oldax;
   float deltay = MausPunkt.y-olday;
   
   //NSLog(@"deltax: %1.1f deltay: %1.1f",deltax, deltay);
	
   NSDictionary* neueZeileDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:MausPunkt.x], @"ax",
                            [NSNumber numberWithFloat:MausPunkt.y], @"ay",[NSNumber numberWithFloat:oldbx + deltax], @"bx",
                            [NSNumber numberWithFloat:oldby + deltay],@"by",[NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",[NSNumber numberWithInt:oldpwm],@"pwm",NULL];
   //NSLog(@"testDic:  %1.2f  %1.2f  %1.2f  %1.2f",MausPunkt.x,MausPunkt.y,oldbx+deltax,oldby+deltay);
   
	if ([CNC_Starttaste state])
	{
		[[StartKoordinate cellAtIndex:0]setFloatValue:MausPunkt.x];
		[[StartKoordinate cellAtIndex:1]setFloatValue:MausPunkt.y];
		oldMauspunkt=MausPunkt;
		
      NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:MausPunkt.x], @"ax",
										 [NSNumber numberWithFloat:MausPunkt.y], @"ay",[NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
										 [NSNumber numberWithFloat:MausPunkt.y + offsety],@"by",[NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",[NSNumber numberWithInt:oldpwm],@"pwm",NULL];
		//NSLog(@"tempDic: %@",[tempDic description]);
		
      switch ([KoordinatenTabelle count])
		{
			case 0:
			{
				
				[IndexFeld setIntValue:[KoordinatenTabelle count]];
				[IndexStepper setIntValue:[IndexFeld intValue]];
				[IndexStepper setMaxValue:[IndexFeld intValue]];
		//		[KoordinatenTabelle addObject:tempDic];
            [KoordinatenTabelle addObject:neueZeileDic];
			}break;
				
			default:
			{
				[KoordinatenTabelle replaceObjectAtIndex:0 withObject:tempDic];
				[IndexFeld setIntValue:0];
				[IndexStepper setIntValue:[IndexFeld intValue]];
			}break;
				
		}//switch
		
	}
	else if ([CNC_Stoptaste state])
	{
		[[StopKoordinate cellAtIndex:0]setFloatValue:MausPunkt.x];
		[[StopKoordinate cellAtIndex:1]setFloatValue:MausPunkt.y];
		
		NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:MausPunkt.x], @"ax",
										 [NSNumber numberWithFloat:MausPunkt.y], @"ay",[NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
										 [NSNumber numberWithFloat:MausPunkt.y + offsety], @"by",[NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",[NSNumber numberWithInt:oldpwm],@"pwm",NULL];
		//NSLog(@"if CNC_Stoptaste state tempDic: %@",[tempDic description]);
      if ([KoordinatenTabelle count]>1)
		{
			//[KoordinatenTabelle replaceObjectAtIndex:[KoordinatenTabelle count]-1 withObject:tempDic];
			//if (GraphEnd)
			{
				
				[IndexFeld setIntValue:[KoordinatenTabelle count]];
				[IndexStepper setIntValue:[IndexFeld intValue]];
				[IndexStepper setMaxValue:[IndexFeld intValue]];

			//	[KoordinatenTabelle addObject:tempDic];
            [KoordinatenTabelle addObject:neueZeileDic];
			}
			//[KoordinatenTabelle replaceObjectAtIndex:[KoordinatenTabelle count]-1 withObject:tempDic];
			
		}
		else 
		{
			
			[IndexFeld setIntValue:[KoordinatenTabelle count]];		
			[IndexStepper setIntValue:[IndexFeld intValue]];
			[IndexStepper setMaxValue:[IndexFeld intValue]];
			//[KoordinatenTabelle addObject:tempDic];
         [KoordinatenTabelle addObject:neueZeileDic];
		}
		
		
	}
	else 
	{
		
		if (abs(MausPunkt.x - oldMauspunkt.x) > [CNC steps]*0x7F) // Groesser als int16_t
		{
			NSLog(@"zu grosser Schritt X");
			
		}
		
		NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:MausPunkt.x], @"ax",
										 [NSNumber numberWithFloat:MausPunkt.y], @"ay",[NSNumber numberWithFloat:MausPunkt.x + offsetx], @"bx",
										 [NSNumber numberWithFloat:MausPunkt.y + offsety], @"by",[NSNumber numberWithInt:[KoordinatenTabelle count]],@"index",[NSNumber numberWithInt:oldpwm],@"pwm",NULL];
		
      //NSLog(@"tempDic: %@",[tempDic description]);
		[IndexFeld setIntValue:[KoordinatenTabelle count]];
		[IndexStepper setIntValue:[IndexFeld intValue]];
		[IndexStepper setMaxValue:[IndexFeld intValue]];
		//[KoordinatenTabelle addObject:tempDic];
      [KoordinatenTabelle addObject:neueZeileDic];
		
	}
   oldMauspunkt=MausPunkt;
	//NSLog(@"Mausklicktabelle: %@",[KoordinatenTabelle description]);
	
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
   //   NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];

	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	//[ProfilTable reloadData];
   [CNCTable reloadData];
   if ([KoordinatenTabelle count] > 0)
   {
      [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   }

   
}

- (void)setDatenVonZeile:(int)dieZeile
{
   NSDictionary* tempZeile=[KoordinatenTabelle objectAtIndex:dieZeile];
   [IndexFeld setIntValue:[[tempZeile objectForKey:@"index"]intValue]];
   [IndexStepper setIntValue:[IndexFeld intValue]];

   [WertAXFeld setFloatValue:[[tempZeile objectForKey:@"ax"]floatValue]];
   [WertAXStepper setFloatValue:[WertAXFeld floatValue]];
   [WertAYFeld setFloatValue:[[tempZeile objectForKey:@"ay"]floatValue]];
   [WertAYStepper setFloatValue:[WertAYFeld floatValue]];

   [WertBXFeld setFloatValue:[[tempZeile objectForKey:@"bx"]floatValue]];
   [WertBXStepper setFloatValue:[WertBXFeld floatValue]];
   [WertBYFeld setFloatValue:[[tempZeile objectForKey:@"by"]floatValue]];
   [WertBYStepper setFloatValue:[WertBYFeld floatValue]];
   
   [ProfilGraph setKlickpunkt:[IndexFeld intValue]];
   [ProfilGraph setNeedsDisplay:YES];
}

- (void)MausDragAktion:(NSNotification*)note
{
	//NSLog(@"MausDragAktion note: %@",[[note userInfo]description]);
	
	NSPoint MausPunkt = NSPointFromString([[note userInfo]objectForKey:@"mauspunkt"]);
	int klickIndex= [[[note userInfo] objectForKey:@"klickpunkt"]intValue];
   int Graphoffset= [[[note userInfo] objectForKey:@"graphoffset"]intValue];
   //MausPunkt
	NSDictionary* oldDic= [KoordinatenTabelle objectAtIndex:klickIndex]; // Werte für bx, by uebernehmen
   int Klickseite = [[[note userInfo] objectForKey:@"klickseite"]intValue];
   
   if (Klickseite ==2)
   {
      //MausPunkt.y -= Graphoffset;
   }
   
   float oldax=[[oldDic objectForKey:@"ax"]floatValue];
   float olday=[[oldDic objectForKey:@"ay"]floatValue];
   
   float oldbx=[[oldDic objectForKey:@"bx"]floatValue];
   float oldby=[[oldDic objectForKey:@"by"]floatValue];
   
   float deltaAX =0;
   float deltaAY =0;
   float deltaBX =0;
   float deltaBY =0;
   if ([ABBindCheck state] || (Klickseite == 1))
   {
      //deltaAX = MausPunkt.x- oldax;
      //deltaAY = MausPunkt.y- olday;
      deltaAX = [WertAXFeld floatValue]- oldax;
      deltaAY = [WertAYFeld floatValue]- olday;
   }
   
   if ([ABBindCheck state] || (Klickseite == 2))
   {
      //deltaBX = MausPunkt.x- oldax;
      //deltaBY = MausPunkt.y- olday;
      deltaBX = [WertBXFeld floatValue]- oldbx;
      deltaBY = [WertBYFeld floatValue]- oldby;
   
   
   }
   
   int seite = [[oldDic objectForKey:@"seite"]intValue];
   
	//NSLog(@"MausDragAktion deltax %2.2f deltay: %2.2f * deltbx: %2.2f deltby: %2.2f",deltaAX, deltaAY,deltaBX,deltaBY);
   /*
    NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:MausPunkt.x], @"ax",
    [NSNumber numberWithFloat:MausPunkt.y], @"ay",[oldDic objectForKey:@"bx"],@"bx",[oldDic objectForKey:@"by"],@"by",[NSNumber numberWithInt:klickIndex],@"index",NULL];
    */
	
   NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax+deltaAX], @"ax",[NSNumber numberWithFloat:olday + deltaAY], @"ay",[NSNumber numberWithFloat:oldbx + deltaBX],@"bx",[NSNumber numberWithFloat:oldby + deltaBY],@"by",[NSNumber numberWithInt:klickIndex],@"index",NULL];
   
   float oldabrax=0;
   float oldabray=0;
   float oldabrbx=0;
   float oldabrby=0;
   
   if ([oldDic objectForKey:@"abrax"])
   {
      oldabrax=[[oldDic objectForKey:@"abrax"]floatValue];
      oldabray=[[oldDic objectForKey:@"abray"]floatValue];
      oldabrbx=[[oldDic objectForKey:@"abrbx"]floatValue];
      oldabrby=[[oldDic objectForKey:@"abrby"]floatValue];
      
      [tempDic setObject:[NSNumber numberWithFloat:oldabrax+deltaAX] forKey:@"abrax"];
      [tempDic setObject:[NSNumber numberWithFloat:oldabray+deltaAY] forKey:@"abray"];
      [tempDic setObject:[NSNumber numberWithFloat:oldabrbx+deltaBX] forKey:@"abrbx"];
      [tempDic setObject:[NSNumber numberWithFloat:oldabrby+deltaBY] forKey:@"abrby"];
      
   }
   
   if ([oldDic objectForKey:@"pwm"])
   {
      [tempDic setObject:[oldDic objectForKey:@"pwm"] forKey:@"pwm"];
   }
	// [NSNumber numberWithFloat:oldax+deltax], @"ax",
   
   
   [IndexFeld setIntValue:klickIndex];
	[IndexStepper setIntValue:[IndexFeld intValue]];
   
	[WertAXFeld setFloatValue:MausPunkt.x];
	[WertAYFeld setFloatValue:MausPunkt.y];
	
	[WertAXStepper setFloatValue:MausPunkt.x];
	[WertAYStepper setFloatValue:MausPunkt.y];
   
	[WertBXFeld setFloatValue:MausPunkt.x];
	[WertBYFeld setFloatValue:MausPunkt.y];
	
	[WertBXStepper setFloatValue:MausPunkt.x];
	[WertBYStepper setFloatValue:MausPunkt.y];
   
	[KoordinatenTabelle replaceObjectAtIndex:klickIndex withObject:tempDic];
   
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
//   NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];

   
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
}

- (int)mausistdown
{
  // return mausistdown;
   return [TestPfeiltaste Tastestatus];
}

- (void)MausAktion:(NSNotification*)note
{
   if ([[note userInfo]objectForKey:@"mausistdown"])
   {
      mausistdown =[[[note userInfo]objectForKey:@"mausistdown"]intValue];
      //NSLog(@"MausAktion mausistdown: %d",mausistdown);
   }
}

- (void)MausKlickAktion:(NSNotification*)note
{
	[[self window]makeFirstResponder: ProfilGraph];
	//NSLog(@"MausKlickAktion note: %@",[[note userInfo]description]);
	
	//NSPoint MausPunkt = NSPointFromString([[note userInfo]objectForKey:@"mauspunkt"]);
	int klickIndex= [[[note userInfo] objectForKey:@"klickpunkt"]intValue];
	if (klickIndex > 0x0FFF)
   {
      klickIndex -= 0xF000;
      
   }
//	klickpunkt = klickIndex;
   
   NSDictionary* tempZeilenDic = [KoordinatenTabelle objectAtIndex:klickIndex];
   int klickseite;
	
	[IndexFeld setIntValue:klickIndex];
	[IndexStepper setIntValue:[IndexFeld intValue]];

   // neu: Koord nicht mehr von Mauspunkt. Kollision mit Graphoffset
	[WertAXFeld setFloatValue:[[tempZeilenDic objectForKey:@"ax"]floatValue]];
	[WertAYFeld setFloatValue:[[tempZeilenDic objectForKey:@"ay"]floatValue]];
	
	[WertAXStepper setFloatValue:[WertAXFeld floatValue]];
	[WertAYStepper setFloatValue:[WertAYFeld floatValue]];
	
	//[WertBXFeld setFloatValue:MausPunkt.x];
	//[WertBYFeld setFloatValue:MausPunkt.y];
   
	[WertBXFeld setFloatValue:[[tempZeilenDic objectForKey:@"bx"]floatValue]];
	[WertBXStepper setFloatValue:[WertBXFeld floatValue]];

   [WertBYFeld setFloatValue:[[tempZeilenDic objectForKey:@"by"]floatValue]];
   [WertBYStepper setFloatValue:[WertBYFeld floatValue]];
	

	
   
   [ProfilGraph setNeedsDisplay:YES];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:klickIndex] byExtendingSelection:NO];
   
   
   if ([[note userInfo] objectForKey:@"klickabschnitt"])
   {
      int clickAbschnitt=[[[note userInfo] objectForKey:@"klickabschnitt"]intValue];
      //NSLog(@"clickAbschnitt: %d",clickAbschnitt);
   }

   if ([[note userInfo] objectForKey:@"klickrange"])
   {
      NSRange Klickrange = NSRangeFromString([[note userInfo] objectForKey:@"klickrange"]);
   }
   
   if ([[note userInfo] objectForKey:@"klickseite"])
   {
      klickseite = [[[note userInfo] objectForKey:@"klickseite"]intValue];
   }
   
}

- (void)PfeilAktion:(NSNotification*)note
{
	//[self reportManDown:NULL];
	//NSLog(@"AVR PfeilAktion note: %@",[[note userInfo]description]);
   
   // Richtung >0: Pfeiltaste
   if ([[note userInfo]objectForKey:@"richtung"]&&[[[note userInfo]objectForKey:@"richtung"]intValue])
   {
      quelle=[[[note userInfo]objectForKey:@"richtung"]intValue];
      if ([[note userInfo]objectForKey:@"push"])
      {
         mausistdown = [[[note userInfo]objectForKey:@"push"]intValue];
         if (mausistdown)
         {
            
            switch (quelle)
            {
               case MANDOWN:
               {
                  //NSLog(@"AVR PfeilAktion mandown");
                  [self reportManDown:NULL];
               }break;
               case MANUP:
               {
                  //NSLog(@"AVR PfeilAktion manup");
                  [self reportManUp:NULL];
               }break;
               case MANLEFT:
               {
                  //NSLog(@"AVR PfeilAktion manleft");
                  [self reportManLeft:NULL];
               }break;
               case MANRIGHT:
               {
                  //NSLog(@"AVR PfeilAktion manright");
                  [self reportManRight:NULL];
               }break;
                  
            }//switch
         }
         else
         {
            
         }
      }
   }
    

}

- (int)PfeiltasteStatus
{
   return [TestPfeiltaste state];
   
}



- (void)PfeiltasteAktion:(NSNotification*)note
{
	float Pfeiltastenschritt=0.2;
	NSLog(@"AVR PfeiltasteAktion note: %@",[[note userInfo]description]);
	if ([[[note userInfo]objectForKey:@"klickpunkt"]intValue]>=0)
	{
		int klickpunkt=[[[note userInfo]objectForKey:@"klickpunkt"]intValue];
      if (klickpunkt > 0x0FFF)
      {
         klickpunkt -= 0xF000;
      }
		int klickseite = [[[note userInfo]objectForKey:@"klickseite"]intValue];
      int pfeiltaste=[[[note userInfo]objectForKey:@"pfeiltaste"]intValue];
      NSLog(@"PfeiltasteAktion pfeiltaste: %d klickpunkt: %d klickseite: %d" ,pfeiltaste,klickpunkt,klickseite);

      NSDictionary* tempZeilenDic = [KoordinatenTabelle objectAtIndex:klickpunkt];

		NSDictionary* tempDic;
		switch (pfeiltaste) 
		{
			case 123: // links
			{
            // Seite 1
				float stepperAXwert=[WertAXFeld floatValue]; // vorhandener Wert
            if ([ABBindCheck state] || klickseite == 1) // Seiten gekopppelt oder Klick auf Seite 1
            {
               stepperAXwert -= Pfeiltastenschritt;   // Koord mutieren entsprechend Richtung
               if (stepperAXwert <0)                  // Keine Kollision mit Rand
                  {stepperAXwert=0;}
            }
            
				[WertAXFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperAXwert]];
				[WertAXStepper setFloatValue:stepperAXwert];
				//NSLog(@"stepperAXwert: %2.2F",stepperAXwert);

				// Seite 2
            float stepperBXwert=[WertBXFeld floatValue];
            //NSLog(@"stepperBXwert orig: %2.2F",stepperBXwert);
            if ([ABBindCheck state] || klickseite == 2) // Seiten gekopppelt oder Klick auf Seite 2
            {
               stepperBXwert -= Pfeiltastenschritt;
               if (stepperBXwert <0)
                  {stepperBXwert=0;}
            }
				[WertBXFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperBXwert]];
				[WertBXStepper setFloatValue:stepperBXwert];
				//NSLog(@"stepperBXwert bearbeitet: %2.2F",stepperBXwert);
            
            
           if ([tempZeilenDic objectForKey:@"pwm"]) // pwm angegeben, mitgeben
           {
              NSLog(@"pwm da");
              tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAXwert], @"ax",
							  [NSNumber numberWithFloat:[WertAYFeld floatValue]], @"ay",[NSNumber numberWithFloat:stepperBXwert], @"bx", [NSNumber numberWithFloat:[WertBYFeld floatValue]], @"by",[tempZeilenDic objectForKey:@"pwm"], @"pwm",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
           }
           else // pwm ist default
           {
              NSLog(@"pwm nicht da");
              tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAXwert], @"ax",
                         [NSNumber numberWithFloat:[WertAYFeld floatValue]], @"ay",[NSNumber numberWithFloat:stepperBXwert], @"bx", [NSNumber numberWithFloat:[WertBYFeld floatValue]], @"by",[NSNumber numberWithInt:klickpunkt], @"index",NULL];

           }
         
			}break;
			

			
         
         case 124: // rechts
			{
				float stepperAXwert=[WertAXFeld floatValue];
            
            if ([ABBindCheck state] || klickseite == 1) // Seiten gekopppelt oder Klick auf Seite 1
            {   
               stepperAXwert += Pfeiltastenschritt;
               if (stepperAXwert *[[ScalePop selectedItem]tag] > [ProfilFeld bounds].size.width )
               {
                  stepperAXwert=[ProfilFeld bounds].size.width/[[ScalePop selectedItem]tag];
               }
            }
 				[WertAXFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperAXwert]];
				[WertAYStepper setFloatValue:stepperAXwert];
            
				
            float stepperBXwert=[WertBXFeld floatValue];
            //NSLog(@"stepperBXwert orig: %2.2F",stepperBXwert);
            if ([ABBindCheck state] || klickseite == 2) // Seiten gekopppelt oder Klick auf Seite 2
            {
               stepperBXwert += Pfeiltastenschritt;
               if (stepperBXwert *[[ScalePop selectedItem]tag] > [ProfilFeld bounds].size.width )
               {
                  stepperBXwert=[ProfilFeld bounds].size.width/[[ScalePop selectedItem]tag];
               }
            }
				[WertBXFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperBXwert]];
				[WertBXStepper setFloatValue:stepperBXwert];
				//NSLog(@"stepperBXwert bearbeitet: %2.2F",stepperBXwert);
            
				NSLog(@"stepperBXwert: %2.2F",stepperBXwert);
            
            if ([tempZeilenDic objectForKey:@"pwm"]) // pwm angegeben
            {
               tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAXwert], @"ax",
                          [NSNumber numberWithFloat:[WertAYFeld floatValue]], @"ay",[NSNumber numberWithFloat:stepperBXwert], @"bx",
                          [NSNumber numberWithFloat:[WertBYFeld floatValue]], @"by",[tempZeilenDic objectForKey:@"pwm"], @"pwm",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
               
            }
            else
            {
               tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAXwert], @"ax",
                          [NSNumber numberWithFloat:[WertAYFeld floatValue]], @"ay",[NSNumber numberWithFloat:stepperBXwert], @"bx",
                          [NSNumber numberWithFloat:[WertBYFeld floatValue]], @"by",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
				}
			}break;

			case 125: // down
			{
				float stepperAYwert=[WertAYFeld floatValue];
            if ([ABBindCheck state] || klickseite == 1) // Seiten gekopppelt oder Klick auf Seite 1
            {
               stepperAYwert -= Pfeiltastenschritt;
               if (stepperAYwert <0)
               {
                  stepperAYwert=0;
               }
            }
				[WertAYFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperAYwert]];
				[WertAYStepper setFloatValue:stepperAYwert];
				//NSLog(@"stepperAYwert: %2.2F",stepperAYwert);
            
            float stepperBYwert=[WertBYFeld floatValue];
            //NSLog(@"stepperBYwert orig: %2.2F",stepperBYwert);
            if ([ABBindCheck state] || klickseite == 2) // Seiten gekopppelt oder Klick auf Seite 2
            {
               stepperBYwert -= Pfeiltastenschritt;
               if (stepperBYwert <0)
               {stepperBYwert=0;}
            }
				[WertBYFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperBYwert]];
				[WertBYStepper setFloatValue:stepperBYwert];
				//NSLog(@"stepperBXwert bearbeitet: %2.2F",stepperBXwert);
           
            if ([tempZeilenDic objectForKey:@"pwm"]) // pwm angegeben
            {
				tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAYwert], @"ay",
							  [NSNumber numberWithFloat:[WertAXFeld floatValue]], @"ax",[NSNumber numberWithFloat:stepperBYwert], @"by",
							  [NSNumber numberWithFloat:[WertBXFeld floatValue]], @"bx",[tempZeilenDic objectForKey:@"pwm"], @"pwm",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
				}
            else 
            {
               tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAYwert], @"ay",
                          [NSNumber numberWithFloat:[WertAXFeld floatValue]], @"ax",[NSNumber numberWithFloat:stepperBYwert], @"by",
                          [NSNumber numberWithFloat:[WertBXFeld floatValue]], @"bx",[NSNumber numberWithInt:klickpunkt], @"index",NULL];

            }
			
         }break;
			
			case 126: // up
			{
            float stepperAYwert=[WertAYFeld floatValue];
            if ([ABBindCheck state] || klickseite == 1) // Seiten gekopppelt oder Klick auf Seite 1
            {
               stepperAYwert += Pfeiltastenschritt;
               //NSLog(@"stepperAYwert: %2.2f h: %2.2f",stepperAYwert,[ProfilFeld bounds].size.height);
               if (stepperAYwert * [[ScalePop selectedItem]tag] > [ProfilFeld bounds].size.height )
               {
                  stepperAYwert=[ProfilFeld bounds].size.height/[[ScalePop selectedItem]tag];
               }
            }
				[WertAYFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperAYwert]];
				[WertAYStepper setFloatValue:stepperAYwert];
				NSLog(@"stepperYwert: %2.2F",stepperAYwert);
            
            float stepperBYwert=[WertBYFeld floatValue];
            //NSLog(@"stepperBXwert orig: %2.2F",stepperBXwert);
            if ([ABBindCheck state] || klickseite == 2) // Seiten gekopppelt oder Klick auf Seite 2
            {
               stepperBYwert += Pfeiltastenschritt;
               if (stepperBYwert *[[ScalePop selectedItem]tag] > [ProfilFeld bounds].size.width )
               {
                  stepperBYwert=[ProfilFeld bounds].size.width/[[ScalePop selectedItem]tag];
               }
            }
				[WertBYFeld setStringValue:[NSString stringWithFormat:@"%.2f", stepperBYwert]];
				[WertBYStepper setFloatValue:stepperBYwert];
				//NSLog(@"stepperBYwert bearbeitet: %2.2F",stepperBYwert);
				//NSLog(@"stepperBYwert: %2.2F",stepperBYwert);
            
            if ([tempZeilenDic objectForKey:@"pwm"]) // pwm angegeben
            {
               tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAYwert], @"ay",
                          [NSNumber numberWithFloat:[WertAXFeld floatValue]], @"ax",[NSNumber numberWithFloat:stepperBYwert], @"by",
                          [NSNumber numberWithFloat:[WertBXFeld floatValue]], @"bx",[tempZeilenDic objectForKey:@"pwm"], @"pwm",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
				}
            else 
            {
               tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:stepperAYwert], @"ay",
                          [NSNumber numberWithFloat:[WertAXFeld floatValue]], @"ax",[NSNumber numberWithFloat:stepperBYwert], @"by",
                          [NSNumber numberWithFloat:[WertBXFeld floatValue]], @"bx",[NSNumber numberWithInt:klickpunkt], @"index",NULL];
               
            }
			}break;

			default:
			return;
				break;
		}
		
		[KoordinatenTabelle replaceObjectAtIndex:klickpunkt withObject:tempDic];
		[ProfilGraph setDatenArray:KoordinatenTabelle];
		[ProfilGraph setNeedsDisplay:YES];
		[ProfilTable reloadData];
		[CNCTable reloadData];
	}
	
}

- (void)ProfilPfadAktion:(NSOpenPanel *)sheet 
			 returnCode:(int)returnCode 
			contextInfo:(void *)contextInfo
{
	NSLog(@"openPanelDidEnd: returnCode: %d Pfadarray: %@",returnCode,[[ sheet URLs]description]);
	
	
	
}



- (IBAction)reportProfil:(id)sender
{
	NSLog(@"AVR openProfil");
	
	NSString* ProfilName;
	NSArray* ProfilArrayA;
	NSArray* ProfilArrayB;
  // NSArray* ProfilUArray;
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
	// Profil lesen
   [ProfilGraph setScale:[[ScalePop selectedItem]tag]];
   
   if ([WertAXFeld floatValue]==0)
   {
      [WertAXFeld setFloatValue:25.0 + [ProfilTiefeFeldA intValue]];
   }
   if ([WertAYFeld floatValue]==0)
   {
      [WertAYFeld setFloatValue:25];
      //[WertAYFeld setFloatValue:[ProfilBOffsetYFeld intValue]];
   }
   
   NSPoint StartpunktA;
   NSPoint StartpunktB;
   
   if ([KoordinatenTabelle count])
   {
      float ax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      float ay = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      float bx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      float by = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      StartpunktA = NSMakePoint(ax, ay);
      StartpunktB = NSMakePoint(bx, by);
   }
   else
   {
      StartpunktA = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
      StartpunktB = NSMakePoint([WertAXFeld floatValue]+offsetx, [WertAYFeld floatValue]+offsety);

   }
   
   NSDictionary* ProfilDic;
   
   // ***********************************  Profil lesen
   ProfilDic=[Utils readProfilMitName];
   
   if (ProfilDic == NULL) // canceled
   {
      return;
   }
   //
   
   
   ProfilName=[ProfilDic objectForKey:@"profilname"]; //Dic mit Keys x,y. Werte sind normiert auf Bereich 0-1
   NSLog(@"ProfilDic %@",[ProfilDic description]);
   
   float ProfiltiefeA = [ProfilTiefeFeldA floatValue];
   float ProfiltiefeB = [ProfilTiefeFeldB floatValue];
    
   
   //ProfilArray = [CNC ProfilVonPunkt:Startpunkt mitProfil:ProfilDic mitProfiltiefe:[ProfilTiefeFeldA intValue] mitScale:[[ScalePop selectedItem]tag]];
   
  
   
      
   // Dic mit keys x,y,index, Werte mit wahrer laenge in mm proportional Profiltiefe
   NSDictionary* ProfilpunktDicA=[CNC ProfilDicVonPunkt:StartpunktA mitProfil:ProfilDic mitProfiltiefe:ProfiltiefeA mitScale:[[ScalePop selectedItem]tag]];
   
   NSDictionary* ProfilpunktDicB=[CNC ProfilDicVonPunkt:StartpunktB mitProfil:ProfilDic mitProfiltiefe:ProfiltiefeB mitScale:[[ScalePop selectedItem]tag]];
   
   //NSLog(@"ProfilpunktDicA %@",[ProfilpunktDicA description]);
   ProfilArrayA = [ProfilpunktDicA objectForKey:@"profilpunktarray"];

   ProfilArrayB = [ProfilpunktDicB objectForKey:@"profilpunktarray"];
   
   int Nasenindex=[[ProfilpunktDicA objectForKey:@"nase"]intValue];
   
   
   
  // NSLog(@"AVR ProfilOArray: %@",[ProfilOArray description]);
  // NSLog(@"AVR ProfilUArray: %@",[ProfilUArray description]);
   // Letzten Punkt der Koordinatentabelle entfernen, wird zu erstem Punkt des Profils
   
   if ([KoordinatenTabelle count])
   {
      [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1]; // Letzen Punkt entfernen
   }
   [self updateIndex];
   
   
   int index=0;
   
   // Oberseite einfuegen
   NSLog(@"Oberseite Nasenindex: %d",Nasenindex);
   if ([OberseiteCheckbox state])
   {
      for (index=0;index<= Nasenindex;index++) // Punkte der Oberseite
      {
         NSDictionary* tempZeilenDicA = [ProfilArrayA objectAtIndex:index];
         NSDictionary* tempZeilenDicB = [ProfilArrayB objectAtIndex:index];
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"x"] forKey:@"ax"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"y"] forKey:@"ay"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"x"] forKey:@"bx"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"y"] forKey:@"by"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"index"] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:0] forKey:@"pwm"];
         [KoordinatenTabelle addObject:tempZeilenDic];
         //NSLog(@"index: %d x: %1.1f",index,[[[ProfilArray objectAtIndex:index]objectForKey:@"ax"]floatValue]);
      }
   }
   
   if ([OberseiteCheckbox state]&& [UnterseiteCheckbox state]) // Oberseite schon eingefuegt, letztes Element entfernen, vor Unterseite anfuegen
   {
      NSLog(@"Nase weg index: %d x: %1.1f",index,[[[ProfilArrayA objectAtIndex:[KoordinatenTabelle count]-1]objectForKey:@"ax"]floatValue]);
      [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1]; // Letzen Punkt entfernen
   }   
   
   // Unterseite anfuegen
    NSLog(@"Unterseite ");
   if ([UnterseiteCheckbox state])
   {
      for (index=Nasenindex;index< [ProfilArrayA count];index++) // Alle Punkte abfahren
      {
         int unterseiteindex=index;
         if ([OberseiteCheckbox state]) // Unterseite anschliessen
         {
            //[KoordinatenTabelle addObject:[ProfilArrayA objectAtIndex:index]];
            //NSLog(@"index: %d x: %1.1f",index,[[[ProfilArray objectAtIndex:index]objectForKey:@"ax"]floatValue]);         
         }
         else // Unterseite rueckwäerts einsetzen
         {
            int rueckwaertsindex=[ProfilArrayA count]-(index-Nasenindex)-1;
            unterseiteindex = [ProfilArrayA count]-(index-Nasenindex)-1;
            
            //[KoordinatenTabelle addObject:[ProfilArrayA objectAtIndex:rueckwaertsindex]];
            //NSLog(@"index: %d rueckwaertsindex: %d x: %1.1f",index,rueckwaertsindex,[[[ProfilArray objectAtIndex:rueckwaertsindex]objectForKey:@"ax"]floatValue]);         
         }
         
         NSDictionary* tempZeilenDicA = [ProfilArrayA objectAtIndex:unterseiteindex];
         NSDictionary* tempZeilenDicB = [ProfilArrayB objectAtIndex:unterseiteindex];
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"x"] forKey:@"ax"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"y"] forKey:@"ay"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"x"] forKey:@"bx"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"y"] forKey:@"by"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"index"] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:0] forKey:@"pwm"];
         [KoordinatenTabelle addObject:tempZeilenDic];
        
         
      }
   }
  
    //   [KoordinatenTabelle addObjectsFromArray:ProfilArray];
  // NSLog(@"Profil KoordinatenTabelle: %@",[[KoordinatenTabelle valueForKey:@"ax"] description]);
   
   [self updateIndex];
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
   //NSLog(@"KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];

   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];
   
	return;
  }

- (NSArray*)readFigur
{
   NSArray* FigurArray;
   NSLog(@"readFigur start");
   
   /*
    [ProfilOpenPanel beginWithCompletionHandler:^(NSInteger result)
    {
    NSLog(@"readFigur B");
    if (result == NSFileHandlingPanelOKButton)
    {
    NSLog(@"readFigur C");
    for (NSURL *fileURL in [ProfilOpenPanel URLs])
    {
    NSLog(@"readFigur C");
    NSLog(@"URLs: %@",[[ProfilOpenPanel URLs] description]);
    // Do what you want with fileURL
    // ...
    }
    }
    NSLog(@"readFigur D");
    [ProfilOpenPanel release];
    
    }];
    */
	/*
    [OpenPanel beginSheetForDirectory:NSHomeDirectory() file:nil
	 //types:nil
    modalForWindow:[self window]
    modalDelegate:self
    didEndSelector:@selector(ProfilPfadAktion:returnCode:contextInfo:)
    contextInfo:nil];
    */
   
   
   return NULL;
   NSOpenPanel* ProfilOpenPanel = [NSOpenPanel openPanel];
	NSURL* FigurPfad=[ProfilOpenPanel URL];
   
	//NSLog(@"readFigur: URL: %@",FigurPfad);
	NSError* err=0;
	NSString* FigurString=[NSString stringWithContentsOfURL:FigurPfad encoding:NSUTF8StringEncoding error:&err]; // String des Speicherpfads
	
   //NSLog(@"Utils openProfil FigurString: \n%@",FigurString);
	
   NSArray* tempArray = [NSArray array];
   
	//NSArray* tempArray=[FigurString componentsSeparatedByString:@"\r"];
   
   //NSArray* temp_n_Array=[FigurString componentsSeparatedByString:@"\n"];
   //NSLog(@"Utils openProfil anz: %d temp_n_Array: %@",[temp_n_Array count],temp_n_Array);
   if ([[FigurString componentsSeparatedByString:@"\n"]count] == 1) // separator \r
   {
      tempArray=[FigurString componentsSeparatedByString:@"\r"];
      
   }
   else
   {
      tempArray=[FigurString componentsSeparatedByString:@"\n"];
   }
   
   //NSArray* temp_r_Array=[FigurString componentsSeparatedByString:@"\r"];
	
   
   // NSLog(@"Utils openProfil anz: %d temp_r_Array: \n%@",[temp_r_Array count],temp_r_Array);
   
   NSString* firstString = [tempArray objectAtIndex:0];
	//NSLog(@"firstString Titel: %@ ",firstString);
	if (([[firstString componentsSeparatedByString:@"\t"]count]==1)) // Titel
	{
      NSLog(@"Titel gefunden: %@ ",firstString);
		NSRange titelRange;
      
		titelRange.location = 1;
		titelRange.length = [tempArray count]-1;
      
		tempArray = [tempArray subarrayWithRange:titelRange];
      
	}
	//NSLog(@"Utils openFigur tempArray nach Titel: \n%@",[tempArray description]);
	//NSLog(@"Utils openFigur tempArray count: %d",[tempArray count]);
	int i=0;
	
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:4];
	[numberFormatter setFormat:@"##0.0000"];
   
	for (i=0;i<[tempArray count];i++)
	{
		NSString* tempZeilenString=[tempArray objectAtIndex:i];
		//NSLog(@"Utils tempZeilenString l: %d",[tempZeilenString length]);
		if ((tempZeilenString==NULL)|| ([tempZeilenString length]<=1))
		{
			continue;
		}
		//NSLog(@"char 0: %d",[tempZeilenString characterAtIndex:0]);
		
      if ([tempZeilenString characterAtIndex:0]==10)
		{
         NSLog(@"char 0 weg");
         tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		
      //leerschlag weg
		while ([tempZeilenString characterAtIndex:0]==' ')
		{
         tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		//NSLog(@"i: %d tempZeilenString: %@",i,tempZeilenString);
		//NSLog(@"LeerschlagRange start loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		
		NSArray* tempZeilenArray=[tempZeilenString componentsSeparatedByString:@"\t"];
		if ([tempZeilenArray count])
      {
         // object 0 ist index
         float wertx=[[tempZeilenArray objectAtIndex:1]floatValue];//*100;
         float werty=[[tempZeilenArray objectAtIndex:2]floatValue];//*100;
         NSString*tempX=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:wertx]]];
         NSString*tempY=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:werty]]];
         //NSLog(@"tempX: %@",tempX);
         //NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertx], @"x",
         //[NSNumber numberWithFloat:werty], @"y",NULL];
         NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",tempX, @"x",tempY, @"y",NULL];
         [FigurArray addObject:tempDic];
      }
		//[ProfilArray insertObject:tempDic atIndex:0];
	}
	
	//NSLog(@"Utils openProfil FigurArray: \n%@",[FigurArray description]);
	return FigurArray;
}

- (IBAction)reportHolm:(id)sender
{
   float Holmposition = 0.66; // Lage des Holms von der Endleiste an gemessen
   NSString* ProfilName;
	NSArray* HolmArrayA;
	NSArray* HolmArrayB;
   float origpwm=[DC_PWM intValue];
   
   float abstandoben = 5;
   float abstandunten = 10;
   
   
   //
   /*
    NSLog(@"OpenPanel2");
    NSOpenPanel * TestProfilOpenPanel = [NSOpenPanel openPanel];
    NSLog(@"readFigur ProfilOpenPanel: %@",[TestProfilOpenPanel description]);    //
    [TestProfilOpenPanel setCanChooseFiles:YES];
    [TestProfilOpenPanel setCanChooseDirectories:NO];
    [TestProfilOpenPanel setAllowsMultipleSelection:YES];
    [TestProfilOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    
    [NSApp runModalForWindow:TestProfilOpenPanel];
    //int antwort=[TestProfilOpenPanel runModal];
    */
   
   // NSArray* ProfilUArray;
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
	// Profil lesen
   [ProfilGraph setScale:[[ScalePop selectedItem]tag]];
   
   if ([WertAXFeld floatValue]==0)
   {
      [WertAXFeld setFloatValue:25.0 + [ProfilTiefeFeldA intValue]*Holmposition];
   }
   if ([WertAYFeld floatValue]==0)
   {
      [WertAYFeld setFloatValue:25];
      //[WertAYFeld setFloatValue:[ProfilBOffsetYFeld intValue]];
   }
   
   NSPoint StartpunktA;
   NSPoint StartpunktB;
   
   if ([KoordinatenTabelle count])
   {
      float ax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      float ay = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      float bx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      float by = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      StartpunktA = NSMakePoint(ax, ay);
      StartpunktB = NSMakePoint(bx, by);
   }
   else
   {
      StartpunktA = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
      StartpunktB = NSMakePoint([WertAXFeld floatValue]+offsetx, [WertAYFeld floatValue]+offsety);
      
   }
   
   BOOL LibOK=NO;
	BOOL istOrdner;
   
   NSDictionary* ProfilDic;
   NSMutableArray* ProfilnamenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* ProfilLibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ProfilLib"];
   [ProfilLibPfad retain];
   //NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:ProfilLibPfad isDirectory:&istOrdner]&&istOrdner);
   //NSLog(@"readProfilLib:    LibPfad: %@ LibOK: %d profilindex: %d",ProfilLibPfad, LibOK,[ProfilPop indexOfSelectedItem]+1);
   
   if (LibOK)
	{
      ProfilnamenArray = (NSMutableArray*)[Filemanager contentsOfDirectoryAtPath:ProfilLibPfad error:NULL];
      [ProfilnamenArray removeObject:@".DS_Store"];
      [ProfilnamenArray removeObject:@" Profile ReadMe.txt"];
		//NSLog(@"readProfilLib ProfilnamenArray: %@ selected: %@",[ProfilnamenArray description], [[ProfilnamenArray objectAtIndex:[ProfilPop indexOfSelectedItem]+1] description]); // item 0 ist Titel
		
	}//LIBOK
   
   NSArray* Profil1Array;
   NSArray* Profil2Array;
   
   NSString* Profil1Name;
   NSString* Profil2Name;
   
   if ([ProfilPop indexOfSelectedItem])
   {
      int index=[ProfilPop indexOfSelectedItem]; // Item 0 ist Titel
      NSLog(@"reportProfilPop Profil aus Pop: %@",[ProfilPop itemTitleAtIndex:index]);
      Profil1Name = [ProfilPop itemTitleAtIndex:index];
   }
   else
   {
      Profil1Name = [ProfilNameFeldA stringValue];
      Profil1Name = [Profil1Name stringByAppendingPathExtension:@"txt"];
      NSLog(@"reportProfilPop Profil aus ProfilNameFeldA: %@",Profil1Name);
      if ([Profil1Name length]==0)
      {
         return;
      }
   }
   
   
   NSString* Profilpfad = [ProfilLibPfad stringByAppendingPathComponent:Profil1Name];
   
   //NSLog(@"reportProfilPop Profilpfad: %@",Profilpfad);
   int ProfilOK= [Filemanager fileExistsAtPath:Profilpfad];
   
   if (ProfilOK)
   {
      // Profilkoordinaten lesen
      NSDictionary* ProfilDic = [Utils ProfilDatenAnPfad:Profilpfad];
      
      //NSLog(@"reportProfilPop ProfilDic: %@",[ProfilDic description]);
      
      Profil1Array = [ProfilDic objectForKey:@"profilarray"];
      
      if ([ProfilDic objectForKey:@"name"])
      {
         Profil1Name = [NSString stringWithString:[ProfilDic objectForKey:@"name"]];
      }
      
      // Provisorisch
      Profil2Array = [ProfilDic objectForKey:@"profilarray"];
      
      // Rahmen zusammenstellen
      
      NSDictionary* maxminDic = [self maxminWertVonArray:[Profil1Array valueForKey:@"y"]];
      //NSLog(@"maxpos: %d max: %.3f minpos: %d min: %.3f",[[maxminDic objectForKey:@"maxpos"]intValue],[[maxminDic objectForKey:@"maxwert"]floatValue],[[maxminDic objectForKey:@"minpos"]intValue],[[maxminDic objectForKey:@"minwert"]floatValue]);
      
      float maxwert = [[maxminDic objectForKey:@"maxwert"]floatValue]* [ProfilTiefeFeldA intValue];
      float minwert = [[maxminDic objectForKey:@"minwert"]floatValue]* [ProfilTiefeFeldB intValue];
      //NSLog(@"StartpunktA.y: %.3f maxwert: %.3f minwert: %.3f",StartpunktA.y,maxwert,minwert);
      
      //NSLog(@"StartpunktA.y: %.3f abstandoben: %.3f abstandunten: %.3f",StartpunktA.y,abstandoben,abstandunten);
      
      //NSLog(@"count: %d KoordinatenTabelle vor: %@",[KoordinatenTabelle count],[KoordinatenTabelle description]);
      
      if ([KoordinatenTabelle count])
      {
         [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1]; // Letzen Punkt entfernen
      }
      
      NSMutableDictionary* tempRahmenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      NSPoint tempPunktA = StartpunktA;
      NSPoint tempPunktB = StartpunktB;
      NSPoint EckeLinksUnten;
      int rahmenindex=0;
      int einstichx = 5;
            
      // Start
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      //NSLog(@"count: %d KoordinatenTabelle 0: %@",[KoordinatenTabelle count],[KoordinatenTabelle description]);
      
      // Hochfahren bis Kote
      rahmenindex++;
      tempPunktA.y += self.Kote;
      tempPunktB.y += self.Kote;
      
      EckeLinksUnten = tempPunktA; // Rückkehrwert
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      // Einstich
      rahmenindex++;
      tempPunktA.x += einstichx;
      tempPunktB.x += einstichx;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      //NSLog(@"count: %d KoordinatenTabelle 1: %@",[KoordinatenTabelle count],[KoordinatenTabelle description]);
      
      
      // Hochfahren
      rahmenindex++;
      tempPunktA.x += 0;
      tempPunktA.y += (maxwert-minwert) + abstandunten; // Differenz der y-Werte + abstandunten
      tempPunktB.x += 0;
      tempPunktB.y += (maxwert-minwert) + abstandunten;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      
      NSDictionary* HolmpunktDicA = [CNC HolmDicVonPunkt:tempPunktA mitProfil:Profil1Array mitProfiltiefe:[ProfilTiefeFeldA intValue] mitScale:0];
      NSDictionary* HolmpunktDicB = [CNC HolmDicVonPunkt:tempPunktB mitProfil:Profil2Array mitProfiltiefe:[ProfilTiefeFeldB intValue] mitScale:0];
      
      HolmArrayA = [HolmpunktDicA objectForKey:@"holmpunktarray"];
      HolmArrayB = [HolmpunktDicB objectForKey:@"holmpunktarray"];
      
      float breiteA = [[[HolmArrayA objectAtIndex:3]objectForKey:@"y"]floatValue] - [[[HolmArrayA objectAtIndex:2]objectForKey:@"y"]floatValue];
      float breiteB = [[[HolmArrayB objectAtIndex:3]objectForKey:@"y"]floatValue] - [[[HolmArrayB objectAtIndex:2]objectForKey:@"y"]floatValue];
      
      float untenAx = [[[HolmArrayA objectAtIndex:2]objectForKey:@"x"]floatValue]; // Dist A vom Start bis erster Knick unten.
      float untenBx = [[[HolmArrayB objectAtIndex:2]objectForKey:@"x"]floatValue]; // Dist B vom Start bis erster Knick unten. Soll gleich liegen wie bei A
 //     fprintf(stderr,"A:\t%.3f\tB:\t%.3f\n",untenAx,untenBx);
      
      float delta = untenAx - untenBx;
      
      // Startpunkt korrigieren
      // offset bei A: 5
      // offset bei B: 5 + delta
      
      // Einlauf
      float offsetA = 5;
      float offsetB = offsetA + delta;
      
      rahmenindex++;
      tempPunktA.x += offsetA;
      tempPunktA.y += 0;
      tempPunktB.x += offsetB;
      tempPunktB.y += 0;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      
      //         [self updateIndex];
      
      //NSLog(@"KoordinatenTabelle count: %d",[KoordinatenTabelle count]);
      
      //NSLog(@"HolmArrayA count: %d",[HolmArrayA count]);
      for (int index=1;index< [HolmArrayA count];index++) // Punkte der Oberseite. Erster Punkt ist Startpunkt
      {
         NSMutableDictionary* tempZeilenDicA = [NSMutableDictionary dictionaryWithDictionary:[HolmArrayA objectAtIndex:index]];
         //NSLog(@"A index: %d x: %1.3f",index,[[[HolmArrayA objectAtIndex:index]objectForKey:@"x"]floatValue]);
         
         NSMutableDictionary* tempZeilenDicB = [NSMutableDictionary dictionaryWithDictionary:[HolmArrayB objectAtIndex:index]];
         //NSLog(@"B index: %d x: %1.3f",index,[[[HolmArrayB objectAtIndex:index]objectForKey:@"x"]floatValue]);
         
         // offset korrigieren
         
         float tempAx = [[tempZeilenDicA objectForKey:@"x"]floatValue];
         tempAx += offsetA;
         [tempZeilenDicA setObject:[NSNumber numberWithFloat:tempAx] forKey:@"x"];
         
         float tempBx = [[tempZeilenDicB objectForKey:@"x"]floatValue];
         tempBx += offsetB;
         [tempZeilenDicB setObject:[NSNumber numberWithFloat:tempBx] forKey:@"x"];
         
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"x"] forKey:@"ax"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"y"] forKey:@"ay"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"x"] forKey:@"bx"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"y"] forKey:@"by"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"index"] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
         // pwm
         [tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
         [KoordinatenTabelle addObject:tempZeilenDic];
         //NSLog(@"index: %d x: %1.3f",index,[[[ProfilArrayA objectAtIndex:index]objectForKey:@"ax"]floatValue]);
         
      }
      //NSLog(@"count: %d KoordinatenTabelle: %@",[KoordinatenTabelle count],[KoordinatenTabelle description]);
      
      // letzten Punkt setzen
      tempPunktA.x = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      tempPunktA.y = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      
      tempPunktB.x = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      tempPunktB.y = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      
      
      // Offset weiterfahren
      
      rahmenindex++;
      tempPunktA.x += offsetA;
      tempPunktA.y += 0;
      tempPunktB.x = tempPunktA.x; // gleiche Abzisse
      tempPunktB.y += 0;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      
      // Herunterfahren
      tempPunktA.y = StartpunktA.y + self.Kote;
      tempPunktB.y = StartpunktB.y + self.Kote;
      
      rahmenindex++;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      // zurueckfahren
      tempPunktA.x = StartpunktA.x + einstichx;
      tempPunktA.y = StartpunktA.y + self.Kote;
      tempPunktB.x = StartpunktB.x + einstichx;
      tempPunktB.y = StartpunktB.y + self.Kote;
      //tempPunktB.y = StartpunktB.y + KoteWert;
      
      rahmenindex++;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      
      // Einstich herausfahren
      rahmenindex++;
      tempPunktA.x -= einstichx;
      //tempPunktA.y -= einstichy;
      tempPunktB.x -= einstichx;
      //tempPunktB.y -= einstichy;
      
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.x] forKey:@"ax"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktA.y] forKey:@"ay"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.x] forKey:@"bx"];
      [tempRahmenDic setObject:[NSNumber numberWithFloat:tempPunktB.y] forKey:@"by"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:rahmenindex] forKey:@"index"];
      [tempRahmenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
      //NSLog(@"rahmenindex: %d tempRahmenDic: %@",rahmenindex,[tempRahmenDic description]);
      [KoordinatenTabelle addObject:[tempRahmenDic copy]];
      
      
      [self updateIndex];
      [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
      [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
      
      [ProfilGraph setDatenArray:KoordinatenTabelle];
      [ProfilGraph setNeedsDisplay:YES];
      [CNCTable reloadData];
      
   }
   
}


- (IBAction)reportEllipse:(id)sender
{


}


- (IBAction)reportNewElement:(id)sender
{
   
}

- (IBAction)reportNeueLinie:(id)sender
{
   //NSLog(@"Koordinatentabelle count: %d numberOfRows: %d ",[KoordinatenTabelle count],[CNCTable numberOfRows]);
   // Sicherheitshalber: letzten Punkt der bisherigen Datentabelle auswählen und Werte in Felder fuellen. Sonst wird neues Element nicht mit Endpunkt verbunden
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[CNCTable numberOfRows]-1] byExtendingSelection:NO];
   //[ProfilTable reloadData];
   //NSLog(@"reportNeueLinie");
   if (!CNC_Eingabe)
   {
       CNC_Eingabe =[[rEinstellungen alloc]init];
   }
//   [CNC_Eingabe setPList:[self readCNC_PList]];
   /*
   NSArray* LibElementArray=[self readLib];
   NSArray* LibElementnamenArray=[LibElementArray valueForKey:@"name"];
   
   NSLog(@"LibArray: %@",[LibElementnamenArray description]);
    */
   //NSLog(@"reportNeueLinie CNC_Eingabe: %@",[[CNC_Eingabe window]title]);
   NSMutableDictionary* datenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

   [datenDic setObject:@"Linie" forKey:@"element"];
   [datenDic setObject:[NSNumber numberWithFloat:[WertAXFeld floatValue]] forKey:@"startx"];
   [datenDic setObject:[NSNumber numberWithFloat:[WertAYFeld floatValue]] forKey:@"starty"];
   [datenDic setObject:[NSNumber numberWithInt:[Einlaufrand intValue]] forKey:@"einlaufrand"];
   [datenDic setObject:[NSNumber numberWithInt:[Auslaufrand intValue]] forKey:@"auslaufrand"];

   [datenDic setObject:[NSNumber numberWithInt:[Einlauflaenge intValue]] forKey:@"einlauflaenge"];
   [datenDic setObject:[NSNumber numberWithInt:[Einlauftiefe intValue]] forKey:@"einlauftiefe"];
   [datenDic setObject:[NSNumber numberWithInt:[Auslauflaenge intValue]] forKey:@"auslauflaenge"];
   [datenDic setObject:[NSNumber numberWithInt:[Auslauftiefe intValue]] forKey:@"auslauftiefe"];

   
   [datenDic setObject:[NSNumber numberWithFloat:[AbbrandFeld floatValue]] forKey:@"abbranda"];
   
    
   NSModalSession session = [NSApp beginModalSessionForWindow:[CNC_Eingabe window]];
   //NSLog(@"runModalForWindow A");
   
   [CNC_Eingabe setPList:CNC_PList];
   //NSLog(@"runModalForWindow B");
   [CNC_Eingabe setDaten:datenDic];
   
   [CNC_Eingabe clearProfilGraphDaten];

   
//   for (;;) 
   {
      
      while ([NSApp runModalSession:session] != NSRunContinuesResponse)
      {
       //NSLog(@"Modal break");
      break;
      }
      //[CNC_Eingabe showWindow:NULL];
      //[self doSomeWork];
   }
   
   [NSApp endModalSession:session];
   
  // [NSApp runModalForWindow:CNC_Eingabe];
   
   //[NSApp beginSheet:CNC_Eingabe modalForWindow:[self window] modalDelegate:self didEndSelector:NULL contextInfo:nil];
   
}

- (void)ElementeingabeAktion:(NSNotification*)note
{
   //NSLog(@"ElementeingabeAktion note: %@",[[note userInfo] description]);
   //NSLog(@"KoordinatenTabelle vor: %@",[KoordinatenTabelle description]);
   float origpwm=[DC_PWM intValue];
   
   NSArray* tempElementKoordinatenArray = [[note userInfo]objectForKey:@"koordinatentabelle"];
   //NSLog(@"tempElementKoordinatenArray: %@",[tempElementKoordinatenArray description]);
   
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];

   
    NSDictionary* oldPosDic = nil;
   
   float oldax= 0;//MausPunkt.x;
   float olday=0;//MausPunkt.y;
   float oldbx=0;//oldax + offsetx;
   float oldby=0;//olday + offsety;

   
   // Startpunkte setzen aus Koordinatentabelle
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
   }
   else // Beim Start Offset dazuzaehlen
   {
      oldbx += offsetx;
      oldby += offsety;
      
   }

   
   // Offset der letzten Punkte von A und B:
   
   float deltax = oldbx-oldax;
   float deltay = oldby-olday;
   //NSLog(@"deltax: %2.2f deltay: %2.2f",deltax,deltay);
   // Elemente von B sind um deltax, deltay verschoben

   
   int i=0;
   for (i=0;i<[tempElementKoordinatenArray count];i++)
   {
      float dx = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:0]floatValue]; 
      float dy = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:1]floatValue];
      
      // Neue Werte zu alten dazuzaehlen
      oldax += dx;
      olday += dy;
      oldbx += dx;
      oldby += dy;
      
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax],@"ax",[NSNumber numberWithFloat:olday],@"ay",[NSNumber numberWithFloat:oldbx],@"bx",[NSNumber numberWithFloat:oldby],@"by",[NSNumber numberWithInt:i],@"index", nil];
//[tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
     
      //NSLog(@"tempDic: %@",[tempDic description]);
      [KoordinatenTabelle addObject: tempDic];

      
      
   }
   
   //NSLog(@"KoordinatenTabelle nach: %@",[KoordinatenTabelle description]);
   
   
   [self updateIndex];
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
  
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
//   NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];


   
   //NSLog(@"KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];

   
}

- (void)LibElementeingabeAktion:(NSNotification*)note
{
   //NSLog(@"LibElementeingabeAktion note: %@",[[note userInfo] description]);
   //NSLog(@"KoordinatenTabelle vor: %@",[KoordinatenTabelle description]);
   [UndoKoordinatenTabelle removeAllObjects];
   // letzten Stand der Koordinatentabelle sichern
   [UndoKoordinatenTabelle addObjectsFromArray:KoordinatenTabelle];
   
   //Index des letzten Elements im KoordinatenTabelle sichern
   [UndoSet addIndex:[KoordinatenTabelle count]];
   
   // ElementKoordinatenArray von CNC_Eingabe lesen
   NSArray* tempElementKoordinatenArray = [[note userInfo]objectForKey:@"koordinatentabelle"];
   //NSLog(@"tempElementKoordinatenArray FIRST: %@",[[tempElementKoordinatenArray objectAtIndex:0]description]);
   //NSLog(@"tempElementKoordinatenArray LAST: %@",[[tempElementKoordinatenArray lastObject]description]);
   //NSLog(@"tempElementKoordinatenArray: %@",[tempElementKoordinatenArray description]);
   
   // neu fuer A,B
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
   
   NSDictionary* oldPosDic = nil;
   
   float oldax= 0;//MausPunkt.x;
   float olday=0;//MausPunkt.y;
   float oldbx=0;//oldax + offsetx;
   float oldby=0;//olday + offsety;
   
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
   }
   else // Startpunkt, nur Offset aus Offsetfeldern
   {
      oldbx += offsetx;
      oldby += offsety;
   }
   // Offset der letzten Punkte von A und B:
   //NSLog(@"oldax: %2.2f olday: %2.2f",oldax,olday);
  
   int i=0;
   // 31.10.
   for (i=0;i<[tempElementKoordinatenArray count];i++) // Data 0 ist letztes Data von Koordinatentabelle 
   {
      float dx = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:0]floatValue]; 
      float dy = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:1]floatValue];

      //NSLog(@"index: %d oldax: %2.2f olday: %2.2f  dx: %2.2f dy: %2.2f",i,oldax,olday,dx,dy);
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax+dx],@"ax",[NSNumber numberWithFloat:olday+dy],@"ay",[NSNumber numberWithFloat:oldbx+dx],@"bx",[NSNumber numberWithFloat:oldby+dy],@"by",[NSNumber numberWithInt:i],@"index", nil];
      
      [KoordinatenTabelle addObject: tempDic];
      
   
   
   }
      //NSLog(@"LibElementeingabeAktion Koordinatentabelle count: %d numberOfRows: %d ",[KoordinatenTabelle count],[CNCTable numberOfRows]);

   //NSLog(@"KoordinatenTabelle nach: %@",[KoordinatenTabelle description]);
   
   [self updateIndex];
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
   
   //maximales x finden

   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
//   NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];
   
   NSMutableDictionary* StartwertDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ax"] forKey:@"startx"];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ay"] forKey:@"starty"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"eingabedaten" object:self userInfo:StartwertDic];

   //NSLog(@"KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];

}


- (void)LibProfileingabeAktion:(NSNotification*)note
{
   //NSLog(@"LibProfileingabeAktion note: %@",[[note userInfo] description]);
	/*
   Werte fuer "teil":
    10:  Endleisteneinlauf
    20:  Oberseite
    30:  Unterseite, rueckwaerts eingesetzt
    40:  Nasenleisteauslauf
    */
   //NSLog(@"LibProfileingabeAktion start [KoordinatenTabelle count] beim Start: %d",[KoordinatenTabelle count]);;
   int startindexoffset = [KoordinatenTabelle count]-1;
	NSString* ProfilName;
   NSString* Profil1Name;
   NSString* Profil2Name;
	NSArray* ProfilArrayA;
	NSArray* ProfilArrayB;
   // NSArray* ProfilUArray;
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
   if ([WertAXFeld floatValue]==0)
   {
      [WertAXFeld setFloatValue:20];
   }
   if ([WertAYFeld floatValue]==0)
   {
      [WertAYFeld setFloatValue:50];
   }
   //NSLog(@"LibProfileingabeAktion KoordinatenTabelle: %@",[KoordinatenTabelle description]);
	// Profil lesen
   [ProfilGraph setScale:[[ScalePop selectedItem]tag]];
   
   /*
   if ([WertAXFeld floatValue]==0)
   {
      [WertAXFeld setFloatValue:25.0 + [ProfilTiefeFeldA intValue]];
   }
   if ([WertAYFeld floatValue]==0)
   {
      [WertAYFeld setFloatValue:50];
      //[WertAYFeld setFloatValue:[ProfilBOffsetYFeld intValue]];
   }
   */
   
   
   
   float ax = 0;
   float ay = 0;;
   float bx = 0;;
   float by = 0;;
   
   NSPoint StartpunktA;
   NSPoint StartpunktB;

   // Werte fuer Abbrandlinie
   
   float abrax = 0;
   float abray = 0;;
   float abrbx = 0;;
   float abrby = 0;;
   
   
      
   NSPoint AbbrandStartpunktA;
   NSPoint AbbrandStartpunktB;
   
   float abbranda = [AbbrandFeld floatValue];
   float abbrandb = [AbbrandFeld floatValue]/[ProfilTiefeFeldB floatValue]*[ProfilTiefeFeldA floatValue]; // groesser bei groesserem Unterschied

   
   float origpwm=[DC_PWM intValue];
   
   if ([KoordinatenTabelle count])
   {
      ax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      ay = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      bx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      by = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      
      StartpunktA = NSMakePoint(ax, ay);
      StartpunktB = NSMakePoint(bx, by);
   }
   else
   {
      StartpunktA = NSMakePoint([WertAXFeld floatValue], [WertAYFeld floatValue]);
      StartpunktB = NSMakePoint([WertAXFeld floatValue]+offsetx, [WertAYFeld floatValue]+offsety);
      bx += offsetx;
      by += offsety;
   }
   
   
   NSDictionary* ProfilDic;
   if ([note userInfo])
   {
      ProfilDic = [note userInfo];
   }
   else
   {
      
      return;
   }
   
   
   
   [OberseiteCheckbox  setState:[[ProfilDic objectForKey:@"oberseite"]intValue]];
   [UnterseiteCheckbox  setState:[[ProfilDic objectForKey:@"unterseite"]intValue]];
   [EinlaufCheckbox  setState:[[ProfilDic objectForKey:@"einlauf"]intValue]];
   [AuslaufCheckbox  setState:[[ProfilDic objectForKey:@"auslauf"]intValue]];
   
   mitOberseite = [[ProfilDic objectForKey:@"oberseite"]intValue];
   mitUnterseite = [[ProfilDic objectForKey:@"unterseite"]intValue];
   mitEinlauf = [[ProfilDic objectForKey:@"einlauf"]intValue];
   mitAuslauf = [[ProfilDic objectForKey:@"auslauf"]intValue];
   flipH = [[ProfilDic objectForKey:@"fliph"]intValue];
   flipV = [[ProfilDic objectForKey:@"flipv"]intValue];
   reverse = [[ProfilDic objectForKey:@"reverse"]intValue];

   
   if ([ProfilDic objectForKey:@"profil1name"])
   {
   Profil1Name=[ProfilDic objectForKey:@"profil1name"]; //Dic mit Keys x,y. Werte sind normiert auf Bereich 0-1
   [ProfilNameFeldA setStringValue:Profil1Name];
   }
   if ([ProfilDic objectForKey:@"profil2name"])
   {
      Profil2Name=[ProfilDic objectForKey:@"profil2name"]; //Dic mit Keys x,y. Werte sind normiert auf Bereich 0-1
   [ProfilNameFeldB setStringValue:Profil2Name];
   }
   
   // Dic mit keys x,y,index, Werte mit wahrer laenge in mm proportional Profiltiefe
   
   NSArray* Profil1Array=NULL;
   if ([ProfilDic objectForKey:@"profil1array"])
   {
      Profil1Array=[ProfilDic objectForKey:@"profil1array"];
   }
   NSArray* Profil2Array=NULL;
   if ([ProfilDic objectForKey:@"profil2array"])
   {
      Profil2Array=[ProfilDic objectForKey:@"profil2array"];
   }
    
   //NSLog(@"ProfilDic %@",[ProfilDic description]);
   
   float ProfiltiefeA = [ProfilTiefeFeldA floatValue];
   float ProfiltiefeB = [ProfilTiefeFeldB floatValue];
      
   
   float pfeilung = (ProfiltiefeA - ProfiltiefeB)/[Spannweite intValue];
   float arc=atan(pfeilung);
   float sinus = sin(arc);
   //NSLog(@"pfeilung: %2.8f arc: %2.8f sinus: %2.8f",pfeilung,arc,sinus);
   
   float TiefeA = ProfiltiefeA + [Basisabstand intValue] * pfeilung;
   float TiefeB = TiefeA - [Portalabstand intValue] * pfeilung;
   
   TiefeA += abbranda; // Korrektur wegen Abbrand an Ende und Nase
   TiefeB += abbrandb;
   
   
   float testB = TiefeB + ([Portalabstand intValue] - ([Spannweite intValue]+[Basisabstand intValue] ))*pfeilung;
   
   
   //NSLog(@"pfeilung: %2.4f TiefeA: %2.2f TiefeB: %2.2f testB: %2.2f",pfeilung,TiefeA,TiefeB, testB);
   /*
   switch ([GleichesProfilRadioKnopf selectedRow])
   {
      case 0: // beide gleich
      {
         [ProfilNameFeldA setStringValue:Profil1Name];
         [ProfilNameFeldB setStringValue:Profil1Name];
         
      }break;
      case 1: // Profil A
      {
         [ProfilNameFeldB setStringValue:Profil1Name];
         
      }break;
      case 2: // Profil B
      {
         [ProfilNameFeldB setStringValue:Profil2Name];
         
      }break;
         
         
   } // switch radio
    */
     
   einlauflaenge = [[ProfilDic objectForKey:@"einlauflaenge"]intValue];
   einlauftiefe = [[ProfilDic objectForKey:@"einlauftiefe"]intValue];
   einlaufrand = [[ProfilDic objectForKey:@"einlaufrand"]intValue];
   [Einlaufrand setIntValue:einlaufrand];
   [Einlauftiefe setIntValue:[[ProfilDic objectForKey:@"einlauftiefe"]intValue]];
   [Einlauflaenge setIntValue:[[ProfilDic objectForKey:@"einlauflaenge"]intValue]];

   auslauflaenge = [[ProfilDic objectForKey:@"auslauflaenge"]intValue];
   auslauftiefe = [[ProfilDic objectForKey:@"auslauftiefe"]intValue];
   auslaufrand = [[ProfilDic objectForKey:@"auslaufrand"]intValue];
   [Auslaufrand setIntValue:auslaufrand];
   [Auslauftiefe setIntValue:[[ProfilDic objectForKey:@"auslauftiefe"]intValue]];
   [Auslauflaenge setIntValue:[[ProfilDic objectForKey:@"auslauflaenge"]intValue]];
   
  // NSLog(@"einlaufrand: %d auslaufrand: %d",einlaufrand,auslaufrand);
   
   // Einlauf-Schnittlinie
   
   if (!(mitOberseite && mitUnterseite) && mitEinlauf) // Nur Ober- ODER Unterseite
   {
      // Endleistenwinkel bestimmen
      float winkelA = [CNC EndleistenwinkelvonProfil:[ProfilDic objectForKey:@"profil1array"]];
     // NSLog(@"Endleistenwinkel A: %2.2f",winkelA*180/M_PI);

      //float winkelB = [CNC EndleistenwinkelvonProfil:[ProfilDic objectForKey:@"profil2array"]];
      float winkelB = [CNC EndleistenwinkelvonProfil:Profil2Array];
      //NSLog(@"Endleistenwinkel B: %2.2f",winkelB*180/M_PI);

     // if ([OberseiteCheckbox state]&& (![OberseiteCheckbox state]))
      if (mitOberseite && (!mitUnterseite)) 
      {
         //if (flipV)
         //winkel *= -1;
      }
      
      // Koordinaten der Einlauflinie: nur x,y
      NSArray* EndleistenEinlaufArrayA=[CNC EndleisteneinlaufMitWinkel:winkelA mitLaenge:einlauflaenge mitTiefe:einlauftiefe];
      NSArray* EndleistenEinlaufArrayB=[CNC EndleisteneinlaufMitWinkel:winkelB mitLaenge:einlauflaenge mitTiefe:einlauftiefe];
      //NSLog(@"AVR EndleistenEinlaufArrayA: %@",[EndleistenEinlaufArrayA description]);
      int k=0;
      for(k=1;k<[EndleistenEinlaufArrayA count];k++)
      {
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         
         float tempax = [[[EndleistenEinlaufArrayA objectAtIndex:k]objectAtIndex:0]floatValue];
         float tempay = [[[EndleistenEinlaufArrayA objectAtIndex:k]objectAtIndex:1]floatValue];
         //NSLog(@"tempx: %2.2f tempy: %2.2f",tempx, tempy);
         [tempZeilenDic setObject:[NSNumber numberWithFloat:ax+tempax]forKey:@"ax"];
         [tempZeilenDic setObject:[NSNumber numberWithFloat:ay+tempay]forKey:@"ay"];
         
         // reduziertes pwm:
         if ([[EndleistenEinlaufArrayA objectAtIndex:k]count]>2) // Angaben fuer pwm an index 2
         {
            //NSLog(@"EndleistenEinlaufArrayA pwm: %2.2f",[[[EndleistenEinlaufArrayA objectAtIndex:k]objectAtIndex:2]floatValue]);
            int temppwm = [[[EndleistenEinlaufArrayA objectAtIndex:k]objectAtIndex:2]floatValue]*origpwm;
            
            [tempZeilenDic setObject:[NSNumber numberWithInt:temppwm] forKey:@"pwm"];
            //NSLog(@"EndleistenEinlaufArrayA pwm: %2.2f",temppwm);

         }
         else 
         {
            [tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
         }
         
         float tempbx = [[[EndleistenEinlaufArrayB objectAtIndex:k]objectAtIndex:0]floatValue];
         float tempby = [[[EndleistenEinlaufArrayB objectAtIndex:k]objectAtIndex:1]floatValue];
         
         [tempZeilenDic setObject:[NSNumber numberWithFloat:bx+tempbx]forKey:@"bx"];
         [tempZeilenDic setObject:[NSNumber numberWithFloat:by+tempby]forKey:@"by"];
         
         
         [tempZeilenDic setObject:[NSNumber numberWithInt:k] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:10] forKey:@"teil"];
         // pwm
         
         [KoordinatenTabelle addObject:tempZeilenDic];
      }
      
      // Abbrandlinie auf letztem Abschnitt einfuegen
      int abrindex=[KoordinatenTabelle count]-1; // last object
      
      
      [self updateIndex];
      
      ax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      ay = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      bx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      by = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      StartpunktA = NSMakePoint(ax, ay);
      StartpunktB = NSMakePoint(bx, by);
      
      
      
   }
   
   //NSLog(@"AVR KoordinatenTabelle: %@",[KoordinatenTabelle description]);

   // Dic mit keys x,y,index, Werte mit wahrer laenge in mm proportional Profiltiefe
/*
   NSArray* Profil1Array=NULL;
   if ([ProfilDic objectForKey:@"profil1array"])
   {
      Profil1Array=[ProfilDic objectForKey:@"profil1array"];
   }
   NSArray* Profil2Array=NULL;
   
 if ([ProfilDic objectForKey:@"profil2array"])
   {
      Profil2Array=[ProfilDic objectForKey:@"profil2array"];
   }
   if ([ProfilWrenchFeld floatValue])
   {
      Profil2Array = [Utils wrenchProfil:Profil2Array mitWrench:[ProfilWrenchFeld floatValue]];
   }
*/
   //NSDictionary* ProfilpunktDicA=[CNC ProfilDicVonPunkt:StartpunktA mitProfil:Profil1Array mitProfiltiefe:ProfiltiefeA mitScale:[[ScalePop selectedItem]tag]];
   NSDictionary* ProfilpunktDicA=[CNC ProfilDicVonPunkt:StartpunktA mitProfil:Profil1Array mitProfiltiefe:TiefeA mitScale:[[ScalePop selectedItem]tag]];
   
   //NSDictionary* ProfilpunktDicB=[CNC ProfilDicVonPunkt:StartpunktB mitProfil:Profil2Array mitProfiltiefe:ProfiltiefeB mitScale:[[ScalePop selectedItem]tag]];
   NSDictionary* ProfilpunktDicB=[CNC ProfilDicVonPunkt:StartpunktB mitProfil:Profil2Array mitProfiltiefe:TiefeB mitScale:[[ScalePop selectedItem]tag]];
   
   //NSLog(@"ProfilpunktDicA %@",[ProfilpunktDicA description]);
   ProfilArrayA = [ProfilpunktDicA objectForKey:@"profilpunktarray"];
   
   ProfilArrayB = [ProfilpunktDicB objectForKey:@"profilpunktarray"];
   
   //NSLog(@"wrench: %2.2f",[ProfilWrenchFeld floatValue]);

   //NSLog(@"wrench: %2.2f ProfilArrayB %@",[ProfilWrenchFeld floatValue],[ProfilArrayB description]);

    
   
   int Nasenindex=[[ProfilpunktDicA objectForKey:@"nase"]intValue];
   
   //NSLog(@"AVR ProfilArrayA count: %d",[ProfilArrayA count]);
   
   // NSLog(@"AVR ProfilOArray: %@",[ProfilOArray description]);
   // NSLog(@"AVR ProfilUArray: %@",[ProfilUArray description]);
   // Letzten Punkt der Koordinatentabelle entfernen, wird zu erstem Punkt des Profils
   
   if ([KoordinatenTabelle count])
   {
      [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1]; // Letzen Punkt entfernen
   }
   [self updateIndex];
   //NSLog(@"[KoordinatenTabelle count] beim Start: %d",[KoordinatenTabelle count]);;
   
   int index=0;
   int profilstartindex=0;
   int profilendindex=0;
   // Oberseite einfuegen
   //NSLog(@"Oberseite Nasenindex: %d",Nasenindex);
   //if ([OberseiteCheckbox state])
   if (mitOberseite)
   {
      // Startindex fixieren, wird fuer Abbrand gebraucht fuer 'von'
      profilstartindex = [[[KoordinatenTabelle lastObject]objectForKey:@"index"]intValue];
       profilstartindex =[KoordinatenTabelle count];
      
      //NSLog(@"profilstartindex: %d",profilstartindex);
      for (index=0;index<= Nasenindex;index++) // Punkte der Oberseite
      {
         NSDictionary* tempZeilenDicA = [ProfilArrayA objectAtIndex:index];
         NSDictionary* tempZeilenDicB = [ProfilArrayB objectAtIndex:index];
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"x"] forKey:@"ax"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"y"] forKey:@"ay"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"x"] forKey:@"bx"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"y"] forKey:@"by"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"index"] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:20] forKey:@"teil"]; // Kennzeichnung Oberseite
         // pwm
         [tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
         [KoordinatenTabelle addObject:tempZeilenDic];
         //NSLog(@"index: %d x: %1.3f",index,[[[ProfilArrayA objectAtIndex:index]objectForKey:@"ax"]floatValue]);
      }
   }
    
   
   
   
   //if ([OberseiteCheckbox state]&& [UnterseiteCheckbox state]) // Oberseite schon eingefuegt, letztes Element entfernen, vor Unterseite anfuegen
      if (mitOberseite&& mitUnterseite) // Oberseite schon eingefuegt, letztes Element entfernen, vor Unterseite anfuegen
   {
      //NSLog(@"index: %d",index);
      //NSLog(@"ProfilArrayA count: %d",[ProfilArrayA count]);
      //NSLog(@"ProfilArrayA count-1: %@",[ProfilArrayA objectAtIndex:[ProfilArrayA count]-1]);
      
      //NSLog(@"Nase weg index: %d x: %1.1f",index,[[[ProfilArrayA objectAtIndex:[ProfilArrayA count]-1]objectForKey:@"ax"]floatValue]);
      [KoordinatenTabelle removeObjectAtIndex:[KoordinatenTabelle count]-1]; // Letzen Punkt entfernen
   }   
   
   // Unterseite anfuegen
   //NSLog(@"Unterseite ");

   if (mitUnterseite)
   {
      //NSLog(@"Unterseite einfuegen");

      for (index=Nasenindex;index< [ProfilArrayA count];index++) // Alle Punkte abfahren
      {
         int unterseiteindex=index;
//         if ([OberseiteCheckbox state]) // Unterseite anschliessen
         if (mitOberseite) // Unterseite anschliessen
         {
            //[KoordinatenTabelle addObject:[ProfilArrayA objectAtIndex:index]];
            //NSLog(@"index: %d x: %1.1f",index,[[[ProfilArray objectAtIndex:index]objectForKey:@"ax"]floatValue]);         
         }
         else // Unterseite rueckwäerts einsetzen
         {
            unterseiteindex = [ProfilArrayA count]-(index-Nasenindex)-1;
            
            //[KoordinatenTabelle addObject:[ProfilArrayA objectAtIndex:rueckwaertsindex]];
            //NSLog(@"index: %d rueckwaertsindex: %d x: %1.1f",index,rueckwaertsindex,[[[ProfilArray objectAtIndex:rueckwaertsindex]objectForKey:@"ax"]floatValue]);         
         }
         
         NSDictionary* tempZeilenDicA = [ProfilArrayA objectAtIndex:unterseiteindex];
         NSDictionary* tempZeilenDicB = [ProfilArrayB objectAtIndex:unterseiteindex];
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"x"] forKey:@"ax"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"y"] forKey:@"ay"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"x"] forKey:@"bx"];
         [tempZeilenDic setObject:[tempZeilenDicB objectForKey:@"y"] forKey:@"by"];
         [tempZeilenDic setObject:[tempZeilenDicA objectForKey:@"index"] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:30] forKey:@"teil"];
         // pwm
         [tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
         
         [KoordinatenTabelle addObject:tempZeilenDic];
         //NSLog(@"index: %d x: %1.1f",index,[[[ProfilArrayA objectAtIndex:index]objectForKey:@"ax"]floatValue]);
         
      }
      // Endindex fixieren, wird fuer Abbrand gebraucht fuer 'bis'
      profilendindex = [[[KoordinatenTabelle lastObject]objectForKey:@"index"]intValue];
      profilendindex = [KoordinatenTabelle count];
      //NSLog(@"profilendindex: %d",profilendindex);
      
   } // mit Unterseite
   
   
   
   //
//   if (!([OberseiteCheckbox state]&&[UnterseiteCheckbox state])&&[AuslaufCheckbox state])
   if (!(mitOberseite&&mitUnterseite)&&mitAuslauf)
   {
      ax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      ay = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      bx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      by = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      
      NSArray* NasenleistenAuslaufArray=[CNC NasenleistenauslaufMitLaenge:auslauflaenge mitTiefe:auslauftiefe];
      //NSLog(@"AVR EndleistenEinlaufArray: %@",[NasenleisteneinlaufMitLaenge description]);
      int l;
      for(l=1;l<[NasenleistenAuslaufArray count];l++)
      {
         NSMutableDictionary* tempZeilenDic =[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
         float tempx = [[[NasenleistenAuslaufArray objectAtIndex:l]objectAtIndex:0]floatValue];
         float tempy = [[[NasenleistenAuslaufArray objectAtIndex:l]objectAtIndex:1]floatValue];
         //NSLog(@"tempx: %2.2f tempy: %2.2f",tempx, tempy);
         [tempZeilenDic setObject:[NSNumber numberWithFloat:ax+tempx]forKey:@"ax"];
         [tempZeilenDic setObject:[NSNumber numberWithFloat:ay+tempy]forKey:@"ay"];
         [tempZeilenDic setObject:[NSNumber numberWithFloat:bx+tempx]forKey:@"bx"];
         [tempZeilenDic setObject:[NSNumber numberWithFloat:by+tempy]forKey:@"by"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:l] forKey:@"index"];
         [tempZeilenDic setObject:[NSNumber numberWithInt:40] forKey:@"teil"]; // Kennzeichnung Auslauf
         
         
         if ([[NasenleistenAuslaufArray objectAtIndex:l]count]>2) // Angaben fuer pwm an index 2
         {
            //NSLog(@"NasenleistenAuslaufArray pwm-index: %2.2f",[[[NasenleistenAuslaufArray objectAtIndex:l]objectAtIndex:2]floatValue]);
            float temppwm = [[[NasenleistenAuslaufArray objectAtIndex:l]objectAtIndex:2]floatValue]*origpwm;
            //NSLog(@"NasenleistenAuslaufArray pwm: %2.2f",temppwm);
            [tempZeilenDic setObject:[NSNumber numberWithInt:temppwm] forKey:@"pwm"];
         
         }
         else 
         {
            [tempZeilenDic setObject:[NSNumber numberWithInt:origpwm] forKey:@"pwm"];
         }


         [KoordinatenTabelle addObject:tempZeilenDic];
         
      }
      
      [self updateIndex];
   }
 
   
   
   if ([ProfilWrenchFeld floatValue])
   {
      float wrenchwinkel =0;
      switch ([ProfilWrenchEinheitRadio selectedRow]) // mm
           {
              case 0:
              {
              wrenchwinkel = atanf([ProfilWrenchFeld floatValue]/[ProfilTiefeFeldB floatValue])*180/M_PI * (-1);
              }break;
              case 1:
              {
                 wrenchwinkel = [ProfilWrenchFeld floatValue]* (-1);
              }break;
           }
      NSLog(@"wrenchwinkel: %2.2f ",wrenchwinkel);
      
      if (mitOberseite &&!mitUnterseite && flipV) // nur Oberseite und gespiegelt
      {
         wrenchwinkel *= -1;
      }
      KoordinatenTabelle = [[Utils wrenchProfilschnittlinie:KoordinatenTabelle mitWrench:wrenchwinkel]retain];
   
   }

   
   //NSLog(@"KoordinatenTabelle nach wrench: %@",[KoordinatenTabelle description]);

   //   [KoordinatenTabelle addObjectsFromArray:ProfilArray];
   // NSLog(@"Profil KoordinatenTabelle: %@",[[KoordinatenTabelle valueForKey:@"ax"] description]);
   
   [self updateIndex];
   //NSLog(@" Last: %@",[[KoordinatenTabelle lastObject] description]);
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
   
   int von=0;
   int bis=[KoordinatenTabelle count];
   
 //  if ((mitUnterseite ||  mitOberseite) &&! (mitOberseite && mitUnterseite)) // nur eine Seite
  if ((mitUnterseite ^  mitOberseite) ) // nur eine Seite
       {
          //NSLog(@"nur eine Seite");
          if (mitEinlauf)
          {
             von=startindexoffset + 2;
          }
          if (mitAuslauf)
          {
             bis=[KoordinatenTabelle count]-2;
          }
       }
   
   if (mitOberseite && mitUnterseite) // ganzes Profil, Einlauf manuell: von, bis an Anfang und Ende des Profils
   {
      NSLog(@"mitOberseite && mitUnterseite startindex: %d endindex: %d",profilstartindex, profilendindex );
      von = profilstartindex;
      bis = profilendindex;
   }
   
   
   if ([AbbrandCheckbox state])
   {
      KoordinatenTabelle = [CNC addAbbrandVonKoordinaten:KoordinatenTabelle mitAbbrandA:abbranda  mitAbbrandB:abbrandb aufSeite:0 von:von bis:bis];
   }
   
   
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
   //NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];

   // Startwerte in mm in CNC_Eingabe aktualisieren
   NSMutableDictionary* StartwertDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ax"] forKey:@"startx"];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ay"] forKey:@"starty"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"eingabedaten" object:self userInfo:StartwertDic];

   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];
   [self saveProfileinstellungen];

//   [self Blockeinfuegen];
}

- (void)FormeingabeAktion:(NSNotification*)note
{
   //NSLog(@"FormeingabeAktion note: %@",[[note userInfo] description]);
   //NSLog(@"KoordinatenTabelle vor: %@",[KoordinatenTabelle description]);
   [UndoKoordinatenTabelle removeAllObjects];
   // letzten Stand der Koordinatentabelle sichern
   [UndoKoordinatenTabelle addObjectsFromArray:KoordinatenTabelle];
   
   //Index des letzten Elements im KoordinatenTabelle sichern
   [UndoSet addIndex:[KoordinatenTabelle count]];
   
   NSArray* tempFormKoordinatenArray = [[note userInfo]objectForKey:@"koordinatentabelle"];
   //NSArray* tempElementKoordinatenArray = [[note userInfo]objectForKey:@"elementarray"];
   //NSLog(@"tempFormKoordinatenArray FIRST: %@",[[tempFormKoordinatenArray objectAtIndex:0]description]);
   //NSLog(@"tempFormKoordinatenArray LAST: %@",[[tempFormKoordinatenArray lastObject]description]);
   //NSLog(@"tempFormKoordinatenArray: %@",[tempFormKoordinatenArray description]);
   
   // neu fuer A,B
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
   
   NSDictionary* oldPosDic = nil;
   
   float oldax= 0;//MausPunkt.x;
   float olday=0;//MausPunkt.y;
   float oldbx=0;//oldax + offsetx;
   float oldby=0;//olday + offsety;
   
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
   }
   else // Start
   {
      oldbx += offsetx;
      oldby += offsety;
   }
   // Offset der letzten Punkte von A und B:
   
   //NSLog(@"oldax: %2.2f olday: %2.2f",oldax,olday);
   int i=0;
   // 31.10.
   for (i=0;i<[tempFormKoordinatenArray count];i++) // Data 0 ist letztes Data von Koordinatentabelle 
   {
      float d1x = [[[tempFormKoordinatenArray objectAtIndex:i]objectAtIndex:0]floatValue]; 
      float d1y = [[[tempFormKoordinatenArray objectAtIndex:i]objectAtIndex:1]floatValue];
      float d2x = [[[tempFormKoordinatenArray objectAtIndex:i]objectAtIndex:2]floatValue]; 
      float d2y = [[[tempFormKoordinatenArray objectAtIndex:i]objectAtIndex:3]floatValue];
      
      //NSLog(@"index: %d oldax: %2.2f olday: %2.2f  dx: %2.2f dy: %2.2f",i,oldax,olday,d1x,d1y);
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax+d1x],@"ax",[NSNumber numberWithFloat:olday+d1y],@"ay",[NSNumber numberWithFloat:oldbx+d2x],@"bx",[NSNumber numberWithFloat:oldby+d2y],@"by",[NSNumber numberWithInt:i],@"index", nil];
      
      [KoordinatenTabelle addObject: tempDic];
   }
   //NSLog(@"LibElementeingabeAktion Koordinatentabelle count: %d numberOfRows: %d ",[KoordinatenTabelle count],[CNCTable numberOfRows]);

   float abbranda = [AbbrandFeld floatValue];
   float abbrandb = [AbbrandFeld floatValue]/[ProfilTiefeFeldB floatValue]*[ProfilTiefeFeldA floatValue]; // groesser bei groesserem Unterschied
   int von = 0;
   int bis = [KoordinatenTabelle  count];
  
   if ([AbbrandCheckbox state])
   {
      KoordinatenTabelle = [CNC addAbbrandVonKoordinaten:KoordinatenTabelle mitAbbrandA:abbranda  mitAbbrandB:abbrandb aufSeite:1 von:von bis:bis];
   }
   

   
   //NSLog(@"KoordinatenTabelle nach: %@",[KoordinatenTabelle description]);
   
   [self updateIndex];
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
   
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
   //NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];

   
   NSMutableDictionary* StartwertDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ax"] forKey:@"startx"];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ay"] forKey:@"starty"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"eingabedaten" object:self userInfo:StartwertDic];
   
   //NSLog(@"KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];
   
   
   
}

- (void)BlockeingabeAktion:(NSNotification*)note
{
   NSLog(@"BlockeingabeAktion note: %@",[[note userInfo] description]);
   [Blockoberkante setIntValue:[[[note userInfo]objectForKey:@"blockoberkante"]intValue]];
   [OberkantenStepper setIntValue:[Blockoberkante intValue]];



}

- (void)FigElementeingabeAktion:(NSNotification*)note
{
  // NSLog(@"FigElementeingabeAktion note: %@",[[note userInfo] description]);
   // ElementKoordinatenArray von CNC_Eingabe lesen
   NSArray* tempElementKoordinatenArray = [[note userInfo]objectForKey:@"koordinatentabelle"];
   //NSLog(@"tempElementKoordinatenArray FIRST: %@",[[tempElementKoordinatenArray objectAtIndex:0]description]);
   //NSLog(@"tempElementKoordinatenArray LAST: %@",[[tempElementKoordinatenArray lastObject]description]);
   //NSLog(@"tempElementKoordinatenArray: %@",[tempElementKoordinatenArray description]);
   
   // neu fuer A,B
   float offsetx = [ProfilBOffsetXFeld floatValue];
   float offsety = [ProfilBOffsetYFeld floatValue];
   
   
   NSDictionary* oldPosDic = nil;
   
   float oldax= 0;//MausPunkt.x;
   float olday=0;//MausPunkt.y;
   float oldbx=0;//oldax + offsetx;
   float oldby=0;//olday + offsety;
   
   if ([KoordinatenTabelle count])
   {
      oldPosDic = [KoordinatenTabelle lastObject];
      oldax = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      olday = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      oldbx = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      oldby = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
   }
   else // Startpunkt, nur Offset aus Offsetfeldern
   {
      oldbx += offsetx;
      oldby += offsety;
   }
   // Offset der letzten Punkte von A und B:
   //NSLog(@"oldax: %2.2f olday: %2.2f",oldax,olday);
   
   int i=0;
   // 31.10.
   for (i=0;i<[tempElementKoordinatenArray count];i++) // Data 0 ist letztes Data von Koordinatentabelle 
   {
      float dx = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:0]floatValue]; 
      float dy = [[[tempElementKoordinatenArray objectAtIndex:i]objectAtIndex:1]floatValue];
      
      //NSLog(@"index: %d oldax: %2.2f olday: %2.2f  dx: %2.2f dy: %2.2f",i,oldax,olday,dx,dy);
      NSDictionary* tempDic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:oldax+dx],@"ax",[NSNumber numberWithFloat:olday+dy],@"ay",[NSNumber numberWithFloat:oldbx+dx],@"bx",[NSNumber numberWithFloat:oldby+dy],@"by",[NSNumber numberWithInt:i],@"index", nil];
      
      [KoordinatenTabelle addObject: tempDic];
      
      
      
   }
   //NSLog(@"LibElementeingabeAktion Koordinatentabelle count: %d numberOfRows: %d ",[KoordinatenTabelle count],[CNCTable numberOfRows]);
   
   //NSLog(@"KoordinatenTabelle nach: %@",[KoordinatenTabelle description]);
   
   [self updateIndex];
   
   [WertAXFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue]];
   [WertAYFeld setFloatValue:[[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue]];
   
   NSDictionary* RahmenDic = [self RahmenDic];
   float maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   float minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   float maxY=[[RahmenDic objectForKey:@"maxy"]floatValue];
   float minY=[[RahmenDic objectForKey:@"miny"]floatValue];
  // NSLog(@"maxX: %2.2f minX: %2.2f * maxY: %2.2f minY: %2.2f",maxX,minX,maxY,minY);
   [AbmessungX setIntValue:maxX - minX];
   [AbmessungY setIntValue:maxY - minY];
   
   float abbranda = [AbbrandFeld floatValue];
   float abbrandb = [AbbrandFeld floatValue]/[ProfilTiefeFeldB floatValue]*[ProfilTiefeFeldA floatValue]; // groesser bei groesserem Unterschied
   int von = 0;
   int bis = [KoordinatenTabelle  count];
   
   if ([AbbrandCheckbox state])
   {
      KoordinatenTabelle = [CNC addAbbrandVonKoordinaten:KoordinatenTabelle mitAbbrandA:abbranda  mitAbbrandB:abbrandb aufSeite:1 von:von bis:bis];
   }

   
   NSMutableDictionary* StartwertDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ax"] forKey:@"startx"];
	[StartwertDic setObject:[[KoordinatenTabelle lastObject]objectForKey:@"ay"] forKey:@"starty"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"eingabedaten" object:self userInfo:StartwertDic];
   
   //NSLog(@"KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
   [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
   [CNCTable reloadData];
   


}


- (NSDictionary*)RahmenDic
{
   NSMutableDictionary* RahmenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   // Einlauf:
   float einlaufAX;
   float einlaufAY;
   float einlaufBX;
   float einlaufBY;
   // Auslauf:
   float auslaufAX;
   float auslaufAY;
   float auslaufBX;
   float auslaufBY;
   
   float maxx=0,minx=MAXFLOAT; // Startwerte fuer Suche nach Rand
   float maxy=0,miny=MAXFLOAT;
   
   if ([KoordinatenTabelle count])
   {
      einlaufAX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ax"]floatValue];
      einlaufAY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ay"]floatValue];
      einlaufBX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"bx"]floatValue];
      einlaufBY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"by"]floatValue];
      
      auslaufAX = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      auslaufAY = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      auslaufBX = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      auslaufBY = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      int i;
      for (i=0;i<[KoordinatenTabelle count]; i++)
      {
         // y-werte
         // max y von Seite a und b
         float tempy = fmax([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
         if (tempy > maxy)
         {
            maxy = tempy;
         }
         
         // min y von Seite a und b
         tempy = fmin([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
         if (tempy < miny)
         {
            miny = tempy;
         }
         
         // x-werte
         float tempx = fmax([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"bx"]floatValue]);
         if (tempx > maxx)
         {
            maxx = tempx;
         }
         tempx = fmin([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"bx"]floatValue]);
         if (tempx < minx)
         {
            minx = tempx;
         }
      }
      //NSLog(@"Rahmen minx: %2.2f maxx: %2.2f * miny: %2.2f maxy: %2.2f",minx, maxx, miny, maxy);
      
      /*
      maxy -=einlaufAY;
      miny -= einlaufAY;
      maxx -=einlaufAY;
      minx -= einlaufAY;
      */
      
      //NSLog(@"Rahmen maxy: %2.2f miny: %2.2f",maxy,miny);
      [RahmenDic setObject:[NSNumber numberWithFloat:einlaufAX] forKey:@"einlaufax"];
      [RahmenDic setObject:[NSNumber numberWithFloat:einlaufAY] forKey:@"einlaufay"];
      [RahmenDic setObject:[NSNumber numberWithFloat:einlaufBX] forKey:@"einlaufbx"];
      [RahmenDic setObject:[NSNumber numberWithFloat:einlaufBY] forKey:@"einlaufby"];
      [RahmenDic setObject:[NSNumber numberWithFloat:auslaufAX] forKey:@"auslaufax"];
      [RahmenDic setObject:[NSNumber numberWithFloat:auslaufAY] forKey:@"auslaufay"];
      [RahmenDic setObject:[NSNumber numberWithFloat:auslaufBX] forKey:@"auslaufbx"];
      [RahmenDic setObject:[NSNumber numberWithFloat:auslaufBY] forKey:@"auslaufby"];
      [RahmenDic setObject:[NSNumber numberWithFloat:maxx] forKey:@"maxx"];
      [RahmenDic setObject:[NSNumber numberWithFloat:minx] forKey:@"minx"];
      [RahmenDic setObject:[NSNumber numberWithFloat:maxy] forKey:@"maxy"];
      [RahmenDic setObject:[NSNumber numberWithFloat:miny] forKey:@"miny"];
   }
   
   return RahmenDic;
}

- (void)Blockeinfuegen
{
   
   // Einlauf:
   float einlaufAX;
   float einlaufAY;
   float einlaufBX;
   float einlaufBY;
   // Auslauf:
   float auslaufAX;
   float auslaufAY;
   float auslaufBX;
   float auslaufBY;
   
   float maxy=0,miny=MAXFLOAT;

   if ([KoordinatenTabelle count])
   {
      einlaufAX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ax"]floatValue];
      einlaufAY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ay"]floatValue];
      einlaufBX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"bx"]floatValue];
      einlaufBY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"by"]floatValue];
     
      auslaufAX = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      auslaufAY = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      auslaufBX = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      auslaufBY = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      int i;
      for (i=0;i<[KoordinatenTabelle count]; i++)
      {
         
            float tempy = fmax([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
            if (tempy > maxy)
            {
               maxy = tempy;
            }
         tempy = fmin([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
         if (tempy < miny)
         {
            miny = tempy;
         }
      }
      NSLog(@"Blockeinfuegen maxy: %2.2f miny: %2.2f",maxy,miny);
      maxy -=einlaufAY;
      miny -= einlaufAY;
      NSLog(@"Blockeinfuegen maxy: %2.2f miny: %2.2f",maxy,miny);

      
   }
   
 

}

- (IBAction)reportOberkanteAnfahren:(id)sender
{
   NSLog(@"reportOberkanteAnfahren");
   // von 32
   [CNC_Lefttaste setEnabled:YES];
   [AnschlagLinksIndikator setTransparent:YES];
   
   [CNC_Downtaste setEnabled:YES];
   [CNC_Halttaste setEnabled:YES];
   [AnschlagUntenIndikator setTransparent:YES];
   // anscheinend OK
   // end von 32
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSDictionary* tempDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:OBERKANTEANFAHREN] forKey:@"usb"];
	[nc postNotificationName:@"usbopen" object:self userInfo:tempDic];
   int lastSpeed = [CNC speed];
   [CNC setSpeed:14];
   [CNC setredpwm:[red_pwmFeld floatValue]];
   
   float plattendicke = 50;
   
   float breite = [Blockbreite floatValue];
   float rand=[Einlaufrand floatValue];
   
   float dicke=[Blockdicke floatValue];
   float blockoberkante = [Blockoberkante floatValue];
   NSMutableArray* AnfahrtArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   NSArray* tempLinienArray = [CNC LinieVonPunkt:NSMakePoint(0,0) mitLaenge:blockoberkante mitWinkel:90];
   
   // Startpunkt ist Home. Lage: 0: Einlauf 1: Auslauf
   NSPoint PositionA = NSMakePoint(0, 0);
   NSPoint PositionB = NSMakePoint(0, 0);
   int index=0;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // Hochfahren auf Blockoberkante
   PositionA.y += blockoberkante;
   PositionB.y += blockoberkante;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   /*   
    // Anfahren Rahmen 5 mm
    PositionA.x +=5;
    PositionB.x +=5;
    //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
    index++;
    [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
    */
   // von reportStopKnopf
   int i=0;
   int zoomfaktor=1.0;
   NSMutableArray* AnfahrtSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   for (i=0;i<[AnfahrtArray count]-1;i++)
	{
		// Seite A
		NSPoint tempStartPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      // Seite B
      NSPoint tempStartPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
		
		NSPoint tempEndPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      // Dic zusammenstellen
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[AnfahrtArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      
		[AnfahrtSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   } // for i
   //NSLog(@"AnfahrtSchnittdatenArray: %@",[AnfahrtSchnittdatenArray description]);
   // Schnittdaten an CNC schicken
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:AnfahrtSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
//   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
   
   [CNC setSpeed:lastSpeed];
   
}

- (IBAction)reportBlockkonfigurieren:(id)sender
{
   //NSLog(@"reportBlockkonfigurieren Seite: %d",[RechtsLinksRadio selectedSegment]);
   
   // Einlauf und Auslauf in gleicher funktion. Unterschieden durch Parameter 'Lage'.
   // Lage: 0: Einlauf 1: Auslauf
   
   float full_pwm = 1;
   float red_pwm = [red_pwmFeld floatValue];
   [CNC setredpwm:red_pwm];
   int aktuellepwm=[DC_PWM intValue];
   
   int lage=0;
   
   // Einlauf:
   float einlaufAX;
   float einlaufAY;
   float einlaufBX;
   float einlaufBY;
   // Auslauf:
   float auslaufAX;
   float auslaufAY;
   float auslaufBX;
   float auslaufBY;
   float zugabeoben=3 + [AbbrandFeld intValue];
   float zugabeunten=10;
   
   float einstichx = 6;
   float einstichy = 4;
   float plattendicke = 50;

   
   float maxx=0,minx=MAXFLOAT; // Startwerte fuer Suche nach Rand
   float maxy=0,miny=MAXFLOAT;
   
   if ([KoordinatenTabelle count])
   {
      // Beginn der Schnittlinie des Profils incl. Einlauf
      einlaufAX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ax"]floatValue];
      einlaufAY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ay"]floatValue];
      einlaufBX = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"bx"]floatValue];
      einlaufBY = [[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"by"]floatValue];
      //NSLog(@"reportBlockkonfigurieren einlaufAX: %2.2f einlaufBX: %2.2f",einlaufAX,einlaufBX);
      //NSLog(@"reportBlockkonfigurieren einlaufAY: %2.2f einlaufBY: %2.2f",einlaufAY,einlaufBY);
      
      // Ende der Schnittlinie des Profils incl. Auslauf
      auslaufAX = [[[KoordinatenTabelle lastObject]objectForKey:@"ax"]floatValue];
      auslaufAY = [[[KoordinatenTabelle lastObject]objectForKey:@"ay"]floatValue];
      auslaufBX = [[[KoordinatenTabelle lastObject]objectForKey:@"bx"]floatValue];
      auslaufBY = [[[KoordinatenTabelle lastObject]objectForKey:@"by"]floatValue];
      int i;
      for (i=0;i<[KoordinatenTabelle count]; i++)
      {
         // y-werte
         // max y von Seite a und b
         float tempy = fmax([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
         if (tempy > maxy)
         {
            maxy = tempy;
         }
         
         // min y von Seite a und b
         tempy = fmin([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"by"]floatValue]);
         if (tempy < miny)
         {
            miny = tempy;
         }
         
         // x-werte
         float tempx = fmax([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"bx"]floatValue]);
         if (tempx > maxx)
         {
            maxx = tempx;
         }
         tempx = fmin([[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue],[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"bx"]floatValue]);
         if (tempx < minx)
         {
            minx = tempx;
         }
         
         
         
      }
      
      float ausmassx = maxx-minx;
      float ausmassy = maxy-miny;
      //NSLog(@"reportBlockkonfigurieren ausmassx: %2.2f ausmassy: %2.2f",ausmassx,ausmassy);
      
      //NSLog(@"reportBlockkonfigurieren maxy: %2.2f miny: %2.2f",maxy,miny);
      //NSLog(@"reportBlockkonfigurieren maxx: %2.2f minx: %2.2f",maxx,minx);
      
      //      maxy -= fmax(einlaufAY,einlaufBY);       // Abstand von Einlauf bis oberster Punkt 
      float abstandoben = maxy - fmax(einlaufAY,einlaufBY);       // Abstand von Einlauf bis oberster Punkt 
      
      //      miny -= fmax(einlaufAY,einlaufBY);      // Abstand von Einlauf bis unterster Punkt
      float abstandunten = fmax(einlaufAY,einlaufBY) - miny;       // Abstand von Einlauf bis oberster Punkt 
      
      //NSLog(@"reportBlockkonfigurieren maxy: %2.2f miny: %2.2f",maxy,miny);
      
      
      float breite = [Blockbreite floatValue];
      float rand=[Einlaufrand floatValue];
      
      float dicke=[Blockdicke floatValue];
      
      float blockoberkante = [Blockoberkante floatValue];
      //blockoberkante = plattendicke-5;
      
      if ((maxy + fabs(miny))>dicke) 
      {
      }
      
      // Rahmen
      
      if (mitOberseite && mitUnterseite) // kein ein/auslauf
      {
         dicke = (abstandoben+abstandunten)+zugabeoben +zugabeoben;
         rand = 5;
      }
      else
      {
         dicke = (abstandoben+abstandunten)+zugabeoben +zugabeunten; // (maxy-miny) ist Dicke ohne zugaben
      }
      
      NSLog(@"reportBlockkonfigurieren dicke: %2.2f",dicke);
      [Blockoberkante setIntValue:dicke+zugabeoben];
      //[Blockoberkante setIntValue:plattendicke-5];
      
      [OberkantenStepper setIntValue:[Blockoberkante intValue]];
      
      [Blockdicke setIntValue:dicke];
      [Einlaufrand setIntValue:einlaufrand];
      [Auslaufrand setIntValue:auslaufrand];
      
      [Blockbreite setIntValue:maxx+einlaufrand - minx + auslaufrand];
      [AbmessungX setIntValue:[Blockbreite intValue] + einstichx];
      //      NSPoint EckeRechtsOben = NSMakePoint(maxx+rand,fmax(einlaufAY,einlaufBY)+ maxy + zugabeoben);
      //      NSLog(@"reportBlockkonfigurieren EckeRechtsOben x: %2.2f  y: %2.2f",EckeRechtsOben.x,EckeRechtsOben.y);
      
      //      NSPoint EckeLinksOben = NSMakePoint(minx -rand, EckeRechtsOben.y);
      //NSPoint EckeLinksUnten = NSMakePoint(EckeLinksOben.x, EckeRechtsOben.y- dicke);
      //NSPoint EckeRechtsUnten = NSMakePoint(EckeRechtsOben.x, EckeLinksUnten.y);
      
      // neue Berechnung
      
      
      NSPoint EckeLinksUnten = NSMakePoint(einlaufAX -rand, fmax(einlaufAY,einlaufBY) - abstandunten  -zugabeunten);
      NSPoint EckeLinksOben = NSMakePoint(EckeLinksUnten.x, EckeLinksUnten.y + dicke);
      
      NSPoint EckeRechtsOben = NSMakePoint(EckeLinksOben.x + ausmassx + einlaufrand + auslaufrand, EckeLinksOben.y);
      NSPoint EckeRechtsUnten = NSMakePoint(EckeRechtsOben.x, EckeLinksUnten.y);   
      
      //NSLog(@"reportBlockkonfigurieren EckeRechtsOben x: %2.2f  y: %2.2f",EckeRechtsOben.x,EckeRechtsOben.y);
      
      BlockrahmenArray = [NSMutableArray arrayWithObjects:NSStringFromPoint(EckeLinksOben),NSStringFromPoint(EckeRechtsOben),NSStringFromPoint(EckeRechtsUnten),NSStringFromPoint(EckeLinksUnten), nil];
      
      
      //NSLog(@"reportBlockkonfigurieren RahmenArray: %@",[BlockrahmenArray description]);
      
      [ProfilGraph setRahmenArray:BlockrahmenArray];
      [ProfilGraph setNeedsDisplay:YES];
      
      // Start Konfig Schnittlinie
      /*
       // Startpunkt ist EckeLinksOben. Lage: 0: Einlauf 1: Auslauf
       NSPoint PositionA = EckeLinksOben;
       NSPoint PositionB = EckeLinksOben;
       */
      // Startpunkt ist EckeLinksUnten. Lage: 0: Einlauf 1: Auslauf
      NSPoint PositionA = EckeLinksUnten;
      NSPoint PositionB = EckeLinksUnten;
      
      
      // Start des Schnittes ist um einstichx, einstichy verschoben. Start vorerst dorthin verlegen
      
  //    einstichy = plattendicke - dicke;
      einstichy = self.Kote;
      
      PositionA.x -=einstichx;
      PositionB.x -=einstichx;
      
      PositionA.y -=einstichy;
      PositionB.y -=einstichy;
      
      int index=0;
      
      
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      
      
      index++;
      
      // Hochfahren auf Kote
      PositionA.y +=einstichy;
      PositionB.y +=einstichy;
      
      //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;
      
      
      
      
      // Einstich  zum Blockrand
      PositionA.x +=einstichx;       
      PositionB.x +=einstichx;
      //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;

      
     
      /*    
       // Blockrand senkrecht nach unten schneiden
       PositionA.y -=dicke;
       PositionB.y -=dicke;
       //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
       [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithInt:aktuellepwm*full_pwm],@"pwm",nil]];
       index++;
       
       
       // weg vom Blockrand 2mm      
       PositionA.x -=2;
       PositionB.x -=2;
       //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
       [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithInt:aktuellepwm*full_pwm],@"pwm",nil]];
       index++;
       */
      
      
      // Anfahrt von unten: Zuerst schneiden senkrecht noch oben bis Blockrand
      
      // Hochfahren auf Einlauf. Liegt auf gleicher Hoehe, wenn kein wrench
      //float deltaAY = zugabeunten - miny; 
      //float deltaBY = zugabeunten - miny;
      
      float deltaAY = einlaufAY - EckeLinksUnten.y;
      float deltaBY = einlaufBY - EckeLinksUnten.y;
      
      
      
      PositionA.y +=deltaAY;
      PositionB.y +=deltaBY;
      //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;
      
      /*
       // Rand bei Einlauf schneiden
       PositionA.x -=rand;
       PositionB.x -=rand;
       NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
       [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
       index++;
       */     
      // Schneiden zum Einlauf. Kann in x und y unterschiedlich sein.
      //     NSLog(@"reportBlockkonfigurieren vor Schneiden zum Einlauf EckeRechtsOben x: %2.2f  y: %2.2f",EckeRechtsOben.x,EckeRechtsOben.y);
      //NSLog(@"vor index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      
      float deltaAX = einlaufAX - PositionA.x;
      deltaAY = einlaufAY - PositionA.y;
      
      PositionA.x +=deltaAX;
      PositionA.y +=deltaAY;
      
      
      float deltaBX =   einlaufBX - PositionB.x;
      deltaBY =  einlaufBY - PositionB.y;
      
      PositionB.x +=deltaBX;
      PositionB.y +=deltaBY;
      
      
      //NSLog(@"nach index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;
      //NSLog(@"BlockKoordinatenTabelle Einlauf: %@",[BlockKoordinatenTabelle description]);
      //NSLog(@"reportBlockkonfigurieren nach Schneiden zum Einlauf EckeRechtsOben x: %2.2f  y: %2.2f",EckeRechtsOben.x,EckeRechtsOben.y);
      
      
      // Nach Profil und ev. Ausstich:
      
      // Auslauf
      lage=1;
      
      //Letzte Position
      PositionA = NSMakePoint(auslaufAX, auslaufAY);
      PositionB = NSMakePoint(auslaufBX, auslaufBY);
      //NSLog(@"Auslauf start index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      
      // Distanz ist unterschiedlich
      
      //Schneiden an Blockrand rechts Eventuell Strom red
      
      PositionA.x = EckeRechtsOben.x;
      PositionB.x = EckeRechtsOben.x;
      //NSLog(@"Auslauf Rand rechts index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
      
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*red_pwm],@"pwm",nil]];
      index++;
      
      /*
       //Schneiden an Blockoberkante rechts
       
       PositionA.y = EckeRechtsOben.y;
       PositionB.y = EckeRechtsOben.y;
       
       [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithInt:aktuellepwm*full_pwm],@"pwm",nil]];
       index++;
       */
      //Schneiden an Blockunterkante rechts
      
      PositionA.y = EckeRechtsUnten.y;// - einstichy + 3;
      PositionB.y = EckeRechtsUnten.y;// - einstichy + 3;
      
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;
      
      //Schneiden an Blockunterkante links - einstichy
      
      PositionA.x = EckeLinksUnten.x - 4;//-einstichx+1; // Nicht bis Anschlag fahren
      PositionB.x = EckeLinksUnten.x - 4;//-einstichx+1;
      
      [BlockKoordinatenTabelle addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:lage],@"lage",[NSNumber numberWithFloat:aktuellepwm*full_pwm],@"pwm",nil]];
      index++;
      
   } // if count
   else
   {
      return;
   }
}

- (IBAction)reportBlockanfuegen:(id)sender
{
   //NSLog(@"reportBlockanfuegen ");
   [self reportBlockkonfigurieren:NULL];
   if ([KoordinatenTabelle count])
   {
      if ([BlockKoordinatenTabelle count])
      {
         int i=0;
         [KoordinatenTabelle removeObjectAtIndex:0];
         for(i=0;i<[BlockKoordinatenTabelle count];i++)
         {
               if ([[[BlockKoordinatenTabelle objectAtIndex:i]objectForKey:@"lage"]intValue]) // Auslauf
               {
                  [KoordinatenTabelle addObject:[BlockKoordinatenTabelle objectAtIndex:i] ];
               }
            else // Einlauf
            {
               [KoordinatenTabelle insertObject:[BlockKoordinatenTabelle objectAtIndex:i] atIndex:i];
            }
            
         }
      }
      
      //- (NSArray*)addAbbrandVonKoordinaten:(NSArray*)Koordinatentabelle mitAbbrandA:(float)abbrand aufSeite:(int)seite

//      KoordinatenTabelle = [CNC addAbbrandVonKoordinaten:KoordinatenTabelle mitAbbrandA:10 aufSeite:0];
      
      
      [self updateIndex];
      
      [CNCTable scrollRowToVisible:[KoordinatenTabelle count] - 1];
      [CNCTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[KoordinatenTabelle count]-1] byExtendingSelection:NO];
      [CNCTable reloadData];
      [ProfilGraph setDatenArray:KoordinatenTabelle];
      [ProfilGraph setNeedsDisplay:YES];

   //NSLog(@"reportBlockanfuegen KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   }
   
}



- (IBAction)reportKotenstepper:(id)sender
{
   [Blockoberkante setIntValue:[sender intValue]];
}

- (NSString *)inputNameMitTitel: (NSString *)prompt information:(NSString *)info defaultValue: (NSString *)defaultValue 
{
   NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                    defaultButton:@"OK"
                                  alternateButton:@"Cancel"
                                      otherButton:nil
                        informativeTextWithFormat:info];
   
   NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0,0,200,24)];
   [input setStringValue:defaultValue];
   [alert setAccessoryView:input];
   //[alert addButtonWithTitle:@"ax"];
   NSInteger button = [alert runModal];
   if (button == NSAlertDefaultReturn) 
   {
      [input validateEditing];
      return [input stringValue];
   } 
   else if (button == NSAlertAlternateReturn) 
   {
      [input release];
      return nil;
   } 
   else 
   {
      NSAssert1(NO, @"Invalid input dialog button %d", button);
      return nil;
   }
   [input release];
}


- (IBAction)reportElementSichern:(id)sender
{
   //NSLog(@"reportElementSichern");
   //NSLog(@"reportElementSichern KoordinatenTabelle: %@",[KoordinatenTabelle description]);
   float startx=[[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ax"]floatValue];
   float starty=[[[KoordinatenTabelle objectAtIndex:0]objectForKey:@"ay"]floatValue];
   NSDictionary* startDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0],@"ax",[NSNumber numberWithFloat:0],@"ay",[NSNumber numberWithInt:0],@"index", nil];

   int i=0;
   NSMutableArray* ElementArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   [ElementArray addObject:startDic];
   for (i= 1;i<[KoordinatenTabelle count];i++)
   {
      float tempx=[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ax"]floatValue];
      tempx -= startx;
      float tempy=[[[KoordinatenTabelle objectAtIndex:i]objectForKey:@"ay"]floatValue];
      tempy -= starty;
      NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempx],@"x",[NSNumber numberWithFloat:tempy],@"y",[NSNumber numberWithInt:i],@"index", nil];
      [ElementArray addObject:tempDic];

   }
   
   NSString* neuerName=[self inputNameMitTitel:@"Neues Element" information:@"Name des neuen Elements:" defaultValue:@"Element"];
   //NSLog(@"reportElementSichern ElementArray: %@",[ElementArray description]);
   
   NSDictionary* neuesElementDic = [NSDictionary dictionaryWithObjectsAndKeys:ElementArray,@"elementarray",neuerName,@"name", nil];
   
   int erfolg=0;
   NSLog(@"ElementSichern");
   BOOL LibOK=NO;
   BOOL istOrdner;
   NSError* error=0;
   NSFileManager *Filemanager = [NSFileManager defaultManager];
   NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
   NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
   LibOK= ([Filemanager fileExistsAtPath:LibPfad isDirectory:&istOrdner]&&istOrdner);
   NSLog(@"ElementSichern:    LibPfad: %@ LibOK: %d",LibPfad, LibOK );	
   if (LibOK)
   {
      ;
   }
   else
   {
      BOOL OrdnerOK=[Filemanager createDirectoryAtURL:LibURL  withIntermediateDirectories:NO  attributes:NULL error:&error];
      //Datenordner ist noch leer
      
      
   }
   NSString* ElementPfad;
   NSString* ElementName = @"Element.plist";
   
   //NSLog(@"\n\n");
   ElementPfad=[LibPfad stringByAppendingPathComponent:ElementName];
   NSURL* ElementURL = [NSURL fileURLWithPath:ElementPfad];
   //	NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
   //NSMutableDictionary* saveElementDic = nil;
   NSMutableArray* saveElementArray=nil;
   if ([Filemanager fileExistsAtPath:ElementPfad])
   {
      //saveElementDic=[NSMutableDictionary dictionaryWithContentsOfFile:ElementPfad];
      saveElementArray=[NSMutableArray arrayWithContentsOfFile:ElementPfad];
      //NSLog(@"saveElement: vorhandener ElementDic: %@",[ElementArray description]);
   }
   else
   {
      //saveElementDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
       saveElementArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   }
   //[saveElementDic setObject:@"A" forKey:@"Name"];
   if ([saveElementArray count])
   {
      NSArray* ElementnamenArray = [saveElementArray valueForKey:@"name"];
      //NSLog(@"ElementnamenArray %@",[ElementnamenArray  description]);
      int dupindex=[ElementnamenArray indexOfObject:neuerName];
      NSLog(@"dupindex: %d",dupindex);
     if (dupindex<NSNotFound)
     {
        NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
        [Warnung addButtonWithTitle:@"Ersetzen"];
        //[Warnung addButtonWithTitle:@""];
        //[Warnung addButtonWithTitle:@""];
        [Warnung addButtonWithTitle:@"Neu eingeben"];
        [Warnung setMessageText:[NSString stringWithFormat:@"Der Name %@ ist schon vorhanden.",neuerName]];
        
        NSString* s1=@"";
        NSString* s2=@"";
        NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
        [Warnung setInformativeText:InformationString];
        [Warnung setAlertStyle:NSWarningAlertStyle];
        
        int antwort=[Warnung runModal];
        switch (antwort)
        {
           case NSAlertFirstButtonReturn://
           { 
              NSLog(@"NSAlertFirstButtonReturn");// ersetzen
              
              [saveElementArray replaceObjectAtIndex:dupindex withObject:neuesElementDic];
              [NSApp stopModalWithCode:0];
              
              /*
              NSError* error=0;
              NSString* LibPfad=[NSHomeDirectory() stringByAppendingFormat:@"%@%@%@",@"/Documents",@"/CNCDaten",@"/ElementLib"];
              LibPfad = [LibPfad stringByAppendingPathComponent:@"Element.plist"];
              NSURL* LibURL=[NSURL fileURLWithPath:LibPfad];
              NSLog(@"LibElementsichern LibURL vor: %@",LibURL);
              if ([Filemanager fileExistsAtPath:LibPfad])
              {
                 NSInteger clearOK=[Filemanager removeItemAtURL:LibURL error:&error];
                 NSLog(@"Elementloeschen clearOK: %d",clearOK);
              }
              int saveOK=[saveElementArray writeToURL:LibURL atomically:YES];
              NSLog(@"Elementsichern saveOK: %d",saveOK);
               */
              //[[self window] orderOut:NULL];
              //[self reportElementSichern:NULL];
           }break;
              
           case NSAlertSecondButtonReturn://
           {
              NSLog(@"NSAlertSecondButtonReturn"); // neu eingeben
              [self reportElementSichern:NULL];
              return;
           }break;
           case NSAlertThirdButtonReturn://		
           {
              NSLog(@"NSAlertThirdButtonReturn");
              
           }break;
              
        }//switch
        
     }
      else
      {
         NSLog(@"neues Element sichern");
         [saveElementArray addObject:neuesElementDic];
         //int i=[CNC_Eingabe SetLibElemente:[saveElementArray valueForKey:@"name"]];
         
      }
      
   }
   
   
   if ([Filemanager fileExistsAtPath:ElementPfad])
   {
      NSInteger clearOK=[Filemanager removeItemAtURL:ElementURL error:&error];
      NSLog(@"ElementLib ersetzen clearOK: %d",clearOK);
   }

   
	int saveOK=[saveElementArray writeToURL:ElementURL atomically:YES];
   NSLog(@"saveElement saveOK: %d",saveOK);

}

- (NSArray*)KoordinatenTabelle
{
   return KoordinatenTabelle;
}


- (IBAction)reportNeuTaste:(id)sender
{
   NSLog(@"reportNeuTaste");
  // NSLog(@"reportNeuTaste KoordinatenTabelle count: %lu",[KoordinatenTabelle count]);
  // NSLog(@"reportNeuTaste KoordinatenTabelle vor: %@",[KoordinatenTabelle description]);
	[CNC_Preparetaste setEnabled:YES];
   [CNC_Halttaste setState:0];
   [CNC_Halttaste setEnabled:NO];
	[CNC_Sendtaste setEnabled:NO];
	[CNC_Starttaste setEnabled:YES];
   [CNC_Stoptaste setEnabled:NO];
   [NeuesElementTaste setEnabled:NO];

   [PositionFeld setIntValue:0];
   [PositionFeld setStringValue:@""];
   
   [[StartKoordinate cellAtIndex:0]setStringValue:@""];
   [[StartKoordinate cellAtIndex:1]setStringValue:@""];

   
	//[CNC_Starttaste setEnabled:NO];
	[CNC_Terminatetaste setEnabled:NO];
   [HomeTaste setState:0];
   [DC_Taste setState:0];
    
	[KoordinatenTabelle removeAllObjects];
   if (BlockrahmenArray&&[BlockrahmenArray count])
   {
      [BlockrahmenArray removeAllObjects];
      [ProfilGraph setRahmenArray:BlockrahmenArray];
   }
   [BlockKoordinatenTabelle removeAllObjects];
	[CNCDatenArray removeAllObjects];
	[SchnittdatenArray removeAllObjects];

	[CNCTable reloadData];
	cncposition =0;
	[CNCPositionFeld setIntValue:0];
	[CNCStepXFeld setIntValue:0];
	[CNCStepYFeld setIntValue:0];
   [ProfilGraph setStepperposition:-1];
	[ProfilGraph setDatenArray:KoordinatenTabelle];
	
   [ProfilGraph setNeedsDisplay:YES];
	
   [WertAXFeld setStringValue:@""];
   [WertAYFeld setStringValue:@""];
   
   [WertAYStepper setFloatValue:0.0];
	[WertAYStepper setFloatValue:0.0];

   [WertBXFeld setStringValue:@""];
   [WertBYFeld setStringValue:@""];
   
   [WertBYStepper setFloatValue:0.0];
	[WertBYStepper setFloatValue:0.0];

   [IndexStepper setIntValue:0];
  
   [RechtsLinksRadio setSelectedSegment:0];
   
   // von 32
   [AnschlagLinksIndikator setTransparent:YES];
   [AnschlagUntenIndikator setTransparent:YES];
   [CNC_Righttaste setEnabled:YES];
   [CNC_Lefttaste setEnabled:YES];
   [CNC_Uptaste setEnabled:YES];
   [CNC_Downtaste setEnabled:YES];
   [self setBusy:0];
   // anscheinend OK
   //end von 32
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"slavereset" object:self userInfo:NULL];
//   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSDictionary* tempDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:NEUTASTE] forKey:@"usb"];
	[nc postNotificationName:@"usbopen" object:self userInfo:tempDic];

   //[self setStepperstrom:0];

}

- (IBAction)reportHaltTaste:(id)sender
{
	NSLog(@"AVR  reportHaltTaste");
	[CNC_Preparetaste setEnabled:![sender state]];
	[CNC_Starttaste setEnabled:[sender state]];
	[CNC_Stoptaste setEnabled:![sender state]];
	[CNC_Sendtaste setEnabled:![sender state]];
	[CNC_Terminatetaste setEnabled:![sender state]];
	[DC_Taste setState:0];
   [self setBusy:0];
   [PositionFeld setIntValue:0];
   [PositionFeld setStringValue:@""];
   
   
   //NSMutableDictionary* haltInfoDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	//[haltInfoDic setObject:[NSNumber numberWithInt:[CNC_Halttaste state]] forKey:@"halt"];
   NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:[CNC_Halttaste state]] forKey:@"halt"];
	[NotificationDic setObject:[NSNumber numberWithInt:0] forKey:@"push"];
   
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	
   [nc postNotificationName:@"Halt" object:self userInfo:NotificationDic];
   [self setStepperstrom:0];

}

- (IBAction)reportResetTaste:(id)sender
{
   
}

- (IBAction)reportShiftLeft:(id)sender
{
   //NSLog(@"AVR shiftLeft");
   int i=0;
   float schritt=5;
   [self shiftX:-5 Y:0 Schritt:0];
   
   return;

   if ([KoordinatenTabelle count])
   {
      for(i=0;i<[KoordinatenTabelle count];i++)
      {
         float tempax=0;
         float tempay=0;
         float tempbx=0;
         float tempby=0;
         NSDictionary* tempZeilenDic = [KoordinatenTabelle objectAtIndex:i];
         tempax = [[tempZeilenDic objectForKey:@"ax"]floatValue];
         tempay = [[tempZeilenDic objectForKey:@"ay"]floatValue];
         tempbx = [[tempZeilenDic objectForKey:@"bx"]floatValue];
         tempby = [[tempZeilenDic objectForKey:@"by"]floatValue];
         int index = [[tempZeilenDic objectForKey:@"index"]intValue];
         tempax -= schritt;
         tempbx -= schritt;
         NSDictionary* newZeilenDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempax] ,@"ax",[NSNumber numberWithFloat:tempay] ,@"ay",[NSNumber numberWithFloat:tempbx] ,@"bx",[NSNumber numberWithFloat:tempby] ,@"by",[NSNumber numberWithInt:index] ,@"index", nil];
         [KoordinatenTabelle replaceObjectAtIndex:i  withObject:newZeilenDic];
      }
      
   }
   [ProfilGraph setDatenArray:KoordinatenTabelle];
	[ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
   [self setDatenVonZeile:[KoordinatenTabelle count]-1];
}

- (IBAction)reportShiftRight:(id)sender
{
   //NSLog(@"AVR shiftRight");
   int i=0;
   float schritt=5;
   [self shiftX:5 Y:0 Schritt:0];
}

- (IBAction)reportShiftUp:(id)sender
{
   //NSLog(@"AVR shiftUp");
   int i=0;
   float schritt=2;
   [self shiftX:0 Y:2 Schritt:0];
   
}

- (IBAction)reportShiftDown:(id)sender
{
   //NSLog(@"AVR shiftDown");
   int i=0;
   float schritt=2;
   [self shiftX:0 Y:-2 Schritt:0];
   
}

- (void)shiftX:(float)x Y:(float)y Schritt:(int)schritt
{
   NSMutableArray* RahmenArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];

   int i=0;
   if ([KoordinatenTabelle count])
   {
      for(i=0;i<[KoordinatenTabelle count];i++)
      {
         NSDictionary* tempZeilenDic = [KoordinatenTabelle objectAtIndex:i];
         float tempax = [[tempZeilenDic objectForKey:@"ax"]floatValue];
         float tempay = [[tempZeilenDic objectForKey:@"ay"]floatValue];
         float tempbx = [[tempZeilenDic objectForKey:@"bx"]floatValue];
         float tempby = [[tempZeilenDic objectForKey:@"by"]floatValue];

         
         int index = [[tempZeilenDic objectForKey:@"index"]intValue];
         
         tempax += x;
         tempay += y;
         tempbx += x;
         tempby += y;
         
         NSMutableDictionary* newZeilenDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempax] ,@"ax",[NSNumber numberWithFloat:tempay] ,@"ay",[NSNumber numberWithFloat:tempbx] ,@"bx",[NSNumber numberWithFloat:tempby] ,@"by",[NSNumber numberWithInt:index] ,@"index", nil];
         
         float tempabrax = 0;
         float tempabray = 0;
         float tempabrbx = 0;
         float tempabrby = 0;
         
         if ([tempZeilenDic objectForKey:@"abrax"]) // Es hat Daten fuer Abbrand
         {
            tempabrax = [[tempZeilenDic objectForKey:@"abrax"]floatValue]+x;
            tempabray = [[tempZeilenDic objectForKey:@"abray"]floatValue]+y;
            tempabrbx = [[tempZeilenDic objectForKey:@"abrbx"]floatValue]+x;
            tempabrby = [[tempZeilenDic objectForKey:@"abrby"]floatValue]+y;
            [newZeilenDic setObject:[NSNumber numberWithFloat:tempabrax] forKey:@"abrax"];
            [newZeilenDic setObject:[NSNumber numberWithFloat:tempabray] forKey:@"abray"];
            [newZeilenDic setObject:[NSNumber numberWithFloat:tempabrbx] forKey:@"abrbx"];
            [newZeilenDic setObject:[NSNumber numberWithFloat:tempabrby] forKey:@"abrby"];
         }
      
         
         [KoordinatenTabelle replaceObjectAtIndex:i  withObject:newZeilenDic];
      
      }
      
   }
   
   [ProfilGraph setDatenArray:KoordinatenTabelle];

   
   // Koordinatentabelle fuer Schnitt zum Startpunkt verschieben
   if ([BlockKoordinatenTabelle count])
   {
      //NSLog(@"shiftX start: %@",[BlockKoordinatenTabelle description]);
      for(i=0;i<[BlockKoordinatenTabelle count];i++)
      {
         NSDictionary* tempZeilenDic = [BlockKoordinatenTabelle objectAtIndex:i];
         //NSLog(@"i: %d tempZeilenDic: %@",i,[tempZeilenDic description]);
         float tempax = [[tempZeilenDic objectForKey:@"ax"]floatValue];
         float tempay = [[tempZeilenDic objectForKey:@"ay"]floatValue];
         float tempbx = [[tempZeilenDic objectForKey:@"bx"]floatValue];
         float tempby = [[tempZeilenDic objectForKey:@"by"]floatValue];
         int index = [[tempZeilenDic objectForKey:@"index"]intValue];
         int lage= [[tempZeilenDic objectForKey:@"lage"]intValue];
         tempax += x;
         tempay += y;
         tempbx += x;
         tempby += y;
         NSDictionary* newZeilenDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:tempax] ,@"ax",[NSNumber numberWithFloat:tempay] ,@"ay",[NSNumber numberWithFloat:tempbx] ,@"bx",[NSNumber numberWithFloat:tempby] ,@"by",[NSNumber numberWithInt:lage] ,@"lage",[NSNumber numberWithInt:index] ,@"index", nil];
         //NSLog(@"i: %d newZeilenDic: %@",i,[newZeilenDic description]);
         [BlockKoordinatenTabelle replaceObjectAtIndex:i  withObject:newZeilenDic];
        
      }
      
   }
   
   
   // Blockrahmen fuer Darstellung verschieben
   if (BlockrahmenArray && [BlockrahmenArray count])
   {
      //NSLog(@"shiftX start BlockrahmenArray: %@",[BlockrahmenArray description]);
      //NSPoint tempRahmenPoint= NSMakePoint(tempax,tempay);
      //[RahmenArray addObject:NSStringFromPoint(tempRahmenPoint)];
      for(i=0;i<[BlockrahmenArray count];i++)
      {
         NSPoint tempRahmenPoint=NSPointFromString([BlockrahmenArray objectAtIndex:i]);
         tempRahmenPoint.x += x;
         tempRahmenPoint.y += y;
         NSString* tempString=NSStringFromPoint(tempRahmenPoint);
         [BlockrahmenArray replaceObjectAtIndex:i  withObject:tempString];
      }
      [ProfilGraph setRahmenArray:BlockrahmenArray];
   }

   
   //NSLog(@"shiftX end: %@",[BlockKoordinatenTabelle description]);
	
   [ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];
   [self setDatenVonZeile:[KoordinatenTabelle count]-1];


}

- (IBAction)reportSeiteVertauschen:(id)sender
{
   if ([KoordinatenTabelle count]==0)
   {
      return;
   }
   int i=0;
   for (i=0;i<[KoordinatenTabelle count]; i++) 
   {
      NSMutableDictionary* tempZeilenDic = (NSMutableDictionary*)[KoordinatenTabelle objectAtIndex:i];
      NSLog(@"tempZeilenDic: %@",[tempZeilenDic description]);

      NSNumber* tempax=(NSNumber*)[tempZeilenDic objectForKey:@"ax"];
      NSNumber* tempay=(NSNumber*)[tempZeilenDic objectForKey:@"ay"];
      NSNumber* tempbx=(NSNumber*)[tempZeilenDic objectForKey:@"bx"];
      NSNumber* tempby=(NSNumber*)[tempZeilenDic objectForKey:@"by"];
      
 

      NSNumber* tempindex=(NSNumber*)[tempZeilenDic objectForKey:@"index"];
      NSMutableDictionary* neuerZeilenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      // keys vertauschen
      [neuerZeilenDic setObject:tempax forKey:@"bx"];
      [neuerZeilenDic setObject:tempay forKey:@"by"];
      [neuerZeilenDic setObject:tempbx forKey:@"ax"];
      [neuerZeilenDic setObject:tempby forKey:@"ay"];
      
      if ([tempZeilenDic objectForKey:@"abrax"])
      {
         NSNumber* tempabrax=(NSNumber*)[tempZeilenDic objectForKey:@"abrax"];
         NSNumber* tempabray=(NSNumber*)[tempZeilenDic objectForKey:@"abray"];
         NSNumber* tempabrbx=(NSNumber*)[tempZeilenDic objectForKey:@"abrbx"];
         NSNumber* tempabrby=(NSNumber*)[tempZeilenDic objectForKey:@"abrby"];
         // keys vertauschen
         [neuerZeilenDic setObject:tempabrax forKey:@"abrbx"];
         [neuerZeilenDic setObject:tempabray forKey:@"abrby"];
         [neuerZeilenDic setObject:tempabrbx forKey:@"abrax"];
         [neuerZeilenDic setObject:tempabrby forKey:@"abray"];
         
      }

      
      
      [neuerZeilenDic setObject:tempindex forKey:@"index"];
      NSLog(@"neuerZeilenDic: %@",[neuerZeilenDic description]);
      [KoordinatenTabelle replaceObjectAtIndex:i withObject:neuerZeilenDic];

   }
   [ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];

}

- (IBAction)reportLinkeRechteSeite:(id)sender
{
   //NSLog(@"AVR  reportLinkeRechteSeite %d",[sender selectedSegment]);
   if ([KoordinatenTabelle count]==0)
   {
      return;
   }
   int i=0;
   NSMutableArray* tempKoordinatenArray = [[[NSMutableArray alloc]initWithArray: KoordinatenTabelle]autorelease];
   
   //maximales x finden
   float maxX=0;
   float minX=MAXFLOAT;
   NSDictionary* RahmenDic = [self RahmenDic];
   maxX = [[RahmenDic objectForKey:@"maxx"]floatValue];
   minX = [[RahmenDic objectForKey:@"minx"]floatValue];
   
   //NSLog(@"maxX: %2.2f minX: %2.2f",maxX,minX);
   // x-Werte spiegeln und maxX addieren
   for (i=0;i< [tempKoordinatenArray count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[KoordinatenTabelle objectAtIndex:i]];
      if (i<5 || i> [tempKoordinatenArray count]-5)
      {
         
        // NSLog(@"tempZeilenDic vor: %@",[[tempKoordinatenArray objectAtIndex:i] description]);
      }
      
      float tempax=[[tempZeilenDic objectForKey:@"ax"]floatValue]-minX;
      tempax *= -1;
      tempax += maxX;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempax]forKey:@"ax"];
      
      float tempbx=[[tempZeilenDic objectForKey:@"bx"]floatValue]-minX;
      tempbx *= -1;
      tempbx += maxX;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempbx]forKey:@"bx"];
      
      // Abbrand
      if ([tempZeilenDic objectForKey:@"abrax"])
      {
         float tempax=[[tempZeilenDic objectForKey:@"abrax"]floatValue]-minX;
         tempax *= -1;
         tempax += maxX;
         [tempZeilenDic setObject:[NSNumber numberWithFloat:tempax]forKey:@"abrax"];
         
         float tempbx=[[tempZeilenDic objectForKey:@"abrbx"]floatValue]-minX;
         tempbx *= -1;
         tempbx += maxX;
         [tempZeilenDic setObject:[NSNumber numberWithFloat:tempbx]forKey:@"abrbx"];
         
         
      }
      
      [KoordinatenTabelle replaceObjectAtIndex:i withObject:tempZeilenDic];
      
      if (i<5 || i> [tempKoordinatenArray count]-5)
      {
         //NSLog(@"tempZeilenDic nach: %@",[tempZeilenDic  description]);
      }
   }

   /*
   for (i=0;i<[KoordinatenTabelle count]; i++) 
   {
      NSMutableDictionary* tempZeilenDic = (NSMutableDictionary*)[KoordinatenTabelle objectAtIndex:i];
      NSLog(@"tempZeilenDic: %@",[tempZeilenDic description]);
      NSNumber* tempax=(NSNumber*)[tempZeilenDic objectForKey:@"ax"];
      NSNumber* tempay=(NSNumber*)[tempZeilenDic objectForKey:@"ay"];
      NSNumber* tempbx=(NSNumber*)[tempZeilenDic objectForKey:@"bx"];
      NSNumber* tempby=(NSNumber*)[tempZeilenDic objectForKey:@"by"];
      NSNumber* tempindex=(NSNumber*)[tempZeilenDic objectForKey:@"index"];
      NSMutableDictionary* neuerZeilenDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   }
    */
   //NSLog(@"maxX: %2.2f",maxX);
   for (i=0;i<4;i++)
   {
      NSPoint tempEcke = NSPointFromString([BlockrahmenArray objectAtIndex:i]);
      float tempx = tempEcke.x-minX;
      tempx *= -1;
      tempx += maxX;
      NSString* newEckestring = NSStringFromPoint(NSMakePoint(tempx, tempEcke.y));
      [BlockrahmenArray replaceObjectAtIndex:i  withObject:newEckestring];
    }
   [ProfilGraph setRahmenArray:BlockrahmenArray];
   //NSLog(@"reportRechteSeiteLinkeSeite RahmenArray: %@",[BlockrahmenArray description]);
   
   [ProfilGraph setNeedsDisplay:YES];
	[CNCTable reloadData];

}

- (IBAction)reportLinkeRechteSeiteOffset:(id)sender;
{
   NSLog(@"reportLinkeRechteSeiteOffset");
   // von 32
   [CNC_Lefttaste setEnabled:YES];
   [AnschlagLinksIndikator setTransparent:YES];
   
   [CNC_Downtaste setEnabled:YES];
   [AnschlagUntenIndikator setTransparent:YES];
   // anscheinend OK
   // end von 32
   
   float offset = [AbmessungX intValue];
   NSMutableArray* OffsetArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
//   NSArray* tempLinienArray = [CNC LinieVonPunkt:NSMakePoint(0,0) mitLaenge:blockoberkante mitWinkel:90];
   
   // Startpunkt ist Home. Lage: 0: Einlauf 1: Auslauf
   NSPoint PositionA = NSMakePoint(0, 0);
   NSPoint PositionB = NSMakePoint(0, 0);
   int index=0;
   [OffsetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // Verschieben um Blockbreite + Einstichx auf Blockoberkante
   PositionA.x += offset;
   PositionB.x += offset;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [OffsetArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   /*   
    // Anfahren Rahmen 5 mm
    PositionA.x +=5;
    PositionB.x +=5;
    //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
    index++;
    [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
    */
   // von reportStopKnopf
   int i=0;
   int zoomfaktor=1.0;
   NSMutableArray* OffsetSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   for (i=0;i<[OffsetArray count]-1;i++)
	{
		// Seite A
		NSPoint tempStartPunktA= NSMakePoint([[[OffsetArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[OffsetArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunktA= NSMakePoint([[[OffsetArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[OffsetArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      // Seite B
      NSPoint tempStartPunktB= NSMakePoint([[[OffsetArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[OffsetArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
		
		NSPoint tempEndPunktB= NSMakePoint([[[OffsetArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[OffsetArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      // Dic zusammenstellen
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[OffsetArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      
		[OffsetSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   } // for i
   NSLog(@"OffsetSchnittdatenArray: %@",[OffsetSchnittdatenArray description]);
   // Schnittdaten an CNC schicken
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:OffsetSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
   
   
   
}

- (IBAction)reportAndereSeiteAnfahren:(id)sender
{
   NSDictionary* tempDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:ANDERESEITEANFAHREN] forKey:@"usb"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbopen" object:self userInfo:tempDic];

   float full_pwm = 1;
   float red_pwm = [red_pwmFeld floatValue];
   [CNC setredpwm:red_pwm];
   int aktuellepwm=[DC_PWM intValue];
   int lastSpeed = [CNC speed];
   int nowpwm =0;
   if ([DC_Taste state])
   {
      nowpwm = [DC_PWM intValue]; // Standardwert wenn nichts anderes angegeben
   }
   else 
   {
      [CNC setSpeed:14]; // Schnellgang ohne Schnitt

   }
   
   int lage=0;
   int einstichx = 4;
   int einstichy = 4;
   
   
   NSLog(@"reportOberkanteAnfahren");
   // von 32
   [CNC_Halttaste setEnabled:YES];
   [CNC_Lefttaste setEnabled:YES];
   [AnschlagLinksIndikator setTransparent:YES];
   
   [CNC_Downtaste setEnabled:YES];
   [AnschlagUntenIndikator setTransparent:YES];
   // anscheinend OK
   // end von 32
   int blockbreite = [Blockbreite intValue];
   int blockhoehe = [Blockdicke intValue];
   
   
   NSLog(@"reportAndereSeiteAnfahren blockhoehe: %d blockbreite: %d nowpwm: %d",blockhoehe,blockbreite,nowpwm);
   
   NSMutableArray* AnfahrtArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   // Startpunkt ist Home. Lage: 0: Einlauf 1: Auslauf
   NSPoint PositionA = NSMakePoint(0, 0);
   NSPoint PositionB = NSMakePoint(0, 0);
   int index=0;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // Hochfahren auf Blockoberkante
   PositionA.y += blockhoehe + einstichy;
   PositionB.y += blockhoehe + einstichy;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",[NSNumber numberWithInt:full_pwm],@"pwm",nil]];
   
   // Fahren Blockbreite
   PositionA.x += blockbreite + 3*einstichx;
   PositionB.x += blockbreite + 3*einstichx;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // Fahren auf Blockunterkante
   PositionA.y -= blockhoehe + einstichy;
   PositionB.y -= blockhoehe + einstichy;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // von reportStopKnopf
   int i=0;
   int zoomfaktor=1.0;
   NSMutableArray* AnfahrtSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   for (i=0;i<[AnfahrtArray count]-1;i++)
	{
		// Seite A
		NSPoint tempStartPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      // Seite B
      NSPoint tempStartPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
		
		NSPoint tempEndPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      // Dic zusammenstellen
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      if (nowpwm)
      {
         [tempDic setObject:[NSNumber numberWithInt:nowpwm]forKey:@"pwm"];
      }
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[AnfahrtArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      
		[AnfahrtSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   } // for i
   NSLog(@"AnfahrtSchnittdatenArray: %@",[AnfahrtSchnittdatenArray description]);
   // Schnittdaten an CNC schicken
   NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [SchnittdatenDic setObject:AnfahrtSchnittdatenArray forKey:@"schnittdatenarray"];
   [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   
   
//   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
   [CNC setSpeed:lastSpeed];
}

- (IBAction)reportHome:(id)sender
{
   NSLog(@"AVR  reportHome");
   [CNC_Halttaste setState:0];
   [CNC_Halttaste setEnabled:YES];
   if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
   {
      NSLog(@"return wegen ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))");
      return;
   }
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   NSDictionary* tempDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:HOMETASTE] forKey:@"usb"];
	[nc postNotificationName:@"usbopen" object:self userInfo:tempDic];

	[nc postNotificationName:@"slavereset" object:self userInfo:NULL];

   NSLog(@"Horizontal bis Anschlag");
   
   NSMutableArray* AnfahrtArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   // Startpunkt ist aktuelle Position. Lage: 2: Home horizontal
   NSPoint PositionA = NSMakePoint(0, 0);
   NSPoint PositionB = NSMakePoint(0, 0);
   int index=0;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   //Horizontal bis Anschlag
   PositionA.x -= 500; // sicher ist sicher
   PositionB.x -= 500;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   /*
   PositionA.x -= 500; // sicher ist sicher
   PositionB.x -= 500;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   */

   // Vertikal ab bis Anschlag
 //  PositionA.y -=200;
 //  PositionB.y -=200;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   //index++;
//   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // von reportOberkanteAnfahren
   int i=0;
   int zoomfaktor=1.0;
   NSMutableArray* HomeSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   int lastSpeed = [CNC speed];
   [CNC setSpeed:14];

   
   for (i=0;i<[AnfahrtArray count]-1;i++)
	{
		// Seite A
		NSPoint tempStartPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      // Seite B
      NSPoint tempStartPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
		
		NSPoint tempEndPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      // Dic zusammenstellen
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];

      // home      
      int code=0xF0; // zeigt home an
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[AnfahrtArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
    
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      //NSLog(@"AVR  reportHome tempSteuerdatenDic: %@",[tempSteuerdatenDic description]);
     
            
		[HomeSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   } // for i
   
   [CNC setSpeed:lastSpeed];

   NSMutableDictionary* HomeSchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [HomeSchnittdatenDic setObject:HomeSchnittdatenArray forKey:@"schnittdatenarray"];
   [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   //NSLog(@"AVR  reportHome HomeSchnittdatenDic: %@",[HomeSchnittdatenDic description]);

   if ([HomeTaste state])
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:1] forKey:@"home"]; // Home anfahren
      //[HomeTaste setState:0];
   }
   else
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
      
   }
   
   [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"art"]; // 
   //NSLog(@"reportUSB_SendArray SchnittdatenDic: %@",[HomeSchnittdatenDic description]);

//	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbschnittdaten" object:self userInfo:HomeSchnittdatenDic];
 
   
}

- (void)homeSenkrechtSchicken
{
   NSLog(@"AVR  homeSenkrechtSchicken");
   
   if ((cncstatus)|| !([CNC_Seite1Check state] || [CNC_Seite2Check state]))
   {
      return;
   }
   NSLog(@"Vertikal bis Anschlag");
   //return;
   NSMutableArray* AnfahrtArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   
   
   
   // Startpunkt ist aktuelle Position. Lage: 2: Home horizontal
   NSPoint PositionA = NSMakePoint(0, 0);
   NSPoint PositionB = NSMakePoint(0, 0);
   int index=0;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
    
   // Vertikal ab bis Anschlag
   PositionA.y -=200;
   PositionB.y -=200;
   //NSLog(@"index: %d A.x: %2.2f A.y: %2.2f B.x: %2.2f B.y: %2.2f",index,PositionA.x,PositionA.y,PositionB.x,PositionB.y);
   index++;
   [AnfahrtArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:PositionA.x],@"ax",[NSNumber numberWithFloat:PositionA.y],@"ay",[NSNumber numberWithFloat:PositionB.x],@"bx", [NSNumber numberWithFloat:PositionB.y],@"by",[NSNumber numberWithInt:index],@"index",[NSNumber numberWithInt:0],@"lage",nil]];
   
   // von reportOberkanteAnfahren
   int i=0;
   int zoomfaktor=1.0;
   NSMutableArray* HomeSchnittdatenArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   int lastSpeed = [CNC speed];
   [CNC setSpeed:14];
   [CNC setredpwm:[red_pwmFeld floatValue]];
   
   for (i=0;i<[AnfahrtArray count]-1;i++)
	{
		// Seite A
		NSPoint tempStartPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempStartPunktAString= NSStringFromPoint(tempStartPunktA);
		
		//NSPoint tempEndPunkt= [[KoordinatenTabelle objectAtIndex:i+1]objectForKey:@"punktstring"];
		NSPoint tempEndPunktA= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ax"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"ay"]floatValue]*zoomfaktor);
		NSString* tempEndPunktAString= NSStringFromPoint(tempEndPunktA);
		//NSLog(@"tempStartPunktString: %@ tempEndPunktString: %@",tempStartPunktString,tempEndPunktString);
      
      // Seite B
      NSPoint tempStartPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i]objectForKey:@"by"]floatValue]*zoomfaktor);
		NSString* tempStartPunktBString= NSStringFromPoint(tempStartPunktB);
		
		NSPoint tempEndPunktB= NSMakePoint([[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"bx"]floatValue]*zoomfaktor,[[[AnfahrtArray objectAtIndex:i+1]objectForKey:@"by"]floatValue]*zoomfaktor);
      NSString* tempEndPunktBString= NSStringFromPoint(tempEndPunktB);
      
      // Dic zusammenstellen
      NSMutableDictionary* tempDic= [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkt"];
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkt"];
      
      // AB
      [tempDic setObject:tempStartPunktAString forKey:@"startpunkta"];
      [tempDic setObject:tempStartPunktBString forKey:@"startpunktb"];
      
      [tempDic setObject:tempEndPunktAString forKey:@"endpunkta"];
      [tempDic setObject:tempEndPunktBString forKey:@"endpunktb"];
      
      
      [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      
      [tempDic setObject:[NSNumber numberWithFloat:zoomfaktor] forKey:@"zoomfaktor"];
      int code=0xF0;
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"code"];
      
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codea"];
      [tempDic setObject:[NSNumber numberWithInt:code] forKey:@"codeb"];
      
      
      int position=0;
      if (i==0)
      {
         position |= (1<<FIRST_BIT);
      }
      if (i==[AnfahrtArray count]-2)
      {
         position |= (1<<LAST_BIT);
      }
      [tempDic setObject:[NSNumber numberWithInt:position] forKey:@"position"];
      
      NSDictionary* tempSteuerdatenDic=[CNC SteuerdatenVonDic:tempDic];
      
      
		[HomeSchnittdatenArray addObject:[CNC SchnittdatenVonDic:tempSteuerdatenDic]];
      
   } // for i
   
   [CNC setSpeed:lastSpeed];
   
   NSMutableDictionary* HomeSchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   [HomeSchnittdatenDic setObject:HomeSchnittdatenArray forKey:@"schnittdatenarray"];
   [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"cncposition"];
   //NSLog(@"AVR  reportHome HomeSchnittdatenDic: %@",[HomeSchnittdatenDic description]);
   
   /*
   if ([HomeTaste state])
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:1] forKey:@"home"]; // Home anfahren
      [HomeTaste setState:0];
   }
   else
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
      
   }
   */
   // vertikalabschnitt signalisieren1
   int code=0; // zeigt home an
   
   if ([HomeTaste state])
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:1] forKey:@"home"]; // 
      [HomeTaste setState:0];
   }
   else
   {
      [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
   }
   
   
   [HomeSchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"art"]; // 
   //NSLog(@"homeSenkrechtSchicken SchnittdatenDic: %@",[HomeSchnittdatenDic description]);
   
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbschnittdaten" object:self userInfo:HomeSchnittdatenDic];
   
   
}

- (int)halt
{
	return [CNC_Halttaste state];
}

- (NSDictionary*)AnzahlSchritte
{
   return 0;
}

#pragma mark AutoTask
- (IBAction)reportProfilTask:(id)sender
{
   //[self reportOberkanteAnfahren:NULL];
   [CNC_Stoptaste setState:0];
   [CNC_Neutaste performClick:NULL];
   [CNC_Starttaste performClick:NULL];
   [CNC_Starttaste performClick:NULL]; // Startpunkt fixieren
   [RechtsLinksRadio setSelectedSegment:0];

   [self reportNeueLinie:NULL];
   int profilpopindex =0;
   if ([ProfilPop indexOfSelectedItem])
   {
      profilpopindex=[ProfilPop indexOfSelectedItem]; // Item 0 ist Titel
      NSLog(@"reportProfilOberseiteTask Profil aus Pop: %@",[ProfilPop itemTitleAtIndex:profilpopindex]);
   }
   else
   {
      
      NSString* Profil1Name = [[ProfilNameFeldA stringValue]stringByAppendingPathExtension:@"txt"];
      profilpopindex = [[ProfilPop itemTitles]indexOfObject:Profil1Name];
      
      NSLog(@"reportProfilPop profilpopindex: %d Profil aus ProfilNameFeldA: %@",profilpopindex,Profil1Name);
      if (profilpopindex == NSNotFound)
      {
         NSLog(@"reportProfilPop kein Profil");
         return;
      }
   }

   [CNC_Eingabe doProfil1PopTaskMitProfil:profilpopindex];
   
   [CNC_Eingabe setUnterseite:0];
   [CNC_Eingabe doProfilSpiegelnVertikalTask];
   [CNC_Eingabe doProfilEinfuegenTask];
   [CNC_Eingabe doSchliessenTask];
   
//   [CNC_BlockKonfigurierenTaste performClick:NULL];
   [CNC_BlockAnfuegenTaste performClick:NULL];   
}

- (IBAction)reportProfilOberseiteTask:(id)sender
{
   NSDate *anfang = [NSDate date];

   [CNC_Stoptaste setState:0];
   //[self reportOberkanteAnfahren:NULL];
   [CNC_Neutaste performClick:NULL];
   [CNC_Starttaste performClick:NULL];
   [CNC_Starttaste performClick:NULL]; // Startpunkt fixieren
   
   [self reportNeueLinie:NULL];
   NSLog(@"reportProfilOberseiteTask items: %@",[[ProfilPop itemTitles]description]);
   int profilpopindex =0;
   if ([ProfilPop indexOfSelectedItem])
   {
      profilpopindex=[ProfilPop indexOfSelectedItem]; // Item 0 ist Titel
      NSLog(@"reportProfilOberseiteTask profilpopindex: %d Profil aus Pop: %@",profilpopindex,[ProfilPop itemTitleAtIndex:profilpopindex]);
   }
   else
   {
      
      NSString* Profil1Name = [[ProfilNameFeldA stringValue]stringByAppendingPathExtension:@"txt"];
      profilpopindex = [[ProfilPop itemTitles]indexOfObject:Profil1Name];
      
      NSLog(@"reportProfilOberseiteTask profilpopindex: %d Profil aus ProfilNameFeldA: %@",profilpopindex,Profil1Name);
      if (profilpopindex == NSNotFound)
      {
         NSLog(@"reportProfilPop kein Profil");
         return;
      }
      
   }

   [CNC_Eingabe doProfil1PopTaskMitProfil:profilpopindex];
   
   [CNC_Eingabe setOberseite:1];
   [CNC_Eingabe setUnterseite:0];
   [CNC_Eingabe doProfilSpiegelnVertikalTask];
   [CNC_Eingabe doProfilEinfuegenTask];
   [CNC_Eingabe doSchliessenTask];
   
   //   [CNC_BlockKonfigurierenTaste performClick:NULL];
   [CNC_BlockAnfuegenTaste performClick:NULL]; 
   [RechtsLinksRadio setSelectedSegment:1];
   [RechtsLinksRadio  performClick:NULL]; 
   double delta = [anfang timeIntervalSinceNow];
   NSLog(@"delta: %f",delta);
   
}

- (IBAction)reportProfilUnterseiteTask:(id)sender
{
   //[self reportOberkanteAnfahren:NULL];
   [CNC_Neutaste performClick:NULL];
   [CNC_Starttaste performClick:NULL];
   [CNC_Starttaste performClick:NULL]; // Startpunkt fixieren
   
   [self reportNeueLinie:NULL];
   
   int profilpopindex =0;
   if ([ProfilPop indexOfSelectedItem])
   {
      profilpopindex=[ProfilPop indexOfSelectedItem]; // Item 0 ist Titel
      NSLog(@"reportProfilOberseiteTask Profil aus Pop: %@",[ProfilPop itemTitleAtIndex:profilpopindex]);
   }
   else
   {
      
      NSString* Profil1Name = [[ProfilNameFeldA stringValue]stringByAppendingPathExtension:@"txt"];
      profilpopindex = [[ProfilPop itemTitles]indexOfObject:Profil1Name];
      
      NSLog(@"reportProfilPop profilpopindex: %d Profil aus ProfilNameFeldA: %@",profilpopindex,Profil1Name);
      if (profilpopindex == NSNotFound)
      {
         NSLog(@"reportProfilPop kein Profil");
         return;
      }
   }

   [CNC_Eingabe doProfil1PopTaskMitProfil:profilpopindex];
   
   [CNC_Eingabe setOberseite:0];
   [CNC_Eingabe setUnterseite:1];
   [CNC_Eingabe doProfilEinfuegenTask];
   [CNC_Eingabe doSchliessenTask];
   
   //   [CNC_BlockKonfigurierenTaste performClick:NULL];
   [CNC_BlockAnfuegenTaste performClick:NULL]; 
   [RechtsLinksRadio setSelectedSegment:0];
    
}


- (IBAction)reportEdgeTask:(id)sender
{
   //[self reportOberkanteAnfahren:NULL];
   [CNC_Neutaste performClick:NULL];
   [CNC_Starttaste performClick:NULL];
   [CNC_Starttaste performClick:NULL];
   
   [self reportNeueLinie:NULL];
   [CNC_Eingabe doLibTaskMitElement:11];
   [CNC_Eingabe doSchliessenTask];
   
}


#pragma mark USB_Aktion
- (IBAction)reportUSB_sendArray:(id)sender
{
   if ([SchnittdatenArray count]==0)
   {
      NSLog(@"reportUSB_sendArray SchnittdatenArray leer");
      return;
   }
   if (AVR_USBStatus)
   {
      //NSLog(@"SchnittdatenArray 0: %@",[SchnittdatenArray description]);
      
      if (([[[SchnittdatenArray objectAtIndex:0]objectAtIndex:1]intValue] <= 0x7F) || ([[[SchnittdatenArray objectAtIndex:0]objectAtIndex:9]intValue] <= 0x7F))
      {
         [AnschlagLinksIndikator setTransparent:YES];
      }
      
      if (([[[SchnittdatenArray objectAtIndex:0]objectAtIndex:3]intValue] <= 0x7F) || ([[[SchnittdatenArray objectAtIndex:0]objectAtIndex:11]intValue] <= 0x7F))
      {
         [AnschlagUntenIndikator setTransparent:YES];
      }
      
      // von 32
      
      int antwort=0;
      int delayok=0;
      if (![DC_Taste state])
      {
         NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
         [Warnung addButtonWithTitle:@"Einschalten"];
         [Warnung addButtonWithTitle:@"Ignorieren"];
         //	[Warnung addButtonWithTitle:@""];
         [Warnung addButtonWithTitle:@"Abbrechen"];
         [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"CNC Schnitt starten"]];
         
         NSString* s1=@"Der Heizdraht ist noch nicht eingeschaltet.";
         NSString* s2=@"Nach dem Einschalten den Vorgang erneut starten.";
         NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
         [Warnung setInformativeText:InformationString];
         [Warnung setAlertStyle:NSWarningAlertStyle];
         
         antwort=[Warnung runModal];
         
         // return;
         // NSLog(@"antwort: %d",antwort);
      }
      switch (antwort)
      {
         case NSAlertFirstButtonReturn: // Einschalten
         {
            [DC_Taste setState:1];
            [self DC_ON:[DC_PWM intValue]];
            delayok=1;
         }break;
            
         case NSAlertSecondButtonReturn: // Ignorieren
         {
            // pwm entfernen
            int i=0;
            for (i=0;i<[SchnittdatenArray count];i++)
            {
               [[SchnittdatenArray  objectAtIndex:i]replaceObjectAtIndex:20 withObject:[NSNumber numberWithInt:0]];
            }
            
         }break;
            
         case NSAlertThirdButtonReturn: // Abbrechen
         {
            return;
         }break;
      }
      
      // end von 32
      
      //NSLog(@"AVR  reportUSB_sendArray cncposition: %d\n\n",cncposition);
      [CNC_Halttaste setEnabled:YES];
      [CNC_Stoptaste setState:0];
      [PositionFeld setIntValue:0];
      [ProfilGraph setStepperposition:0];
      
      //NSLog(@"reportUSB_sendArray cncposition: %d \nSchnittdatenArray: %@",cncposition,[[SchnittdatenArray objectAtIndex:0]description]);
      // Array an USB schicken
      NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
      NSMutableDictionary* SchnittdatenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      [SchnittdatenDic setObject:[NSNumber numberWithInt:[self pwm]] forKey:@"pwm"];
      
      [SchnittdatenDic setObject:SchnittdatenArray forKey:@"schnittdatenarray"];
      [SchnittdatenDic setObject:[NSNumber numberWithInt:cncposition] forKey:@"cncposition"];
      
      if ([HomeTaste state])
      {
         [SchnittdatenDic setObject:[NSNumber numberWithInt:1] forKey:@"home"]; // Home anfahren
         
      }
      else
      {
         [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"home"]; // 
         
      }
      
      [SchnittdatenDic setObject:[NSNumber numberWithInt:0] forKey:@"art"]; // 
      //NSLog(@"reportUSB_SendArray SchnittdatenDic: %@",[SchnittdatenDic description]);
      
      //   [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
      //NSLog(@"reportUSB_SendArray delayok: %d",delayok);
      [SchnittdatenDic setObject:[NSNumber numberWithInt:delayok] forKey:@"delayok"];
      
      if (delayok)
      {
         NSLog(@"mit delay");
         [self performSelector:@selector (sendDelayedArrayWithDic:) withObject:SchnittdatenDic afterDelay:2];
      }
      else 
      {
         NSLog(@"ohne delay");
         [nc postNotificationName:@"usbschnittdaten" object:self userInfo:SchnittdatenDic];
      }
      [self saveSpeed];
      [self savePWM];
      [self saveMinimaldistanz];
   } // if AVR_USBStatus
   else 
   {
      int antwort=0;
      NSAlert *Warnung = [[[NSAlert alloc] init] autorelease];
      [Warnung addButtonWithTitle:@"Einstecken und einschalten"];
      [Warnung addButtonWithTitle:@"Zurück"];
      //	[Warnung addButtonWithTitle:@""];
      //[Warnung addButtonWithTitle:@"Abbrechen"];
      [Warnung setMessageText:[NSString stringWithFormat:@"%@",@"CNC Schnitt starten"]];
      
      NSString* s1=@"USB ist noch nicht eingesteckt.";
      NSString* s2=@"";
      NSString* InformationString=[NSString stringWithFormat:@"%@\n%@",s1,s2];
      [Warnung setInformativeText:InformationString];
      [Warnung setAlertStyle:NSWarningAlertStyle];
      
      antwort=[Warnung runModal];
      [CNC_Stoptaste setState:0];
      [self DC_ON:0];
      [self setStepperstrom:0];
      
   }
}

- (void)sendDelayedArrayWithDic:(NSDictionary*) schnittdatendic
{
   //NSLog(@"sendDelayedArrayWithDic");
   NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
   [nc postNotificationName:@"usbschnittdaten" object:self userInfo:schnittdatendic];
}

- (void)USBReadAktion:(NSNotification*)note
{
   //NSLog(@"AVR  USBReadAktion note: %@",[[note userInfo]description]);
   if ([[note userInfo]objectForKey:@"inposition"])
   {
      if ([[[note userInfo]objectForKey:@"outposition"]intValue] > [PositionFeld intValue])
      {
         [PositionFeld setIntValue:[[[note userInfo]objectForKey:@"outposition"]intValue]];
         [ProfilGraph setStepperposition:[[[note userInfo]objectForKey:@"outposition"]intValue]];
         //[ProfilGraph setNeedsDisplay:YES];
      }
       if ([[[note userInfo]objectForKey:@"stepperposition"]intValue] > [CNCPositionFeld intValue])
       {
         [CNCPositionFeld setIntValue:[[[note userInfo]objectForKey:@"stepperposition"]intValue]];
          //[ProfilGraph setStepperposition:[[[note userInfo]objectForKey:@"stepperposition"]intValue]];
          //[ProfilGraph setNeedsDisplay:YES];
       }
   }
   
   if ([[[note userInfo]objectForKey:@"slaveversion"]intValue])
   {
      int slaveversionint =[[[note userInfo]objectForKey:@"slaveversion"]intValue];
      [SlaveVersionFeld setStringValue:[NSString stringWithFormat:@"Slaveversion: %03d",slaveversionint]];
   
   }
  
   
   int homeanschlagCount=0;
   if ([[note userInfo]objectForKey:@"homeanschlagset"])
   {
      homeanschlagCount = [[[note userInfo]objectForKey:@"homeanschlagset"]count];
   }

   if([[note userInfo]objectForKey:@"abschnittfertig"])
   {
      int abschnittfertig=[[[note userInfo]objectForKey:@"abschnittfertig"]intValue];
      switch (abschnittfertig)
      {
         case 0xAA:
         {
          //  NSLog(@"AVR End Abschnitt von A");
            
         }break;
         
         case 0xAB:
         {
          //  NSLog(@"AVR End Abschnitt von B");
         }break;
            
         case 0xAC:
         {
          //  NSLog(@"AVR End Abschnitt von C");
         }break;
            
         case 0xAD:
         {
          //  NSLog(@"AVR End Abschnitt von D");
         }break;
            
         case 0xB5:
         {
            NSLog(@"AVR Anschlag A0 home first");
         }break;
            
         case 0xB6:
         {
            NSLog(@"AVR Anschlag B0 home first");
         }break;
            
         case 0xB7:
         {
            NSLog(@"AVR Anschlag C0 home first");
         }break;
            
         case 0xB8:
         {
            NSLog(@"AVR Anschlag D0 home first");
         }break;
         
         case 0xA5:   
         {
            NSLog(@"AVR Anschlag A0");
            [AnschlagDic setObject:[NSNumber numberWithInt:abschnittfertig] forKey:@"anschlaga0"];
            [AnschlagLinksIndikator setTransparent:NO];
            [CNC_Lefttaste setEnabled:NO];
         }break;
            
         case 0xA6:   
         {
            NSLog(@"AVR Anschlag B0");
            [AnschlagDic setObject:[NSNumber numberWithInt:abschnittfertig] forKey:@"anschlagb0"];
            [AnschlagUntenIndikator setTransparent:NO];
            [CNC_Downtaste setEnabled:NO];

         }break;
            
         case 0xA7:   
         {
            NSLog(@"AVR Anschlag C0");
            [AnschlagDic setObject:[NSNumber numberWithInt:abschnittfertig] forKey:@"anschlagc0"];
            [AnschlagLinksIndikator setTransparent:NO];
            [CNC_Lefttaste setEnabled:NO];
            
         }break;
            
         case 0xA8:   
         {
            NSLog(@"AVR Anschlag D0");
            [AnschlagDic setObject:[NSNumber numberWithInt:abschnittfertig] forKey:@"anschlagd0"];
            [AnschlagUntenIndikator setTransparent:NO];
            [CNC_Downtaste setEnabled:NO];

         }break;
            

      }

   }
   
   if([[note userInfo]objectForKey:@"home"])
   {
      //NSLog(@"AVR  USBReadAktion home: %d",[[[note userInfo]objectForKey:@"home"]intValue]);
      int home=0;
      if ([[note userInfo]objectForKey:@"home"])
      {
         home = [[[note userInfo]objectForKey:@"home"]intValue];
      }
      if ((home==2)&& (homeanschlagCount <4)) // senkrekten Abschnitt von home schicken.
//      if ((homeanschlagCount <4)) // senkrekten Abschnitt von home schicken.
      {
         [self homeSenkrechtSchicken];
         [HomeTaste setState:0];
      }
      if (homeanschlagCount == 4)
          {
             NSLog(@"AVR USBReadAktion Home erreicht");
             [self setBusy:0];
          }
      
   }

}

- (void)setUSB_Device_Status:(int)status
{
   //NSLog(@"setUSB_Device_Status usbstatus: %d",usbstatus);
   if (status)
   {
      [USBKontrolle setStringValue:@"USB ON"];
   }
   else
   {
      [USBKontrolle setStringValue:@"USB OFF"];
   }
   AVR_USBStatus=status;
}

// von USB_Interface AVR 5N


- (IBAction)reportUSB:(id)sender
{
   //NSLog(@"check A");
   NSDictionary* tempDic=[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:USBTASTE] forKey:@"usb"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"usbopen" object:self userInfo:tempDic];
}

- (IBAction)reportSaveStepperDic:(id)sender
{
   NSLog(@"saveStepperDic");
   

}

- (int)saveStepperDic
{
   int erfolg =0;
   
   
   return erfolg;
}

- (IBAction)reportPrint:(id)sender
{
   //schliessencounter++;
   NSLog(@"AVR  reportPrint");
   //NSPageLayout *pageLayout = [NSPageLayout pageLayout];
   //  [pageLayout runModal];

   NSPrintInfo *printInfo;
   NSPrintOperation *printOp;
   printInfo = [NSPrintInfo sharedPrintInfo];
   [printInfo setHorizontalPagination: NSFitPagination];
   //[printInfo setHorizontalPagination:  NSAutoPagination];
   //[printInfo setVerticalPagination: NSFitPagination];
   [printInfo setVerticalPagination: NSAutoPagination];
   [printInfo setVerticallyCentered:NO];
   [printInfo setOrientation:NSLandscapeOrientation];
   //NSLog(@"printInfo: %@",[printInfo dictionary]);
   
   printOp = [NSPrintOperation printOperationWithView:ProfilGraph   printInfo:printInfo];
   [printOp setShowsPrintPanel:YES];
   [printOp	runOperationModalForWindow:[self window]
                                     delegate:self
                               didRunSelector:nil
                                  contextInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"PrintFromAVR",@"task", nil]];
   //[printOp runOperation];
   //[[[printOp printPanel]window] orderOut: self];
   
   //[NSPrintOperation setCurrentOperation: nil];

   //[ProfilGraph print:NULL ];

}

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
    //return [ProfilDaten count];
	 return [KoordinatenTabelle count];
}

- (id)tableView:(NSTableView *)tableView
      objectValueForTableColumn:(NSTableColumn *)tableColumn
      row:(int)row
{
 //   return [KoordinatenTabelle objectAtIndex:row];
	id dieZeile;
	id derWert=0;;
	dieZeile=[KoordinatenTabelle objectAtIndex:row];
	//NSLog(@"dieZeile: %@",dieZeile);
	derWert=[dieZeile objectForKey:[tableColumn identifier]];
	//NSLog(@"identifier: %@ derWert: %@",[tableColumn identifier],derWert);
    
    return derWert;
}

- (void)tableViewSelectionDidChange:(NSNotification *)note
{
   //NSLog(@"tableViewSelectionDidChange %d",[[note object]selectedRow]);
   if ([[note object]numberOfRows]&&[[note object]numberOfSelectedRows])
   {
      [self setDatenVonZeile:[[note object]selectedRow]];
   }
  // [[note object] scrollRowToVisible:[[note object]selectedRow]];
}

- (void)controlTextDidEndEditing:(NSNotification *)note

{
  NSLog(@"AVR: controlTextDidChange tag: %d",[[note object]tag]);
   switch ([[note object]tag])
   {
      case 11:
      case 12:
      {
         int index=[IndexFeld intValue];
         float wertX=[WertAXFeld floatValue];
         float wertY=[WertAYFeld floatValue];
         
         [WertAYStepper setFloatValue:wertX];
         [WertAYStepper setFloatValue:wertY];
         //NSLog(@"reportWertAXStepper index: %d wertX: %2.2F wertY: %2.2F",index, wertX, wertY);
         
         NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertX], @"ax",
                                  [NSNumber numberWithFloat:wertY], @"ay",[NSNumber numberWithInt:index],@"index",NULL];
         
         //NSLog(@"tempDic: %@",[tempDic description]);
         if ([KoordinatenTabelle count])
         {
            [KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
         }
         
         [ProfilGraph setDatenArray:KoordinatenTabelle];
         [ProfilGraph setNeedsDisplay:YES];
         [CNCTable reloadData];
      }break;
         
 
      case 1001:
      {
         //NSLog(@"DC-wert 1001: %d",[[note object]intValue]);
         [DC_Stepper setIntValue:[[note object]intValue]];
         [[self window]makeFirstResponder: ProfilGraph];
         //[self savePWM];
         
      }break;
         
      case 1002:
      {
         //NSLog(@"Speed 1002: %d",[[note object]intValue]);
         [SpeedStepper setIntValue:[[note object]intValue]];
         [[self window]makeFirstResponder: ProfilGraph];
         [CNC setSpeed:[[note object] intValue]];
         //[self saveSpeed];
         
      }break;
         
         //abbrand: 1005
         // redpwm: 1006
         
      case 1006:
      {
         [CNC setredpwm:[[note object] floatValue]];
      }break;

      case 1007:
      {
         minimaldistanz=[[note object] floatValue];
      }break;

      case 1010:
      {
         NSLog(@"PWM 1010: %d",[[note object]intValue]);
         [PWMStepper setIntValue:[[note object]intValue]];
         int index=[IndexFeld intValue];
         NSDictionary* oldDic = [KoordinatenTabelle objectAtIndex:index];
         id wertax = [oldDic objectForKey:@"ax"];
         id wertay = [oldDic objectForKey:@"ay"];
         id wertbx = [oldDic objectForKey:@"bx"];
         id wertby = [oldDic objectForKey:@"by"];
         id wertindex=[oldDic objectForKey:@"index"];
         //NSLog(@"reportPWMStepper index: %d wertax: %2.2F wertay: %2.2F wertbx: %2.2F wertby: %2.2F",index, [wertax floatValue], [wertay floatValue],[wertbx floatValue], [wertby floatValue]);
         
         NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:wertax, @"ax",wertay, @"ay",
                                  wertbx, @"bx",wertby, @"by",wertindex,@"index",
                                  [NSNumber numberWithInt:[[note object] intValue]],@"pwm",NULL];
         
         
         //NSLog(@"tempDic: %@",[tempDic description]);
         
         //NSLog(@"Dic vorher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
         
         [KoordinatenTabelle replaceObjectAtIndex:index withObject:tempDic];
         //NSLog(@"Dic nachher: %@",[[KoordinatenTabelle objectAtIndex:index]description]);
         
         [ProfilGraph setDatenArray:KoordinatenTabelle];
         [ProfilGraph setNeedsDisplay:YES];
         [CNCTable reloadData];

         //[self saveSpeed];
         
      }break;
       
         

   }// switch tag
}

- (void)dealloc
{
   [UndoSet release];
   [Utils release];
   [AnschlagDic release];
   [CNCDatenArray release];
	[KoordinatenTabelle release];
	[UndoKoordinatenTabelle release];
   [BlockKoordinatenTabelle release];
   [SchnittdatenArray release];
	GraphEnd=0;
	[CNC release];
	[ProfilDatenOA release];
	[ProfilDatenUA release];
   [CNC_PList release];

}
@end
