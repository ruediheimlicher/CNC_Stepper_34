//
//  rTagplan.h
//  SndCalcII
//
//  Created by Sysadmin on 13.02.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rTagplan : NSView 
{
NSString* Wochentag;
int tag;
int Hoehe, Breite, Balkenbreite;
int Elementbreite,  Elementhoehe, RandL, RandR, RandU;
NSPoint						Nullpunkt;
NSMutableArray*				StundenArray;
NSMutableArray*				lastONArray;
}
- (void)setTagplan:(NSArray*)derStundenArray forTag:(int)derTag;
- (void)setNullpunkt:(NSPoint)derPunkt;
- (void)setStundenarraywert:(int)derWert vonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (int)StundenarraywertVonStunde:(int)dieStunde forKey:(NSString*)derKey;
- (void)drawRect:(NSRect)dasFeld;
@end
