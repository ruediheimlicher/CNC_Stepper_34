//
//  rHexEingabe.h
//  IOWarriorProber
//
//  Created by Sysadmin on 26.01.06.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rHexView.h"

@interface rHexFeld: NSTextField
{

}
- (void)keyDown:(NSEvent *)theEvent;
@end


@interface rHexEingabe : NSView 
{
int					KolonnenRaster;
int					ZeilenRaster;
int					Tastenhoehe;
int					Anzeigehoehe;
int					Hexfeldhoehe;
int					PortTastenhoehe;
NSPoint				Nullpunkt;
NSRect				Rahmen;
NSMutableArray*		TastenArray;
NSMutableArray*		AnzeigenArray;
NSMutableArray*		TextfeldArray;
NSMutableArray*		PortTastenArray;
NSMutableArray*		BitArray;
NSArray*			HexArray;
NSCharacterSet*		HexSet;

int					PaketNummer;
NSButton*			ClearTaste;
NSButton*			SendTaste;
NSButton*			AllTaste;
NSSegmentedControl*	PortTaste;
NSPopUpButton*		PaketNummerPop;
NSTextField*		PaketNummerTitelFeld;
rHexView*			HexFeld;

}
- (NSString*)HexFeld;
- (id)initWithFrame:(NSRect)derRahmen;
- (void)setPaketNummer:(int)dieNummer;
- (NSString*)HexAusBitArray:(NSArray*)derBitArray;
- (NSArray*)BitArrayAusHex:(NSString*)derHexString;
- (IBAction)ClearTastenAktion:(id)sender;
- (IBAction)SendTastenAktion:(id)sender;
- (IBAction)AllTastenAktion:(id)sender;
- (void)setState:(BOOL)derStatus forTaste:(int)dieTaste;
- (void)setBitAnzeigeMitArray:(NSArray*)derBitArray;
@end
