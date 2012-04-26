/* rOrdinate */

#import <Cocoa/Cocoa.h>


@interface rLegende : NSView
{
int							Tag;
NSPoint						AchsenEcke;
NSPoint						AchsenSpitze;
NSString*					Einheit;
int							anzBalken;
int							Schriftgroesse;
NSMutableArray*			InhaltArray;
NSMutableArray*			BalkenlageArray;

}
- (void)setTag:(int)derTag;
- (void)AchseZeichnen;
- (void)setAnzahlBalken:(int)dieAnzahl;
- (void)setAchsenDic:(NSDictionary*)derAchsenDic;
- (void)setInhaltArray:(NSArray*)derInhaltArray;
@end
