/* rLevelmeter */

#import <Cocoa/Cocoa.h>

@interface rLevelmeter : NSView
{
	//NSColor* penColour;
	float Feldbreite;
	int Feldhoehe;
	int AnzFelder;
	int Grenze;
	int Level;
	int max;
	int lastLevel;
	int lastMax;
	BOOL maxSet;
	BOOL delaySet;
	float fixTime;
	int holdMax;
	NSTimer* fixTimer;
}
- (void)setLevel:(int) derLevel;
- (void)drawLevelmeter;

@end
