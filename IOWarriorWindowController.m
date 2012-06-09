#import "IOWarriorWindowController.h"


extern int usbstatus;

									 
									 
									 
									 
static NSString *SystemVersion ()
{
	NSString *systemVersion = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];    
//	NSLog(@"systemVersion: %@",systemVersion);

//	NSArray* VersionArray=[systemVersion componentsSeparatedByString:@"."];
//	NSLog(@"VersionArray: %@",[VersionArray description]);
return systemVersion;
}

@implementation IOWarriorWindowController

static NSString *	SystemVersion();
int			SystemNummer;





// LinkedList


struct list_node 
{
   int data;
   struct list_node *next;
   struct list_node *prev;
};
typedef struct list_node node;

struct Abschnitt *first, *last, * curr;

struct Abschnitt  * init_list(uint8_t *data)
{
   struct Abschnitt * ersterAbschnitt =malloc(sizeof(struct Abschnitt));
   ersterAbschnitt->num=0;
   ersterAbschnitt->data  = data;
   first = ersterAbschnitt;
   last = ersterAbschnitt;
   ersterAbschnitt->next = NULL;
   ersterAbschnitt->prev = NULL;

   return ersterAbschnitt;
}

struct Abschnitt  * insert_right(struct Abschnitt *list, uint8_t *data)
{
	struct Abschnitt *neuerAbschnitt = (struct Abschnitt *) malloc(sizeof(struct Abschnitt));
	neuerAbschnitt->data        = data;
   neuerAbschnitt->num = list->num+1;
	neuerAbschnitt->prev        = list;
   
   if (list->next)
   {
      //printf("next ist da\n");
      neuerAbschnitt->next       = list->next;
      neuerAbschnitt->next->prev = neuerAbschnitt;
   }
   else
   {
      //printf("next ist nicht da\n");
      neuerAbschnitt->next=NULL;
   }
   list->next      = neuerAbschnitt;
   //neuerAbschnitt->next=NULL;
	return neuerAbschnitt;
}


struct Abschnitt * delete(struct Abschnitt *list)
{
   if (list->next)// nicht letzter Abschnitt
   {
      list->next->prev = list->prev; // next von vorherigem Abschnitt setzen
      list->prev->next = list->next;
      return list->prev;
   }
   
	return list->prev;
}

struct Abschnitt * delete_last(struct Abschnitt *list)
{
   struct Abschnitt *lastAbschnitt = list;
   while (lastAbschnitt->next && lastAbschnitt->next->next) // Ende suchen
   {
      //printf("%d",lastAbschnitt->num);
		lastAbschnitt=lastAbschnitt->next;
	}
   // Ende erreicht, vorletzter Abschnitt
   //return lastAbschnitt;
   if (lastAbschnitt->next)
   {
      struct Abschnitt* temp=lastAbschnitt->next;
      free(temp);
      lastAbschnitt->next=NULL;
   }
   
	return lastAbschnitt;
}

struct Abschnitt * delete_first(struct Abschnitt *list)
{
   struct Abschnitt *currAbschnitt = list;
   while (currAbschnitt->prev) // Anfang suchen
   {
		currAbschnitt=currAbschnitt->prev;
	}
   //return currAbschnitt;
   // Anfang erreicht
   struct Abschnitt* temp=currAbschnitt;
   currAbschnitt=currAbschnitt->next;
   currAbschnitt->prev=NULL;
   free(temp);
   
	return currAbschnitt;
}



struct Abschnitt * delete_all(struct Abschnitt *list)
{
   struct Abschnitt *firstAbschnitt = list;
   while (firstAbschnitt->next) // Ende suchen
   {
		firstAbschnitt=firstAbschnitt->next;
	}
   // Ende erreicht
   while (firstAbschnitt->prev) // prev von erstem Abschnitt ist NULL
   {
      //struct Abschnitt* temp = ;
      firstAbschnitt = firstAbschnitt->prev;
      if (firstAbschnitt->next)
      {      
         struct Abschnitt* temp = firstAbschnitt->next;
         firstAbschnitt->next = NULL;
         free(temp);
      }
   }
   return firstAbschnitt;
}




void print_all_num(struct Abschnitt* list)
{
	struct Abschnitt *head = list;
	struct Abschnitt *current = list;
	printf("%d ", head->num);
	while (head != (current = current->next)){
		printf("%d ", current->num);
	}
	printf("\n");
}


// end LinkedList

- (void)Alert:(NSString*)derFehler
{
	NSAlert * DebugAlert=[NSAlert alertWithMessageText:@"Debugger!" 
		defaultButton:NULL 
		alternateButton:NULL 
		otherButton:NULL 
		informativeTextWithFormat:@"Mitteilung: \n%@",derFehler];
		[DebugAlert runModal];

}

- (void)observerMethod:(id)note
{
   NSLog(@"observerMethod userInfo: %@",[[note userInfo]description]);
   NSLog(@"observerMethod note: %@",[note description]);
   
}

void DeviceAdded(void *refCon, io_iterator_t iterator)
{
   NSLog(@"DeviceAdded");
   NSDictionary* NotDic = [NSDictionary  dictionaryWithObjectsAndKeys:@"neu",@"usb", nil];
   NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
   
   [nc postNotificationName:@"usbopen" object:NULL userInfo:NotDic];
   
}
void DeviceRemoved(void *refCon, io_iterator_t iterator)
{
   NSLog(@"DeviceRemoved");
   
}


/*" Invoked when the nib file including the window has been loaded. "*/
- (void) awakeFromNib
{
   mausistdown=0;
   anzrepeat=0;
   int i,listcount=0;
   struct Abschnitt *first;
   // LinkedList
   first=NULL;
   
 // 
   /*
   NSNotificationCenter *notCenter;
   notCenter = [[NSWorkspace sharedWorkspace] notificationCenter];
   [notCenter addObserver:self
                 selector:@selector(observerMethod:)
                     name:NSWorkspaceDidMountNotification object:self]; // Register for all notifications
   
   kern_return_t kr;
   mach_port_t masterPort;
   kr = IOMasterPort (MACH_PORT_NULL, &masterPort);
   static IONotificationPortRef    gNotifyPort;
   CFRunLoopSourceRef runLoopSource;
   
   CFMutableDictionaryRef  matchingDict =  IOServiceMatching(kIOUSBDeviceClassName); 
   //NSMutableDictionary* matchingDict = IOServiceMatching(kIOUSBDeviceClassName);

 //  gNotifyPort = IONotificationPortCreate(kIOMasterPortDefault);
   
   if (!kr && masterPort)
   {
      gNotifyPort = IONotificationPortCreate(masterPort);
      
      runLoopSource = IONotificationPortGetRunLoopSource (gNotifyPort);
      
      CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop],
                         runLoopSource,
                         kCFRunLoopDefaultMode);
      
      
      
      int usbVendor=0;
      // kern_return_t kr;
      io_iterator_t  addedIter;
           
//      CFDictionarySetValue (matchingDict, CFSTR(kUSBVendorID), CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &usbVendor));
      
      // omitting productID here
      kr = IOServiceAddMatchingNotification (gNotifyPort, kIOFirstMatchNotification, (CFMutableDictionaryRef)matchingDict,
                                             DeviceAdded, NULL, &addedIter);
      
      DeviceAdded(NULL, addedIter);
      //   mach_port_deallocate (mach_task_self(), masterPort);
   }
 //  
   */ 
 	int adresse=0xABCD;
	adresse = 0xA030;
	int lbyte=adresse<<8;
	lbyte &= 0xff00;
	//lbyte >>=8;
	//int hbyte=adresse>>8;
	//int lbyte=adresse%0x100;
	//int hbyte=adresse/0x100;
	//lbyte>>=8;
	//NSLog(@"adresse: %x lbyte: %x hbyte; %x",adresse, lbyte,hbyte);
	
	
	uint8_t zahl=244;
	char string[3];
	uint8_t l,h;                             // schleifenzähler
	//NSLog(@"zahl: %d   hex: %02X ",zahl, zahl);
	
	
	//  string[4]='\0';                       // String Terminator
	string[2]='\0';                       // String Terminator
	l=(zahl % 16);
	if (l<10)
		string[1]=l +'0';  
	else
	{
		l%=10;
		string[1]=l + 'A'; 
		
	}
	zahl /=16;
	h= zahl % 16;
	if (h<10)
		string[0]=h +'0';  
	else
	{
		h%=10;
		string[0]=h + 'A'; 
	}
	
	
	NSImage* myImage = [NSImage imageNamed: @"USB"];
	[NSApp setApplicationIconImage: myImage];
	
	
	// set the global ptr to the main window controller to self, needed for iowarrior callbacks
	//	NSString *systemVersion = [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"] objectForKey:@"ProductVersion"];    
	//	NSLog(@"systemVersion: %@",systemVersion);
	//	NSArray* VersionArray=[systemVersion componentsSeparatedByString:@"."];
	//	NSLog(@"VersionArray: %@",[VersionArray description]);
	
	// init the IOWarrior library
	NSString* SysVersion=SystemVersion();
	NSArray* VersionArray=[SysVersion componentsSeparatedByString:@"."];
	SystemNummer=[[VersionArray objectAtIndex:1]intValue];
	NSLog(@"SystemVersion: %@",SysVersion);
	
	isReading = false;
	isTracking = false;
	ignoreDuplicates = YES;
	
	//dumpTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	//Dump_DS=[[rDump_DS alloc]init];
	//[dumpTable setDelegate:Dump_DS];
	//[dumpTable setDataSource:Dump_DS];
	dumpCounter=0;
	
   lastValueRead = [[NSData alloc]init];
   
	logEntries = [[NSMutableArray alloc] init];
	[logTable setTarget:self];
	[logTable setDoubleAction:@selector(logTableDoubleClicked)];
	
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];
// CNC
    /*
	[nc addObserver:self
			 selector:@selector(CNCAktion:)
				  name:@"CNCaktion"
				object:nil];
	*/
	[nc addObserver:self
           selector:@selector(USB_SchnittdatenAktion:)
               name:@"usbschnittdaten"
             object:nil];

	[nc addObserver:self
          selector:@selector(SlaveResetAktion:)
              name:@"slavereset"
            object:nil];
   



	[nc addObserver:self
			 selector:@selector(TastenAktion:)
				  name:@"Tastenaktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(EinzelTastenAktion:)
				  name:@"Einzeltastenaktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(SendTastenAktion:)
				  name:@"SendTastenAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(SendAktion:)
				  name:@"SendAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(InputAktion:)
				  name:@"InputAktion"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(BeendenAktion:)
				  name:@"IOWarriorBeenden"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(FensterSchliessenAktion:)
				  name:@"NSWindowWillCloseNotification"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(sendCmdAktion:)
				  name:@"sendcmd"
				object:nil];

	[nc addObserver:self
			 selector:@selector(sendReportAktion:)
				  name:@"sendReport"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(i2cEEPROMReadReportAktion:)
				  name:@"i2ceepromread"
				object:nil];
	
	
	[nc addObserver:self
			 selector:@selector(i2cEEPROMWriteReportAktion:)
				  name:@"i2ceepromwrite"
				object:nil];
	
	[nc addObserver:self
			 selector:@selector(i2cAVRWriteReportAktion:)
				  name:@"i2cavrwrite"
				object:nil];

	

	[nc addObserver:self
			 selector:@selector(WriteSchnittdatenArrayReportAktion:)
				  name:@"writeschnittdatenarray"
				object:nil];
	
	
	
	[nc addObserver:self
			 selector:@selector(i2cStatusAktion:)
				  name:@"i2cstatus"
				object:nil];
	
	
	[nc addObserver:self
			 selector:@selector(twiStatusAktion:)
				  name:@"twistatus"
				object:nil];

	
	[nc addObserver:self
			 selector:@selector(spiStatusAktion:)
				  name:@"spistatus"
				object:nil];
	
   
   [nc addObserver:self
          selector:@selector(MausAktion:)
              name:@"mausdaten"
            object:nil];
   
   [nc addObserver:self
          selector:@selector(USBAktion:)
              name:@"usbopen"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(PfeilAktion:)
              name:@"Pfeil"
            object:nil];

   
   [nc addObserver:self
          selector:@selector(HaltAktion:)
              name:@"Halt"
            object:nil];
   
	

   
   [nc addObserver:self
          selector:@selector(DC_Aktion:)
              name:@"DC_pwm"
            object:nil];
   
   
   [nc addObserver:self
          selector:@selector(StepperstromAktion:)
              name:@"stepperstrom"
            object:nil];
   

	lastDataRead=[[NSData alloc]init];
	//	[self readPList];
	
	[self showAVR:NULL];
	
	[[FileMenu itemWithTag:1005]setTarget :AVR];
	//[ProfilMenu setTarget :AVR];
	//[[ProfilMenu itemWithTag:5001]setAction:@selector(readProfil:)];
	
	//	IOW vorbereiten
	//	Port 0: Bit 0-3 auf FF setzen (Eingaenge). 
	//	Bit 4 auf H setzen: AVR anzeigen, das TWI nicht ausgeschaltet werden soll 
	//	Bit 7 auf H setzen: warten bis AVR das Bit auf L zieht (TWI ausgeschaltet)
	//	Port 1: FF setzen (Eingaenge)
	
	//[AVR setProfilPlan:NULL];
	//	[self showADWandler:NULL];	
	/*
	 [ADWandler setInterfaceNummer:2];
	 [ADWandler setTabIndex:1];
	 [ADWandler setEinkanalWahlTaste:3];
	 
	 NSMutableArray* tempKanalArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:1]];
	 [tempKanalArray addObject:[NSNumber numberWithInt:0]];
	 [ADWandler setMehrkanalWahlTasteMitArray:tempKanalArray];//[NSArray arrayWithObjects:0,1,1,1,0,1,0,1,0,nil]];
	 [self Alert:@"ADWandler awake vor readPList "];
	 [self readPList];
	 */
	//	
	//	[self readPList];
	//[ADWandler showWindow:self];
	
	//NSLog(@"BIN  zahl: %d bin: %02X",14, 14);

	// 
	//CNC
	SchnittDatenArray=[[[NSMutableArray alloc]initWithCapacity:0]retain];
   
   pfeilaktion=0; // signalisiert in writeCNCAbschnitt, dass eine der Pfeiltasten im Fenster gedrückt und wieder losgelassen wurde,also Pfeil beenden 
	
   HomeAnschlagSet = [[NSMutableIndexSet indexSet]retain];
   
   schliessencounter=0;	// Zaehlt FensterschliessenAktionen
    
    ignoreDuplicates=1;
   
   pwm=0;
	int  r;
	char buf[64];
    
	r = rawhid_open(1, 0x16C0, 0x0480, 0xFFAB, 0x0200);
	if (r <= 0) 
    {
        NSLog(@"no rawhid device found");
       //printf("no rawhid device found\n");
       [AVR setUSB_Device_Status:0];
       usbstatus=0;
       //USBStatus=0;
	}
   else
   {
      NSLog(@"awake found rawhid device");
      [AVR setUSB_Device_Status:1];
      usbstatus=1;
      //USBStatus=1;
      [self StepperstromEinschalten:1];
   }
   
   
   //
   // von http://stackoverflow.com/questions/9918429/how-to-know-when-a-hid-usb-bluetooth-device-is-connected-in-cocoa
   
   IONotificationPortRef notificationPort = IONotificationPortCreate(kIOMasterPortDefault);
   CFRunLoopAddSource(CFRunLoopGetCurrent(), 
                      IONotificationPortGetRunLoopSource(notificationPort), 
                      kCFRunLoopDefaultMode);
   
   CFMutableDictionaryRef matchingDict2 = IOServiceMatching(kIOUSBDeviceClassName);
   CFRetain(matchingDict2); // Need to use it twice and IOServiceAddMatchingNotification() consumes a reference
   
   
   io_iterator_t portIterator = 0;
   // Register for notifications when a serial port is added to the system
   kern_return_t result = IOServiceAddMatchingNotification(notificationPort,
                                                           kIOPublishNotification,
                                                           matchingDict2,
                                                           DeviceAdded,
                                                           self,           
                                                           &portIterator);
   while (IOIteratorNext(portIterator)) {}; // Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
   
   // Also register for removal notifications
   IONotificationPortRef terminationNotificationPort = IONotificationPortCreate(kIOMasterPortDefault);
   CFRunLoopAddSource(CFRunLoopGetCurrent(),
                      IONotificationPortGetRunLoopSource(terminationNotificationPort),
                      kCFRunLoopDefaultMode);
   result = IOServiceAddMatchingNotification(terminationNotificationPort,
                                             kIOTerminatedNotification,
                                             matchingDict2,
                                             DeviceRemoved,
                                             self,         // refCon/contextInfo
                                             &portIterator);
   
   while (IOIteratorNext(portIterator)) {}; // Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
   
   //


}



- (void) dealloc
{
	NSLog(@"dealloc");
    [logEntries release];
    [lastValueRead release];
	[lastDataRead release];
    [super dealloc];
}


- (void) setLastValueRead:(NSData*) inData
{
   [inData retain];
   [lastValueRead release];
   lastValueRead = inData;
	
}






- (void)readPList
{
	BOOL USBDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"]retain];
	USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    USBPfad: %@",USBPfad);	
	if (USBDatenDa)
	{
		
		//NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);
		
		NSString* PListName=@"CNC.plist";
		NSString* PListPfad;
		//NSLog(@"\n\n");
		PListPfad=[USBPfad stringByAppendingPathComponent:PListName];
		NSLog(@"awake: PListPfad: %@ ",PListPfad);
		if (PListPfad)		
		{
			NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			if ([Filemanager fileExistsAtPath:PListPfad])
			{
				tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
				NSLog(@"awake: tempPListDic: %@",[tempPListDic description]);

				if ([tempPListDic objectForKey:@"koordinatentabelle"])
				{
					//NSArray* PListKoordTabelle=[tempPListDic objectForKey:@"koordinatentabelle"];
               //NSLog(@"awake: PListKoordTabelle: %@",[PListKoordTabelle description]);
            }
			}
			
		}
		//	NSLog(@"PListOK: %d",PListOK);
		
	}//USBDatenDa
   [USBPfad release];
}

- (void)savePListAktion:(NSNotification*)note
{
	BOOL USBDatenDa=NO;
	BOOL istOrdner;
	NSFileManager *Filemanager = [NSFileManager defaultManager];
	NSString* USBPfad=[[NSHomeDirectory() stringByAppendingFormat:@"%@%@",@"/Documents",@"/CNCDaten"]retain];
   NSURL* USBURL=[NSURL fileURLWithPath:USBPfad];
	USBDatenDa= ([Filemanager fileExistsAtPath:USBPfad isDirectory:&istOrdner]&&istOrdner);
	//NSLog(@"mountedVolume:    USBPfad: %@",USBPfad );	
	if (USBDatenDa)
	{
		;
	}
	else
	{
		//BOOL OrdnerOK=[Filemanager createDirectoryAtPath:USBPfad attributes:NULL];
		BOOL OrdnerOK=[Filemanager createDirectoryAtURL:USBURL withIntermediateDirectories:NO attributes:nil error:nil];		//Datenordner ist noch leer
		
	}
	//	NSLog(@"savePListAktion: PListDic: %@",[PListDic description]);
	//	NSLog(@"savePListAktion: PListDic: Testarray:  %@",[[PListDic objectForKey:@"testarray"]description]);
	NSString* PListName=@"CNC.plist";
	
	NSString* PListPfad;
	//NSLog(@"\n\n");
	//NSLog(@"savePListAktion: SndCalcPfad: %@ ",SndCalcPfad);
	PListPfad=[USBPfad stringByAppendingPathComponent:PListName];
   NSURL* PListURL = [NSURL fileURLWithPath:PListPfad];
	//	NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
	
   if (PListPfad)
	{
		//NSLog(@"savePListAktion: PListPfad: %@ ",PListPfad);
		
      
      
     
		NSMutableDictionary* tempPListDic;//=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
		NSFileManager *Filemanager=[NSFileManager defaultManager];
		if ([Filemanager fileExistsAtPath:PListPfad])
		{
			tempPListDic=[NSMutableDictionary dictionaryWithContentsOfFile:PListPfad];
			//NSLog(@"savePListAktion: vorhandener PListDic: %@",[tempPListDic description]);
		}
		
		else
		{
			tempPListDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			//NSLog(@"savePListAktion: neuer PListDic");
		}
		//[tempPListDic setObject:[NSNumber numberWithInt:AnzahlAufgaben] forKey:@"anzahlaufgaben"];
		//[tempPListDic setObject:[NSNumber numberWithInt:MaximalZeit] forKey:@"zeit"];

		if ([[AVR KoordinatenTabelle]count])
		{
	//		[tempPListDic setObject:[AVR KoordinatenTabelle] forKey:@"koordinatentabelle"];
		}
      int cncspeed = [AVR speed];
      [tempPListDic setObject:[NSNumber numberWithInt:[AVR speed]] forKey:@"speed"];
      int pwm = [AVR pwm2save];
      [tempPListDic setObject:[NSNumber numberWithInt:[AVR pwm2save]] forKey:@"pwm"];
		//NSLog(@"savePListAktion: gesicherter PListDic: %@",[tempPListDic description]);
		
		BOOL PListOK=[tempPListDic writeToURL:PListURL atomically:YES];
		
	}
	//	NSLog(@"PListOK: %d",PListOK);
	
	//[tempUserInfo release];
}

- (BOOL)windowShouldClose:(id)sender
{
	NSLog(@"windowShouldClose");
/*	
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	NSMutableDictionary* BeendenDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];

	[nc postNotificationName:@"IOWarriorBeenden" object:self userInfo:BeendenDic];

*/
	
	return YES;
}

- (BOOL)Beenden
{
	NSLog(@"Beenden");
   [AVR DC_ON:0];
   [AVR setStepperstrom:0];
//   if (schliessencounter ==0)
   {
      NSLog(@"Beenden savePListAktion");
      [self savePListAktion:NULL];
   }
	return YES;
}

- (void) FensterSchliessenAktion:(NSNotification*)note
{
   //NSLog(@"FensterSchliessenAktion note: %@ schliessencounter: %d",[[note object]title],schliessencounter);
	if (schliessencounter)
	{
		return;
	}
//	NSLog(@"Fenster Schliessen");
		
   if ([[[note object]title]length])
   {
      schliessencounter++;
      NSLog(@"hat Title");
      // "New Folder" wird bei 10.6.8 als Titel von open zurueckgegeben. Deshalb ausschliessen(iBook schwarz)
      if (!([[[note object]title]isEqualToString:@"CNC-Eingabe"]||[[[note object]title]isEqualToString:@"New Folder"]))
      {
         if ([self Beenden])
         {
            [NSApp terminate:self];
         }
      }
   }
   

	//if ([self Beenden])
	{
//		[NSApp terminate:self];
		
	}
	//return YES;
}


- (void)BeendenAktion:(NSNotification*)note
{
NSLog(@"BeendenAktion");
[self terminate:self];
}


- (IBAction)terminate:(id)sender
{
	BOOL OK=[self Beenden];
	NSLog(@"terminate: OK: %d",OK);
	if (OK)
	{
      
		[NSApp terminate:self];
		
	}
	


}


@end
