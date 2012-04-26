/* rOrdinate */

#import <Cocoa/Cocoa.h>

@interface rOrdinate : NSView
{
NSPoint						AchsenEcke;
NSPoint						AchsenSpitze;
NSString*					Einheit;
int							MajorTeile;
int							MinorTeile;
float						Max;
float						Min;
float						Nullpunkt;
NSMutableArray*				EinheitenArray;
}

- (void)AchseZeichnen;
- (void)setAchsenDic:(NSDictionary*)derAchsenDic;
@end
