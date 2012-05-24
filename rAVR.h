//
//  rAVR.h
//  USBInterface
//
//  Created by Sysadmin on 01.02.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "rProfil_DS.h"
#import "rDump_DS.h"
#import "rProfilGraph.h"
#import "rCNC.h"
#import "rUtils.h"
#import "datum.c"
#import "version.c"
#import "rEinstellungen.h"
/*
@interface rPfeiltasteCell : NSButtonCell 
{
   int richtung;
}
- (void)setRichtung:(int)dieRichtung;
@end
*/

@interface rPfeiltaste : NSButton 
{
   int richtung;
   IBOutlet id Taste;
}
- (IBAction)reportPfeiltaste:(id)sender;
- (void)setRichtung:(int)dieRichtung;
- (int)Richtung;
- (int)Tastestatus;
@end


@interface rAVR : NSWindowController <NSTableViewDataSource,NSTableViewDelegate>
{
   NSMutableDictionary*		CNC_Plist;
   IBOutlet id					StepperTab;
   IBOutlet	id					ProfilFeld;
   
   IBOutlet	id					ProfilTiefeFeldA;
   
   IBOutlet	id					ProfilTiefeFeldB;
   
   IBOutlet	id					ProfilBOffsetYFeld;
   IBOutlet	id					ProfilBOffsetXFeld;
   
   IBOutlet	id					ProfilWrenchFeld;// Schränkung
   IBOutlet	id					ProfilWrenchEinheitRadio;
   IBOutlet	id					HorizontalSchieberFeld;
   IBOutlet	id					VertikalSchieberFeld;
   IBOutlet	id					HorizontalSchieber;
   IBOutlet	id					VertikalSchieber;
   
   IBOutlet	id					SpeedStepper;
   IBOutlet	id					SpeedFeld;
   
   NSTableView*				ProfilTable;
   NSMutableArray*			ProfilDaten;
   NSArray*						ProfilDatenOA;
   NSArray*						ProfilDatenUA;
   IBOutlet	id					ProfilNameFeldA;

   NSArray*						ProfilDatenOB;
   NSArray*						ProfilDatenUB;
   IBOutlet	id					ProfilNameFeldB;
   
   
   IBOutlet	id					StopKoordinate;
   IBOutlet	id					StartKoordinate;
   IBOutlet	id					Adresse;
   IBOutlet	id					Cmd;
   IBOutlet	id					Drehgeber;
   IBOutlet	id					DrehgeberFeld;
   
//   IBOutlet	id					StartKnopf;
//   IBOutlet	id					StopKnopf;
   
   IBOutlet	id					CNCKnopf;
   IBOutlet	id					OberseiteCheckbox;
   IBOutlet	id					UnterseiteCheckbox;
   IBOutlet	id					OberseiteTaste;
   IBOutlet	id					UnterseiteTaste;
   IBOutlet id             EinlaufCheckbox;
   IBOutlet id             AuslaufCheckbox;
   
   IBOutlet id             AbbrandCheckbox;

   IBOutlet	id					ScalePop;
   IBOutlet	id					CNCPositionFeld;
   IBOutlet	id					CNCStepXFeld;
   IBOutlet	id					CNCStepYFeld;
   int							Scale;
   int							cncposition;
   int							cncstatus;
   
   //rProfil_DS*					Profil_DS;
   //rDump_DS*					Dump_DS;
   
   NSString*					CNCdataPfad;
   NSMutableArray*			EEPROMArray;
   NSMutableArray*			KoordinatenTabelle;
   
   NSMutableArray*			UndoKoordinatenTabelle;
   NSMutableIndexSet*      UndoSet;

   NSMutableArray*			BlockKoordinatenTabelle;
   NSMutableArray*			BlockrahmenArray;

   NSPoint						oldMauspunkt;
   rProfilGraph*				ProfilGraph;
   int							GraphEnd;
   IBOutlet	NSTableView*	CNCTable;
   IBOutlet	NSScrollView*	CNCScroller;
   
   rCNC*							CNC;
   int                     CNC_busy;
   
   NSTimer*						CNCTimer;
   
   int							ProfilTiefe;
   float							ProfilZoom;
   NSPoint						ProfilNullpunkt;
   int                     mitOberseite;
   int                     mitUnterseite;
   int                     mitEinlauf;
   int                     mitAuslauf;
   int                     flipH;
   int                     flipV;
   int                     reverse;
   
   int einlauflaenge;
   int einlauftiefe;
   int einlaufrand;
   
   int auslauflaenge;
   int auslauftiefe;
   int auslaufrand;
   
   
   
   NSMutableArray*			CNCDatenArray;
   NSMutableArray*			SchnittdatenArray;
   
   NSTimer*						IOWTimer;
   int							AnzahlDaten;
   int							n;
   int							aktuellerTag;
   int							IOW_busy;
   int							aktuelleMark;
   NSMutableDictionary*		StepperDic;
   rUtils*						Utils;
   
   NSMutableArray*			Eingangsdaten;
   // TWI
   
   IBOutlet id					TWI_Statustaste;
   IBOutlet id					TWI_Sendtaste;
   
   // CNC
   IBOutlet id					CNC_Preparetaste;
   IBOutlet id					CNC_Starttaste;
   IBOutlet id					CNC_Stoptaste;
   IBOutlet id					CNC_Sendtaste;
   IBOutlet id					CNC_Terminatetaste;
   IBOutlet id					CNC_Neutaste;
   IBOutlet id					CNC_Halttaste;
   IBOutlet id             DC_Taste;
   IBOutlet id             DC_Stepper;
   IBOutlet id             DC_PWM;

   IBOutlet id					CNC_Uptaste;
   IBOutlet id					CNC_Downtaste;
   IBOutlet id					CNC_Lefttaste;
   IBOutlet id					CNC_busySpinner;
   
   IBOutlet id             CNC_Linkstaste;
   
   IBOutlet id					CNC_Righttaste;
   
   IBOutlet id					CNC_Seite1Check;
   IBOutlet id					CNC_Seite2Check;
   
   IBOutlet id					CNC_BlockKonfigurierenTaste;
   IBOutlet id					CNC_BlockAnfuegenTaste;

   
   IBOutlet rPfeiltaste*             TestPfeiltaste;
   
   IBOutlet id					IndexFeld;
   IBOutlet id					IndexStepper;
   IBOutlet id					WertXFeld;
   IBOutlet id					WertXStepper;
   IBOutlet id					WertYFeld;
   IBOutlet id					WertYStepper;
   IBOutlet id					LagePop;
   IBOutlet id					WinkelFeld;
   IBOutlet id					WinkelStepper;

   IBOutlet id					PWMFeld;
   IBOutlet id					PWMStepper;

   IBOutlet id					AbbrandFeld;
    
   IBOutlet	id					GleichesProfilRadioKnopf;
   IBOutlet id					WertFeld;
   
   IBOutlet id					PositionFeld;
   
   IBOutlet id					SaveChangeTaste;
   IBOutlet id					ShiftAllTaste;
   
   IBOutlet id					Blockoberkante;
   IBOutlet id					OberkantenStepper;
   IBOutlet id					Blockbreite;
   IBOutlet id					Blockdicke;
   IBOutlet id					Blockrand;
   IBOutlet id					AnschlagLinksIndikator;
   IBOutlet id					AnschlagUntenIndikator;
   
   IBOutlet id					USBKontrolle;
   
   IBOutlet id					HomeTaste;

   IBOutlet id					SeitenVertauschenTaste;
   IBOutlet id					RechtsLinksRadio;

   NSMutableDictionary*		AnschlagDic;

   
   IBOutlet id					VersionFeld;
   IBOutlet id					DatumFeld;
   int                     startwert;
   NSWindow*					window;
   int                     mausistdown;
   int                     quelle;
   
   rEinstellungen*			CNC_Eingabe;
  
   int                     AVR_USBStatus;
}
- (NSMutableDictionary*)readCNC_PList;
- (IBAction)reportUSB:(id)sender;
- (void)setUSB_Device_Status:(int)status;
- (IBAction)reportHorizontalSchieber:(id)sender;
- (IBAction)reportVertikalSchieber:(id)sender;
- (IBAction)reportDrehgeber:(id)sender;
- (IBAction)reportStartKnopf:(id)sender;
- (IBAction)reportStopKnopf:(id)sender;
- (void)DC_ON:(int)pwm;
- (int)pwm;
- (void)setStepperstrom:(int)ein;
- (void)setBusy:(int)busy;
- (int)speed;
- (int)saveSpeed;
- (IBAction)reportSpeedStepper:(id)sender;

- (IBAction)reportCNCKnopf:(id)sender;
- (IBAction)reportOberseiteTaste:(id)sender;
- (IBAction)reportUnterseiteTaste:(id)sender;
- (IBAction)reportProfil:(id)sender;
- (IBAction)reportClearProfilTabelle:(id)sender;
- (IBAction)reportScalePop:(id)sender;
- (IBAction)reportHaltTaste:(id)sender;
- (IBAction)reportIndexStepper:(id)sender;
- (IBAction)reportWertXStepper:(id)sender;
- (IBAction)reportWertYStepper:(id)sender;

- (IBAction)reportPWMStepper:(id)sender;

- (IBAction)reportManLeft:(id)sender;
- (IBAction)reportManRight:(id)sender;
- (IBAction)reportManUp:(id)sender;
- (IBAction)reportManDown:(id)sender;
- (void)updateIndex;
- (IBAction)reportDauerpfeilTaste:(id)sender;
- (IBAction)reportOberkanteAnfahren:(id)sender;
- (IBAction)reportHome:(id)sender;

- (IBAction)reportElementSichern:(id)sender;

- (int)mausistdown;
- (int)PfeiltasteStatus;
- (IBAction)reportQuadrat:(id)sender;
- (IBAction)reportKreis:(id)sender;
- (IBAction)reportEllipse:(id)sender;
- (NSArray*)KoordinatenTabelle;
- (IBAction)reportSaveStepperDic:(id)sender;
- (IBAction)reportZeileWeg:(id)sender;
- (IBAction)reportNeueZeile:(id)sender;
- (void)setDatenVonZeile:(int)dieZeile;
- (void)shiftX:(float)x Y:(float)y Schritt:(int)schritt;
- (IBAction)reportShiftLeft:(id)sender;
- (IBAction)reportShiftRight:(id)sender;
- (IBAction)reportShiftUp:(id)sender;
- (IBAction)reportShiftDown:(id)sender;
- (void)shiftX:(float)x Y:(float)y Schritt:(int)schritt;
- (IBAction)reportSeiteVertauschen:(id)sender;
- (IBAction)reportLinkeRechteSeite:(id)sender;

- (IBAction)reportProfilTask:(id)sender;
- (IBAction)reportEdgeTask:(id)sender;
// SPI


// TWI
//- (void)writeAVR:(int)i2cAdresse mitDaten:(NSArray*)dieDaten;
- (IBAction)reportUSB_sendArray:(id)sender;
- (IBAction)reportPrepareTaste:(id)sender;
- (IBAction)reportNeuTaste:(id)sender;
- (IBAction)terminateTransfer:(id)sender;

- (IBAction)ok:(id)sender;
- (void)HomebusAnlegen;
- (void)saveLabel:(NSString*)dasLabel forRaum:(int)derRaum forSegment:(int)dasSegment;
- (void)checkHomebus;
- (int)saveStepperDic;
- (int)sendData:(NSArray*)dieDaten;
- (int)sendReport:(NSString*)derReport mitDaten:(NSArray*)dieDaten;
- (NSString*)IntToBin:(int)dieZahl;
- (int)halt;
- (NSArray*)readLib;
- (void)Blockeinfuegen;
- (IBAction)reportBlockkonfigurieren:(id)sender;
- (IBAction)reportBlockanfuegen:(id)sender;

- (int)saveStepperDic:(id)sender;
@end
