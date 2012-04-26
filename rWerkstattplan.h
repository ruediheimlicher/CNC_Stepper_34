//
//  rWerkstattplan.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rWerkstattplan : NSView 
{

NSString* Wochentag;
int tag;
int Hoehe, Breite, Balkenbreite;
int Elementbreite,  Elementhoehe, RandL, RandR, RandU;

int AnzPlaene;

NSPoint						Nullpunkt;
NSMutableArray*				StundenArray;
NSMutableArray*				lastONArray;
}
- (void)setWochenplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (void)drawRect:(NSRect)dasFeld;
@end
