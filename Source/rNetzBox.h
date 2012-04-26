/* rNetzBox */

#import <Cocoa/Cocoa.h>
//#import "rVertikalanzeige.h"

@interface rNetzBox : NSBox
{
	int							Kolonnenbreite;
	NSPoint						NetzEcke;
	//float						KolonnenVektor[8];
	float						ZeilenVektor[8];
	NSMutableArray*				KanalDatenArray;
	NSMutableArray*				KanalTitelArray;
	NSMutableArray*				KanalHexDatenArray;
	NSMutableArray*				KanalFloatDatenArray;
	NSMutableArray*				KanalLevelArray;
	NSMutableArray*				KanalNetzArray;
	NSMutableArray*				KanalTastenArray;
	NSMutableArray*				KanalKolonnenArray;
	NSMatrix*					NetzMatrix;
	NSMutableDictionary*		NetzDic;
	NSMutableArray*				NetzArray;

}
- (id)initWithFrame:(NSRect)frame;
- (void)setKolonnenVektor:(NSArray*)derVektor;
- (void)setNetzBox;
- (NSArray*)TastenArrayAnEcke:(NSPoint)dieEcke
					mitHoehe:(float)dieHoehe
			mitKolonnenArray:(NSArray*)derKolonnenArray
			   mitTitelArray:(NSArray*)derTitelArray
			   mitTippTasten:(BOOL)derTyp;
- (NSArray*)HexFeldArrayAnEcke:(NSPoint)dieEcke
					  mitHoehe:(float)dieHoehe
			  mitKolonnenArray:(NSArray*)derKolonnenArray;

- (NSArray*)IntFeldArrayAnEcke:(NSPoint)dieEcke
					  mitHoehe:(float)dieHoehe
			  mitKolonnenArray:(NSArray*)derKolonnenArray;
- (NSArray*)AnzeigenArrayAnEcke:(NSPoint)dieEcke
					   mitHoehe:(float)dieHoehe
			   mitKolonnenArray:(NSArray*)derKolonnenArray
				  mitTitelArray:(NSArray*)derTitelArray
						mitHold:(BOOL)derTyp
					mitHoldZeit:(int)dieZeit;

-(void)NetzBoxTastenArrayAktion:(id)sender;
- (void)GitterZeichnen;
- (void)setHexDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setIntDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setAnzeigeDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setTag:(int)derTag;
@end
