//
//  Utils.h
//  USBInterface
//
//  Created by Sysadmin on 09.03.07.
//  Copyright 2007 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface rUtils : NSObject {

}
- (void) logRect:(NSRect)r;
- (NSDictionary*)ProfilDatenAnPfad:(NSString*)profilpfad;
- (NSArray*)readProfil:(NSString*)profilname;
- (NSDictionary*)readProfilMitName;
- (NSDictionary*)SplinekoeffizientenVonArray:(NSArray*)dataArray;
- (NSArray*)wrenchProfil:(NSArray*)profilArray mitWrench:(float)wrench;
- (NSMutableArray*)wrenchProfilschnittlinie:(NSArray*)profilArray mitWrench:(float)wrench;
- (NSArray*)readFigur;
@end
