//
//  rInput.m
//  IOWarriorProber
//
//  Created by Sysadmin on 19.02.06.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "IOWarriorWindowController.h"
#import "IOWarriorLib.h"

void reportHandlerCallback (void *	 		target,
                            IOReturn                     result,
                            void * 			refcon,
                            void * 			sender,
                            UInt32		 	bufferSize);

@implementation  IOWarriorWindowController(rInput)
static NSString* kReportDirectionIn = @"R";
static NSString* kReportDirectionOut = @"W";




- (NSArray*)ReadHexStringArray
{
	//[readTimer				invalidate];
	IOWarriorListNode*		listNode;
	
	UInt8*					buffer;
    int						result = 0;
    int						reportID = -1;
    NSData*					dataRead;
    int						reportSize;
	
	NSLog(@"ReadHexStringArray: kReportDirectionIn: %@",kReportDirectionIn);
	
	NSMutableArray*	InputArray=[[NSMutableArray alloc]initWithCapacity:0];
	int i;
	for (i=0;i<4;i++)
	{
	[InputArray addObject:@"00"];
	}
	listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
	if (nil == listNode) // if there is no interface, exit and don't invoke timer again
		return InputArray;

	if (listNode->interfaceType == kIOWarrior24Interface0 ||
		listNode->interfaceType == kIOWarrior40Interface0)
	{
		// if user has selected some kind of interface0, read every 0.05 seconds using getReport request
		[self setLastDataRead:nil];
		// read immediatly
		
	    reportSize = [self reportSizeForInterfaceType:listNode->interfaceType];
		if (listNode->interfaceType == kIOWarrior24Interface0 ||
			listNode->interfaceType == kIOWarrior40Interface0)
		{
			//NSLog(@"ReadHexStringArray: reportSize: %d",reportSize);
			buffer = malloc (reportSize);
			
			result = IOWarriorReadFromInterface (listNode->ioWarriorHIDInterface, 0, reportSize, buffer);
			
			if (result != 0)
			{
				NSRunAlertPanel (@"IOWarrior Error", @"An error occured while trying to read from the selected IOWarrior device.", @"OK", nil, nil);
				[self doRead:self]; // invalidates timer
				return InputArray;
			}
			dataRead = [NSData dataWithBytes:buffer length:reportSize];
			
			
			int k;
			for (k=0;k<reportSize;k++)
			{
				NSString* InputString =[NSString stringWithFormat:@"%X", (UInt8*) buffer[k]];
				if (InputString)
				{
					if ([InputString length]==1)//vorstehende Null fehlt
					{
					InputString=[@"0" stringByAppendingString:InputString];
					}
					//NSLog(@" index: %d InputString: %@",k,InputString);
					[InputArray replaceObjectAtIndex:k withObject:InputString];
				}
			}
			
			
			
			free (buffer);
		}
	
	
	}
	/*
	Notificaton in ReadIntf
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:reportSize] forKey:@"reportsize"];
	[NotificationDic setObject:InputArray forKey:@"inputarray"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	//[nc postNotificationName:@"InputArray" object:self userInfo:NotificationDic];
	*/
	//NSLog(@"ReadHexStringArray:	InputArray: %@",[InputArray description]);
	return InputArray;
}


- (IBAction)ReadIntf:(id)sender
{
//NSLog(@"ReadIntf:	Start");

NSArray* InputArray=[self ReadHexStringArray];

[InputArray retain];
NSLog(@"ReadIntf:	InputArray: %@",[InputArray description]);
//NSLog(@"ReadIntf:	HexDatenArray: %@",[HexDatenArray description]);
//[HexDatenArray retain];
//[HexDatenArray setArray:InputArray];

//[self setPortBox:HexDatenArray];


//*********** Anzeige setzen
	//NSLog(@"ReadIntf: vor Notification");
	NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[NotificationDic setObject:[NSNumber numberWithInt:2] forKey:@"reportsize"];
	//[NotificationDic setObject:HexDatenArray forKey:@"inputarray"];
	NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"InputArray" object:self userInfo:NotificationDic];
	//NSLog(@"ReadIntf nach Notification:	InputArray: %@",[InputArray description]);



//***********
return;

//[HexDatenArray setArray:InputArray];
[self setPortBox:InputArray];

}


- (void)InputAktion:(NSNotification*)note
{
//	NSLog(@"InputAktion note: %@",[[note userInfo]description]);
//	NSLog(@"InputAktion Zeit: %2.4f",[[NSDate date]timeIntervalSinceDate:[[note userInfo] objectForKey:@"startzeit"]]);
//	NSLog(@"InputAktion Zeitkompression: %2.2f",[[[note userInfo] objectForKey:@"zeitkompression"]floatValue]);
	NSArray* InputArray=[self ReadHexStringArray];
	DatenleseZeit=[NSDate date];
	[DatenleseZeit retain];
	int tempKanalNummer=[[[note userInfo]objectForKey:@"kanalnummer"]intValue];
//	NSLog(@"\n");
	//NSLog(@"InputAktion: InputArray: %@  Kanal: %d",[InputArray description],tempKanalNummer);
	NSString* tempDatenString=[InputArray objectAtIndex:1];											//Paket 1 von IOW24
	[ADWandler setHexDaten:tempDatenString forKanal:tempKanalNummer];
	
	NSNumber* IntNumber=[self NumberAusHex:tempDatenString];
	//NSLog(@"tempDatenString: %@ IntString:%@",tempDatenString,IntNumber);
	
	[ADWandler setIntDaten:[IntNumber stringValue] forKanal:tempKanalNummer];
	
	[ADWandler setAnzeigeDaten:tempDatenString forKanal:tempKanalNummer];
	
	[ADWandler setGraphDaten:tempDatenString zurZeit:DatenleseZeit forKanal:tempKanalNummer mitVorgaben:[note userInfo]];
	

}


- (void)setPortBox:(NSArray*)derPortArray
{
//NSLog(@"setPortBox:	derPortArray: %@",[derPortArray description]);


}

- (IBAction)TrackIntf:(id)sender
{
NSLog(@"TrackIntf: isTracking: %d",isTracking);

  //  if (isTracking)
    {
  //      [self stopTracking];
    }
		if ([sender state])
		{
        [self startTracking];
		}
		else
		{
			[self stopTracking];
		}

   
}

- (void) stopTracking
{

    [trackTimer invalidate];
	NSLog(@"trackTimer retainCount: %d",[trackTimer retainCount]);
	
    isTracking = YES;
}

- (void) startTracking
{
	NSLog(@"startTracking");
    IOWarriorListNode* 	listNode;
    
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (nil == listNode) // if there is no interface, exit and don't invoke timer again
        return;
    
    if (listNode->interfaceType == kIOWarrior24Interface0 ||
        listNode->interfaceType == kIOWarrior40Interface0)
    {
        // if user has selected some kind of interface0, read every 0.05 seconds using getReport request
        [self setLastDataRead:nil];

        // read immediatly
        [self trackRead:nil];
        // activate timer
		if ([trackTimer isValid])
		{
			NSLog(@"startTracking:	trackTimer invalidate");
			[trackTimer invalidate];
		}
        trackTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(trackRead:) userInfo:nil repeats:YES];
		[trackTimer retain];
	}
	
    else
    {
        // we have somd kind of interface1, install interrupt handler
       NSLog(@"interface1");
		 char* buffer;
        
        buffer = malloc(8);
        IOWarriorSetInterruptCallback(listNode->ioWarriorHIDInterface, buffer, 8, reportHandlerCallback, self);
    }
}



- (void)trackRead:(NSTimer*) inTimer
{
    UInt8*		buffer;
    int	 		result = 0;
    int 		reportID = -1;
    NSData*		trackDataRead;
    IOWarriorListNode* 	listNode;
    int                 reportSize;
	NSMutableArray*	trackReadArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	int i;
	NSLog(@"trackRead: start");
	for (i=0;i<4;i++)
	{
		[trackReadArray addObject:@"00"];
	}
	
    listNode = IOWarriorInterfaceListNodeAtIndex ([interfacePopup indexOfSelectedItem]);
    if (nil == listNode) // if there is no interface, exit and don't invoke timer again
        return;
    
    reportSize = [self reportSizeForInterfaceType:listNode->interfaceType];
    if (listNode->interfaceType == kIOWarrior24Interface0 ||
        listNode->interfaceType == kIOWarrior40Interface0)
    {
		
        buffer = malloc (reportSize);
      // NSLog(@"trackRead: reportSize: %d	strlen(buffer): %d",reportSize,strlen(buffer));
        result = IOWarriorReadFromInterface (listNode->ioWarriorHIDInterface, 0, reportSize, buffer);
		//NSLog(@"trackRead: reportSize: %d	strlen(buffer): %d",reportSize,strlen(buffer));

        if (result != 0)
        {
            NSRunAlertPanel (@"IOWarrior Error", @"An error occured while trying to read from the selected IOWarrior device.", @"OK", nil, nil);
            [self doRead:self]; // invalidates timer
            return ;
        }
        trackDataRead = [NSData dataWithBytes:buffer length:reportSize];
		
		//NSLog(@"trackRead: last: %@		new: %@ ",[lastDataRead description],[trackDataRead description]);

		//NSString* tempString=[trackDataRead description];
		//NSLog(@"trackRead: dataRead length: %d",[dataRead length]);
		ignoreDuplicates=YES;
		
        if (!ignoreDuplicates || (ignoreDuplicates && ![trackDataRead isEqualTo:lastDataRead]))
        {
			[self setLastDataRead:trackDataRead];
			//NSLog(@"trackRead: last: %@		new: %@ ",[lastDataRead description],[trackDataRead description]);
			int k;
			for (k=0;k<reportSize;k++)
			{
				NSString* InputString =[NSString stringWithFormat:@"%X", (UInt8*) buffer[k]];
				if (InputString)
				{
					if ([InputString length]==1)//vorstehende Null fehlt
					{
						InputString=[@"0" stringByAppendingString:InputString];
					}
					//NSLog(@" index: %d InputString: %@",k,InputString);
					[trackReadArray replaceObjectAtIndex:k withObject:InputString];
					
				}
			}
			[trackReadArray retain];
			//NSLog(@"InputArray: %@",[InputArray description]);
			NSMutableDictionary* NotificationDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
			[NotificationDic setObject:[NSNumber numberWithInt:reportSize] forKey:@"reportsize"];
			[NotificationDic setObject:trackReadArray forKey:@"inputarray"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			
			[nc postNotificationName:@"InputArray" object:self userInfo:NotificationDic];
			
			NSLog(@"trackRead:	trackReadArray: %@",[trackReadArray description]);
			
			
        }
        free (buffer);
    }
}

- (void) setLastDataRead:(NSData*) inData
{
    [inData retain];
    [lastDataRead release];
    lastDataRead = inData;
}

@end
