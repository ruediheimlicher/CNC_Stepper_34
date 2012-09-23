/* rMehrkanalDiagramm */

#import <Cocoa/Cocoa.h>

@interface rMehrkanalDiagramm : NSView
{
	NSPoint				DiagrammEcke;
	NSPoint				lastPunkt;
	NSMutableArray*		GraphArray;	
	NSMutableArray*		GraphFarbeArray;	
	NSMutableArray*		GraphKanalArray;	
	NSBezierPath*		Graph;
	NSColor*			GraphFarbe;
	NSMutableArray*		NetzlinienX;
	NSMutableArray*		NetzlinienY;
	NSMutableArray*			ProfilDatenArray;
	NSMutableArray*			DatenFeldArray;
	
	int							MajorTeileY;
	int							MinorTeileY;
	float						MaxY;
	float						MinY;
	float						NullpunktY;
	float						Zoom;
	NSMutableArray*				EinheitenYArray;
	NSMutableArray*			DatenTitelArray;
	
	
	int					OffsetY;
}
- (void)setOffsetY:(int)y;
- (void)setWert:(NSPoint)derWert  forKanal:(int)derKanal;
- (void)setWertMitX:(float)x mitY:(float)y forKanal:(int)derKanal;
- (void)setStartWerteArray:(NSArray*)Werte;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray;
- (void)setWerteArray:(NSArray*)derWerteArray mitKanalArray:(NSArray*)derKanalArray mitVorgabenDic:(NSDictionary*)dieVorgaben;
- (void)setEinheitenDicY:(NSDictionary*)derEinheitenDic;
- (void)waagrechteLinienZeichnen;
@end
