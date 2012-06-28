//
//  rCNC.h
//  IOW_Stepper
//
//  Created by Sysadmin on 26.April.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rUtils.h"


@interface rCNC : NSObject 
{
	NSMutableArray*		DatenArray;
	int			speed;
	int			steps;

}
- (int)steps;
- (void)setSteps:(int)dieSteps;
- (void)setDatenArray:(NSArray*)derDatenArray;
- (NSArray*)DatenArray;
- (void)setSpeed:(float)dieGeschwindigkeit;
- (int)speed;
- (NSDictionary*)SteuerdatenVonDic:(NSDictionary*)derDatenDic;
- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic;

- (NSArray*)PfeilvonPunkt:(NSPoint) Startpunkt mitLaenge:(int)laenge inRichtung:(int)richtung;
- (NSArray*)LinieVonPunkt:(NSPoint)Anfangspunkt mitLaenge:(float)laenge mitWinkel:(int)winkel;

- (NSArray*)QuadratVonPunkt:(NSPoint)EckeLinksUnten mitSeite:(float)Seite mitLage:(int)Lage;
- (NSArray*)QuadratKoordinatenMitSeite:(float)Seite mitWinkel:(float)Winkel;

- (NSArray*)KreisVonPunkt:(NSPoint)Startpunkt mitRadius:(float)Radius mitLage:(int)Lage;
- (NSArray*)KreisKoordinatenMitRadius:(float)Radius mitLage:(int)Lage;
- (NSArray*)KreisKoordinatenMitRadius:(float)Radius mitLage:(int)Lage  mitAnzahlPunkten:(int)anzahlPunkte;
- (NSArray*)KreisabschnitteVonKreiskoordinaten:(NSArray*)dieKreiskoordiaten  mitRadius:(float)Radius;
- (NSArray*)EllipsenKoordinatenMitRadiusA:(float)RadiusA mitRadiusB:(float)RadiusB mitLage:(int)Lage;
- (NSArray*)EllipsenKoordinatenMitRadiusA:(float)RadiusA mitRadiusB:(float)RadiusB mitLage:(int)Lage mitAnzahlPunkten:(int)anzahlPunkte;

- (NSArray*)ProfilVonPunkt:(NSPoint)Startpunkt mitProfil:(NSDictionary*)ProfilDic mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale;
- (NSDictionary*)ProfilDicVonPunkt:(NSPoint)Startpunkt mitProfil:(NSArray*)ProfilArray mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale;

- (float) EndleistenwinkelvonProfil:(NSArray*)profil;
- (NSArray*)EndleisteneinlaufMitWinkel:(float)winkel mitLaenge:(float)laenge  mitTiefe:(float)tiefe;
- (NSArray*)NasenleistenauslaufMitLaenge:(float)laenge  mitTiefe:(float)tiefe;

- (NSMutableArray*)addAbbrandVonKoordinaten:(NSArray*)Koordinatentabelle mitAbbrandA:(float)abbrand  mitAbbrandB:(float)abbrandmassb aufSeite:(int)seite von:(int)von bis:(int)bis;

@end
