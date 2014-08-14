//
//  rCNC.h
//  IOW_Stepper
//
//  Created by Sysadmin on 26.April.11.
//  Copyright 2011 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "rUtils.h"

float det(float v0[],float v1[]);

@interface rCNC : NSObject 
{
	NSMutableArray*		DatenArray;
	int			speed;
	int			steps;
   float red_pwm;
   float schalendicke;

}
- (int)steps;
- (void)setSteps:(int)dieSteps;
- (void)setDatenArray:(NSArray*)derDatenArray;
- (NSArray*)DatenArray;
- (void)setSpeed:(float)dieGeschwindigkeit;
- (float)speed;

- (void)setSchalendicke:(float)dieDicke;
- (int)schalendicke;


- (void)setredpwm:(float)red_pwmwert;
- (NSDictionary*)SteuerdatenVonDic:(NSDictionary*)derDatenDic;
- (NSDictionary*)SteuerdatenVonDic:(NSDictionary*)derDatenDic mitAbbrand:(int)mitabbrand;

- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic;
- (NSArray*)SchnittdatenVonDic:(NSDictionary*)derDatenDic mitAbbrand:(int)mitabbrand;
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

- (NSDictionary*)HolmDicVonPunkt:(NSPoint)Startpunkt mitProfil:(NSArray*)ProfilArray mitProfiltiefe:(int)Profiltiefe mitScale:(int)Scale;
@end
