//
//  rAVR_DS.m
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rProfil_DS.h"



@implementation rProfil_DS

- (id)init
{

	ProfilTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	[ProfilTabelle retain];
	return self;
}

- (NSArray*)ProfilTabelle
{

return ProfilTabelle;
}
- (void)setProfilTabelle:(NSArray*)dieProfilTabelle
{
	//NSLog(@"rProfil_DS setProfilPlan: %@",[derProfilPlan description]);
	int anzReports=[dieProfilTabelle count];
	int i;
	for (i=0;i<anzReports;i++)
	{
	//NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
//	[tempTagDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];
//	[ProfilTabelle addObject:tempTagDic];
	 
	
	}
	[ProfilTabelle setArray:dieProfilTabelle];
}

- (void)clearProfilTabelle
{
[ProfilTabelle  removeAllObjects];

}

- (void)addTagplan:(NSArray*)derTagplan
{
	//NSLog(@"AVR_DS setProfilPlan");
	int anz=[derTagplan count];
	int i,k;
	k=0;
	for (i=0;i<anz;i++)
	{

	NSMutableDictionary* tempTagDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	[tempTagDic setObject:[NSNumber numberWithInt:i] forKey:@"stunde"];

	[ProfilTabelle addObject:tempTagDic];
	
	
	}
	
}




- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [ProfilTabelle count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einTestDic = [NSDictionary dictionary];
	if (rowIndex<[ProfilTabelle count])
	{
			einTestDic = [ProfilTabelle objectAtIndex: rowIndex];
			
	}
	//NSLog(@"einTestDic  Testname: %@",[einTestDic objectForKey:@"name"]);

	return [einTestDic objectForKey:[aTableColumn identifier]];
	
}

- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex
{
		//NSLog(@"setObjectValue ForTableColumn");

    NSMutableDictionary* einTestDic;
    if (rowIndex<[ProfilTabelle count])
	{
		einTestDic=[ProfilTabelle objectAtIndex:rowIndex];
		[einTestDic setObject:anObject forKey:[aTableColumn identifier]];
	}
}

@end
