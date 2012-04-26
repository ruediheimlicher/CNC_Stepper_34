//
//  rHexView.h
//  
//
//  Created by Sysadmin on 03.11.05.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rHexView : NSTextView 
{
NSCharacterSet *				DezimalZahlen;
NSCharacterSet*					HexSet;
int mark;
}
- (id)initWithFrame:(NSRect)frame;
- (void)setErgebnisView;


@end
