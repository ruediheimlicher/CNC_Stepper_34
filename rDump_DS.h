//
//  rDump_DS.h
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rDump_DS : NSObject
{
NSMutableArray* ProfilTabelle;
NSMutableArray* DumpTabelle;

}
- (void)setDumpTabelle:(NSArray*) dieDumpTabelle;




- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex;			
@end
