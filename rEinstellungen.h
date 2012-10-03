//
//  rEinstellungen.h
//  WebInterface
//
//  Created by Sysadmin on 12.November.09.
//  Copyright 2009 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "rUtils.h"
#import "rCNC.h"

@interface rGraph : NSControl 
{
   NSDictionary*    DatenDic;
   NSPoint     StartPunkt;
   NSPoint     EndPunkt;
   NSPoint     Mittelpunkt;
   NSBezierPath* Graph;
   NSColor*    GraphFarbe;
   NSPoint     oldMauspunkt;
   int         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         klickpunkt;
   NSRange     klickrange;
   NSMutableIndexSet* klickset;
   int         startklickpunkt;
}

- (void)setDaten:(NSDictionary*)datenDic;
@end

@interface rLibGraph : NSControl 
{
   NSDictionary*    DatenDic;
   NSPoint     StartPunkt;
   NSPoint     EndPunkt;
   NSPoint     Mittelpunkt;
   NSBezierPath* Graph;
   NSColor*    GraphFarbe;
   NSPoint     oldMauspunkt;
   float         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         klickpunkt;
   NSRange     klickrange;
   NSMutableIndexSet* klickset;
   int         startklickpunkt;
   NSMutableArray* ElementArray;
   
}
- (void)GitterZeichnenMitUrsprung:(NSPoint)ursprung;
- (void)setDaten:(NSDictionary*)datenDic;
- (void)clearGraph;
@end

@interface rProfilLibGraph : NSControl 
{
   NSDictionary*    DatenDic;
   NSPoint     StartPunkt;
   NSPoint     EndPunkt;
   NSPoint     Mittelpunkt;
   NSBezierPath* Graph;
   NSColor*    GraphFarbe;
   NSPoint     oldMauspunkt;
   float         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         klickpunkt;
   NSRange     klickrange;
   NSMutableIndexSet* klickset;
   int         startklickpunkt;
   NSMutableArray* ElementArray;
   NSMutableArray* Profil1Array;
   NSMutableArray* Profil2Array;
   int         anzPunkte1;
   int         anzPunkte2;

}
- (void)GitterZeichnenMitUrsprung:(NSPoint)ursprung;
- (void)setDaten:(NSDictionary*)datenDic;
- (void)clearGraph;
@end


@interface rFigGraph : NSControl 
{
   NSDictionary*    DatenDic;
   NSPoint     StartPunkt;
   NSPoint     EndPunkt;
   NSPoint     Mittelpunkt;
   NSBezierPath* Graph;
   NSColor*    GraphFarbe;
   NSPoint     oldMauspunkt;
   float         scale; // Massstab fuer die Darstellung. Uebergebene Masse sind in mm
   int         mausistdown;
   int         klickpunkt;
   NSRange     klickrange;
   NSMutableIndexSet* klickset;
   int         startklickpunkt;
   NSMutableArray* ElementArray;
   
}
- (void)GitterZeichnenMitUrsprung:(NSPoint)ursprung;
- (void)setDaten:(NSDictionary*)datenDic;
- (void)clearGraph;
@end


@interface rEinstellungen : NSWindowController 
{
   // Element
   IBOutlet id    Element;
   IBOutlet id    StartpunktX;
   IBOutlet id    StartpunktY;
   
   IBOutlet id    StartpunktXStepper;
   IBOutlet id    StartpunktXSlider;
   IBOutlet id    StartpunktYStepper;
   IBOutlet id    StartpunktYSlider;
   
   IBOutlet id    EndpunktX;
   IBOutlet id    EndpunktY;
   IBOutlet id    EndpunktXStepper;
   IBOutlet id    EndpunktXSlider;
   IBOutlet id    EndpunktYStepper;
   IBOutlet id    EndpunktYSlider;
   
   IBOutlet id    deltaX;
   IBOutlet id    deltaXStepper;
   IBOutlet id    deltaXSlider;
   
   IBOutlet id    deltaY;
   IBOutlet id    deltaYStepper;
   IBOutlet id    deltaYSlider;
   
   IBOutlet id    Laenge;
   IBOutlet id    LaengeStepper;
   IBOutlet id    LaengeSlider;
   IBOutlet id    Winkel;
   IBOutlet id    WinkelStepper;
   IBOutlet id    WinkelSlider;
   IBOutlet id    WinkelMatrix;
   IBOutlet id    Graph;
   
   float startx, starty;
   float zoom;
   
   // Lib
   IBOutlet id    LibElement;
   IBOutlet id    LibElemente;
   IBOutlet id    LibStartpunktX;
   IBOutlet id    LibStartpunktY;
   IBOutlet id    LibEndpunktX;
   IBOutlet id    LibEndpunktY;
   IBOutlet id    LibGraph;
   IBOutlet id    LibPop;
   IBOutlet id    libstartx;
   IBOutlet id    libstarty;
   
   NSMutableArray*       ElementLibArray;
   
   NSString*         LibElementName;
   NSMutableArray*   LibElementArray;
   NSString*         LibElementPfad;
   
   // Profil
   IBOutlet id          Profile1;
   IBOutlet id          Profile2;

   IBOutlet id          Profil2Tiefe;
   IBOutlet id          Profil1Tiefe;
   
   IBOutlet id          ProfilStartpunktX;
   IBOutlet id          ProfilStartpunktY;
   IBOutlet id          ProfilEndpunktX;
   IBOutlet id          ProfilEndpunktY;
   IBOutlet id          ProfilGraph;
   IBOutlet id          ProfilPop;
   IBOutlet id          Profilstartx;
   IBOutlet id          Profilstarty;
   
   //IBOutlet id          Profiltiefe1;
   //IBOutlet id          Profiltiefe2;
   //IBOutlet id          Profilwrest2;
   
   IBOutlet id          OberseiteCheck;
   IBOutlet id          UnterseiteCheck;
   IBOutlet id          EinlaufCheck;
   IBOutlet id          AuslaufCheck;

   IBOutlet id          Auslauflaenge;
   IBOutlet id          Auslauftiefe;
   IBOutlet id          Einlauflaenge;
   IBOutlet id          Einlauftiefe;
   IBOutlet id          Einlaufrand;
   IBOutlet id          Auslaufrand;
 
   IBOutlet id          FlipHTaste;
   IBOutlet id          FlipVTaste;
   IBOutlet id          ReverseTaste;
   IBOutlet id          ProfilEinfuegenTaste;
   
   IBOutlet id          AbbrandmassA;
   IBOutlet id          AbbrandmassB;
   
   NSMutableArray*      ProfilLibArray;
   NSString*            Profil1Name;
   NSString*            Profil2Name;
   NSMutableArray*      Profil1Array;
   NSMutableArray*      Profil2Array;
   NSString*            ProfilLibPfad;
   int                  flipH;
   int                  flipV;
   int                  reverse;

   // Form
   IBOutlet id          SeiteA1;
   IBOutlet id          SeiteB1;
   IBOutlet id          Winkel1;
   
   IBOutlet id          SeiteA2;
   IBOutlet id          SeiteB2;
   IBOutlet id          Winkel2;
   
   IBOutlet id          Form1Pop;
   IBOutlet id          Form2Pop;
   IBOutlet id          LagePop;
   
   IBOutlet id          AnzahlPunkte;

   NSArray*             FormNamenArray;
   NSString*            FormName;
   NSMutableArray*      Form1KoordinatenArray;
   NSMutableArray*      Form2KoordinatenArray;
   NSMutableArray*      BlockKoordinatenArray;
   
   // Block
   IBOutlet id          Blockoberkante;
   IBOutlet id          BlockoberkanteStepper;
   IBOutlet id          Auslaufkote;
   IBOutlet id          Blockbreite;
   IBOutlet id          Blockdicke;
   
    
   
   // Figur extern
   IBOutlet id          FigGraph;
   IBOutlet id          FigStartpunktX;
   IBOutlet id          FigStartpunktY;
   IBOutlet id          FigEndpunktX;
   IBOutlet id          FigEndpunktY;
   
   NSMutableArray*      FigElementArray;
   NSString*            FigElementPfad;

   
   
   rUtils*              Utils;
   rCNC*                CNC;
   NSMutableDictionary* PList;

}

- (void)setDaten:(NSDictionary*)daten;
- (void)setGraphDaten;
- (IBAction)reportLinieEinfuegen:(id)sender;
- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportWinkelmatrixknopf:(id)sender;
- (float)calcLaenge;
- (float)calcX;
- (float)calcY;

// Lib
- (NSArray*)readLib;
- (int)SetLibElemente:(NSArray*)LibArray;
- (IBAction)reportLibPop:(id)sender;
- (IBAction)reportLibElementEinfuegen:(id)sender;
- (IBAction)reportLibElementLoeschen:(id)sender;
- (IBAction)reportLibElementSpiegelnHorizontal:(id)sender;
- (IBAction)reportLibElementSpiegelnVertikal:(id)sender;
- (IBAction)reportLibElementAnfangZuEnde:(id)sender;
- (void)doLibTaskMitElement:(int)Elementnummer;
- (void)setLibGraphDaten;

// Profil
- (NSArray*)readProfilLib;
- (void)SetLibProfile:(NSArray*)profile;
- (IBAction)reportProfilPop:(id)sender;
- (IBAction)reportProfilEinfuegen:(id)sender;
- (IBAction)reportProfilLoeschen:(id)sender;
- (IBAction)reportProfilSpiegelnHorizontal:(id)sender;
- (IBAction)reportProfilSpiegelnVertikal:(id)sender;
- (void)doProfilSpiegelnVertikalTask;
- (IBAction)reportProfilAnfangZuEnde:(id)sender;

- (void)setProfilGraphDaten;
- (void)clearProfilGraphDaten;

// von 32
- (void)doProfil1PopTaskMitProfil:(int)profil1;
- (void)doProfilEinfuegenTask;
- (void)setOberseite:(int) ein;
- (void)setUnterseite:(int) ein;
- (void)doSchliessenTask;


// Form
- (IBAction)reportForm1Pop:(id)sender;
- (IBAction)reportForm2Pop:(id)sender;
- (IBAction)reportLagePop:(id)sender;
- (IBAction)reportFormEinfuegen:(id)sender;

// Block
- (IBAction)reportBlockEinfuegen:(id)sender;
- (IBAction)reportOberkanteStepper:(id)sender;

// Extern
- (IBAction)reportReadFigur:(id)sender;
- (NSArray*)readFigur;
//- (int)SetFigElemente:(NSArray*)LibArray;
//- (IBAction)reportLibPop:(id)sender;
- (IBAction)reportFigElementEinfuegen:(id)sender;
- (IBAction)reportFigElementLoeschen:(id)sender;
- (IBAction)reportFigElementSpiegelnHorizontal:(id)sender;
- (IBAction)reportFigElementSpiegelnVertikal:(id)sender;
- (IBAction)reportFigElementAnfangZuEnde:(id)sender;
- (void)setFigGraphDaten;



- (void)setPList:(NSDictionary*)plist;
- (NSDictionary*)PList;

@end
