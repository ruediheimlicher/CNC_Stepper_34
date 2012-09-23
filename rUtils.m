//
//  rUtils.m
//  USBInterface
//
//  Created by Sysadmin on 09.03.07.
//  Copyright 2007 Ruedi Heimlicher. All rights reserved.
//

#import "rUtils.h"


@implementation rUtils
- (void) logRect:(NSRect)r
{
NSLog(@"logRect: origin.x %2.2f origin.y %2.2f size.heigt %2.2f size.width %2.2f",r.origin.x, r.origin.y, r.size.height, r.size.width);
}

- (NSArray*)readProfil:(NSString*)profilname
{
	NSMutableArray* ProfilArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSOpenPanel* OpenPanel=[NSOpenPanel openPanel];
	[OpenPanel setCanChooseFiles:YES];
	[OpenPanel setCanChooseDirectories:NO];
	[OpenPanel setAllowsMultipleSelection:NO];
   [OpenPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"txt",NULL]];
	/*
	[OpenPanel beginSheetForDirectory:NSHomeDirectory() file:nil 
	 //types:nil 
							 modalForWindow:[self window] 
							  modalDelegate:self 
							 didEndSelector:@selector(ProfilPfadAktion:returnCode:contextInfo:)
								 contextInfo:nil];
	*/
	int antwort=[OpenPanel runModal];
	NSURL* ProfilPfad=[OpenPanel URL];
	NSLog(@"readProfil: URL: %@",ProfilPfad);
	NSError* err=0;
	NSString* ProfilString=[NSString stringWithContentsOfURL:ProfilPfad encoding:NULL error:&err]; // String des Speicherpfads
	//NSLog(@"Utils openProfil ProfilString: \n%@",ProfilString);
	
	NSArray* tempArray=[ProfilString componentsSeparatedByString:@"\r"];
	NSString* firstString = [tempArray objectAtIndex:0];
	NSLog(@"firstString: %@ Array:%@",firstString,[[firstString componentsSeparatedByString:@"\t"]description]);
	
	if (!([[firstString componentsSeparatedByString:@"\t"]count]==2)) // Titel
	{
		NSRange titelRange;
 
		titelRange.location = 1;
		titelRange.length = [tempArray count]-1;
 
		tempArray = [tempArray subarrayWithRange:titelRange];
	
	}
	NSLog(@"Utils openProfil tempArray: \n%@",[tempArray description]);
	//NSLog(@"Utils openProfil tempArray count: %d",[tempArray count]);
	int i=0;
	
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:4];
	[numberFormatter setFormat:@"##0.0000"];

	for (i=0;i<[tempArray count];i++)
	{
		NSString* tempZeilenString=[tempArray objectAtIndex:i];
		//NSLog(@"Utils tempZeilenString l: %d",[tempZeilenString length]);
		if ((tempZeilenString==NULL)|| ([tempZeilenString length]==1))
		{
			continue;
		}
		//NSLog(@"char 0: %d",[tempZeilenString characterAtIndex:0]);
		if ([tempZeilenString characterAtIndex:0]==10)
		{
		//NSLog(@"char 0 weg");
		tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		
		while ([tempZeilenString characterAtIndex:0]==' ')
		{
		tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		//NSLog(@"tempZeilenString A: %@",tempZeilenString);
		NSRange LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
		//NSLog(@"LeerschlagRange start loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		while(LeerschlagRange.length )
		{
			//if (LeerschlagRange.length==1)
			{
				//tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
				
			}
			//else
			{
				tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
			}
			LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
			NSLog(@"LeerschlagRange loop loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		}
		//NSLog(@"tempZeilenString B: %@",tempZeilenString);
		tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
		//NSLog(@"tempZeilenString C: %@",tempZeilenString);
		
		NSArray* tempZeilenArray=[tempZeilenString componentsSeparatedByString:@"\t"];
		float wertx=[[tempZeilenArray objectAtIndex:0]floatValue];//*100;
		float werty=[[tempZeilenArray objectAtIndex:1]floatValue];//*100;
		NSString*tempX=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:wertx]]];
		NSString*tempY=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:werty]]];
		//NSLog(@"tempX: %@",tempX);
		//NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertx], @"x",
		//[NSNumber numberWithFloat:werty], @"y",NULL];
		NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:tempX, @"x",tempY, @"y",NULL];
		[ProfilArray addObject:tempDic];
		//[ProfilArray insertObject:tempDic atIndex:0];
	}
	
	NSLog(@"Utils openProfil ProfilArray: \n%@",[ProfilArray description]);
	return ProfilArray;
}

- (NSArray*)flipProfil:(NSArray*)profilArray
{
   NSMutableArray* flipProfilArray = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   int i;
   
   for (i=0;i< [profilArray count];i++)
   {
      NSMutableDictionary* tempZeilenDic = [NSMutableDictionary dictionaryWithDictionary:[profilArray objectAtIndex:i]];
      float tempx=[[tempZeilenDic objectForKey:@"x"]floatValue];
      tempx *= -1;
      tempx += 1;
      [tempZeilenDic setObject:[NSNumber numberWithFloat:tempx]forKey:@"x"];
      [flipProfilArray addObject:tempZeilenDic];
   }
   
   return flipProfilArray;
}


- (NSDictionary*)ProfilDatenAnPfad:(NSString*)profilpfad
{
	NSMutableArray* ProfilArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   //NSLog(@"ProfilDatenAnPfad: URL: %@",profilpfad);
	NSError* err=0;
	NSString* ProfilString=[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:profilpfad] encoding:NSUTF8StringEncoding error:&err]; // String des Speicherpfads
	//NSLog(@"Utils openProfil ProfilString: \n%@ err: %@",ProfilString, [err description]);
	if (ProfilString==NULL)
	{
      return NULL;
	}
   
   NSString* stringterm;
   if ([[ProfilString componentsSeparatedByString:@"\r"]count]==1)
   {
      stringterm = @"\n";
   }
   else {
      stringterm = @"\r";
   }
   
   
	NSArray* tempArray=[ProfilString componentsSeparatedByString:stringterm];
   
   
	NSString* firstString = [tempArray objectAtIndex:0];
	//NSLog(@"firstString: %@",firstString );
   
	//NSLog(@"firstString desc: %@",[firstString description]);
	NSString* ProfilName=[NSString string];
   
   NSRange testRange;
	testRange=[firstString rangeOfString:@"\r"];
	//NSLog(@"testRange start loc: %u l: %u",testRange.location, testRange.length);	
   
   
   
	NSRange nameRange;
	nameRange=[firstString rangeOfString:@"\n"];
	//NSLog(@"nameRange start loc: %u l: %u",nameRange.location, nameRange.length);	
	
	if (nameRange.location < NSNotFound)
	{
		ProfilName = [firstString substringToIndex:nameRange.location];
		
		//NSLog(@"firstString mit n: %@ ProfilName:%@",firstString,ProfilName);
	}
	else if (!([[firstString componentsSeparatedByString:@"\t"]count]==2)) // Titel
	{
		ProfilName = firstString;
		NSRange titelRange;
		
		titelRange.location = 1;
		titelRange.length = [tempArray count]-1;
		
		tempArray = [tempArray subarrayWithRange:titelRange];
		
	}
	else
	{
		ProfilName =@"Profil";
	}
	//NSLog(@"Utils openProfil ProfilName: %@",ProfilName);
	//NSLog(@"Utils openProfil tempArray: \n%@",[tempArray description]);
	//NSLog(@"Utils openProfil tempArray count: %d",[tempArray count]);
	int i=0;
	
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:4];
	[numberFormatter setFormat:@"##0.0000"];
	
   // Nasenindex suchen
   float minx=NSNotFound;
   int Nasenindex=0;
   
	for (i=0;i<[tempArray count];i++)
	{
		
		NSString* tempZeilenString=[tempArray objectAtIndex:i];
		nameRange=[tempZeilenString rangeOfString:@"\n"];
		//NSLog(@"nameRange start loc: %d l: %d",nameRange.location, nameRange.length);	
		
		if (nameRange.location < NSNotFound)
		{
			//NSLog(@"i: %d String mit n: %@ ",i,tempZeilenString);
			tempZeilenString = [tempZeilenString substringFromIndex:nameRange.location];
			
			//NSLog(@"i: %d String ohne n: %@ ",i,tempZeilenString);
		}
		
		//NSLog(@"i: %d Utils tempZeilenString l: %d",i,[tempZeilenString length]);
		
		if ((tempZeilenString==NULL)|| ([tempZeilenString length]==1))
		{
         //NSLog(@"i: %d ((tempZeilenString==NULL)|| ([tempZeilenString length]==1))",i);
			continue;
		}
		//NSLog(@"char 0: %d",[tempZeilenString characterAtIndex:0]);
		if ([tempZeilenString characterAtIndex:0]==10)
		{
			//NSLog(@"char 0 weg");
			tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		
		while ([tempZeilenString characterAtIndex:0]==' ')
		{
			tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		//NSLog(@"tempZeilenString A: %@",tempZeilenString);
		NSRange LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
		//NSLog(@"LeerschlagRange start loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		while(LeerschlagRange.length )
		{
			//if (LeerschlagRange.length==1)
			{
				//tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
				
			}
			//else
			{
				tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
			}
			LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
			//NSLog(@"LeerschlagRange loop loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		}
		//NSLog(@"tempZeilenString B: %@",tempZeilenString);
		tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
		//NSLog(@"i: %d tempZeilenString C: %@",i,tempZeilenString);
		
		NSArray* tempZeilenArray=[tempZeilenString componentsSeparatedByString:@"\t"];
		float wertx=[[tempZeilenArray objectAtIndex:0]floatValue];
		float werty=[[tempZeilenArray objectAtIndex:1]floatValue];
		NSString*tempX=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:wertx]]];
		NSString*tempY=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:werty]]];
		//NSLog(@"tempX: %@",tempX);
		//NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertx], @"x",
		//[NSNumber numberWithFloat:werty], @"y",NULL];
		NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:tempX, @"x",tempY, @"y",[NSNumber numberWithFloat:1], @"data",NULL];
		[ProfilArray addObject:tempDic];
      if (wertx < minx)
      {
         minx=wertx;
         Nasenindex=i;
      }
      //[ProfilArray insertObject:tempDic atIndex:0];
	}
	
   ProfilArray = (NSMutableArray*)[self flipProfil:ProfilArray];
	//NSLog(@"Utils openProfil ProfilArray: \n%@",[ProfilArray description]);
	
   // Test Spline
   
   //NSLog(@"count: %d Nasenindex: %d",[ProfilArray count],Nasenindex);
   
   //NSLog(@"Spline Oberseite");
   NSArray* OberseiteArray=[ProfilArray subarrayWithRange:NSMakeRange(0, Nasenindex+1)];
   
   // NSDictionary* OberseiteSplineKoeffArray=[self SplinekoeffizientenVonArray:OberseiteArray];
   
   NSArray* UnterseiteArray=[ProfilArray subarrayWithRange:NSMakeRange(Nasenindex, [ProfilArray count]-Nasenindex)];
   NSMutableArray * revUnterseiteArray = [NSMutableArray arrayWithCapacity:[UnterseiteArray count]];
   
   for(int i = 0; i < [UnterseiteArray count]; i++) 
   {
      [revUnterseiteArray addObject:[UnterseiteArray objectAtIndex:[UnterseiteArray count] - i - 1]];
   }
   
   
   //NSLog(@"Spline Unterseite");
   
   //   NSDictionary* UnterseiteSplineKoeffArray=[self SplinekoeffizientenVonArray:revUnterseiteArray];
   
   
   // End Spline
   
   
   
   
   NSDictionary* ProfilDic=[NSDictionary dictionaryWithObjectsAndKeys:ProfilArray,@"profilarray",ProfilName, @"profilname",NULL];
   //NSLog(@"Utils openProfil ProfilDic: \n%@",[ProfilDic description]);
	return ProfilDic;
}

-  (NSDictionary*)readProfilMitName
{
	NSMutableArray* ProfilArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	NSOpenPanel* OpenPanel=[[NSOpenPanel openPanel]retain];
	[OpenPanel setCanChooseFiles:YES];
	[OpenPanel setCanChooseDirectories:NO];
	[OpenPanel setAllowsMultipleSelection:NO];
   [OpenPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"txt",NULL]];
   //NSButton *gleichesProfil = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 240, 24)];
   //[gleichesProfil setButtonType:NSSwitchButton];
   //[gleichesProfil setState:1];
   //[gleichesProfil setTitle:@"gleiches Profil fuer beide Seiten"];
   //[OpenPanel setAccessoryView:gleichesProfil];
	/*
	 [OpenPanel beginSheetForDirectory:NSHomeDirectory() file:nil 
	 //types:nil 
	 modalForWindow:[self window] 
	 modalDelegate:self 
	 didEndSelector:@selector(ProfilPfadAktion:returnCode:contextInfo:)
	 contextInfo:nil];
	 */
	int antwort=[OpenPanel runModal];
   if (antwort == NSFileHandlingPanelCancelButton)
   {
      [OpenPanel release];
      return NULL;
      
   }
   
	NSURL* ProfilPfad=[OpenPanel URL];
   [OpenPanel release];
	NSLog(@"readProfilMitName: URL: %@",ProfilPfad);
	NSError* err=0;
	NSString* ProfilString=[NSString stringWithContentsOfURL:ProfilPfad encoding:NSUTF8StringEncoding error:&err]; // String des Speicherpfads
	//NSLog(@"Utils openProfil ProfilString: \n%@ err: %@",ProfilString, [err description]);
	if (ProfilString==NULL)
	{
	ProfilString=[NSString stringWithContentsOfURL:ProfilPfad encoding:NSMacOSRomanStringEncoding error:&err];
	
	}
	if (ProfilString==NULL)
	{
	ProfilString=[NSString stringWithContentsOfURL:ProfilPfad encoding:NSUnicodeStringEncoding error:&err];
	
	}

	NSArray* tempArray=[ProfilString componentsSeparatedByString:@"\r"];
	NSString* firstString = [tempArray objectAtIndex:0];
	NSLog(@"firstString: %@",firstString);
	NSString* ProfilName=[NSString string];
	
	NSRange nameRange;
	nameRange=[firstString rangeOfString:@"\n"];
	NSLog(@"nameRange start loc: %u l: %u",nameRange.location, nameRange.length);	
	
	if (nameRange.location < NSNotFound)
	{
		ProfilName = [firstString substringToIndex:nameRange.location];
		
		NSLog(@"firstString mit n: %@ ProfilName:%@",firstString,ProfilName);
	}
	else if (!([[firstString componentsSeparatedByString:@"\t"]count]==2)) // Titel
	{
		ProfilName = firstString;
		NSRange titelRange;
		
		titelRange.location = 1;
		titelRange.length = [tempArray count]-1;
		
		tempArray = [tempArray subarrayWithRange:titelRange];
		
	}
	else
	{
		ProfilName =@"Profil";
	}
	//NSLog(@"Utils openProfil ProfilName: %@",ProfilName);
	//NSLog(@"Utils openProfil tempArray: \n%@",[tempArray description]);
	//NSLog(@"Utils openProfil tempArray count: %d",[tempArray count]);
	int i=0;
	
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:4];
	[numberFormatter setFormat:@"##0.0000"];
	
	for (i=0;i<[tempArray count];i++)
	{
		
		NSString* tempZeilenString=[tempArray objectAtIndex:i];
		nameRange=[tempZeilenString rangeOfString:@"\n"];
		//NSLog(@"nameRange start loc: %d l: %d",nameRange.location, nameRange.length);	
		
		if (nameRange.location < NSNotFound)
		{
			//NSLog(@"i: %d String mit n: %@ ",i,tempZeilenString);
			tempZeilenString = [tempZeilenString substringFromIndex:nameRange.location];
			
			//NSLog(@"i: %d String ohne n: %@ ",i,tempZeilenString);
		}
		
		//NSLog(@"i: %d Utils tempZeilenString l: %d",i,[tempZeilenString length]);
		
		if ((tempZeilenString==NULL)|| ([tempZeilenString length]==1))
		{
         //NSLog(@"i: %d ((tempZeilenString==NULL)|| ([tempZeilenString length]==1))",i);
			continue;
		}
		//NSLog(@"char 0: %d",[tempZeilenString characterAtIndex:0]);
		if ([tempZeilenString characterAtIndex:0]==10)
		{
			//NSLog(@"char 0 weg");
			tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		
		while ([tempZeilenString characterAtIndex:0]==' ')
		{
			tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		//NSLog(@"tempZeilenString A: %@",tempZeilenString);
		NSRange LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
		//NSLog(@"LeerschlagRange start loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		while(LeerschlagRange.length )
		{
			//if (LeerschlagRange.length==1)
			{
				//tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
				
			}
			//else
			{
				tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
			}
			LeerschlagRange=[tempZeilenString rangeOfString:@"  "];
			//NSLog(@"LeerschlagRange loop loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		}
		//NSLog(@"tempZeilenString B: %@",tempZeilenString);
		tempZeilenString=[tempZeilenString stringByReplacingOccurrencesOfString:@" " withString:@"\t"];
		//NSLog(@"i: %d tempZeilenString C: %@",i,tempZeilenString);
		
		NSArray* tempZeilenArray=[tempZeilenString componentsSeparatedByString:@"\t"];
		float wertx=[[tempZeilenArray objectAtIndex:0]floatValue];
		float werty=[[tempZeilenArray objectAtIndex:1]floatValue];
		NSString*tempX=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:wertx]]];
		NSString*tempY=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:werty]]];
		//NSLog(@"tempX: %@",tempX);
		//NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertx], @"x",
		//[NSNumber numberWithFloat:werty], @"y",NULL];
		NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:tempX, @"x",tempY, @"y",NULL];
		[ProfilArray addObject:tempDic];
	}
	
	//NSLog(@"Utils openProfil ProfilArray: \n%@",[ProfilArray description]);
	
	NSDictionary* ProfilDic=[NSDictionary dictionaryWithObjectsAndKeys:ProfilArray,@"profilarray",ProfilName, @"profilname",NULL];
   //NSLog(@"Utils openProfil ProfilDic: \n%@",[ProfilDic description]);
	return ProfilDic;
}

- (NSDictionary*)SplinekoeffizientenVonArray:(NSArray*)dataArray
{
  // NSLog(@"SplinekoeffizientenVonArray l: %d dataArray: %@",[dataArray count],[dataArray description]);
   NSMutableDictionary* splineKoeffDic = [[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
   unsigned long l=[dataArray count];
   double* a=malloc(l*sizeof(double));
   double* b=malloc(l*sizeof(double));
   double* c=malloc(l*sizeof(double));
   double* d=malloc(l*sizeof(double));
   double* x=malloc(l*sizeof(double));
   double* y=malloc(l*sizeof(double));
   
   double* h=malloc(l*sizeof(double));
   double* e=malloc(l*sizeof(double));
   double* r=malloc(l*sizeof(double));
   double* u=malloc(l*sizeof(double));
   double* kappa=malloc(l*sizeof(double));
   int i;
   for(i=0;i<l;i++)
   {
      x[i] = [[[dataArray objectAtIndex:i] objectForKey:@"x"]floatValue];
      y[i] = [[[dataArray objectAtIndex:i] objectForKey:@"y"]floatValue];
      
   }
   // Differenzen der x-Werte: x(i+1) - x(i)
   for(i=0;i<(l-1);i++)
   {
      NSDictionary* tempZeilenDic = [dataArray objectAtIndex:i];
      //NSLog(@"i: %d tempZeilenDic: %@",i,[tempZeilenDic description]);
      //float temp=[[[dataArray objectAtIndex:i+1] objectForKey:@"x"]floatValue] - [[[dataArray objectAtIndex:i] objectForKey:@"x"]floatValue];
      
      h[i]= [[[dataArray objectAtIndex:i+1] objectForKey:@"x"]floatValue] - [[[dataArray objectAtIndex:i] objectForKey:@"x"]floatValue];
//      NSLog(@"i: %d  h[i]:%f temp: %f",i,h[i],temp);
      //NSLog(@"i: %d  h[i]:%f ",i,h[i]);
     // fprintf(stderr, "h: %f\n", h[i]);
   }
  // NSLog(@"\n\n");
   // Koeff e: 6/h(i) * (y(i+1)-y(i))
   for(i=0;i<(l-1);i++)
   {
      //NSArray* tempZeilenArray = [dataArray objectAtIndex:i];
      e[i]= 6/h[i] * ([[[dataArray objectAtIndex:i+1]objectForKey:@"y"]floatValue] - [[[dataArray objectAtIndex:i]objectForKey:@"y"]floatValue]);
//      fprintf(stderr, "i: %d e: %f\n",i, e[i]);
      //NSLog(@"i: %d  e[i]:%f ",i,e[i]);
   }
   //NSLog(@"\n\n");
   // Koeff u: 2*(h(i]+h[i-1]) - h[i-1]^2/ u[i-1]
   for(i=1;i<l;i++)
   {
      if (i==1)
      {
         u[i] = 2*(h[i] + h[i-1]);
      }
      else
      {
         u[i] = 2*(h[i] + h[i-1]) - h[i-1]*h[i-1]/u[i-1];
      }
     // fprintf(stderr, "i: %d u: %f\n",i, u[i]);
     //NSLog(@"i: %d  u[i]:%f ",i,u[i]);
   }
   //NSLog(@"\n\n");
   // Koeff r: e(i]-e[i-1) - r[i-1] * h[i-1] / u[i-1]
   for(i=1;i<l-1;i++)
   {
      if (i==1)
      {
         r[i] = e[i] - e[i-1];
      }
      else
      {
         r[i] = (e[i] - e[i-1]) - r[i-1] * h[i-1] / u[i-1] ;
      }
   //NSLog(@"i: %d  r[i]:%f ",i,r[i]);
   //fprintf(stderr, "i: %d r: %f\n",i, r[i]);

   }
   //NSLog(@"\n\n");
   // Koeff kappa: e(i]-e[i-1) - r[i-1] * h[i-1] / u[i-1] rueckwaerts einsetzen
   
   for(i=l-1;i>=0;i--)
   {
      if (i==0 || i==l-1) // Randwerte sind 0
      {
         kappa[i] = 0;
      }
      else
      {
         kappa[i] = (r[i] - h[i]*kappa[i+1])/u[i];
      }
 //     NSLog(@"i: %d  kappa[i]:%f ",i,kappa[i]);
 //     fprintf(stderr, "i: %d kappa: %f\n",i, kappa[i]);
   }
   
   NSLog(@"\n\n");
//   fprintf(stderr, "i:\tx:\ty:\tkappa:\ta:\tb:\tc:\td:\t\n");
   for(i=0;i<l;i++)
   {
     if (i<l-1)
     {
      a[i] = (kappa[i+1]-kappa[i])/(6*h[i]);
     }
      else
      {
         a[i]=0;
      }
      b[i] = kappa[i]/2;
      if (i<l-1)
      {
      c[i] = (y[i+1]-y[i])/h[i] - h[i]/6*(2*kappa[i] + kappa[i+1]);
      }
      else
      {
         c[i]=0;
      }
      d[i] = y[i];
      
  //    fprintf(stderr, "%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",i, x[i], y[i], kappa[i], a[i], b[i], c[i], d[i]);
   } 
   
   free(a);
    free(b);
    free(c);
    free(d);
    free(x);
    free(y);
   free(h);
   free(e);
   free(r);
   free(u);
   free(kappa);
   
   return splineKoeffDic;
}


- (NSArray*)wrenchProfil:(NSArray*)profilArray mitWrench:(float)wrench
{
   NSMutableArray* wrenchArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   int i=0;
   /*
    x2 = x1 * cos(phi) - y1 * sin(phi)
    y2 = x1 * sin(phi) + y1 * cos(phi)
    */
   // winkel in rad:
   float phi=wrench/180*M_PI;
   // offset x infolge wrench:
   float offsetx= 1-cosf(phi);
   // offset y infolge wrench:
   float offsety= sinf(phi);
   
   //NSLog(@"offsetx: %2.5f offsety: %2.5f count: %d",offsetx,offsety,[profilArray count]);
   // NSLog(@"profilArray: %@",[profilArray description]);
   for(i=0;i<[profilArray count];i++)
   {
      
      float x1=[[[profilArray objectAtIndex:i]objectForKey:@"x"]floatValue];
      float y1=[[[profilArray objectAtIndex:i]objectForKey:@"y"]floatValue];
      float x2=x1*cosf(phi)-y1*sinf(phi);
      float y2=x1*sinf(phi)+y1*cosf(phi);
      y2 -= offsety;
      [wrenchArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x2],@"x",[NSNumber numberWithFloat:y2],@"y", nil]];
      
   }
   
   //NSLog(@"wrenchArray: %@",[wrenchArray description]);
   return wrenchArray;
}

- (NSMutableArray*)wrenchProfilschnittlinie:(NSArray*)linienArray mitWrench:(float)wrench
{
   NSMutableArray* wrenchArray=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
   int i=0;
   /*
    x2 = x1 * cos(phi) - y1 * sin(phi)
    y2 = x1 * sin(phi) + y1 * cos(phi)
    */
   // winkel in rad:
   float phi=wrench/180*M_PI;
   // offset x infolge wrench:
   float offsetx= 1-cosf(phi);
   // offset y infolge wrench:
   float offsety= sinf(phi);
   
   //NSLog(@"offsetx: %2.5f offsety: %2.5f count: %d",offsetx,offsety,[profilArray count]);
   //NSLog(@"linienArray: %@",[linienArray description]);
//   NSLog(@"linienArray: %@",[linienArray valueForKey:@"teil"]);
 
   // anfangspunkt und Endpunkt der Profillinie feststellen. Einlauf: 10. Auslauf: 40
   int profilanfangindex=0;
   int profilendeindex=0;
   int pos=10; // Auslauf oder Einlauf erkennen
   
   // Werte ohne Ein- und Auslauf
   float x0=[[[linienArray objectAtIndex:0]objectForKey:@"bx"]floatValue];
   float y0=[[[linienArray objectAtIndex:[linienArray count]-1]objectForKey:@"by"]floatValue];

   for(i=0;i<[linienArray count];i++)
   {
      
      if ([[[linienArray objectAtIndex:i]objectForKey:@"teil"]intValue] > pos) // Einlauf ist 20
      {
         if (profilanfangindex == 0) // noch nicht gesetzt
         {
         profilanfangindex = i; // Anfang gefunden
         pos=30;
         }
         else if (profilendeindex == 0)// Ende gefunden
         {
            profilendeindex = i; // Anfang gefunden
            pos=50;
           
         }
         
      }
      
   }
   if (pos>10)
   {
   profilendeindex -=1;
   NSLog(@"profilanfangindex: %d profilendeindex: %d",profilanfangindex,profilendeindex);
   x0=[[[linienArray objectAtIndex:profilendeindex]objectForKey:@"bx"]floatValue];
   y0=[[[linienArray objectAtIndex:profilendeindex]objectForKey:@"by"]floatValue];
   }
      NSLog(@"x0: %2.2f y0: %2.2f",x0,y0);

   //Koordinaten drehen
   for(i=0;i<[linienArray count];i++)
   {
   
      float x1=[[[linienArray objectAtIndex:i]objectForKey:@"bx"]floatValue];
      float y1=[[[linienArray objectAtIndex:i]objectForKey:@"by"]floatValue];
      float x2=(x1-x0)*cosf(phi)-(y1-y0)*sinf(phi) +x0;
      float y2=(x1-x0)*sinf(phi)+(y1-y0)*cosf(phi) +y0;
      
 //     y2 -= offsety;
      
//      NSMutableDictionary* tempDic=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
      NSMutableDictionary* tempZeilenDic=[[[NSMutableDictionary alloc]initWithDictionary:[linienArray objectAtIndex:i]]autorelease];
      [tempZeilenDic setObject:[NSNumber numberWithFloat:x2] forKey:@"bx"];
      [tempZeilenDic setObject:[NSNumber numberWithFloat:y2] forKey:@"by"];
      [wrenchArray addObject: tempZeilenDic];
     // [wrenchArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x2],@"x",[NSNumber numberWithFloat:y2],@"y", nil]];
      
   }
   
   //NSLog(@"wrenchArray: %@",[wrenchArray description]);
   return wrenchArray;
}

- (NSArray*)readFigur
{
	NSMutableArray* FigurArray=[[NSMutableArray alloc]initWithCapacity:0];
	NSOpenPanel* OpenPanel=[NSOpenPanel openPanel];
	[OpenPanel setCanChooseFiles:YES];
	[OpenPanel setCanChooseDirectories:NO];
	[OpenPanel setAllowsMultipleSelection:NO];
   [OpenPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"txt",NULL]];
	/*
    [OpenPanel beginSheetForDirectory:NSHomeDirectory() file:nil 
	 //types:nil 
    modalForWindow:[self window] 
    modalDelegate:self 
    didEndSelector:@selector(ProfilPfadAktion:returnCode:contextInfo:)
    contextInfo:nil];
    */
	int antwort=[OpenPanel runModal];
	NSURL* FigurPfad=[OpenPanel URL];
	//NSLog(@"readFigur: URL: %@",FigurPfad);
	NSError* err=0;
	NSString* FigurString=[NSString stringWithContentsOfURL:FigurPfad encoding:NSUTF8StringEncoding error:&err]; // String des Speicherpfads
	
   //NSLog(@"Utils openProfil FigurString: \n%@",FigurString);
	
   NSArray* tempArray = [NSArray array];
   
	//NSArray* tempArray=[FigurString componentsSeparatedByString:@"\r"];
   
   //NSArray* temp_n_Array=[FigurString componentsSeparatedByString:@"\n"];
   //NSLog(@"Utils openProfil anz: %d temp_n_Array: %@",[temp_n_Array count],temp_n_Array);
   if ([[FigurString componentsSeparatedByString:@"\n"]count] == 1) // separator \r
   {
   tempArray=[FigurString componentsSeparatedByString:@"\r"];   
   
   }
   else 
   {
     tempArray=[FigurString componentsSeparatedByString:@"\n"]; 
   }
   
   //NSArray* temp_r_Array=[FigurString componentsSeparatedByString:@"\r"];
	
   
  // NSLog(@"Utils openProfil anz: %d temp_r_Array: \n%@",[temp_r_Array count],temp_r_Array);
   
   NSString* firstString = [tempArray objectAtIndex:0];
	//NSLog(@"firstString Titel: %@ ",firstString);
	if (([[firstString componentsSeparatedByString:@"\t"]count]==1)) // Titel
	{
      NSLog(@"Titel gefunden: %@ ",firstString);   
		NSRange titelRange;
      
		titelRange.location = 1;
		titelRange.length = [tempArray count]-1;
      
		tempArray = [tempArray subarrayWithRange:titelRange];
      
	}
	//NSLog(@"Utils openFigur tempArray nach Titel: \n%@",[tempArray description]);
	//NSLog(@"Utils openFigur tempArray count: %d",[tempArray count]);
	int i=0;
	
	NSNumberFormatter *numberFormatter =[[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setMaximumFractionDigits:4];
	[numberFormatter setFormat:@"##0.0000"];
   
	for (i=0;i<[tempArray count];i++)
	{
		NSString* tempZeilenString=[tempArray objectAtIndex:i];
		//NSLog(@"Utils tempZeilenString l: %d",[tempZeilenString length]);
		if ((tempZeilenString==NULL)|| ([tempZeilenString length]<=1))
		{
			continue;
		}
		//NSLog(@"char 0: %d",[tempZeilenString characterAtIndex:0]);
		
      if ([tempZeilenString characterAtIndex:0]==10)
		{
         NSLog(@"char 0 weg");
         tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		
      //leerschlag weg
		while ([tempZeilenString characterAtIndex:0]==' ')
		{
         tempZeilenString=[tempZeilenString substringFromIndex:1];
		}
		//NSLog(@"i: %d tempZeilenString: %@",i,tempZeilenString);
		//NSLog(@"LeerschlagRange start loc: %d l: %d",LeerschlagRange.location, LeerschlagRange.length);
		
		NSArray* tempZeilenArray=[tempZeilenString componentsSeparatedByString:@"\t"];
		if ([tempZeilenArray count])
      {
      // object 0 ist index
      float wertx=[[tempZeilenArray objectAtIndex:1]floatValue];//*100;
		float werty=[[tempZeilenArray objectAtIndex:2]floatValue];//*100;
		NSString*tempX=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:wertx]]];
		NSString*tempY=[NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:werty]]];
		//NSLog(@"tempX: %@",tempX);
		//NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:wertx], @"x",
		//[NSNumber numberWithFloat:werty], @"y",NULL];
         NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",tempX, @"x",tempY, @"y",NULL];
		[FigurArray addObject:tempDic];
      }
		//[ProfilArray insertObject:tempDic atIndex:0];
	}
	
	//NSLog(@"Utils openProfil FigurArray: \n%@",[FigurArray description]);
	return FigurArray;
}

- (IBAction)ok:(id)sender
{
NSLog(@"ok");
}
@end
