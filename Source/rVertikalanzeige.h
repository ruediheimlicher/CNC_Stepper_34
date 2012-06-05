/* rVertikalanzeige */

#import <Cocoa/Cocoa.h>

@interface rVertikalanzeige : NSView
{
	//NSColor* penColour;
	float Feldbreite;
	float Feldhoehe;
	int AnzFelder;
	float Grenze;
	float Level;
	float max;
	float lastLevel;
	float lastMax;
	BOOL maxSet;
	BOOL delaySet;
	float fixTime;
	int holdMax;
	NSTimer* fixTimer;
	int tag;
	NSString* titel;
}
- (void)setLevel:(int) derLevel;
- (void)drawAnzeige;
- (void)setStringLevel:(NSString*)derLevel;
@end
