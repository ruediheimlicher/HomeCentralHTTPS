//
//  rSolarController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 04.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rSolarController.h"

@interface rSolarController ()

@end

@implementation rSolarController

- (void)showDebug:(NSString*)warnung
{
   NSLog(@"alertController solar A");
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
   NSLog(@"alertController solar B");
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
      isDownloading = 0;

   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   std=0;
   min=1;
   data=2;
   art =0;
   randlinks=10;
   randrechts=0;
   randunten = 10;
   randoben = 20;
   b = 24;
   intervally = 10;
   intervallx = 60;
   teile = 12;
   startwert =0;

   //[self.diagrammtaste setBackgroundColor:[UIColor grayColor]];
   [self.diagrammtaste setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   [self.diagrammtaste setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
   
   
   UIImage *blueImage = [UIImage imageNamed:@"blauetaste.jpg"];
   UIImage *blueButtonImage = [blueImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
   [self.diagrammtaste setBackgroundImage:blueButtonImage forState:UIControlStateSelected];
   
   UIImage *defButtonImage = [[UIImage imageNamed:@"leeretaste.jpg"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
   [self.diagrammtaste setBackgroundImage:defButtonImage forState:UIControlStateNormal];
   
   self.diagrammscroller.contentSize = self.diagrammview.frame.size;
   self.diagrammscroller.hidden=YES;
   self.ordinate.hidden=YES;
   
   //NSLog(@"diagrammscroller origin x: %.1f y: %.1f",self.diagrammview.frame.origin.x,self.diagrammview.frame.origin.y);
   float kttemp=100.1;
   self.kt.text = [NSString stringWithFormat:@"%.1f°C",kttemp];;
   float botemp=60.5;
   self.bo.text = [NSString stringWithFormat:@"%.1f°C",botemp];
	// Do any additional setup after loading the view.
//   NSURL* stromURL = [NSURL URLWithString:@"http://www.ruediheimlicher.ch"];
   //   int erfolg = [[UIApplication sharedApplication] openURL:stromURL];
   //  NSLog(@"erfolg: %d",erfolg);
   //[self.webfenster loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.ruediheimlicher.ch/"]]];
   ServerPfad =@"https://www.ruediheimlicher.ch/Data";
   
   //self.solardata.text = [[self SolarDataDicVonHeute] objectForKey:@"lastsolardata"];
   NSLog(@"Solar A");
   //[self showDebug:@"Solar A"];
   [self loadLastData];
//   [self showDebug:@"Solar loadLastData"];
   return;
   
   
   NSString* lastsolardataString = [[self lastSolarDataDic] objectForKey:@"lastsolardata"];
   self.solardata.text = lastsolardataString;
   //NSLog(@"lastsolardata: %@",lastsolardataString);
   NSArray* lastDataArray = [lastsolardataString componentsSeparatedByString:@"\t"];
   float kv_temp = [[lastDataArray objectAtIndex:1]floatValue]/2;
   self.kv.text = [NSString stringWithFormat:@"%.1f°C",kv_temp];
   
   float kr_temp = [[lastDataArray objectAtIndex:2]floatValue]/2;
   self.kr.text = [NSString stringWithFormat:@"%.1f°C",kr_temp];
   
   float bu_temp = [[lastDataArray objectAtIndex:3]floatValue]/2;
   self.bu.text = [NSString stringWithFormat:@"%.1f°C",bu_temp];
   
   float bm_temp = [[lastDataArray objectAtIndex:4]floatValue]/2;
   self.bm.text = [NSString stringWithFormat:@"%.1f°C",bm_temp];
   
   float bo_temp = [[lastDataArray objectAtIndex:5]floatValue]/2;
   self.bo.text = [NSString stringWithFormat:@"%.1f°C",bo_temp];
   
   float kt_temp = [[lastDataArray objectAtIndex:6]floatValue]/2;
   self.kt.text = [NSString stringWithFormat:@"%.1f°C",kt_temp];
   
   self.boilerfeld.hidden = NO;
   
   //int test=16;
   //bool testON = (test & 0x10);
   //NSLog(@"testON: %d",testON);
   bool pumpeON = ([[lastDataArray objectAtIndex:7]intValue] & 0x08);
   //NSLog(@"pumpeON: %d",pumpeON);
   //[Pumpe setHidden:pumpeON];
   if (pumpeON)
   {
      self.pumpe.highlighted = YES;
   }
   else
   {
      self.pumpe.highlighted = NO;
      
   }
   
   bool elektroON = ([[lastDataArray objectAtIndex:7]intValue] & 0x10);
   //NSLog(@"elektroON: %d",elektroON);
   if (elektroON)
   {
      [self.heizung setEnabled:YES];
   }
   else
   {
      [self.heizung setEnabled:NO];
      
   }
   /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.backtaste setBackBarButtonItem:backButton];
    */
   //self.webfenster.delegate = self;
	//self.webfenster.scalesPageToFit = YES;
   
	
   //self.webfenster.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
   //[self.webfenster loadHTMLString:@"<h1>Visit <a href='http://www.fourtentech.com'>FourTen</a> for mobile application development!</h1>" baseURL:nil];
   // UIWebView *callWebview = [[UIWebView alloc] init];
   // NSURL *telURL = [NSURL URLWithString:@"tel://0552407844"];
   //[self.webfenster loadRequest:[NSURLRequest requestWithURL:telURL]];
   //[self produceHTMLForPage:1];
   // Diagramm vorbereiten
   
   
}

- (void)loadLastData
{
   //NSLog(@"B");
   NSString* lastsolardataString = [[self lastSolarDataDic] objectForKey:@"lastsolardata"];
   self.solardata.text = lastsolardataString;
   //NSLog(@"lastsolardata: %@",lastsolardataString);
   NSArray* lastDataArray = [lastsolardataString componentsSeparatedByString:@"\t"];
   float kv_temp = [[lastDataArray objectAtIndex:1]floatValue]/2;
   self.kv.text = [NSString stringWithFormat:@"%.1f°C",kv_temp];
   
   float kr_temp = [[lastDataArray objectAtIndex:2]floatValue]/2;
   self.kr.text = [NSString stringWithFormat:@"%.1f°C",kr_temp];
   
   float bu_temp = [[lastDataArray objectAtIndex:3]floatValue]/2;
   self.bu.text = [NSString stringWithFormat:@"%.1f°C",bu_temp];
   
   float bm_temp = [[lastDataArray objectAtIndex:4]floatValue]/2;
   self.bm.text = [NSString stringWithFormat:@"%.1f°C",bm_temp];
   
   float bo_temp = [[lastDataArray objectAtIndex:5]floatValue]/2;
   self.bo.text = [NSString stringWithFormat:@"%.1f°C",bo_temp];
   
   float kt_temp = [[lastDataArray objectAtIndex:6]floatValue]/2;
   self.kt.text = [NSString stringWithFormat:@"%.1f°C",kt_temp];
   
   self.boilerfeld.hidden = NO;
   
   //int test=16;
   //bool testON = (test & 0x10);
   //NSLog(@"testON: %d",testON);
   bool pumpeON = ([[lastDataArray objectAtIndex:7]intValue] & 0x08);
   //NSLog(@"pumpeON: %d",pumpeON);
   //[Pumpe setHidden:pumpeON];
   if (pumpeON)
   {
      self.pumpe.highlighted = YES;
   }
   else
   {
      self.pumpe.highlighted = NO;
      
   }
   
   bool elektroON = ([[lastDataArray objectAtIndex:7]intValue] & 0x10);
   //NSLog(@"elektroON: %d",elektroON);
   if (elektroON)
   {
      [self.heizung setEnabled:YES];
   }
   else
   {
      [self.heizung setEnabled:NO];
      
   }
//NSLog(@"C");
}

- (void)loadDiagrammData
{
   /*
   std=0;
   min=1;
   data=2;
   art =0;
   randlinks=10;
   randrechts=0;
   randunten = 10;
   randoben = 20;
   b = 24;
   intervally = 10;
   //intervallx = 60;
   //teile = 12;
   //startwert =0;
    */
   NSArray* IndexArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:std],[NSNumber numberWithInt:min],[NSNumber numberWithInt:data],[NSNumber numberWithInt:0], nil]; // letztes Element: art
   
   NSDictionary* heuteSolarDic = [self SolarDataDicVonHeute];
   NSMutableDictionary* DiagrammDatenDic = [NSMutableDictionary dictionaryWithDictionary:[self DiagrammDatenDicVon:[heuteSolarDic objectForKey:@"solardata"]mitAnzahlDaten:1 mitIndex:IndexArray]];
   
   //NSLog(@"self.diagrammview.frame.origin.y: %.2f self.diagrammview.frame.size.height: %.2f",self.diagrammview.frame.origin.y , self.diagrammview.frame.size.height);
   // Abstand DiagrammView vom unteren Rand des Srollers: origin hat nullpunkt oben
   float eckeunteny = self.diagrammview.frame.origin.y + self.diagrammview.frame.size.height;
   float eckeuntenx = self.diagrammview.frame.origin.x;
   
   
   float diagrammhoehe = (int)((self.diagrammview.frame.size.height-randoben-randunten)/10)*10;
   float diagrammbreite = (int)((self.diagrammview.frame.size.width-randlinks-randrechts)/10)*10;
   
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:diagrammhoehe] forKey:@"diagrammhoehe"];
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:diagrammbreite] forKey:@"diagrammbreite"];
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:randlinks] forKey:@"randlinks"];
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:randunten] forKey:@"randunten"];
   [DiagrammDatenDic setObject:[NSNumber numberWithInt:intervallx] forKey:@"intervallx"];
   [DiagrammDatenDic setObject:[NSNumber numberWithInt:startwert] forKey:@"startwert"];
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:eckeuntenx] forKey:@"eckeuntenx"];
   [DiagrammDatenDic setObject:[NSNumber numberWithFloat:eckeunteny] forKey:@"eckeunteny"];
   
   NSMutableDictionary* OrdinateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    // Abstand DiagrammView vom unteren Rand des Srollers:
   
   [OrdinateDic setObject:[NSNumber numberWithInt:randlinks] forKey:@"randlinks"];
   [OrdinateDic setObject:[NSNumber numberWithFloat:eckeunteny] forKey:@"eckeunteny"];
   [OrdinateDic setObject:[NSNumber numberWithFloat:randunten] forKey:@"randunten"];

   [OrdinateDic setObject:[NSNumber numberWithFloat:diagrammhoehe] forKey:@"diagrammhoehe"];
   [OrdinateDic setObject:[NSNumber numberWithInt:b] forKey:@"breite"];
   [OrdinateDic setObject:[NSNumber numberWithInt:intervally] forKey:@"intervally"];
   [OrdinateDic setObject:[NSNumber numberWithInt:teile] forKey:@"teile"];
   [OrdinateDic setObject:[NSNumber numberWithInt:startwert] forKey:@"startwert"];
   //char e = (char)(176);
   NSString *GradCelsius = [NSString stringWithFormat:@"%@", @"\u00B0"];
   //NSLog(@"temperature: %@",GradCelsius);
   [OrdinateDic setObject:GradCelsius forKey:@"einheit"];
   [OrdinateDic setObject:@"C" forKey:@"einheit"];
   //NSLog(@"OrdinateDic: %@",[OrdinateDic description]);
   [self.ordinate OrdinateZeichnenMitDic:OrdinateDic];
   
   
   
   float h=22;
   
   teile = diagrammbreite/intervallx;
   startwert =0;

   NSMutableDictionary* AbszisseDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   [AbszisseDic setObject:[NSNumber numberWithInt:eckeunteny] forKey:@"eckeunteny"];
   [AbszisseDic setObject:[NSNumber numberWithFloat:eckeuntenx] forKey:@"eckeuntenx"];
   [AbszisseDic setObject:[NSNumber numberWithFloat:h] forKey:@"diagrammhoehe"];
   [AbszisseDic setObject:[NSNumber numberWithInt:diagrammbreite] forKey:@"breite"];
   [AbszisseDic setObject:[NSNumber numberWithInt:intervallx] forKey:@"intervall"];
   [AbszisseDic setObject:[NSNumber numberWithInt:teile] forKey:@"teile"];
   [AbszisseDic setObject:[NSNumber numberWithInt:startwert] forKey:@"startwert"];
   //NSLog(@"AbszisseDic: %@",[AbszisseDic description]);
   [self.abszisse AbszisseZeichnenMitDic:AbszisseDic];
   
   
   
   //
   [self.diagrammview DiagrammZeichnenMitDic:DiagrammDatenDic];
   // ans Ende scrollen: http://stackoverflow.com/questions/952412/uiscrollview-scroll-to-bottom-programmatically
   CGPoint rightOffset = CGPointMake(self.diagrammscroller.contentSize.width - 1.1*self.diagrammscroller.bounds.size.width,0);
   [self.diagrammscroller setContentOffset:rightOffset animated:YES];

   [self.diagrammview setNeedsDisplay];
   
   [self.ordinate setNeedsDisplay];
   [self.abszisse setNeedsDisplay];

}


-(void)produceHTMLForPage:(NSInteger)pageNumber{
   
   //init a mutable string, initial capacity is not a problem, it is flexible
   NSMutableString* string =[[NSMutableString alloc]initWithCapacity:10];
   [string appendString:
    @"<html>"
    "<head>"
    "<meta name=\"viewport\" content=\"width=320\"/>"
    "</head>"
    "<body>"
    ];
   [string appendString:@"</body>"
    "</html>"
    ];
   
   [self.webfenster loadHTMLString:string baseURL:nil];        //load the HTML String on UIWebView
   
}

- (IBAction)reportTextFieldGo:(id)sender
{
   NSLog(@"reportTextFieldReturn eingabe: %@",[self.urlfeld text]);
   [sender resignFirstResponder];
   NSString* url = self.urlfeld.text;
   if ([url isEqualToString: @"home"])
   {
      NSLog(@"reportTextFieldGo NO");
      [super dismissViewControllerAnimated:YES completion:NULL];
      //do close window magic here!!
      return ;
   }
   
   url = [NSString stringWithFormat:@"https://%@",url];
   NSLog(@"reportTextFieldReturn url: %@",url);
   //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunesconnect.apple.com"]];
   
   //[self produceHTMLForPage:1];
	[self.webfenster loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
   
}

- (NSDictionary*)lastSolarDataDic
{
   /*
    lastdatenarray =     (
    48849,	Laufzeit
    47,		Kollektor Vorlauf
    46,		Kollektor Ruecklauf
    40,		Boiler unten
    128,	Boiler mitte
    136,	Boiler oben
    82,		Kollektortemperatur
    0,
    255
    );
    Alle Temperaturerte mit doppeltem Wert
	 */
   
   NSMutableDictionary* SolarDataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
   
//	NSString* returnString=[NSString string];
	if (isDownloading)
	{
		return nil;//[self cancel];
	}
	else
	{
      NSString* AussentempSuffix = @"/TemperaturDaten.txt";
      NSURL *AussentempURL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:AussentempSuffix]];
		//NSLog(@"SolarDataVonHeute URL: %@",AussentempURL);
		NSStringEncoding *  Aussentempenc=0;
		NSError* AussentempWebFehler=NULL;
		NSString* AussentempDataString=[NSString stringWithContentsOfURL:AussentempURL usedEncoding: Aussentempenc error:&AussentempWebFehler];
      //NSLog(@"SolarDataVonHeute AussentempDataString: %@",AussentempDataString);
//      NSArray* TemperaturDatenArray = [AussentempDataString componentsSeparatedByString:@"\n"];
      //NSLog(@"SolarDataVonHeute TemperaturDatenArray: %@",[TemperaturDatenArray description]);
      
      NSString* AussentemperaturString = [[AussentempDataString componentsSeparatedByString:@"\n"]objectAtIndex:5];
      //NSLog(@"SolarDataVonHeute AussentemperaturString: %@",AussentemperaturString);
      AussentemperaturString = [[AussentemperaturString componentsSeparatedByString:@" "]lastObject];
		AussentemperaturString = [NSString stringWithFormat:@"%@°C",AussentemperaturString];
      self.AussentempFeld.text = AussentemperaturString;
      
      NSString* DataSuffix=@"LastSolarData.txt";
		//NSLog(@"SolarDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
		NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
		//NSLog(@"SolarDataVonHeute URL: %@",URL);
		NSStringEncoding *  enc=0;
		NSError* WebFehler=NULL;
		NSString* DataString=[NSString stringWithContentsOfURL:URL usedEncoding: enc error:&WebFehler];
		
		//NSLog(@"DataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
		if (WebFehler)
		{
			//NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
			
			NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]);
			//ERROR: 503
			NSArray* ErrorArray=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]componentsSeparatedByString:@" "];
			NSLog(@"ErrorArray: %@",[ErrorArray description]);
         // Login-Alert zeigen
         
         /*
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error in Download",@"Download misslungen")
                                                           message:[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]
                                                          delegate:self
                                                 cancelButtonTitle:@""
                                                 otherButtonTitles:@"OK", nil];
         [message setAlertViewStyle:UIAlertViewStyleDefault];
         [message show];
         */
         NSLog(@"alertController lastsolardata");
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fehler beim Download der letzten Solardaten"
                                                                        message:[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {}];
         
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];

         return nil;
//			NSString* MessageText= NSLocalizedString(@"Error in Download",@"Download misslungen");
			
//			NSString* s1=[NSString stringWithFormat:@"URL: \n%@",URL];
//			NSString* s2=[ErrorArray objectAtIndex:2];
//			int AnfIndex=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]rangeOfString:@"\""].location;
//			NSString* s3=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]substringFromIndex:AnfIndex];
//			NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\nFehler: %@",s1,s2,s3];
		}
		if ([DataString length])
		{
			
			char first=[DataString characterAtIndex:0];
			
			// eventuellen Leerschlag am Anfang entfernen
			
			if (![CharOK characterIsMember:first])
			{
				//NSLog(@"DataVonHeute: String korrigieren");
				DataString=[DataString substringFromIndex:1];
			}
			//NSLog(@"LastSolarData DataString: \n%@",DataString);
			//lastDataZeit=[self lastDataZeitVon:DataString];
			//NSLog(@"SolarDataVonHeute lastDataZeit: %d",lastDataZeit);
			[SolarDataDic setObject:DataString forKey:@"datastring"];
			//NSLog(@"solardatenarray: %@",[[DataString componentsSeparatedByString:@"\n"]description]);
         NSArray* SolarDataArray = [DataString componentsSeparatedByString:@"\n"];
         //NSLog(@"SolarDataArray vor: %@",[SolarDataArray description]);
         if ([[SolarDataArray lastObject]length] ==0)
         {
            //NSLog(@"DataVonHeute: SolarDataArray korrigieren");
            SolarDataArray = [SolarDataArray subarrayWithRange:NSMakeRange(0, [SolarDataArray count]-1)];
         }
         //NSLog(@"SolarDataArray nach: %@",[[SolarDataArray lastObject]description]);
         [SolarDataDic setObject:[SolarDataArray lastObject] forKey:@"lastsolardata"];
         
         return SolarDataDic;
		}
		else
		{
			NSLog(@"lastSolarDataDic Keine Daten");
			//[self setErrString:@"DataVonHeute: keine Daten"];
		}
      
	}
	return SolarDataDic;
}

- (NSDictionary*)SolarDataDicVonHeute
{
   /*
    lastdatenarray =     (
    48849,	Laufzeit
    47,		Kollektor Vorlauf
    46,		Kollektor Ruecklauf
    40,		Boiler unten
    128,	Boiler mitte
    136,	Boiler oben
    82,		Kollektortemperatur
    0,
    255
    );
    Alle Temperaturerte mit doppeltem Wert
	 */
   
   NSMutableDictionary* SolarDataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
   
	if (isDownloading)
	{
		return nil;//[self cancel];
	}
	else
	{
		
		NSString* SolarDataSuffix=@"SolarDaten.txt";
		//NSLog(@"SolarDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,SolarDataSuffix);
		NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:SolarDataSuffix]];
		//NSLog(@"SolarDataVonHeute URL: %@",URL);
		NSStringEncoding *  enc=0;
		NSError* WebFehler=NULL;
		NSString* DataString=[NSString stringWithContentsOfURL:URL usedEncoding: enc error:&WebFehler];
		//NSLog(@"SolarDataVonHeute DataString: \n%@",DataString);
		//NSLog(@"DataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
		if (WebFehler)
		{
			//NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
			
			NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]);
			//ERROR: 503
			NSArray* ErrorArray=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]componentsSeparatedByString:@" "];
			NSLog(@"ErrorArray: %@",[ErrorArray description]);
         // Login-Alert zeigen
         NSString* ErrorString = [ErrorArray componentsJoinedByString:@"\n"];
         /*
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error in Download",@"Download misslungen")
                                                           message:[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]
                                                          delegate:self
                                                 cancelButtonTitle:@""
                                                 otherButtonTitles:@"OK", nil];
         [message setAlertViewStyle:UIAlertViewStyleDefault];
         [message show];
         */
         [self showWarnungMitTitel:@"Download misslungen" mitWarnung:ErrorString];
         
         return nil;
//			NSString* MessageText= NSLocalizedString(@"Error in Download",@"Download misslungen");
			
//			NSString* s1=[NSString stringWithFormat:@"URL: \n%@",URL];
//			NSString* s2=[ErrorArray objectAtIndex:2];
//			int AnfIndex=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]rangeOfString:@"\""].location;
//			NSString* s3=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]substringFromIndex:AnfIndex];
//			NSString* InformationString=[NSString stringWithFormat:@"%@\n%@\nFehler: %@",s1,s2,s3];
		}
		if ([DataString length])
		{
			
			char first=[DataString characterAtIndex:0];
			
			// eventuellen Leerschlag am Anfang entfernen
			
			if (![CharOK characterIsMember:first])
			{
				//NSLog(@"DataVonHeute: String korrigieren");
				DataString=[DataString substringFromIndex:1];
			}
			//NSLog(@"SolarDataVonHeute DataString: \n%@",DataString);
			lastDataZeit=[self lastDataZeitVon:DataString];
			//NSLog(@"SolarDataVonHeute lastDataZeit: %d",lastDataZeit);
			[SolarDataDic setObject:DataString forKey:@"datastring"];
			//NSLog(@"solardatenarray: %@",[[DataString componentsSeparatedByString:@"\n"]description]);
         NSArray* SolarDataArray = [DataString componentsSeparatedByString:@"\n"];
         int n= [SolarDataArray count];
         SolarDataArray = [SolarDataArray subarrayWithRange:NSMakeRange(6, n-6)];
         
         //NSLog(@"SolarDataArray sub: %@",[SolarDataArray description]);
         if ([[SolarDataArray lastObject]length] ==0)
         {
            SolarDataArray = [SolarDataArray subarrayWithRange:NSMakeRange(0, [SolarDataArray count]-1)];
         }
         //NSLog(@"SolarDataArray nach: %@",[[SolarDataArray lastObject]description]);
        // NSLog(@"SolarDataArray count: %d",[SolarDataArray count]);
         NSMutableArray* redSolarDataArray = [[NSMutableArray alloc]initWithCapacity:0];
         int lastZeit=0;
         int anzData=0;
         for (int k=0;k<[SolarDataArray count];k++)
         {
            NSArray* tempZeilenArray = [[SolarDataArray objectAtIndex:k]componentsSeparatedByString:@"\t"];
            int t = [[tempZeilenArray objectAtIndex:0]intValue];
            t/=60;
            
            if (t> (lastZeit+4))
            {
               //NSLog(@"*   SolarDataArray k: %d t: %d tempZeilenArray: %@",k,t,[tempZeilenArray description]);
               //NSLog(@"*   SolarDataArray k: %d t: %d tempZeilenArray 0: %d",k,t,[[tempZeilenArray objectAtIndex:0]intValue]);
               /*
               float x= (float)t;
               
               float y1 = (float)([[tempZeilenArray  objectAtIndex:1]intValue]);
               float y2 = (float)([[tempZeilenArray  objectAtIndex:2]intValue]);
               float y3 = (float)([[tempZeilenArray  objectAtIndex:3]intValue]);
               float y4 = (float)([[tempZeilenArray  objectAtIndex:4]intValue]);
               float y5 = (float)([[tempZeilenArray  objectAtIndex:5]intValue]);
               //fprintf(stderr,"%.0f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n",x,y1,y2,y3,y4,y5);
                */
               lastZeit = t;
               anzData++;
               [redSolarDataArray addObject:tempZeilenArray];
            }
            else
            {
               //NSLog(@"SolarDataArray k: %d t: %d",k,t);
            }
         }
         //NSLog(@"anz: %d redSolarDataArray : %@",anzData,[[redSolarDataArray lastObject] description]);
         [SolarDataDic setObject:redSolarDataArray forKey:@"solardata"];
         [SolarDataDic setObject:[SolarDataArray lastObject] forKey:@"lastsolardata"];
         
         return SolarDataDic;
			
		}
		else
		{
			NSLog(@"SolarDicVonHeute Keine Daten");
			//[self setErrString:@"DataVonHeute: keine Daten"];
		}
		
		/*
		 NSLog(@"DataVon URL: %@ DataString: %@",URL,DataString);
		 if (URL)
		 {
		 download = [[WebDownload alloc] initWithRequest:[NSURLRequest requestWithURL:URL] delegate:self];
		 downloadFlag=heute;
		 
		 }
		 if (!download)
		 {
		 
		 NSBeginAlertSheet(@"Invalid or unsupported URL", nil, nil, nil, [self window], nil, nil, nil, nil,
		 @"The entered URL is either invalid or unsupported.");
		 }
		 */
      
		
      
      
	}
	return SolarDataDic;
}

- (NSDictionary*)DiagrammDatenDicVon:(NSArray*)DatenArray mitAnzahlDaten:(int)anz mitIndex:(NSArray*)index
{
   //NSLog(@"Solar DiagrammDatenDicVon anz: %d %d",anz,[DatenArray count]);
   NSMutableDictionary*  DiagrammdatenDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSMutableArray* LineArray = [[NSMutableArray alloc]initWithCapacity:0];
   // Array: dataarray mit datadics
   
  
   //NSLog(@"Solar DiagrammDatenDicVon erste Zeile: %@",[[DatenArray objectAtIndex:0] description]);
   int startminute = [[[DatenArray objectAtIndex:0]objectAtIndex:0]intValue]/60;
   
//   int offsetstd = startminute/60;
//   int offsetmin = startminute%60;
//   int offsetlinks = 60*offsetstd + offsetmin;
   //NSLog(@" offsetstd: %d offsetmin: %d diffx: %d",offsetstd,offsetmin,randlinks);
   //NSLog(@"Solar DiagrammDatenDicVon letzte Zeile array: %@",[[DatenArray lastObject] description]);
   int endminute = [[[DatenArray lastObject]objectAtIndex:0]intValue]/60;

//   int endstd =  endminute/60;;
 //  int endmin =  endminute%60;
//   int endx = 60*endstd + endmin;
//   int diffx = endx - randlinks;
   
   self.zoomfaktorx = (self.diagrammview.bounds.size.width - randlinks)/1440; // Minuten des Tages
   //NSLog(@"width: %.1f zoomfaktorx: %.2f",self.diagrammview.bounds.size.width,zoomfaktorx );

   // Zeitarray mit minute
    NSMutableArray* ZeitArray = [[NSMutableArray alloc]initWithCapacity:0];
   for (int k=0;k<[DatenArray count];k++)
   {
      // Zeit
      int tempzeit = [[[DatenArray objectAtIndex:k]objectAtIndex:0]intValue]/60;
      int tempmin = tempzeit%60;
      int tempstd = tempzeit/60;
      int minute = tempzeit%1440; // minute des Tages
      NSNumber* stdNumber = [NSNumber numberWithInt:tempstd];
      NSNumber* minNumber = [NSNumber numberWithInt:tempmin];
      NSNumber* minuteNumber = [NSNumber numberWithFloat:(float)minute*self.zoomfaktorx];
      //NSLog(@"minute: %d minutewert: %.2f",minute,minute*zoomfaktorx );
      NSArray* tempZeitArray = [NSArray arrayWithObjects:stdNumber,minNumber,minuteNumber,nil];
      [ZeitArray addObject:tempZeitArray];
   }
   
   //NSLog(@" endstd: %d endmin: %d diffx: %d",endstd,endmin,endx);

   //NSLog(@" randlinks: %d endx: %d diffx: %d",randlinks,endx,diffx);
   /*
    lastdatenarray =     (
    48849,	Laufzeit
    47,		Kollektor Vorlauf
    46,		Kollektor Ruecklauf
    40,		Boiler unten
    128,	Boiler mitte
    136,	Boiler oben
    82,		Kollektortemperatur
    0,      code 8: pumpe 16:Heizung
    255
    );
    Alle Temperaturerte mit doppeltem Wert
	 */

   
   NSArray* DataNamenArray = [NSArray arrayWithObjects:
                              @"",
                              @"KV",
                              @"KR",
                              @"BU",
                              @"BM",
                              @"BO",
                              @"KT",
                              nil]; // erstes Element nur als Fueller, index der Zeit im DataArray
   
   NSArray* LinienfarbeArray = [NSArray arrayWithObjects:
                                [UIColor blackColor],
                                [UIColor blueColor],
                                [UIColor redColor],
                                [UIColor greenColor],
                                [UIColor cyanColor],
                                [UIColor magentaColor],
                                [UIColor grayColor],
                                [UIColor lightGrayColor],
                                nil];
   
   //NSLog(@"LinienfarbeArray: %@",[LinienfarbeArray description]);
   for (int i=0;i<[LinienfarbeArray count];i++  )
   {
      //NSLog(@"i: %d Linienfarbe: %@",i,[LinienfarbeArray objectAtIndex:i ]);
   }
   self.zoomfaktory = (self.diagrammview.bounds.size.height-randunten)/120;  // max Temperatur
 
   
   //for (int dataindex=1;dataindex<6;dataindex++)
   for (int dataindex=1;dataindex<[DataNamenArray count];dataindex++)
   {
      NSMutableArray* tempDataArray = [[NSMutableArray alloc]initWithCapacity:0];
      // Daten aus Array den Linien zuordnen
      //fprintf(stderr,"ix:\ti:\tx:\ty:\n");
      for (int i=0;i<[DatenArray count];i++)
      {
         /*
         // Zeit
         int tempzeit = [[[DatenArray objectAtIndex:i]objectAtIndex:0]intValue]/60;
         int tempmin = tempzeit%60;
         int tempstd = tempzeit/60;
         int minute = tempzeit%1440; // minute des Tages
         //NSLog(@"i: %d tempstd: %d tempmin: %d minute: %d",i,tempstd,tempmin,minute);
         NSNumber* stundeNumber = [NSNumber numberWithInt:tempstd];
         NSNumber* minuteNumber = [NSNumber numberWithInt:tempmin];
         // Linien konfig
         */
         // KV
//         float x = [[[ZeitArray objectAtIndex:i]lastObject ]floatValue]; // Zeit Minute
         
         float y = [[[DatenArray objectAtIndex:i] objectAtIndex:dataindex]intValue]/2*self.zoomfaktory;
         //fprintf(stderr,"%d\t%d\t%2.2f\t%2.2f\n",dataindex,i,x,y);
         
         /*
         
         float y1 = (float)([[[DatenArray objectAtIndex:i]  objectAtIndex:1]intValue]);
         float y2 = (float)([[[DatenArray objectAtIndex:i]  objectAtIndex:2]intValue]);
         float y3 = (float)([[[DatenArray objectAtIndex:i]  objectAtIndex:3]intValue]);
         float y4 = (float)([[[DatenArray objectAtIndex:i]  objectAtIndex:4]intValue]);
         float y5 = (float)([[[DatenArray objectAtIndex:i]  objectAtIndex:5]intValue]);
         fprintf(stderr,"%.0f\t%.2f\t%.2f\t%.2f\t%.2f\t%.2f\n",x,y1,y2,y3,y4,y5);
          */
         
         
         NSDictionary* tempDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[ZeitArray objectAtIndex:i]lastObject],@"x",[NSNumber numberWithFloat:y],@"y", nil];
         //NSLog(@"i: %d tempDataDic%@",i,[tempDataDic description]);
         [tempDataArray addObject:tempDataDic];
         
         
      } // for i
      
       
 
      
      // *
      //
      //NSLog(@"linie: %d name: %@",dataindex,[DataNamenArray objectAtIndex:dataindex]);
      NSDictionary* tempLineDic = [NSDictionary dictionaryWithObjectsAndKeys:tempDataArray,@"dataarray",[LinienfarbeArray objectAtIndex:dataindex],@"linecolor", [DataNamenArray objectAtIndex:dataindex],@"linename",nil];
      [LineArray addObject:tempLineDic];

      
   } // for dataindex
   
   // Linien fuer Pumpe und Heizung
   // *
   int codeindex = 7;
   int lastheizungstate=0; // letzten status speichern, Linie eventuell unterbrechen
//   int lastpumpestate=0;
   
   
   NSMutableArray* tempHeizungDataArray = [[NSMutableArray alloc]initWithCapacity:0];
   NSMutableArray* tempPumpeDataArray = [[NSMutableArray alloc]initWithCapacity:0];
   // Daten aus Array den Linien zuordnen
   //fprintf(stderr,"ix:\ti:\tx:\ty:\n");
   for (int i=0;i<[DatenArray count];i++)
   {
//      float x = [[[ZeitArray objectAtIndex:i]lastObject ]floatValue]; // Zeit Minute
      
      int tempcode = [[[DatenArray objectAtIndex:i] objectAtIndex:codeindex]intValue];
      
      float y = 0;
      // * Heizung
      if (tempcode & 0x10)
      {
         //NSLog(@"heizung on");
         y=204;
         lastheizungstate = 1;
      }
      else
      {
         y=-100;
         //NSLog(@"heizung off");
      }
      
      NSDictionary* tempHeizungDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[ZeitArray objectAtIndex:i]lastObject],@"x",[NSNumber numberWithFloat:y],@"y", nil];
      //NSLog(@"i: %d tempDataDic%@",i,[tempDataDic description]);
      [tempHeizungDataArray addObject:tempHeizungDataDic];
      // * end Heizung
      
      y=0;
      
      // *Pumpe*
      
      if (tempcode & 0x08)
      {
         //NSLog(@"Pumpe on on");
         y=200;
         lastheizungstate = 1;
      }
      else
      {
         y=-100;
         //NSLog(@"Pumpe off");
      }
      
      NSDictionary* tempPumpeDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[ZeitArray objectAtIndex:i]lastObject],@"x",[NSNumber numberWithFloat:y],@"y", nil];
      //NSLog(@"i: %d tempDataDic%@",i,[tempDataDic description]);
      [tempPumpeDataArray addObject:tempPumpeDataDic];
      
      // * end Pumpe
      
      
   } // for i
   
   NSDictionary* tempPumpeLineDic = [NSDictionary dictionaryWithObjectsAndKeys:tempPumpeDataArray,@"dataarray",[UIColor orangeColor],@"linecolor", @"P",@"linename",nil];
   [LineArray addObject:tempPumpeLineDic];

   NSDictionary* tempHeizungLineDic = [NSDictionary dictionaryWithObjectsAndKeys:tempHeizungDataArray,@"dataarray",[UIColor orangeColor],@"linecolor", @"E",@"linename",nil];
   [LineArray addObject:tempHeizungLineDic];
   
   // LineArray einsetzen
   [DiagrammdatenDic setObject:LineArray forKey:@"linearray"];
   //startminute = 250;
   [DiagrammdatenDic setObject:[NSNumber numberWithInt:startminute] forKey:@"startwertx"];
   [DiagrammdatenDic setObject:[NSNumber numberWithInt:endminute] forKey:@"endwertx"];
   [DiagrammdatenDic setObject:[NSNumber numberWithFloat:self.zoomfaktorx] forKey:@"zoomfaktorx"];
   [DiagrammdatenDic setObject:[NSNumber numberWithFloat:self.zoomfaktory] forKey:@"zoomfaktory"];

   return (NSDictionary*)DiagrammdatenDic;
}

- (int)lastDataZeitVon:(NSString*)derDatenString
{
	int lastZeit=0;
	//NSLog(@"DataString: %@",derDatenString);
	
	NSArray* DataArray=[derDatenString componentsSeparatedByString:@"\n"];
	if ([[DataArray lastObject]isEqualToString:@""])
	{
		DataArray=[DataArray subarrayWithRange:NSMakeRange(0,[DataArray count]-1)];
	}
	//NSLog(@"DataArray: %@",[DataArray description]);
	
	//NSLog(@"lastDataZeitVon: letzte Zeile: %@",[DataArray lastObject]);
	NSArray* lastZeilenArray=[[DataArray lastObject]componentsSeparatedByString:@"\t"];
	lastZeit = [[lastZeilenArray objectAtIndex:0]intValue];
	
	return lastZeit;
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   NSLog(@"SolarController viewWillAppear");
   
	self.webfenster.delegate = self;	// setup the delegate as the web view is shown
   
   
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   [self.webfenster stopLoading];	// in case the web view is still loading its content
	self.webfenster.delegate = nil;	// disconnect the delegate as the webview is hidden
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   NSLog(@"absoluteString: %@",[[request URL] absoluteString]);
   if ( [@"file:///" isEqualToString:[[request URL] absoluteString]] )
   {
      NSLog(@"shouldStartLoadWithRequest YES");
      return YES;
   }
   if ([[[request URL] absoluteString] isEqualToString: @"https://home/"])
   {
      NSLog(@"shouldStartLoadWithRequest NO");
      [super dismissViewControllerAnimated:YES completion:NULL];
      //do close window magic here!!
      return NO;
   }
   if ([[[request URL] absoluteString] isEqualToString:@"plus.google.com/"])
   {
      [super dismissViewControllerAnimated:YES completion:NULL];
      return NO;
   }
   
   NSLog(@"shouldStartLoadWithRequest YES %@",[request URL]);
   [[UIApplication sharedApplication] openURL:[request URL] options: @{} completionHandler:^(BOOL success) {
      NSLog(@"SolarController Open success: %d",success);
   }];
   
   return YES;
   
   
}



- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
   
   [self setKt:nil];
   [self setKv:nil];
   [self setKr:nil];
   [self setBo:nil];
   [self setBm:nil];
   [self setBu:nil];
   
   [self setUrlfeld:nil];
   [self setWebfenster:nil];
   [self setSolardata:nil];
   [self setHeizung:nil];
   [self setPumpe:nil];
   [self setUrlfeld:nil];
   
   [self setBacktaste:nil];
   [self setBacktaste:nil];
   [self webfenster].delegate=nil;
   [self setRefreshTaste:nil];
   [self setAussentempFeld:nil];
   [self setBoilerfeld:nil];
   [self setDiagrammscroller:nil];
   [self setDiagrammview:nil];
   [self setWolke:nil];
   [self setAnlage:nil];
   [self setDiagrammtaste:nil];
   [self setOrdinate:nil];
   [self setOrdinate:nil];
   [self setAbszisse:nil];
   [super viewDidUnload];
   //[KT setText: @"100"];//
   
   
}

- (IBAction)reportRefresh:(id)sender
{
   NSLog(@"reportRefresh");
   if (self.boilerfeld.hidden==NO)
   {
      NSLog(@"reportRefresh Boiler");
      [self loadLastData];
   }
   if (self.diagrammscroller.hidden==NO)
   {
      NSLog(@"reportRefresh Diagramm");
      [self loadDiagrammData];
   }
   
}

- (IBAction)reportDiagrammTaste:(id)sender
{
   if (self.diagrammtaste.selected)
   {
      self.diagrammtaste.selected = NO;
      self.diagrammscroller.hidden=YES;
      self.boilerfeld.hidden = NO;
      self.ordinate.hidden=YES;
   }
   else
   {
      self.boilerfeld.hidden = YES;
      self.diagrammscroller.hidden=NO;
      self.diagrammscroller.layer.borderWidth = 2; // #import <QuartzCore/QuartzCore.h> notwendig
      self.diagrammscroller.layer.borderColor = [UIColor lightGrayColor].CGColor;
      self.diagrammtaste.selected = YES;
      
      self.ordinate.hidden=NO;
      //NSLog(@"reportDiagrammtaste");
      
      [self loadDiagrammData];
      return;
      
      /*
      int std=0;
      int min=1;
      int data=2;
      int art =0;
      NSArray* IndexArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:std],[NSNumber numberWithInt:min],[NSNumber numberWithInt:data],[NSNumber numberWithInt:0], nil]; // letztes Element: art
      
      NSDictionary* heuteSolarDic = [self SolarDataDicVonHeute];
      NSDictionary* DiagrammDatenDic = [self DiagrammDatenDicVon:[heuteSolarDic objectForKey:@"solardata"]mitAnzahlDaten:1 mitIndex:IndexArray];
      // Abstand DiagrammView vom unteren Rand des Srollers: origin hat nullpunkt oben
      float eckeunteny = self.diagrammview.frame.origin.y + self.diagrammview.frame.size.height;
      
      float diagrammhoehe = (int)(self.diagrammview.frame.size.height/10)*10;
      
      NSMutableDictionary* OrdinateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
      //
      int randlinks=0;
      int randunten=0;
      int b = 24;
      int intervall = 10;
      int teile = 12;
      int startwert =0;
      
      // Abstand DiagrammView vom unteren Rand des Srollers:
      
      
      [OrdinateDic setObject:[NSNumber numberWithInt:randlinks] forKey:@"randlinks"];
      [OrdinateDic setObject:[NSNumber numberWithInt:randunten] forKey:@"randunten"];
      [OrdinateDic setObject:[NSNumber numberWithFloat:eckeunteny] forKey:@"eckeunteny"];
      [OrdinateDic setObject:[NSNumber numberWithFloat:diagrammhoehe] forKey:@"diagrammhoehe"];
      [OrdinateDic setObject:[NSNumber numberWithInt:b] forKey:@"breite"];
      [OrdinateDic setObject:[NSNumber numberWithInt:intervall] forKey:@"intervall"];
      [OrdinateDic setObject:[NSNumber numberWithInt:teile] forKey:@"teile"];
      [OrdinateDic setObject:[NSNumber numberWithInt:startwert] forKey:@"startwert"];
      //NSLog(@"OrdinateDic: %@",[OrdinateDic description]);
      [self.ordinate OrdinateZeichnenMitDic:OrdinateDic];
      
      //
      [self.diagrammview DiagrammZeichnenMitDic:DiagrammDatenDic];
      
      // ans Ende scrollen: http://stackoverflow.com/questions/952412/uiscrollview-scroll-to-bottom-programmatically
      CGPoint rightOffset = CGPointMake(self.diagrammscroller.contentSize.width - 1.2*self.diagrammscroller.bounds.size.width,0);
      [self.diagrammscroller setContentOffset:rightOffset animated:YES];
      [self.diagrammview setNeedsDisplay];
      [self.ordinate setNeedsDisplay];
       */
   }
}

- (IBAction)switch2Strom:(id)sender
{
   [self performSegueWithIdentifier: @"stromid"
                             sender: self];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   //   [webView.scrollView zoomToRect:CGRectMake(0.0, 0.0, 50.0, 50.0) animated:YES];
   //   [webView stringByEvaluatingJavaScriptFromString: @"document.body.style.zoom = 5.0;"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
                            @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                            error.localizedDescription];
	[self.webfenster loadHTMLString:errorString baseURL:nil];
}

@end
