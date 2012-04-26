/* rADWandler */

#import <Cocoa/Cocoa.h>
#import "rNetzBox.h"
#import "rEinkanalDiagramm.h"
#import "rMehrkanalDiagramm.h"
#import "rOrdinate.h"
#import "rUtils.h"

static __inline__ int SSRandomIntBetween(int a, int b)
{
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}

@interface rADWandler : NSWindowController
{
    IBOutlet id					ADTab;
    IBOutlet id					CancelTaste;
    rNetzBox*					NetzBox;
    IBOutlet id					SchliessenTaste;
	
	IBOutlet id					InterfaceNummerTaste;
	IBOutlet id					EinkanalDiagramm;
	IBOutlet id					EinkanalDiagrammScroller;
	IBOutlet id					EinKanalDiagrammWertFeld;
	IBOutlet id					EinkanalZoomTaste;
	IBOutlet id					EinkanalOffsetSchieber;
	IBOutlet id					EinkanalDatenFeld;
	rOrdinate*					EinkanalOrdinate;
	
	IBOutlet id					MehrkanalDiagramm;
	IBOutlet id					MehrkanalDiagrammScroller;
	IBOutlet id					MKWertFeld;
	IBOutlet id					MKWertView;
	IBOutlet id					MehrkanalZoomTaste;
	IBOutlet id					MehrkanalOffsetSchieber;
	IBOutlet id					MehrkanalDatenFeld;
	IBOutlet id					MehrkanalWahlTaste;
	IBOutlet id					MehrkanalTrackZeitTaste;
	IBOutlet id					MehrkanalTrackTaste;
	rOrdinate*					MehrkanalOrdinate;

	NSMutableDictionary*		EinkanalDaten;
	
	NSMutableDictionary*		MehrkanalDaten;
	
	IBOutlet id					KanalWahlTaste;
	IBOutlet id					TrackZeitTaste;
	IBOutlet id					TrackTaste;
	IBOutlet id					TrackRandomTaste;
	IBOutlet id					MehrkanalTrackRandTaste;
	NSMutableArray*				KanalDatenArray;
	NSMutableArray*				KanalTitelArray;
	NSMutableArray*				KanalHexDatenArray;
	NSMutableArray*				KanalFloatDatenArray;
	NSMutableArray*				KanalLevelArray;
	NSMutableArray*				KanalNetzArray;
	NSMutableArray*				KanalTastenArray;
	NSMutableArray*				KanalKolonnenArray;
	NSString*					lastDir;
	float						Kolonnenbreite;
	float						KolonnenVektor[8];
	NSTimer*					sendTimer;
	float						sendAllDelay;
	float						sendKanalDelay;
	float						sendStartBitDelay;
	float						sendReadBitDelay;
	float						sendInputDelay;
	float						sendResetDelay;

	NSCharacterSet *			DezimalZahlen;
	NSCharacterSet*				HexSet;

	NSArray*					HexArray;
	int							readAllIndex;
	NSDate*						start;
	NSDate*						LaunchZeit;
	NSDate*						DatenserieStartZeit;

	NSNumberFormatter*			ZeitFormatter;
	NSNumberFormatter*			DatenFormatter;
	NSMutableArray*				DatenTitelArray;

	NSTimer*					Track1KanalTimer;
	NSTimer*					Track8KanalTimer;
	
	rOrdinate*					Ordinate;
	int							lastInterfaceNummer;
	int							lastTabIndex;
	
}

- (void)GitterZeichnen;

- (IBAction)reportCancel:(id)sender;
- (IBAction)reportClose:(id)sender;
- (IBAction)reportRead1Kanal:(id)sender;
- (IBAction)reportEinkanalOffset:(id)sender;
- (NSArray*)TastenArrayAnEcke:(NSPoint)dieEcke
					mitHoehe:(float)dieHoehe
			mitKolonnenArray:(NSArray*)derKolonnenArray
			   mitTitelArray:(NSArray*)derTitelArray
			   mitTippTasten:(BOOL)derTyp;
- (void)Read1KanalNotificationAktion:(NSNotification*)note;		
- (void)Read1KanalAktion:(NSDictionary*)derDatenDic;

- (void)track1Kanal:(NSDictionary*)derKanalDic;
- (void)reportRead8Kanal:(id)sender;

- (void)reportRead8RandomKanal:(id)sender;

- (void)resetADWandler:(id)sender;	   
- (void)setHexDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setIntDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setAnzeigeDaten:(NSString*)dieDaten forKanal:(int)derKanal;
- (void)setGraphDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic;
- (void)setEinkanalDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic;
- (void)setMehrkanalDaten:(NSString*)dieDaten zurZeit:(NSDate*)dieZeit forKanal:(int)derKanal mitVorgaben:(NSDictionary*)derVorgabenDic;
- (NSString*)HexStringAusBitArray:(NSArray*)derBitArray;
- (NSArray*)BitArray3AusInt:(int)dieZahl;
- (IBAction)saveMehrkanalDaten:(id)sender;
- (void)printMehrkanalDaten:(id)sender;
- (void)setEinkanalWahlTaste:(int)dieTaste;
- (int)EinkanalWahlTastensegment;
- (NSArray*)KanalSelektionArray;
- (NSArray*)MehrkanalTastenArray;
- (void)setMehrkanalWahlTasteMitArray:(NSArray*)derTastenArray;
- (int)lastInterfaceNummer;
- (void)setInterfaceNummer:(int)dieNummer;
- (int)lastTabIndex;
- (void)setTabIndex:(int)derIndex;
@end
