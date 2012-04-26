//
//  rEinstellungenController.m
//  WebInterface
//
//  Created by Sysadmin on 11.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import "IOWarriorWindowController.h"


@implementation IOWarriorWindowController(rEinstellungenController)
	//CNC_Fenster = [[rEinstellungen alloc]init];
- (IBAction)showEinstellungen:(id)sender
{
NSLog(@"showEinstellungenFenster");
	if (!CNC_Fenster)
	{
		//[self Alert:@"showEinstellungenFenster vor init"];
		NSLog(@"showEinstellungenFenster neu");
		
		CNC_Fenster=[[rEinstellungen alloc]init];
		
		//[CNC_Fenster showWindow:self];

		//[self Alert:@"showEinstellungenFenster nach init"];
	}
	[CNC_Fenster showWindow:NULL];

}

@end
