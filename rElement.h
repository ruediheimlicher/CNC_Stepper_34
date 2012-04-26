//
//  rElement.h
//  USB_Stepper
//
//  Created by Ruedi Heimlicher on 20.September.11.
//  Copyright 2011 Skype. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface rElement :  NSObject  
{
@private
   NSPoint  Startpunkt;
   NSPoint  Endpunkt;
   NSArray* ElementdatenArray;
   NSString* Elementname;
}
- (NSPoint)Startpunkt;
- (NSPoint)Endpunkt;
- (NSArray*)ElementdatenArray;
- (IBAction)ElementSichern:(id)sender;
- (rElement*)ElementHolen:(NSString*)LibName;
@end
