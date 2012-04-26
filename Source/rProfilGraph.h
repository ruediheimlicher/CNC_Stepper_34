//
//  ProfilGraph.h
//  IOW_Stepper
//
//  Created by Sysadmin on 26.April.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rProfilGraph : NSControl 
{
   NSArray*    DatenArray;
   NSArray*    RahmenArray;
   NSPoint     StartPunktA;
   NSPoint     EndPunktA;
   NSPoint     StartPunktB;
   NSPoint     EndPunktB;
   
   NSPoint     oldMauspunkt;
   int         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         Klickpunkt;
   NSRange     klickrange;
   NSMutableIndexSet* KlicksetA;
   int         startklickpunkt;
   
   int GraphOffset;
   
}
- (void)setDatenArray:(NSArray*)derDatenArray;
- (void)setRahmenArray:(NSArray*)derRahmenArray;
- (NSArray*)DatenArray;
- (void)setScale:(int)derScalefaktor;
- (BOOL)acceptsFirstResponder;
- (BOOL)canBecomeKeyView;
- (void)keyDown:(NSEvent*)derEvent;
- (int)mausistdown;
- (void)setKlickpunkt:(int)derPunkt;
- (void)setKlickrange:(NSRange)derRange;
- (void)setGraphOffset:(int)offset;
- (int)GraphOffset;
@end
