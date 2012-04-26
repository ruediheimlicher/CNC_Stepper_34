/* rEinkanalDiagramm */

#import <Cocoa/Cocoa.h>
#import "rOrdinate.h"
@interface rEinkanalDiagramm : NSView
{
NSPoint DiagrammEcke;
NSPoint lastPunkt;
NSBezierPath* Graph;
NSColor* GraphFarbe;
NSMutableArray* NetzlinienX;
NSMutableArray* NetzlinienY;
int OffsetY;
rOrdinate*					Ordinate;

int							MajorTeileY;
int							MinorTeileY;
float						MaxY;
float						MinY;
int						NullpunktY;
NSMutableArray*				EinheitenYArray;


}
- (void)setOffsetY:(int)y;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void)setWert:(NSPoint)derWert;
- (void)setWertMitX:(float)x mitY:(float)y;
- (void)setStartwertMitY:(float)y;
- (void)clear1Kanal;


@end
