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
   float         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         Klickpunkt;
   int         Klickseite;
   NSRange     klickrange;
   NSMutableIndexSet* KlicksetA;
   int         startklickpunkt;
   int         stepperposition;
   int anzahlmaschen;
   
   int GraphOffset;
   
}
- (void)setDatenArray:(NSArray*)derDatenArray;
- (void)setRahmenArray:(NSArray*)derRahmenArray;
- (NSArray*)DatenArray;
- (void)setScale:(float)derScalefaktor;
- (void)setStepperposition:(int)pos;
- (void)setAnzahlMaschen: (int)anzahl;
- (BOOL)acceptsFirstResponder;
- (BOOL)canBecomeKeyView;
- (void)keyDown:(NSEvent*)derEvent;
- (int)mausistdown;
- (void)setKlickpunkt:(int)derPunkt;
- (void)setKlickrange:(NSRange)derRange;
- (void)setGraphOffset:(int)offset;
- (void)GitterZeichnenMitMaschen:(int)anzahl;
- (void)GitterZeichnen;
- (int)GraphOffset;
@end
