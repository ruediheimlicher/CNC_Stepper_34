//
//  rProfil_DS.h
//  USBInterface
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rProfil_DS : NSObject <NSTableViewDataSource>
{
NSMutableArray* ProfilTabelle;
//NSMutableArray* DumpTabelle;

}
- (void)setProfilTabelle:(NSArray*) derProfilPlan;
- (void)clearProfilTabelle;
- (NSArray*)ProfilTabelle;
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
    objectValueForTableColumn:(NSTableColumn *)aTableColumn 
			row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView 
   setObjectValue:(id)anObject 
   forTableColumn:(NSTableColumn *)aTableColumn 
			  row:(int)rowIndex;			
@end
