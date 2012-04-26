//
//  rDump_DS.m
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rDump_DS.h"



@implementation rDump_DS

- (id)init
{

	DumpTabelle=[[NSMutableArray alloc]initWithCapacity:0];
	[DumpTabelle retain];
	return self;
}


- (void)setDumpTabelle:(NSArray*)dieDumpTabelle
{
	//NSLog(@"Dump_DS setDumpTabelle: dieDumpTabelle: %@",[dieDumpTabelle description]);
	int anzReports=[dieDumpTabelle count];
	int i;
	for (i=0;i<anzReports;i++)
	{
//	NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	
//	[tempDic setObject:[NSNumber numberWithInt:3] forKey:@"drei"];

	[DumpTabelle addObject:[dieDumpTabelle objectAtIndex:i]];
	}
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

	[DumpTabelle addObject:tempTagDic];
	
	
	}
	
}




- (int)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [DumpTabelle count];
}


- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex
{
	//NSLog(@"objectValueForTableColumn");
    NSDictionary *einTestDic;
	if (rowIndex<[DumpTabelle count])
	{
			einTestDic = [DumpTabelle objectAtIndex: rowIndex];
			
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
		einTestDic=[DumpTabelle objectAtIndex:rowIndex];
		[einTestDic setObject:anObject forKey:[aTableColumn identifier]];
	}
}

@end
