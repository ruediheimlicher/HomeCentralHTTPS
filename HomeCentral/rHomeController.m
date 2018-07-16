//
//  rEingabeViewController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 03.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rHomeController.h"
#import "rEingabeController.h"
#import "Reachability.h"

#import "HomeCentral-Swift.h"
//#import "rURL.swift"


#define PW "ideur00"

#define TAGPLANBREITE		0x40	// 64 Bytes, 2 page im EEPROM

#define RAUMPLANBREITE		0x200	// 512 Bytes
@implementation TWIControl

-(void)setCustomState {
   customState |= kUIControlStateCustomState;
   [self stateWasUpdated];
}

-(void)unsetCustomState {
   customState &= ~kUIControlStateCustomState;
   [self stateWasUpdated];
}
- (UIControlState)state {
   return [super state] | customState;
}

- (void)stateWasUpdated {
   if ([self state])
   {
   [self setCustomState];
   }
   else
   {
      [self unsetCustomState];
   }
   // Add your custom code here to respond to the change in state
}
@end
@interface rHomeController ()

@end

@implementation rHomeController


- (void)showMessage:(BOOL)animated
{
  // http://stackoverflow.com/questions/32804506/uialertcontroller-not-appearing-at-all
   NSLog(@"alertController showMessage");
   UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Do not leave any Field Empty"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
   
   [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [self dismissViewControllerAnimated:YES completion:nil];
   }]];
   [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showDebug:(NSString*)warnung
{
   //NSLog(@"alertController showDebug");
   return;
   UIAlertController* alert_Debug = [UIAlertController alertControllerWithTitle:@"Debug-Status"
                                                                        message:warnung
                                                                 preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                 NSLog(@"showDebug warnung: %@",warnung);
                                 //[self setTWIState:NO]; // TWI ausschalten
                                 
                                 NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
                                 [nc postNotificationName:@"debugwarnung" object:self userInfo:[NSDictionary dictionaryWithObject:warnung forKey:@"debugwarnung"]];
                                 
                              }];
   
   [alert_Debug addAction:OKAction];
   [self presentViewController:alert_Debug animated:YES completion:nil];
}

- (void)showWarnungMitTitel:(NSString*)titel mitWarnung:(NSString*)warnung
{
   NSLog(@"alertController showWarnungMitTitel");
   UIAlertController* alert_Warnung = [UIAlertController alertControllerWithTitle:titel
                                                                          message:warnung
                                                                   preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                 NSLog(@"showWarnungMitTitel titel: %@ warnung: %@",titel, warnung);
                                 //[self setTWIState:NO]; // TWI ausschalten
                                 
                                 NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
                                 [nc postNotificationName:@"debugwarnungmittitel" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:titel,@"titel",warnung,@"debugwarnung",nil]];
                                 
                              }];
   
   [alert_Warnung addAction:OKAction];
   [self presentViewController:alert_Warnung animated:YES completion:nil];
   
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
   debugstring = @"debug: ";
   NSString* loadstring = @"Start ";
   NSLog(@"loadstring: %@",loadstring);
   loadstring = [loadstring stringByAppendingString:@"A"];
   NSLog(@"loadstring: %@",loadstring);
   [super viewDidLoad];
   
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(backgroundaktion:)
                                                name:@"EnterBackground"
                                              object:nil];
    
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(resignaktion:)
                                                name:@"UIApplicationWillResignActiveNotification"
                                              object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(beendenAktion:)
                                                name:@"Beenden"
                                              object:nil];

   URLTask = [[rURLTask alloc]init];
   
   pw = [self passwortstring];
   pwpart = [[NSMutableString alloc]init];
   int anz = [[pw componentsSeparatedByString:@"\t"]count];
   //pwpart = [NSString stringWithFormat:@"&%@&%@&%@&%@",
   for (int i=0;i < anz; i++)
   {
      NSString* part = [NSString stringWithFormat:@"&b%d=%@",i,[[pw componentsSeparatedByString:@"\t"]objectAtIndex:i]];
      // [pwpart appendString:@"&"];
      [pwpart appendString:part];
   }
   
   NSLog(@"HomeClient pw: %@ pwpart: %@",pw,pwpart);

   //[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
   debugstring = [debugstring stringByAppendingString:@"A"];
   loadstring = [loadstring stringByAppendingString:@"B"];
   //NSLog(@"loadstring: %@ debugstring: %@",loadstring,debugstring);
   self.ipfeld.text = [[rVariableStore sharedInstance] IP];

   self.WochentagArray = [NSArray arrayWithObjects:@"MO",@"DI",@"MI",@"DO",@"FR",@"SA", @"SO",nil];
   self.aktuellerRaum =0;

   NSString *WochenplanString = [self readWochenplan];
   debugstring = [debugstring stringByAppendingString:@"B"];
   //NSLog(@"viewDidLoad DataString: %@",WochenplanString);
   self.wochenplanarray = [WochenplanString componentsSeparatedByString:@"\n"];
   //NSLog(@"wochenplanarray: %@",[self.wochenplanarray description]);
  
   
    NSCalendar* heutekalender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   [heutekalender setFirstWeekday:2];
   
//   int wochentagindex = [heutekalender ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]]-1;
   
  NSUInteger wochentagindex = [heutekalender ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfYear forDate:[NSDate date]]-1;
   NSLog(@"wochentagindex: %lu",(unsigned long)wochentagindex);
   
   /*
   NSDateComponents *weekdayComponents =[heutekalender components:( NSWeekdayCalendarUnit) fromDate:[NSDate date]];
   int wochentagint = [weekdayComponents weekday]; // Wochentag mit Sonntag=1
   NSLog(@"wochentagint: %d",wochentagint);
   */
   self.permanent = 3;
   self.aktuellesObjekt=0;
   self.objektstepper.value = self.aktuellesObjekt;
   self.aktuellerWochentag= wochentagindex;
   self.wochentagseg.selectedSegmentIndex = wochentagindex;
   
   self.raumseg.selectedSegmentIndex=self.aktuellerRaum;
   
   
   UIImage *blueImage = [UIImage imageNamed:@"blauetaste.jpg"];
   UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
   
   UIImage *defButtonImage = [[UIImage imageNamed:@"helletaste.jpg"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
   
   UIColor* hintergrund = self.tagplanfeld.backgroundColor;
   int stundenabstand = 70;
   
   CGRect tagplanframe = self.tagplanfeld.frame;
   tagplanframe.size.width = 24*stundenabstand + 100;
   self.tagplanfeld.frame = tagplanframe;
   self.tagplanscroller.contentSize = self.tagplanfeld.frame.size;
   self.tagplanscroller.alwaysBounceVertical = NO;
   self.tagplanscroller.alwaysBounceHorizontal = NO;
   int stunde,test=0;
    for (stunde=0;stunde<24;stunde++)
    {
       test++;
       //NSLog(@"stunde: %d test: %d",stunde,test);
    }
   // Felder fuer die Stunden aufbauen
   for (stunde=0;stunde<24;stunde++)
   {
      // NSLog(@"stunde: %d %d",stunde,6+stundenabstand*stunde);
      CGRect stundefeld = CGRectMake(6+stundenabstand*stunde, 50, 20, 20);
      UILabel* std = [[UILabel alloc]initWithFrame:stundefeld];
      std.text=[NSString stringWithFormat:@"%d",stunde];
      std.textAlignment = NSTextAlignmentCenter;
      std.backgroundColor = hintergrund;
      [self.tagplanfeld addSubview:std];
      
      // Tasten fuer halbe Stunden
      
      CGRect tastenfeld = CGRectMake(20+stundenabstand*stunde, 10, 30, 40);
      UIButton* hstdtaste0=[[UIButton alloc]initWithFrame:tastenfeld];
      [hstdtaste0 setBackgroundImage:blueButtonImage forState:UIControlStateSelected];
      [hstdtaste0 setBackgroundImage:defButtonImage forState:UIControlStateNormal];
      [hstdtaste0 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [hstdtaste0 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
      [hstdtaste0 setTag:100 +10*stunde];
      [hstdtaste0 addTarget:self
                   action:@selector(reportStundenTaste:)
         forControlEvents:UIControlEventTouchUpInside];
      [self.tagplanfeld addSubview:hstdtaste0];
      
      
      tastenfeld.origin.x += 32;
      UIButton* hstdtaste1=[[UIButton alloc]initWithFrame:tastenfeld];
      [hstdtaste1 setBackgroundImage:blueButtonImage forState:UIControlStateSelected];
      [hstdtaste1 setBackgroundImage:defButtonImage forState:UIControlStateNormal];
      [hstdtaste1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [hstdtaste1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
      [hstdtaste1 setTag:100 +10*stunde+1];
      [hstdtaste1 addTarget:self
                    action:@selector(reportStundenTaste:)
          forControlEvents:UIControlEventTouchUpInside];
      [self.tagplanfeld addSubview:hstdtaste1];
      
      // Tasten fuer ganze Stunden
      
      CGRect gtastenfeld = CGRectMake(20+stundenabstand*stunde, 10, 60, 40);
      UIButton* gstdtaste=[[UIButton alloc]initWithFrame:gtastenfeld];
      [gstdtaste setBackgroundImage:blueButtonImage forState:UIControlStateSelected];
      [gstdtaste setBackgroundImage:defButtonImage forState:UIControlStateNormal];
      [gstdtaste setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [gstdtaste setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
      [gstdtaste setTag:500 +10*stunde];
      [gstdtaste addTarget:self
                     action:@selector(reportStundenTaste:)
           forControlEvents:UIControlEventTouchUpInside];
      gstdtaste.hidden=YES;
      [self.tagplanfeld addSubview:gstdtaste];

   
   }
   
   // Tagplananzeige: typ angegen
   //self.tagplananzeige.typ=0;
   //self.ganzstundetagplananzeige.typ=1;
   
 //  [self showMessage:YES];
   [self.onofftaste setBackgroundImage:blueButtonImage forState:UIControlStateSelected];
   [self.onofftaste setBackgroundImage:defButtonImage forState:UIControlStateNormal];
   
   [self.onofftaste setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   [self.onofftaste setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
   
   [self.stundentaste setBackgroundImage:defButtonImage forState:UIControlStateNormal];
   [self.stundentaste setBackgroundImage:blueButtonImage forState:UIControlStateSelected];

   [self.stundentaste setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   [self.stundentaste setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
   
   self.oldstundencodearray  = self.aktuellerstundencodearray;
   [self setTagplanInRaum:self.aktuellerRaum fuerObjekt:self.aktuellesObjekt anWochentag:self.aktuellerWochentag];
   [self.tagplananzeige setNeedsDisplay];
   
   // https
   HomeCentralAdresseString = @"https://ruediheimlicherhome.dyndns.org";
   HomeServerAdresseString = @"https://www.ruediheimlicher.ch";

   self.webfenster.delegate = self;
   maxAnzahl = 32;
   [self.sendtaste setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   [self.sendtaste setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

   debugstring = [debugstring stringByAppendingString:@"C"];
   loadstring = [loadstring stringByAppendingString:@"B"];
   //NSLog(@"loadstring: %@ debugstring: %@",loadstring,debugstring);

   // Datum
   NSDate *currDate = [NSDate date];   //Current Date
   
   NSDateFormatter *df = [[NSDateFormatter alloc] init];
   
   //Day
   [df setDateFormat:@"dd"];
//   NSString* myDayString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   self.aktuellertag = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Month
   [df setDateFormat:@"MM"]; //MM will give you numeric "03", MMM will give you "Mar"
//   NSString* myMonthString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   self.aktuellermonat = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Year
   [df setDateFormat:@"yy"];
//   NSString* myYearString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   self.aktuellesjahr = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   //Hour
   [df setDateFormat:@"hh"];
//   NSString* myHourString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Minute
   [df setDateFormat:@"mm"];
//   NSString* myMinuteString = [NSString stringWithFormat:@"%@",[df stringFromDate:currDate]];
   
   //Second
   [df setDateFormat:@"ss"];
//   NSString* mySecondString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //NSLog(@"Year: %@, Month: %@, Day: %@, Hour: %@, Minute: %@, Second: %@", myYearString, myMonthString, myDayString, myHourString, myMinuteString, mySecondString);
   
   self.statusanzeige.anzahlelemente = 4;
   self.statusanzeige.typ=0;
   self.statusanzeige.code=0;
   NSArray* StatusanzeigeArray = [NSArray arrayWithObjects:@"TWI OFF",@"Adresse",@"Daten",@"Send OK", nil];
   self.statusanzeige.legendearray = StatusanzeigeArray;
   [self.statusanzeige setNeedsDisplay];
   self.lastTWIState=1;
 //  [self showDebug:@"viewDidLoad"];
/*
   
   Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
   
	// Set the blocks
	reach.reachableBlock = ^(Reachability*reach)
	{
		NSLog(@"REACHABLE!");
	};
   
	reach.unreachableBlock = ^(Reachability*reach)
	{
		NSLog(@"UNREACHABLE!");
	};
   
	// Start the notifier, which will cause the reachability object to retain itself!
	[reach startNotifier];
*/
   /*
   UIAlertController* alert_n = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                    message:@"This is an alert."
                                                             preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
   
   [alert_n addAction:defaultAction];
   
   [self presentViewController:alert_n animated:YES completion:nil];
*/
   debugstring = [debugstring stringByAppendingString:@"D"];
   loadstring = [loadstring stringByAppendingString:@"C"];
   //NSLog(@"loadstring: %@ debugstring: %@",loadstring,debugstring);

   // NSLog(@"viewdidLoad debugstring: %@",debugstring);
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   /*
   [rHomeController  checkInternetConnectivityWithSuccessCompletion:^{
      // your internet is working - add code here
      NSLog(@"viewDidAppear: Internet OK");
   }];
    */
   NSLog(@"viewDidAppear");
   NSString* message = [NSString stringWithFormat:@"viewDidAppear debugstring: %@",debugstring];
   //NSLog(@"viewDidAppear message: %@",message);
   //[self showDebug:message];
   
   NSLog(@"viewDidAppear self.twitaste.on: %d",self.twitaste.on);
}

- (NSString*)passwortstring
{
   NSString* returnstring = [NSString string];
   //NSString* ResourcenPfad=[[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Contents/Resources"];
  //NSString* ResourcenPfad = self.resourcePath;
  
   NSString *ResourcenPfad = [[NSBundle mainBundle] pathForResource:@"Passwort" ofType:@"txt"];
//   NSLog(@"ResourcenPfad: %@",ResourcenPfad);
   NSURL *fileUrl = [NSURL fileURLWithPath:ResourcenPfad];
   NSString* passwortstring = [NSString stringWithContentsOfFile:ResourcenPfad encoding:NSMacOSRomanStringEncoding error:NULL];
   //    DataString=[NSString stringWithContentsOfFile:DataPfad encoding:NSMacOSRomanStringEncoding error:NULL];
   //NSString* ResourcenPfad = self.resourcePath;
   NSArray* passwortArray = [passwortstring componentsSeparatedByString:@"\n"];
  // NSLog(@"passwortArray: %@",passwortArray);

     
   // NSLog(@"PasswortString: \n%@",PasswortTabelleString);
   NSArray* PasswortTabelle = [passwortstring componentsSeparatedByString:@"\n"];
   //NSLog(@"PasswortArray: \n%@",PasswortTabelle  );
   //NSLog(@"PasswortArray 6: \n%@",[PasswortTabelle objectAtIndex:6] );
   //NSString* tempPW = [[[PasswortTabelle objectAtIndex:6]componentsSeparatedByString:@"\t"]objectAtIndex:3];
   //NSLog(@"tempPW: %@",tempPW);
   
   /*
    pw_array = 
    {0x47,   0x3E,   0xD,   0x5,   0x21,   0x3D,   0x42,   0x25,
    0x22,   0x34,   0x3F,   0x4C,   0x10,   0x5,   0x3C,   0x63,
    0x50,   0x5,   0x7,   0x0,   0x3C,   0x11,   0x43,   0x4D,
    0x6,   0x5E,   0x0,   0x53,   0x34,   0x10,   0x41,   0x1F,
    0x2A,   0x5E,   0x16,   0x2B,   0x56,   0x7,   0x44,   0x62,
    0x8,   0x54,   0x18,   0x2F,   0x4D,   0x1,   0x5F,   0x4,
    0x9,   0x22,   0x5E,   0x36,   0x2C,   0x48,   0x45,   0x13,
    0x26,   0x5C,   0x4D,   0x4B,   0x32,   0x1E,   0x1D,   0x3F};
    */
   
   srand((unsigned int)time(NULL));   // should only be called once
   int randomnummer1 = rand()%63+1;
   
   randomnummer1=59;
   
   //NSLog(@"Util passwortstring randomnummer 1: *%d* reminder: %d mantisse: %d",randomnummer1 ,randomnummer1%8,randomnummer1/8);
   int randomzeile1 = randomnummer1%8;
   int randomkolonne1 = randomnummer1/8;
   NSLog(@"Util passwortstring randomnummer 1: *%d* randomzeile: %d randomkolonne: %d",randomnummer1 ,randomzeile1,randomkolonne1);
   
   NSString* passwort1 = [[[PasswortTabelle objectAtIndex:randomzeile1]componentsSeparatedByString:@"\t"]objectAtIndex:randomkolonne1];
   //   NSLog(@"passwortstring passwort1: %@ randomnummer 1: *%d* randomzeile: %d randomkolonne: %d",passwort1,randomnummer1 ,randomzeile,randomkolonne);
   
   
   int randomnummer2 = rand()%63+1;
   
   randomnummer2 = 51;
   //NSLog(@"Util passwortstring randomnummer 2: *%d* reminder: %d mantisse: %d",randomnummer2 ,randomnummer2%8,randomnummer2/8);
   int randomzeile2 = randomnummer2%8;
   int randomkolonne2 = randomnummer2/8;
   NSString* passwort2 = [[[PasswortTabelle objectAtIndex:randomzeile2]componentsSeparatedByString:@"\t"]objectAtIndex:randomkolonne2];
 //  NSLog(@"Util passwortstring randomnummer 2: *%d* randomzeile: %d randomkolonne: %d",randomnummer2 ,randomzeile2,randomkolonne2);
   
   
   returnstring = [NSString stringWithFormat:@"%02X\t%02X\t%02X\t%02X",randomnummer1,[passwort1 intValue],randomnummer2,[passwort2 intValue]];
   
 //  NSLog(@"Util passwortstring returnstring: %@",returnstring);
   return returnstring;
}

- (void)backgroundaktion:(NSNotification*)note
{
   NSLog(@"backgroundaktion on: %d",self.twitaste.on);
   
  if ((self.twitaste) && (self.twitaste.on == 0))
   {
      NSLog(@"backgroundaktion twitaste ist noch off");
      [self setTWIState:YES];
   }
   else
   {
       NSLog(@"backgroundaktion twitaste ist on");
   }
   
}

- (void)resignaktion:(NSNotification*)note
{
   NSLog(@"resignaktion on: %d",self.twitaste.on);

   if (self.twitaste && (self.twitaste.on == 0))
   {
      NSLog(@"resignaktion twitaste ist noch off");
      [self setTWIState:YES];
   }
   else
   {
      NSLog(@"resignaktion twitaste ist on");
      
   }
   
   //NSLog(@"resignaktion nach setTWIstate on: %d",self.twitaste.on);
}

- (void)beendenAktion:(NSNotification*)note
{
   NSLog(@"beendenktion on: %d",self.twitaste.on);
   
   if (self.twitaste.on == 0)
   {
      NSLog(@"beendenAktion twitaste ist noch off");
      [self setTWIState:YES];
   }
   else
   {
      NSLog(@"beendenAktion twitaste ist on");
      
   }


   NSLog(@"beendenktion nach setTWIstate on: %d",self.twitaste.on);
   //[NSApp termminate:self];
}


- (NSMutableArray*)setTagplanInRaum:(int)raum fuerObjekt:(int)objekt anWochentag:(int)wochentag
{
   //[self showDebug:@"setTagplanInRaum"];
   // eventuell TWI-Timer reseten
   if ([TWIStatusTimer isValid])
   {
      NSMutableDictionary* TWITimerDic=(NSMutableDictionary*) [TWIStatusTimer userInfo];
      [TWITimerDic setObject:[NSNumber numberWithInt:maxAnzahl] forKey:@"twitimeoutanzahl"];
   }
   int zeile = 56* raum + 7*objekt + wochentag;
   
   NSArray* ZeilenArray = [[self.wochenplanarray objectAtIndex:zeile]componentsSeparatedByString:@"\t"];
   //NSLog(@"setTagplanInRaum: %d objekt: %d wochentag: %d ZeilenArray: %@",raum,objekt,wochentag,[[self.wochenplanarray objectAtIndex:zeile]description]);
   //NSLog(@"setTagplanInRaum: %d objekt: %d wochentag: %d ZeilenArray: %@",raum,objekt,wochentag,[ZeilenArray description]);
   if ([ZeilenArray count]>4)
   {
      // Array mit 6 Bytes fuer je 4 Tasten. Int-Werte
      NSArray* ZeilenDataArray = [ZeilenArray subarrayWithRange:NSMakeRange(4, 6)];
      
      
      // Array mit 24 int 0..3 mit den Angaben fuer jede Stunde
      //NSMutableArray* StundenByteArray = [self StundenCodeArrayVonByteArray:ZeilenDataArray];
      
      self.aktuellerstundencodearray  = [self StundenCodeArrayVonByteArray:ZeilenDataArray];
      
      
      self.tagplananzeige.datenarray = self.aktuellerstundencodearray;
//    self.ganzstundetagplananzeige.datenarray = self.aktuellerstundencodearray;
//    [self.ganzstundetagplananzeige setNeedsDisplay];
      [self.tagplananzeige setNeedsDisplay];
      
      //[self.tagplandic setObject:self.aktuellerstundencodearray forKey:@"stundencodearray"];
      
      
      //NSLog(@"StundenByteArray: %@",[self.aktuellerstundencodearray description]);
      
      if ([ZeilenArray count]>13)
      {
         self.aktuellerObjektname = [ZeilenArray objectAtIndex:13];
         //NSLog(@"aktuellerObjektname: %@",self.aktuellerObjektname);
         self.objektname.text = [ZeilenArray objectAtIndex:13];
      }
      else
      {
         self.aktuellerObjektname =  @"Kein_Name";
         self.objektname.text = @"Kein_Name";
      }
      //[self.tagplandic setObject:self.objektname.text forKey:@"objektname"];
      
      if ([ZeilenArray count]>14)
      {
         
         self.aktuellerObjekttyp = [[ZeilenArray objectAtIndex:14]intValue];
      }
      else
      {
         self.aktuellerObjekttyp=0;
      }
      //NSLog(@"setTagplan aktuellerObjekttyp: %d",self.aktuellerObjekttyp);
      
      self.tagplananzeige.typ = self.aktuellerObjekttyp;
       
      [self setTagPlanInRaum:raum fuerObjekt:objekt anWochentag:wochentag mitDaten:self.aktuellerstundencodearray];
      
      return nil;
   }
   else
   {
      self.objektname.text = @"Keine Daten";
      [self clearTagplan];
      
   }
   return nil;
}



- (void)setTagPlanInRaum:(int)raum fuerObjekt:(int)objekt anWochentag:(int)wochentag mitDaten:(NSArray*)stundencodearray
{
   //int bytezeile = 56*raum + 7*objekt + wochentag;// zeile: 56*$raum + 7*$objekt + $wochentag // aus eeprom.pl
   
   
   for (int stunde=0;stunde<24;stunde++)
   {
      int stundenwert = [[stundencodearray objectAtIndex:stunde]intValue];
      
      // tags fuer halbe stunden
      int htaste0tag = 100 + 10*stunde;
      int htaste1tag = htaste0tag +1;
      
      // tags fuer ganze stunden
      int gtastetag = 500 + 10*stunde;
      //NSLog(@"stunde: %d htaste0tag: %d htaste1tag: %d gtastetag: %d aktuellerObjekttyp: %d",stunde,htaste0tag,htaste1tag,gtastetag,self.aktuellerObjekttyp);
      //
      {
         switch (self.aktuellerObjekttyp)
         {
            case 0: // halbe Stunden
            {
               //NSLog(@"stundenwert: %d htaste0tag: %d",stundenwert,htaste0tag);
               //NSLog(@"w0: %d w1: %d",(stundenwert & 0x02),(stundenwert & 0x01));
               
               [[self.tagplanfeld viewWithTag:gtastetag]setHidden:YES];
               [[self.tagplanfeld viewWithTag:htaste0tag]setHidden:NO];
               [[self.tagplanfeld viewWithTag:htaste1tag]setHidden:NO];
               
               [(UIButton*)[self.tagplanfeld viewWithTag:htaste0tag]setSelected:((stundenwert & 0x02)>0)];
              
               [(UIButton*)[self.tagplanfeld viewWithTag:htaste1tag]setSelected:((stundenwert & 0x01)>0)];
               
            }break;
               
            case 1: // nur ganze Stunden
            {
               //NSLog(@"stundenwert: %d htaste0tag: %d",stundenwert,htaste0tag);
               [[self.tagplanfeld viewWithTag:htaste0tag]setHidden:YES];
               [[self.tagplanfeld viewWithTag:htaste1tag]setHidden:YES];
               [[self.tagplanfeld viewWithTag:gtastetag]setHidden:NO];
               
               [(UIButton*)[self.tagplanfeld viewWithTag:gtastetag]setSelected:((stundenwert )>0)];
            }break;
               
         } // switch ObjektTyp
      }
      
   }
   [self.tagplanfeld setNeedsDisplay];
}


- (NSString*)readWochenplan
{
   //[self showDebug:@"readWochenplan"];
   NSString* ServerPfad =@"https://www.ruediheimlicher.ch/Data/eepromdaten/";
   NSString* DataSuffix=@"eepromdaten.txt";
   //NSLog(@"readWochenplan  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
   NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
   NSLog(@"readWochenplan URL: %@",URL);
   NSStringEncoding *  enc= nil;
   NSError* WebFehler=NULL;
   NSString* DataString=[NSString stringWithContentsOfURL:URL usedEncoding: enc error:&WebFehler];
   if (WebFehler)
   {
      NSLog(@"readWochenplan WebFehler: :%@",[[WebFehler userInfo]description]);
   }
   //NSLog(@"readWochenplan DataString: %@",DataString);
   
   return DataString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   //Scene2ViewController *destination =
   NSLog(@"prepareForSegue: %@",[segue description]);
   
   //destination.labelText = @"Arrived from Scene 1";
}

-(void)IPAktion:(NSNotification*)note
{
//   NSString* IP = [[rVariableStore sharedInstance] IP];
   NSLog(@"IPAktion IP: %@",[[note userInfo]description]);
   //self.ipfeld.text = @"*";
}


- (IBAction)reportOnOff:(UIButton*)sender
{
   NSLog(@"reportOnOff");
   BOOL toggleIsOn = sender.selected;
   sender.selected = !sender.selected;
      if(toggleIsOn){
         NSLog(@"reportOnOff ON");
         //do anything else you want to do.
      }
      else {
         NSLog(@"reportOnOff OFF");
         //do anything you want to do.
      }
      //toggleIsOn = !toggleIsOn;
      //[self.onofftaste setImage:[UIImage imageNamed:toggleIsOn ? @"on.png" :@"off.png"] forState:UIControlStateNormal];
   
}

- (IBAction)reportClear:(id)sender
{
   NSLog(@"reportClear");
   // Felder fuer die Stunden aufbauen
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tagplan löschen?"
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* NEINAction = [UIAlertAction actionWithTitle:@"NEIN" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
   
   [alert addAction:NEINAction];
   UIAlertAction* JAAction = [UIAlertAction actionWithTitle:@"JA" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
   
   [alert addAction:JAAction];
   [self presentViewController:alert animated:YES completion:nil];

}


- (void)clearTagplan
{
   NSLog(@"clearTagplan");
   // Felder fuer die Stunden aufbauen
   for (int stunde=0;stunde<24;stunde++)
   {
      [(UIButton*)[self.tagplanfeld viewWithTag:100+10*stunde]setSelected:NO];
      [(UIButton*)[self.tagplanfeld viewWithTag:100+10*stunde+1]setSelected:NO];
   }
[self restartTWITimer];
}



- (IBAction)reportRaumSeg:(UISegmentedControl*)sender
{
   NSLog(@"reportRaumSeg %d",(int)sender.selectedSegmentIndex);
   self.aktuellesObjekt = 0;
   self.objektstepper.value = 0;
   self.aktuellerRaum = sender.selectedSegmentIndex;
   [self setTagplanInRaum:self.aktuellerRaum fuerObjekt:self.aktuellesObjekt anWochentag:self.aktuellerWochentag];
   [self restartTWITimer];
   
   if (self.twitaste.on == YES)
   {
      //NSLog(@"reportRaumSeg twitaste YES");
      self.statusanzeige.code = 0x00;
   }
   else
   {
      //NSLog(@"reportRaumSeg twitaste NO");
      self.statusanzeige.code = 0x01;
   }
   
   [self.statusanzeige setNeedsDisplay];
}


- (IBAction)reportObjektStepper:(UIStepper*)sender
{
   NSLog(@"reportObjektStepper %d",(int)sender.value);
   NSLog(@"reportObjektStepper aktuellerRaum: %d aktuellesObjekt: %d",self.aktuellerRaum,self.aktuellesObjekt);
   
   self.aktuellesObjekt = (int)sender.value;
  
   [self setTagplanInRaum:self.aktuellerRaum fuerObjekt:self.aktuellesObjekt anWochentag:self.aktuellerWochentag];
   [self restartTWITimer];
   if (self.twitaste.on == YES)
   {
      //NSLog(@"reportRaumSeg twitaste YES");
      self.statusanzeige.code = 0x00;
   }
   else
   {
      //NSLog(@"reportRaumSeg twitaste NO");
      self.statusanzeige.code = 0x01;
   }

   [self.statusanzeige setNeedsDisplay];
}


- (IBAction)reportWochentagSeg:(UISegmentedControl*)sender
{
   
   self.aktuellerWochentag = sender.selectedSegmentIndex;
   [self setTagplanInRaum:self.aktuellerRaum fuerObjekt:self.aktuellesObjekt anWochentag:self.aktuellerWochentag];
   
   NSLog(@"reportWochentagSeg aktuellerWochentag: %ld",self.aktuellerWochentag);
   [self restartTWITimer];
   if (self.twitaste.on == YES)
   {
      //NSLog(@"reportRaumSeg twitaste YES");
      self.statusanzeige.code = 0x00;
   }
   else
   {
      //NSLog(@"reportRaumSeg twitaste NO");
      self.statusanzeige.code = 0x01;
   }

   [self.statusanzeige setNeedsDisplay];

}

- (IBAction)reportResetTaste:(id)sender
{
   NSString *WochenplanString = [self readWochenplan];
   self.wochenplanarray = [WochenplanString componentsSeparatedByString:@"\n"];
   
   [self.aktuellerstundencodearray setArray: self.oldstundencodearray];
   [self setTagplanInRaum:self.aktuellerRaum fuerObjekt:self.aktuellesObjekt anWochentag:self.aktuellerWochentag];
   self.hexdata.text = @"";
   self.testdata.text = @"";
   [self restartTWITimer];
}

- (void)setzePermanent:(int)perm
{
   NSLog(@"setPermanent: %d",perm);
   self.permanent = perm;
   
}

- (IBAction)reportSendTaste:(UIButton *)sender
{
   NSLog(@"reportSendTaste");
  
   //NSLog(@"reportSendTaste aktuellerstundencodearray: %@",[self.aktuellerstundencodearray description]);
   NSArray* StundenByteArray = [self StundenByteArrayVonStundenCodeArray:[self aktuellerstundencodearray]];
   //NSLog(@"reportSendTaste StundenByteArray: %@",[StundenByteArray description]);
   /*
   // Webserver:
    
    HomeClientWriteStandardAktion HomeClientURLString: https://192.168.1.210/twi?pw=ideur00&wadr=0&lbyte=00&hbyte=00&data=0+f+fb+33+ff+75+ff+ff
    
   sendEEPROM URL: https://www.ruediheimlicher.ch/cgi-bin/eeprom.pl?pw=ideur00&perm=1&hbyte=00&lbyte=00&data=0+15+251+51+255+117+255+255&titel=Brenner&typ=0
   */
   
   // URL fuer HomeCentral aufbauen:
   NSString* HomeCentralPfad = [NSString stringWithFormat:@"%@/twi?pw=ideur00&wadr=0&%@",HomeCentralAdresseString,pwpart];
   //NSLog(@"send raum: %d objekt: %d wochentag: %d",self.aktuellerRaum,self.aktuellesObjekt,self.aktuellerWochentag);
   uint16_t i2cStartadresse=self.aktuellerRaum*RAUMPLANBREITE + self.aktuellesObjekt*TAGPLANBREITE+ self.aktuellerWochentag*0x08;
   
   uint8_t lb = i2cStartadresse & 0x00FF;
   uint8_t hb = i2cStartadresse >> 8;
   
   // lbyte, hbyte werden als dez eingesetzt, nicht als hex. Aus Webinterface uebernommen.
   
   NSString* lbyte = [NSString stringWithFormat:@"%02d",lb];
   NSString* hbyte = [NSString stringWithFormat:@"%02d",hb];
   
   
   //NSLog(@"wochentag: %d lbyte: %@ hbyte: %@ i2cStartadresse: %04X %d",self.aktuellerWochentag,lbyte,hbyte,i2cStartadresse,i2cStartadresse);
   /*
    // in WebInterface:
   NSString* lbyte=[[[note userInfo]objectForKey:@"lbyte"]stringValue];
	NSString* hbyte=[[[note userInfo]objectForKey:@"hbyte"]stringValue];
   if ([lbyte length]==1)
   {
      lbyte = [@"0" stringByAppendingString:lbyte];
   }
   if ([hbyte length]==1)
   {
      hbyte = [@"0" stringByAppendingString:hbyte];
   }
*/
   NSString* DataString=@"&data=1"; // Data ankuendigen
   // data anfuegen
   int i=0;
   for (i=0;i<8;i++) // 8 bytes uebertragen
   {
      if (i<[StundenByteArray count])
      {
         DataString= [NSString stringWithFormat:@"%@&d%d=%x",DataString,i,[[StundenByteArray objectAtIndex:i]intValue]];
      }
      else // auffuellen mit 0xff
      {
         DataString= [NSString stringWithFormat:@"%@&d%d=%x",DataString,i,0xff];
         
      }
      
   }// for i
   

   
   /*
   NSString* DataString=@"data=";
   for (int i=0;i<8;i++)
   {
      if (i<[StundenByteArray count])
      {
         DataString= [NSString stringWithFormat:@"%@%x",DataString,[[StundenByteArray objectAtIndex:i]intValue]];
      }
      else
      {
         DataString= [NSString stringWithFormat:@"%@%x",DataString,0xFF];
      }
      if (i< (8-1))
      {
         DataString = [DataString stringByAppendingString:@"+"];
      }
   }
   */
   
   
   self.hexdata.text = DataString;
   
   
   
   
   
    UIAlertController* sendalert = [UIAlertController alertControllerWithTitle:@"Speicherung"
    message:@"Daten permanent?"
    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* NOAction = [UIAlertAction actionWithTitle:@"NEIN" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action)
    {
       NSLog(@"Daten nur temporaer.");
       [self setzePermanent:4];
       self.permanent=4;
       NSString* HomeCentralString = [HomeCentralPfad stringByAppendingFormat:@"&permanent=%@&lbyte=%@&hbyte=%@&%@",@"4",lbyte,hbyte,DataString];
       NSLog(@"HomeCentralString temp: %@",HomeCentralString);
       HomeCentralURL = [NSURL URLWithString:HomeCentralString];
       [self loadURL:HomeCentralURL];
       [self restartTWITimer];
       [sender setEnabled:NO];
       self.statusanzeige.code = 0x01;

       
    }];
    [sendalert addAction:NOAction];
    
    UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"JA" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action)
          {
             NSLog(@"Daten permanent");
             [self setzePermanent:3];
             self.permanent=3;
             NSString* HomeCentralString = [HomeCentralPfad stringByAppendingFormat:@"&permanent=%@&lbyte=%@&hbyte=%@&%@",@"3",lbyte,hbyte,DataString];
             NSLog(@"HomeCentralString permanent: %@",HomeCentralString);
             HomeCentralURL = [NSURL URLWithString:HomeCentralString];
             [self loadURL:HomeCentralURL];
             [self restartTWITimer];
             [sender setEnabled:NO];
             self.statusanzeige.code = 0x01;

          }];
    
    [sendalert addAction:OKAction];
    [self presentViewController:sendalert animated:YES completion:nil];
    
    

//   HomeCentralURL = [NSURL URLWithString:HomeCentralString];
   
 //  NSLog(@"HomeCentralURL: %@",HomeCentralURL);
   
  
   // URL fuer Homeserver aufbauen
   
   // http://www.ruediheimlicher.ch/cgi-bin/eeprom.pl?pw=ideur00&perm=1&hbyte=00&lbyte=00&data=0+15+251+51+255+117+255+255&titel=Brenner&typ=0
   
   
   NSString* EEPROMDataString = [StundenByteArray componentsJoinedByString:@"+"];
   
   
   //NSString* aktuellerWochentagString = [NSString stringWithFormat:@"%02d",self.aktuellerWochentag];
   EEPROMDataString = [EEPROMDataString stringByAppendingFormat:@"+255+255"];
   
   
   
   //NSString* Datumzusatz = [NSString stringWithFormat:@"%@%@%@",self.aktuellesjahr, self.aktuellermonat, self.aktuellerWochentagString];
   NSLog(@"permanent: %d",self.permanent);
   NSString* HomeServerString = [HomeServerAdresseString stringByAppendingFormat:@"/cgi-bin/eeprom.pl?pw=ideur00&perm=%d&lbyte=%@&hbyte=%@&data=%@&titel=%@&tagbalkentyp=%d",self.permanent,lbyte,hbyte,EEPROMDataString,self.aktuellerObjektname,self.aktuellerObjekttyp];
   HomeServerSendString  = [HomeServerAdresseString stringByAppendingFormat:@"/cgi-bin/eeprom.pl?pw=ideur00&lbyte=%@&hbyte=%@&data=%@&titel=%@&tagbalkentyp=%d",lbyte,hbyte,EEPROMDataString,self.aktuellerObjektname,self.aktuellerObjekttyp];
   
    
   NSLog(@"HomeServerString: %@",HomeServerString);
   HomeServerURL = [NSURL URLWithString:HomeServerString];
    NSLog(@"HomeServerURL: %@",HomeServerURL);
   
   NSLog(@"HomeCentralURL: %@",HomeCentralURL);
   
//   [self loadURL:HomeCentralURL];
   //[self loadURL:HomeServerURL];
//   [self restartTWITimer];
   [sender setEnabled:NO];
   self.statusanzeige.code = 0x01;
   
}

- (void)sendEEPROMDataAnHomeServer
{
   self.statusanzeige.code |= DATAOK;
   [self.statusanzeige setNeedsDisplay];

   [self loadURL:HomeServerURL];
}


- (IBAction)reportTWITaste:(UISwitch *)sender
{
   
   self.hexdata.text = @"";
   self.testdata.text = @"";

   self.statusanzeige.code=0;
   [self.statusanzeige setNeedsDisplay];
   NSLog(@"reportTWITaste state: %d",sender.on);
   if (sender.on)
   {
      [self setTWIState:YES];// TWI einschalten
      
   }
   else
   {
      [self.ladeindikator startAnimating];
      self.ladeindikator.hidden = NO;
      
      
      UIAlertController* alert_n = [UIAlertController alertControllerWithTitle:@"TWI-Status"
                                                                       message:@"TWI ausschalten?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction* NOAction = [UIAlertAction actionWithTitle:@"NEIN" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action)
      {
         NSLog(@"TWI nicht ausschalten.");
         //self.twitaste.on=YES;
         // Nichts tun
         [self.ladeindikator stopAnimating];
         self.ladeindikator.hidden = YES;
         
         
      }];
      [alert_n addAction:NOAction];

      UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"JA" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action)
                                      {
                                         NSLog(@" TWI ausschalten");
                                         [self setTWIState:NO]; // TWI ausschalten
                             
                                      }];
      
      [alert_n addAction:OKAction];
      [self presentViewController:alert_n animated:YES completion:nil];
      

      /*
      Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
      
      // Set the blocks
      reach.reachableBlock = ^(Reachability*reach)
      {
         NSLog(@"REACHABLE!");
         //self.twialarm.hidden=YES;
    //     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TWI-Status" message:@"TWI ausschalten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja",nil];
    //     [alert show];
         [self setTWIState:NO];
      
      };
      
      reach.unreachableBlock = ^(Reachability*reach)
      {
         NSLog(@"UNREACHABLE!");
        // self.twialarm.hidden=NO;
      //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung zum Internet" message:@"Mobile Daten muss aktiviert sein" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
       //  [alert show];
         
      };
      
      // Start the notifier, which will cause the reachability object to retain itself!
      [reach startNotifier];
      
      
      //
       */
   }
}


- (void)TWIstatusTimerFunktion:(NSTimer*) derTimer
{
   NSMutableDictionary* statusTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"statusTimerFunktion  maxAnzahl: %d  statusTimerDic: %@",maxAnzahl,[statusTimerDic description]);
   
	if ([statusTimerDic objectForKey:@"anzahl"])
	{
		int anz=[[statusTimerDic objectForKey:@"anzahl"] intValue];
      
      if (self.twitaste.on)
      {
         [derTimer invalidate];
         return;
      }
      
		if (anz < maxAnzahl)
		{
			anz++;
			if (anz>10)
			{
            
 			}
			
			[statusTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
         
      }
}
}

- (void)setTWIState:(int)status
{
   NSLog(@"setTWIstate status: %d",status);
   
   if (status)
   {
      //NSLog(@"setTWIstate TWI einschalten");
      self.twitimer.hidden=YES;
      self.twitimer.text = @"";
      [self.ladeindikator stopAnimating];
      self.ladeindikator.hidden = YES;
      
      self.sendtaste.enabled= NO;
      NSString* TWIStatusSuffix = [NSString stringWithFormat:@"pw=%s&status=%@",PW,@"1"];
      NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@%@",HomeCentralAdresseString, TWIStatusSuffix,pwpart];
      
      //NSLog(@"TWIStatusAktion >ON TWIStatusURL: %@",TWIStatusURLString);
      self.testdata.text = [NSString stringWithFormat:@"ON %@",TWIStatusURLString];
      NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
      //NSLog(@"TWI ein URL: %@",URL);
      
      //NSError* err=0;
      //NSString *html = [NSString stringWithContentsOfURL:URL encoding:NSASCIIStringEncoding error:&err];
      //NSLog(@"TWI ON html: %@\nerr: %@",html,err);
      
      [self loadURL:URL];
      if (TWIStatusTimer && [TWIStatusTimer isValid])
      {
         [TWIStatusTimer invalidate];
      }
      self.testdata.text = @"";
      self.connection.text =@"";
   }
   else
   {
      //NSLog(@"setTWIstate TWI ausschalten");
      
      [self.ladeindikator startAnimating];
      self.ladeindikator.hidden = NO;
      
      // https
      Reachability* reach = [Reachability reachabilityWithHostname:@"ruediheimlicherhome.dyndns.org"];
      
      // Set the blocks
      
      NSLog(@"setTWIState > OFF currentReachabilityString: %@",reach.currentReachabilityString);
      
      
      reach.reachableBlock = ^(Reachability*reach)
      {
         //NSLog(@"REACHABLE!");
         //self.twialarm.hidden=YES;
         //     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TWI-Status" message:@"TWI ausschalten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja",nil];
         //     [alert show];
         //[self setTWIState:NO];
         
         
         /*
          if ([[reach currentReachabilityString] isEqualToString:@"No Connection"])
          {
          self.twialarm.hidden=YES;
          //NSLog(@"in reachableBlock: keine Verbindung");
          [self.ladeindikator stopAnimating];
          
          self.ladeindikator.hidden = YES;
          self.twitaste.on=YES;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung zum Internet" message:@"in reachableBlock: : +Mobile Daten muss aktiviert sein" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
          [alert show];
          
          return;
          }
          */
         
      };
      /*
       if ([[reach currentReachabilityString] isEqualToString:@"No Connection"])
       {
       
       UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Keine Verbindung zum Internet"
       message:@"Mobile Daten muss aktiviert sein."
       preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {}];
       
       [alert addAction:defaultAction];
       [self presentViewController:alert animated:YES completion:nil];
       
       }
       */
      
      reach.unreachableBlock = ^(Reachability*reach)
      {
         NSLog(@"UNREACHABLE!");
         NSString* message = @"UNREACHABLE!";
         self.testdata.text = [NSString stringWithFormat:@"OF %@",message];
         
      };
      
      // Start the notifier, which will cause the reachability object to retain itself!
      [reach startNotifier];
      
//      NSLog(@"currentReachabilityString: %@",[reach currentReachabilityString]);
      
      self.connection.text =[reach currentReachabilityString];
      if ([[reach currentReachabilityString] isEqualToString:@"No Connection"])
      {
         self.twialarm.hidden=YES;
         NSLog(@"keine Verbindung");
         [self.ladeindikator stopAnimating];
         
         self.ladeindikator.hidden = YES;
         self.twitaste.on=YES;
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Keine Verbindung zum Internet" message:@"*Mobile Daten muss //aktiviert sein" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
         //[alert show];
         
         NSLog(@"alertController keone Verbindung ");
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Keine Verbindung zum Internet"
                                                                        message:@"Mobile Daten muss aktiviert sein."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {}];
         
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         return;
      }
      else
      {
         
         NSString* TWIStatusSuffix = [NSString stringWithFormat:@"pw=%s&status=%@",PW,@"0"];
         NSString* TWIStatusURLString =[NSString stringWithFormat:@"%@/twi?%@%@",HomeCentralAdresseString, TWIStatusSuffix,pwpart];
         
         NSLog(@"TWIStatusAktion >OFF TWIStatusURL: %@",TWIStatusURLString);
         self.testdata.text = [NSString stringWithFormat:@"OF %@",TWIStatusURLString];
         
         NSURL *URL = [NSURL URLWithString:TWIStatusURLString];
         //NSLog(@"TWI aus URL: %@",URL);
         
         //NSError* err=0;
         // NSString *html = [NSString stringWithContentsOfURL:URL encoding:NSASCIIStringEncoding error:&err];
         // NSLog(@"TWI OFF html: %@\nerr: %@",html,err);
         [self loadURL:URL];
         NSMutableDictionary* confirmTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
         [confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
         int sendResetDelay=3.0;
         
         //NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
         
         confirmStatusTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
                                                             target:self
                                                           selector:@selector(statusTimerFunktion:)
                                                           userInfo:confirmTimerDic
                                                            repeats:YES];
      }
   }
   
}

- (void)statusTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* statusTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"statusTimerFunktion  maxAnzahl: %d  statusTimerDic: %@",maxAnzahl,[statusTimerDic description]);
   
	if ([statusTimerDic objectForKey:@"anzahl"])
	{
		int anz=[[statusTimerDic objectForKey:@"anzahl"] intValue];
      
      
      
      NSString* TWIStatus0URL;
		if (anz < maxAnzahl)
		{
			anz++;
			if (anz>1)
			{
            NSString* pw = [NSString stringWithUTF8String: PW];
            NSString* TWIStatus0URLSuffix = [NSString stringWithFormat:@"pw=%@&isstat0ok=1",pw];
            
            TWIStatus0URL =[NSString stringWithFormat:@"%@/twi?%@%@",HomeCentralAdresseString, TWIStatus0URLSuffix,pwpart];
            [statusTimerDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            self.testdata.text = [NSString stringWithFormat:@"timer anz %d",anz];
            
            NSURL *URL = [NSURL URLWithString:TWIStatus0URL];
            
            //NSLog(@"statusTimerFunktion  URL: %@",URL);
            [self loadURL:URL];
			}
			
			[statusTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
         
         
			// Blinkanzeige im PW-Feld
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			if (anz%2==0)// gerade
			{
            //[self loadURL:URL];
            //self.sendtaste.hidden=NO;
				[tempDataDic setObject:@"*" forKey:@"wait"];
			}
			else
			{
            //self.sendtaste.hidden=YES;
				[tempDataDic setObject:@" " forKey:@"wait"];
			}
			
			//NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			//[nc postNotificationName:@"StatusWait" object:self userInfo:tempDataDic];
			
		}
		else
		{
			
			NSLog(@"statusTimerFunktion statusTimer invalidate");
         self.testdata.text = [NSString stringWithFormat:@"TWI error"];
         [self.ladeindikator stopAnimating];
         self.ladeindikator.hidden = YES;
         self.twitaste.on=YES;
         
			// Misserfolg an AVRClient senden
         
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"isstatusok"];
         if ([statusTimerDic objectForKey:@"local"] && [[statusTimerDic objectForKey:@"local"]intValue]==1 )
         {
            [tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"local"];
         }
         else
         {
            [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"local"];
            
         }
			self.sendtaste.hidden=NO;
         
         
			[derTimer invalidate];
         self.testdata.text = [NSString stringWithFormat:@""];

         [self showWarnungMitTitel:@"Keine Verbindung mit HomeCentral!" mitWarnung:@"Mobile Daten muss' aktiviert sein"];
 
			
		}
		
	}
}

- (void)TWITimerFunktion:(NSTimer*) derTimer
{
   /*
   Zaehlt vorwaerts und schaltet bei Erreichen von maxAnzahl den TWI wieder ein.
    Angezeigt wird die restliche Anzahl von Intervallen (rueckwaerts)!
   */
	NSMutableDictionary* statusTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"statusTimerFunktion  maxAnzahl: %d  statusTimerDic: %@",maxAnzahl,[statusTimerDic description]);
   
	if ([statusTimerDic objectForKey:@"twitimeoutanzahl"])
	{
		int anz=[[statusTimerDic objectForKey:@"twitimeoutanzahl"] intValue];
      //NSLog(@"TWITimerFunktion statusTimer anz: %d",anz);
		if (anz < maxAnzahl)
		{
			anz++;
			self.twitimer.text = [NSString stringWithFormat:@"%d",(maxAnzahl - anz)];
			[statusTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"twitimeoutanzahl"];
         
         
			
		}
		else
		{
			
			NSLog(@"TWITimerFunktion statusTimer invalidate");
			// Misserfolg an AVRClient senden
         [self setTWIState:YES];
			self.twitimer.hidden=NO;
			[derTimer invalidate];
			self.twitimer.hidden=YES;
			self.twitaste.on=YES;
         self.statusanzeige.code=0;
         [self.statusanzeige setNeedsDisplay];

         
		}
		
	}
}

- (void)restartTWITimer
{
   //NSLog(@"restartTWITimer");
   if (TWIStatusTimer && [TWIStatusTimer isValid])
   {
      [[TWIStatusTimer userInfo]setObject:[NSNumber numberWithInt:0] forKey:@"twitimeoutanzahl" ];
      //NSMutableDictionary* tempDic = [TWIStatusTimer userInfo];
      //NSLog(@"restartTWITimer tempDic vor: %@",[tempDic description]);
      //[tempDic setObject:[NSNumber numberWithInt:0] forKey:@"twitimeoutanzahl" ];
       //NSLog(@"restartTWITimer tempDic nach: %@",[tempDic description]);
   }
}

- (IBAction)reportStundenTaste:(rToggleTaste*)sender
{
   //NSLog(@"reportStundenTaste: selected vor: %d tag: %d",sender.selected,sender.tag);
   sender.selected = !sender.selected;
 //  int tastenON = sender.selected;
   int tastenstunde =0;
   switch(self.aktuellerObjekttyp)
   {
      case 0:
      {
         tastenstunde = (int)(sender.tag-100)/10;
      }break;
      case 1:
      {
         tastenstunde = (int)(sender.tag-500)/10;
      }break;
   }
   
   int ON = [[self.aktuellerstundencodearray objectAtIndex:tastenstunde]intValue];
   //NSLog(@"reportStundenTaste: ON vor: %d",[[self.aktuellerstundencodearray objectAtIndex:tastenstunde]intValue]);
   //NSLog(@"reportStundenTaste: ON vor: %d",ON);
   switch(self.aktuellerObjekttyp)
   {
      case 0:
      {
         switch (sender.tag%2)
         {
            case 0:// Taste links
            {
               //NSLog(@"reportStundenTaste: links");
               if (sender.selected==YES)
               {
                  ON |= 0x02;
               }
               else
               {
                  ON &= ~0x02;
               }
            }
               break;
            case 1:// Taste rechts
            {
               //NSLog(@"reportStundenTaste: rechts");
               if (sender.selected==YES)
               {
                  ON |= 0x01;
               }
               else
               {
                  ON &= ~0x01;
               }
            }
               break;
         }

      }break;
      case 1:
      {
         if (sender.selected==YES)
         {
            ON |= 0x03; // Stundentaste, ganze Stunde ON
         }
         else
         {
            
       //     ON &= ~0x02;
            ON = 0;
         }
      }break;
   }
   //NSLog(@"reportStundenTaste: ON nach: %d",ON);
   //NSLog(@"reportStundenTaste aktuellerstundencodearray vor: %@",[self.aktuellerstundencodearray description]);
   //NSLog(@"stundenbytearray vor: %@",[self StundenByteArrayVonStundenCodeArray:self.aktuellerstundencodearray]);
   [self.aktuellerstundencodearray replaceObjectAtIndex:tastenstunde withObject: [NSNumber numberWithInt:ON]];
   //NSLog(@"reportStundenTaste aktuellerstundencodearray nach: %@",[self.aktuellerstundencodearray description]);

  //NSLog(@"reportStundenTaste: ON nach: %d",[[self.aktuellerstundencodearray objectAtIndex:tastenstunde]intValue]);
   self.tagplananzeige.datenarray = self.aktuellerstundencodearray;
   [self.tagplananzeige setNeedsDisplay];
   //NSLog(@"stundenbytearray nach: %@",[self StundenByteArrayVonStundenCodeArray:self.aktuellerstundencodearray]);
   [self restartTWITimer];
}

- (NSMutableArray*)StundenCodeArrayVonByteArray:(NSArray*)bytearray
{
   /*
    Codierung:
    Typ Heizung
    24 Stunden
    Wert Bedeutung
    0       --    ganze Stunde aus
    1       -X    zweite halbe Stunde ein
    2       X-    erste halbe Stunde ein
    3       XX    ganze Stunde ein
    
    Daten:
    6 Bytes
    pro Byte 4 Stunden, Bit's von links nach rechts
    Wert: 207 Bitfolge: II -- II II
    Belegung fuer erste Stunde: Wert & 0xC0
    */
   
   //NSLog(@"ZeilenDataArray: %@",[ZeilenDataArray description]);
   
   // Array fuer Stundenwerte:
   NSMutableArray* StundenByteArray = [[NSMutableArray alloc]initWithCapacity:0];
   for (int byte=0;byte<6;byte++)
   {
      //NSLog(@"***byte: %d stundenwert: %d",byte,[[ZeilenDataArray objectAtIndex:byte]intValue]);
      int stundenwert = [[bytearray objectAtIndex:byte]intValue];
      int byte0 = stundenwert & 0xC0;
      //NSLog(@"byte0: %d",byte0);
      byte0 >>= 6;
      //NSLog(@"byte0 shift: %d",byte0);
      [StundenByteArray addObject:[NSNumber numberWithInt:byte0]];
      
      int byte1 = stundenwert & 0x30;
      //NSLog(@"byte1: %d",byte1);
      byte1 >>= 4;
      //NSLog(@"byte1 shift: %d",byte1);
      [StundenByteArray addObject:[NSNumber numberWithInt:byte1]];
      
      int byte2 = stundenwert & 0x0C;
      //NSLog(@"byte2: %d",byte2);
      byte2 >>= 2;
      //NSLog(@"byte2 shift: %d",byte2);
      [StundenByteArray addObject:[NSNumber numberWithInt:byte2]];
      
      int byte3 = stundenwert & 0x03;
      //NSLog(@"byte3: %d",byte3);
      [StundenByteArray addObject:[NSNumber numberWithInt:byte3]];
      
   }
   //NSLog(@"StundenByteArray: %@",[StundenByteArray description]);
   return StundenByteArray;
}

- (NSArray*)StundenByteArrayVonStundenCodeArray:(NSArray*)stundencodearray
{
	NSMutableArray* tempByteArray=[[NSMutableArray alloc]initWithCapacity:0];
	int i, k=3;
	uint8_t Stundenbyte=0;
	NSString* StundenbyteString=[NSString string];
	for (i=0;i<[stundencodearray count];i++)
	{
		uint8_t Stundencode=[[stundencodearray objectAtIndex:i] intValue];
		//NSLog(@"StundenByteArray i: %d Tag: %d Objekt: %d Stundencode: %02X",i,Wochentag, Objekt, Stundencode);
		Stundencode=(Stundencode << 2*k);
		//NSLog(@"Stundencode <<: %02X",Stundencode);
		Stundenbyte |=Stundencode;
		//NSLog(@"i: %d      Stundenbyte: %02X",i,Stundenbyte);
		if (k==0)
		{
			
			NSString* ByteString=[NSString stringWithFormat:@"%02X ",Stundenbyte];
			//NSLog(@"      Stundenbyte: %02X ByteString: %@",Stundenbyte , ByteString);
			StundenbyteString=[StundenbyteString stringByAppendingString:ByteString] ;
			[tempByteArray addObject:[NSNumber numberWithInt:Stundenbyte]];
			Stundenbyte=0;
			k=3;
		}
		else
		{
			k--;
		}
		
	}// for i
	//NSLog(@"raum: %d Tag: %d objekt: %d StundenbyteString: %@ tempByteArray: %@",Raum,Wochentag, Objekt,StundenbyteString,[tempByteArray description]);
   //NSLog(@"StundenByteArrayVonStundenCodeArray StundenbyteString: %@ tempByteArray: %@",StundenbyteString,[tempByteArray description]);
	return tempByteArray;
}


- (void)EEPROMisWriteOKRequest
{
   self.statusanzeige.code |= ADRESSEOK;
   [self.statusanzeige setNeedsDisplay];

   //NSLog(@"EEPROMisWriteOKRequest ");
   // Zaehler fuer Anzahl Versuche einsetzen
   NSMutableDictionary* confirmTimerDic=[[NSMutableDictionary alloc]initWithCapacity:0];
   [confirmTimerDic setObject:[NSNumber numberWithInt:0]forKey:@"anzahl"];
   int sendResetDelay=4.0;
   //NSLog(@"EEPROMReadDataAktion  confirmTimerDic: %@",[confirmTimerDic description]);
   confirmTimer=[NSTimer scheduledTimerWithTimeInterval:sendResetDelay
                                                  target:self
                                                selector:@selector(confirmTimerFunktion:)
                                                userInfo:confirmTimerDic
                                                 repeats:YES];
   
	
}

- (void)confirmTimerFunktion:(NSTimer*) derTimer
{
	NSMutableDictionary* confirmTimerDic=(NSMutableDictionary*) [derTimer userInfo];
	//NSLog(@"confirmTimerFunktion  confirmTimerDic: %@",[confirmTimerDic description]);
   
	if ([confirmTimerDic objectForKey:@"anzahl"])
	{
		
		int anz=[[confirmTimerDic objectForKey:@"anzahl"] intValue];
		if (anz < maxAnzahl)
		{
         NSString* TWIReadDataURLSuffix = [NSString stringWithFormat:@"pw=%s&iswriteok=1",PW];
         NSString* TWIReadDataURL =[NSString stringWithFormat:@"%@/twi?%@%@",HomeCentralAdresseString, TWIReadDataURLSuffix,pwpart];
         NSURL *URL = [NSURL URLWithString:TWIReadDataURL];
         //NSLog(@"confirmTimerFunktion  URL: %@",URL);
         [self loadURL:URL];
         anz++;
         [confirmTimerDic setObject:[NSNumber numberWithInt:anz] forKey:@"anzahl"];
		}
		else
		{
			NSLog(@"confirmTimerFunktion confirmTimer invalidate");
			
         // Misserfolg an AVRClient senden
			NSMutableDictionary* tempDataDic=[[NSMutableDictionary alloc]initWithCapacity:0];
			[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"iswriteok"];
			NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
			[nc postNotificationName:@"FinishLoad" object:self userInfo:tempDataDic];
			[derTimer invalidate]; // Anfragen stop
         
         //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"EEPROM write" message:@"Schreiben auf EEPROM ist misslungen" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
         //[alert show];
         [self showWarnungMitTitel:@"EEPROM write" mitWarnung:@"Schreiben auf EEPROM ist misslungen"];
         
		}
		
		
	}
}



- (void)loadURL:(NSURL *)URL
{
   
	NSLog(@"loadURL: %@",URL);
   /* SWIFT
   //URLTask = [rURLTask init];
   [URLTask primer];
   [URLTask follower];
   [URLTask ladeWertWithWert: @"abc"];
   NSURL* test = [NSURL URLWithString:@"http://www.google.com"];
   [URLTask ladeURLWithUrl:URL];
    */
   // https://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/
   // Create the request.
  // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.ruediheimlicher.ch"]];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
   // Setting a timeout
   request.timeoutInterval = 20.0;
   
   NSURLSession *session = [NSURLSession sharedSession];
   
   // http://hayageek.com/ios-nsurlsession-example
   NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration ephemeralSessionConfiguration];
   
   NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
   
   NSURL * url = [NSURL URLWithString:@"http://hayageek.com/examples/jquery/ajax-post/ajax-post.php"];
   
   //NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
   NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:URL];
   urlRequest.timeoutInterval = 20.0;
   
   [urlRequest setHTTPMethod:@"GET"];
   //NSString * params =@"name=Ravi&loc=India&age=31&submit=true";
 //  [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
   
   NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
   [dataTask resume];

   /*
    //Version mit completionHandler: data kommt nicht aus Block heraus
   //https://www.objc.io/issues/5-ios7/from-nsurlconnection-to-nsurlsession/
  
   NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                           completionHandler:
                                 ^(NSData *data, NSURLResponse *response, NSError *error) {
                                    if (error) {
                                       NSLog(@"dataTaskWithRequest err: %@",error);
                                    // Handle error, optionally using
                                   // callback(error, NO);
                                 }
                                 else {
                                    NSLog(@"dataTaskWithRequest OK response: %@",response);
                                    NSString *str=[[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];

                                    NSLog(@"dataTaskWithRequest OK responseData: %@",str);
                                    
                                   // callback(nil, YES);
                                 }
                                 
                                 }];
   
   [task resume];
   */
   return;
   
    // Aufgerufen von Plan
	NSMutableURLRequest *HCRequest = [[NSMutableURLRequest alloc] initWithURL: URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:4.0];
   //NSMutableURLRequest *HCRequest= [NSMutableURLRequest requestWithURL:URL];
   [HCRequest setHTTPMethod:@"GET"];
   //[HCRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//   [[NSURLCache sharedURLCache] removeAllCachedResponses];
   //	NSLog(@"Cache mem: %d",[[NSURLCache sharedURLCache]memoryCapacity]);
 //  [[NSURLCache sharedURLCache] removeCachedResponseForRequest:HCRequest];
   //NSLog(@"loadURL:Vor loadRequest");
   
   
   
	if (HCRequest)
	{
      NSLog(@"loadURL:Request OK");
      [self.webfenster  loadRequest:HCRequest];
	}
	
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
   NSLog(@"webViewDidStartLoad");
   //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)status0Aktion
{
   self.statusanzeige.code |= TWIOFF;
   [self.statusanzeige setNeedsDisplay];
   self.sendtaste.enabled= YES;
   [self.ladeindikator stopAnimating];
   self.ladeindikator.hidden = YES;

   
   int twiresetdelay = 1.0;
   NSMutableDictionary* TWITimerDic=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:0],@"twitimeoutanzahl", nil];
   
   TWIStatusTimer = [NSTimer scheduledTimerWithTimeInterval:twiresetdelay
                                                     target:self
                                                   selector:@selector(TWITimerFunktion:)
                                                   userInfo:TWITimerDic
                                                    repeats:YES];
   
   self.twitimer.hidden=NO;
   self.twitimer.text = [NSString stringWithFormat:@"%d",maxAnzahl];

}

+ (void)checkInternetConnectivityWithSuccessCompletion:(void (^)(void))completion {
   
   // https://stackoverflow.com/questions/48341595/ios-how-to-test-internet-connection-in-the-most-easy-way-without-freezing-the
   //NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com"]];
   request.timeoutInterval = 10;
   //https://stackoverflow.com/questions/30935304/sendasynchronousrequest-was-deprecated-in-ios-9-how-to-alter-code-to-fix
   NSURLSession *session = [NSURLSession sharedSession];
   
   [[session dataTaskWithURL:[NSURL URLWithString:@"https://www.google.com"]
           completionHandler:^(NSData *data,
                               NSURLResponse *response,
                               NSError *error) {
              // handle response
              
           }] resume];   
   /*
   [NSURLConnection sendAsynchronousRequest:request queue:myQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
       NSLog(@"response status code: %ld, error status : %@", (long)[httpResponse statusCode], error.description);
       
       if ((long)[httpResponse statusCode] >= 200 && (long)[httpResponse statusCode]< 400)
       {
          // do stuff
          NSLog(@"Connected!");
          completion();
       }
       else
       {
          NSLog(@"Not connected!");
       }
    }];
    */
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
   NSLog(@"%@",[(NSHTTPURLResponse*)resp.response allHeaderFields]);

   //NSLog(@"webViewDidFinishLoad");
   NSRange CheckRange;
	NSString* Code_String= @"okcode=";
	//NSString* Status0_String= @"status0";
   NSString* Status0_String= @"status0+";             // Status 0 ist bestaetigt

//	NSString* Status1_String= @"status1";              // Status 1 ein
   NSString* EEPROM1_String= @"eeprom+";              // EEPROM laden bestaetigt
   NSString* EEPROM0_String= @"eeprom-";              // EEPROM laden misslungen
   
   NSString* EEPROM_Write_Adresse_String= @"wadr";    // Write-Adresse ist angekommen
   NSString* EEPROM_Write_OK_String= @"write+";       // schreiben auf HomeCentral ist gelungen
   NSString* EEPROM_Write_NOT_OK_String= @"write-";   // EEPROM schreiben ist nicht gelungen

   NSString* EEPROM_Write_HomeServer_OK_String= @"homeserver+";   // EEPROM auf Homeserver schreiben ist gelungen
   
   NSString *HTML_Inhalt = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
   //NSLog(@"HTML_Inhalt: %@",HTML_Inhalt);
   
   // Test, ob Webseite eine okcode-Antwort ist
	CheckRange = [HTML_Inhalt rangeOfString:Code_String];
	if (CheckRange.location < NSNotFound) // es ist eine OK-Antwort
	{
      // Status0+ erhalten?
		CheckRange = [HTML_Inhalt rangeOfString:Status0_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"didFinishLoadForFrame: status0+ ist da");
         self.sendtaste.hidden=NO; // sendtaste zeigen
         [self performSelector:@selector(status0Aktion) withObject:nil afterDelay:0];

			if ([confirmStatusTimer isValid])
             {
                [confirmStatusTimer invalidate];
             }
		}
		else
		{
		//	[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"status0"];
		}
      
      // eeprom+ erhalten?
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM1_String];
		if (CheckRange.location < NSNotFound)
		{
         //NSLog(@"webViewDidFinishLoad: eeprom+ ist da ");
      
      }
      
      // eeprom laden nicht gelungen
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM0_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"webViewDidFinishLoad: eeprom- ist da ");
			//[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom-"];
		}
      
      // wadr da?
		CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_Adresse_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"webViewDidFinishLoad: wadr ist da");
			//[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"wadrok"];
         [self performSelector:@selector(EEPROMisWriteOKRequest) withObject:nil afterDelay:0.5];
         //[self EEPROMisWriteOKRequest]; // EEPROM write starten
		}
      
      // eeprom+ da?
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_OK_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"webViewDidFinishLoad: write+ ist da");
			//[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"writeok"];
			[confirmTimer invalidate]; // Schreiben OK, Ladeversuche stop
         [self performSelector:@selector(sendEEPROMDataAnHomeServer) withObject:nil afterDelay:1.0];
         //[self sendEEPROMDataAnHomeServer];
      }
      
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_NOT_OK_String];
		if (CheckRange.location < NSNotFound)
		{
			//NSLog(@"webViewDidFinishLoad: write- ist da");
			//[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
		}
      
      // end isstatus0ok
   } // if okcode
   
   CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_HomeServer_OK_String];
   if (CheckRange.location < NSNotFound)
   {
      self.statusanzeige.code |= SENDOK;
      
      [self.statusanzeige setNeedsDisplay];
      [self.sendtaste setEnabled:YES];

      //NSLog(@"webViewDidFinishLoad: homeserver+ ist da");
      //[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
   }
   
   //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   NSLog(@"didFailLoadWithError: error: %@  %ld",[error description],(long)[error code]);

   
}
// **************************************
#pragma mark NSURLSession Delegate Methods

// NSURLSessionDataDelegate - get continuous status of your request
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
   NSLog(@" didReceiveResponse");
   receivedData=nil; receivedData=[[NSMutableData alloc] init];
   //[receivedData setLength:0];
   
   completionHandler(NSURLSessionResponseAllow);
}
//NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
   //receivedAnswerString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
   //NSLog(@"didReceiveData: receivedAnswerString: %@",receivedAnswerString);
   NSString * HTML_Inhalt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
   NSLog(@"didReceiveData: HTML_Inhalt: %@",HTML_Inhalt);
  // [receivedData appendData:data];
   NSRange CheckRange;
   NSString* Code_String= @"okcode=";
   //NSString* Status0_String= @"status0";
   NSString* Status0_String= @"status0+";             // Status 0 ist bestaetigt
   
   //   NSString* Status1_String= @"status1";              // Status 1 ein
   NSString* EEPROM1_String= @"eeprom+";              // EEPROM laden bestaetigt
   NSString* EEPROM0_String= @"eeprom-";              // EEPROM laden misslungen
   
   NSString* EEPROM_Write_Adresse_String= @"wadr";    // Write-Adresse ist angekommen
   NSString* EEPROM_Write_OK_String= @"write+";       // schreiben auf HomeCentral ist gelungen
   NSString* EEPROM_Write_NOT_OK_String= @"write-";   // EEPROM schreiben ist nicht gelungen
   
   NSString* EEPROM_Write_HomeServer_OK_String= @"homeserver+";   // EEPROM auf Homeserver schreiben ist gelungen
   // Test, ob Webseite eine okcode-Antwort ist
   CheckRange = [HTML_Inhalt rangeOfString:Code_String];
   if (CheckRange.location < NSNotFound) // es ist eine OK-Antwort
   {
      // Status0+ erhalten?
      CheckRange = [HTML_Inhalt rangeOfString:Status0_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"didFinishLoadForFrame: status0+ ist da");
         self.sendtaste.hidden=NO; // sendtaste zeigen
         [self performSelector:@selector(status0Aktion) withObject:nil afterDelay:0];
         
         if ([confirmStatusTimer isValid])
         {
            [confirmStatusTimer invalidate];
         }
      }
      else
      {
         //   [tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"status0"];
      }
      
      // eeprom+ erhalten?
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM1_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"webViewDidFinishLoad: eeprom+ ist da ");
         
      }
      
      // eeprom laden nicht gelungen
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM0_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"webViewDidFinishLoad: eeprom- ist da ");
         //[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"eeprom-"];
      }
      
      // wadr da?
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_Adresse_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"webViewDidFinishLoad: wadr ist da");
         //[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"wadrok"];
         [self performSelector:@selector(EEPROMisWriteOKRequest) withObject:nil afterDelay:0.5];
         //[self EEPROMisWriteOKRequest]; // EEPROM write starten
      }
      
      // eeprom+ da?
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_OK_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"webViewDidFinishLoad: write+ ist da");
         //[tempDataDic setObject:[NSNumber numberWithInt:1] forKey:@"writeok"];
         [confirmTimer invalidate]; // Schreiben OK, Ladeversuche stop
         [self performSelector:@selector(sendEEPROMDataAnHomeServer) withObject:nil afterDelay:1.0];
         //[self sendEEPROMDataAnHomeServer];
      }
      
      CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_NOT_OK_String];
      if (CheckRange.location < NSNotFound)
      {
         //NSLog(@"webViewDidFinishLoad: write- ist da");
         //[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
      }
      
      // end isstatus0ok
   } // if okcode
   
   CheckRange = [HTML_Inhalt rangeOfString:EEPROM_Write_HomeServer_OK_String];
   if (CheckRange.location < NSNotFound)
   {
      self.statusanzeige.code |= SENDOK;
      
      [self.statusanzeige setNeedsDisplay];
      [self.sendtaste setEnabled:YES];
      
      //NSLog(@"webViewDidFinishLoad: homeserver+ ist da");
      //[tempDataDic setObject:[NSNumber numberWithInt:0] forKey:@"writeok"];
   }
   


}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task 
didCompleteWithError:(NSError *)error {
   if (error) {
      NSLog(@"HomeController didCompleteWithError mit error: %@",error);
      // do the same like connection:didFailWithError:
   }
   else {
      NSLog(@"HomeController didCompleteWithError OK");
      // do the same like connectionDidFinishLoading:
   }
}

//NSURLSessionTaskDelegate
/*
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
   if (error) {
      // Handle error
   }
   else {
      NSDictionary* response=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&tempError];
      // perform operations for the  NSDictionary response
   }
// **************************************
#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
   // A response has been received, this is where we initialize the instance var you created
   // so that we can append data to it in the didReceiveData method
   // Furthermore, this method is called each time there is a redirect so reinitializing it
   // also serves to clear it
   NSLog(@"didReceiveResponse");
   _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
   // Append the new data to the instance variable you declared
   NSLog(@"didReceiveData");
   [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
   // Return nil to indicate not necessary to store a cached response for this connection 
   NSLog(@"willCacheResponse");
   return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   // The request is complete and data has been received
   // You can parse the stuff in your instance variable now
   NSLog(@"connectionDidFinishLoading");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
   // The request has failed for some reason!
   // Check the error var
   NSLog(@"didFailWithError");
}
 */
@end
