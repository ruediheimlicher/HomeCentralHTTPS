//
//  rStromController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 04.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rStromController.h"

@interface rStromController ()

@end

@implementation rStromController

- (void)showDebug:(NSString*)warnung
{
   NSLog(@"alertController Strom D");
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   randlinks=10;
   randrechts=0;
   randunten = 10;
   randoben = 20;
   intervally = 1;
   intervallx = 60;
   startwert =0;

   self.diagrammscroller.contentSize = self.diagrammview.frame.size;
   
	// Do any additional setup after loading the view.
   ServerPfad =@"https://www.ruediheimlicher.ch/Data/StromDaten";
   
   StromDicVonHeute = [self StromDataDicVonHeute];
   
   NSArray* lastDataArray = [[StromDicVonHeute objectForKey:@"laststromdata"]componentsSeparatedByString:@"\t"];
   //NSArray* lastDataArray = [[[self StromDataDicVonHeute]objectForKey:@"laststromdata"]componentsSeparatedByString:@"\t"];
   //NSLog(@"Strom lastDataArray: %@",[lastDataArray description]);
   //NSLog(@"Strom leistungaktuell: %@",[lastDataArray lastObject]);
   self.leistungaktuell.text = [NSString stringWithFormat:@"%d W",[[lastDataArray lastObject]intValue]];
   self.datum.text = [NSString stringWithFormat:@"%2d.%02d.20%d",[[lastDataArray objectAtIndex:2]intValue],[[lastDataArray objectAtIndex:1]intValue],[[lastDataArray objectAtIndex:0]intValue]];
   self.zeit.text = [NSString stringWithFormat:@"%d:%02d:%02d",[[lastDataArray objectAtIndex:3]intValue],[[lastDataArray objectAtIndex:4]intValue],[[lastDataArray objectAtIndex:5]intValue]];
   self.data.text = [StromDicVonHeute objectForKey:@"laststromdata"];
   
   self.lastminute = 60*[[lastDataArray objectAtIndex:3]intValue]+[[lastDataArray objectAtIndex:4]intValue];
   // Stromdaten von heute
   //NSArray* StromArray = [StromDicVonHeute objectForKey:@"stromdata"];
   //NSLog(@"Strom anzeigeseg: %d",self.anzeigeseg.selectedSegmentIndex);
   //NSLog(@"Strom StromArray: %@",[[StromArray objectAtIndex:0] description]);
   
   NSLog(@"IP von Strom: %@",[[rVariableStore sharedInstance] IP]);
   
   int startsegment = 1;
   self.anzeigeseg.selectedSegmentIndex = startsegment;
   [self switchAnzeigeSeg:startsegment];
   
   
 }

- (NSDictionary*)DiagrammDatenDicVon:(NSArray*)DatenArray mitAnzahlDaten:(int)anz mitIndex:(NSArray*)index
{
   //NSLog(@"DiagrammDatenDicVon anz: %d %d",anz,[DatenArray count]);
   NSMutableDictionary*  DiagrammdatenDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSMutableArray* LineArray = [[NSMutableArray alloc]initWithCapacity:0];
   // Array: dataarray mit datadics
   NSMutableArray* tempDataArray = [[NSMutableArray alloc]initWithCapacity:0];
   
   int lastminute=0;
   
   std = [[index objectAtIndex:0]intValue]; // Lage der Daten im DatenArray
   min = [[index objectAtIndex:1]intValue];
   dataindex = [[index objectAtIndex:2]intValue];
   art = [[index lastObject]intValue];
   
   
   int startstd = [[[[DatenArray objectAtIndex:0]componentsSeparatedByString:@"\t" ]objectAtIndex:std]intValue];
   int startmin = [[[[DatenArray objectAtIndex:0]componentsSeparatedByString:@"\t" ]objectAtIndex:min]intValue];
   int startx = 60*startstd + startmin;
   
   int endstd =  [[[[DatenArray lastObject]componentsSeparatedByString:@"\t" ]objectAtIndex:std]intValue];
   int endmin =  [[[[DatenArray lastObject]componentsSeparatedByString:@"\t" ]objectAtIndex:min]intValue];
   int endx = 60*endstd + endmin;
   int diffx = endx - startx;
   
   //NSLog(@"art: %d offsetx: %d endx: %d diffx: %d",art,startx,endx,diffx);
   self.zoomfaktorx = 1;
   switch (self.anzeigeseg.selectedSegmentIndex)
   {
      case 0: // ganzer Tag
      {
         self.zoomfaktorx = (self.diagrammview.bounds.size.width-randlinks)/1440;   // Minuten des Tage
      }break;
         
      case 1: // Monitor 2 Stunden
      {
         self.zoomfaktorx = (self.diagrammview.bounds.size.width-randlinks)/diffx;
      }break;
   }
   
   self.lastzoomfaktorx = self.zoomfaktorx;
   
   float zoomfaktory = (self.diagrammview.bounds.size.height)/8000;  // max Leistung
   //NSLog(@"Segment: %d DiagrammDatenDicVon zoomfaktorx: %.2f",self.anzeigeseg.selectedSegmentIndex,self.zoomfaktorx);
   [DiagrammdatenDic setObject:[NSNumber numberWithInt:startx ] forKey:@"startx"];

   [DiagrammdatenDic setObject:[NSNumber numberWithFloat:self.zoomfaktorx ] forKey:@"zoomfaktorx"];
   [DiagrammdatenDic setObject:[NSNumber numberWithFloat:zoomfaktory ] forKey:@"zoomfaktory"];
   
   //zoomfaktorx=1;
   //NSLog(@"DiagrammDatenDicVon std: %d min: %d dataindex: %d offsetstd: %d offsetmin: %d offsetx: %d",std,min,dataindex,offsetstd,offsetmin,offsetx);
   for (int k=0;k<[DatenArray count];k++)// Datenarray
   {
      
      // Datadic mit Koordinaten
      NSArray* tempZeilenArray = [[DatenArray objectAtIndex:k]componentsSeparatedByString:@"\t"];
      //NSLog(@"i: %d Strom tempZeilenArray: %@",k,[tempZeilenArray description]);
      // if (([[tempZeilenArray objectAtIndex:4]intValue]-lastminute)>1)
      {
         float x =  (60.0*[[tempZeilenArray objectAtIndex:std]intValue]+[[tempZeilenArray objectAtIndex:min]intValue]-startx);
         if (k == [DatenArray count]-1)
         {
            //NSLog(@"last Data k: %d x vor: %.2f",k,x);
         }
         x *= self.zoomfaktorx;
         float y = [[tempZeilenArray objectAtIndex:dataindex]intValue]*zoomfaktory;
         NSDictionary* tempDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:x],@"x",[NSNumber numberWithFloat:y],@"y", nil];
         
         [tempDataArray addObject:tempDataDic];
         lastminute = [[tempZeilenArray objectAtIndex:min]intValue];
      }
   }
   
   UIColor* tempColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.4 alpha:1.0];
   NSDictionary* tempLineDic = [NSDictionary dictionaryWithObjectsAndKeys:tempDataArray,@"dataarray",tempColor,@"linecolor", nil];
   [LineArray addObject:tempLineDic];
   
   //NSLog(@"LineArray: %@",[LineArray description]);
   [DiagrammdatenDic setObject:LineArray forKey:@"linearray"];
   //NSLog(@"DiagrammdatenDic: %@",[DiagrammdatenDic description]);
   
   return (NSDictionary*)DiagrammdatenDic;
}

- (IBAction)reportRefresh:(id)sender
{
   NSLog(@"reportRefresh");
   StromDicVonHeute = [self StromDataDicVonHeute];
   NSArray* lastDataArray = [[StromDicVonHeute objectForKey:@"laststromdata"]componentsSeparatedByString:@"\t"];
   self.leistungaktuell.text = [NSString stringWithFormat:@"%d W",[[lastDataArray lastObject]intValue]];
   self.datum.text = [NSString stringWithFormat:@"%2d.%02d.20%d",[[lastDataArray objectAtIndex:2]intValue],[[lastDataArray objectAtIndex:1]intValue],[[lastDataArray objectAtIndex:0]intValue]];
   self.zeit.text = [NSString stringWithFormat:@"%d:%02d:%02d",[[lastDataArray objectAtIndex:3]intValue],[[lastDataArray objectAtIndex:4]intValue],[[lastDataArray objectAtIndex:5]intValue]];
   
   
}

- (IBAction)reportAnzeigeSeg:(UISegmentedControl *)sender
{
   //NSLog(@"\nreportAnzeigeSeg segment: %d",sender.selectedSegmentIndex);
   [self switchAnzeigeSeg:sender.selectedSegmentIndex];
   return;
   
 }

- (void)switchAnzeigeSeg:(int)seg
{

   NSMutableDictionary* DiagrammDatenDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   switch (seg)
   {
      case 0:
      {
         std=3;
         min=4;
         dataindex=6;
         NSArray* IndexArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:std],[NSNumber numberWithInt:min],[NSNumber numberWithInt:dataindex],[NSNumber numberWithInt:seg], nil];
         // index wird als letztes Element eingefuegt, um Darstellungsart zu uebertragen
         CGRect feld = self.diagrammview.frame;
         feld.size.width = 900.0;
         feld.origin.x=0;
         self.diagrammview.frame = feld;
         
         [DiagrammDatenDic addEntriesFromDictionary:[self DiagrammDatenDicVon:[StromDicVonHeute objectForKey:@"stromdata"]mitAnzahlDaten:1440  mitIndex:IndexArray]];
         
         [DiagrammDatenDic setObject:[NSNumber numberWithInt:seg] forKey:@"art"];
         
         //NSLog(@"switchAnzeigeSeg 0 lastminute: %d lastzoomfaktorx: %.2f offset: %.2f",self.lastminute,self.lastzoomfaktorx,self.lastminute*self.lastzoomfaktorx);
         
         CGPoint rightOffset = CGPointMake(self.lastminute*self.lastzoomfaktorx-0.8*self.diagrammscroller.bounds.size.width,0);

         [self.diagrammscroller setContentOffset:rightOffset animated:YES];

      }break;
         
      case 1:
      {
         //NSLog(@"contentOffset: %.2f",self.diagrammscroller.contentOffset.x);
         CGPoint leftOffset = CGPointMake(0,0);
        [self.diagrammscroller setContentOffset:leftOffset animated:YES];

         std=1;
         min=2;
         dataindex=4;
         
         NSArray* IndexArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:std],[NSNumber numberWithInt:min],[NSNumber numberWithInt:dataindex],[NSNumber numberWithInt:seg], nil];
         
         NSArray* StromArray = [StromDicVonHeute objectForKey:@"strommonitor"];
         
         
         CGRect feld = self.diagrammview.frame;
         //b.size.width = 1440.0/900.0 * (float)[StromArray count];
         
         feld.size.width = self.diagrammscroller.frame.size.width;
         self.diagrammview.frame = feld;
         
         [DiagrammDatenDic addEntriesFromDictionary:[self DiagrammDatenDicVon:StromArray mitAnzahlDaten:1440  mitIndex:IndexArray]];
         //[self.diagrammview DiagrammZeichnenMitDic:[self DiagrammDatenDicVon:StromArray mitAnzahlDaten:[StromArray count] mitIndex:IndexArray]];
         [DiagrammDatenDic setObject:[NSNumber numberWithInt:seg] forKey:@"art"];
      }break;
         
   }// switch
   
   // Zusaetzliche Daten einsetzen
   
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

   

   [self.diagrammview DiagrammZeichnenMitDic:DiagrammDatenDic];
   
   [self.diagrammview setNeedsDisplay];
   
   float breite = 20;
   int ordinatenteile = 8;
   
   
   NSMutableDictionary* OrdinateDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   // Abstand DiagrammView vom unteren Rand des Srollers:
   
   [OrdinateDic setObject:[NSNumber numberWithInt:randlinks] forKey:@"randlinks"];
   [OrdinateDic setObject:[NSNumber numberWithFloat:eckeunteny] forKey:@"eckeunteny"];
   [OrdinateDic setObject:[NSNumber numberWithFloat:randunten] forKey:@"randunten"];
   
   [OrdinateDic setObject:[NSNumber numberWithFloat:diagrammhoehe] forKey:@"diagrammhoehe"];
   [OrdinateDic setObject:[NSNumber numberWithInt:breite] forKey:@"breite"];
   [OrdinateDic setObject:[NSNumber numberWithInt:intervally] forKey:@"intervally"];
   [OrdinateDic setObject:[NSNumber numberWithInt:ordinatenteile] forKey:@"teile"];
   [OrdinateDic setObject:[NSNumber numberWithInt:startwert] forKey:@"startwert"];
   [OrdinateDic setObject:@"kW" forKey:@"einheit"];
   [OrdinateDic setObject:[NSNumber numberWithInt:0] forKey:@"red"]; // nur gerade Werte anzeigen
   //NSLog(@"OrdinateDic: %@",[OrdinateDic description]);
   
   [self.ordinate OrdinateZeichnenMitDic:OrdinateDic];
   


}

- (void)refreshData
{
   StromDicVonHeute = [self StromDataDicVonHeute];
   NSArray* lastDataArray = [[StromDicVonHeute objectForKey:@"laststromdata"]componentsSeparatedByString:@"\t"];
   self.leistungaktuell.text = [NSString stringWithFormat:@"%d W",[[lastDataArray lastObject]intValue]];
   self.datum.text = [NSString stringWithFormat:@"%2d.%02d.20%d",[[lastDataArray objectAtIndex:2]intValue],[[lastDataArray objectAtIndex:1]intValue],[[lastDataArray objectAtIndex:0]intValue]];
   self.zeit.text = [NSString stringWithFormat:@"%d:%02d:%02d",[[lastDataArray objectAtIndex:3]intValue],[[lastDataArray objectAtIndex:4]intValue],[[lastDataArray objectAtIndex:5]intValue]];
   
   //NSLog(@"\refreshData segment: %d",self.anzeigeseg.selectedSegmentIndex);
   
   [self switchAnzeigeSeg:self.anzeigeseg.selectedSegmentIndex];
   return;
   
}


- (NSDictionary*)StromDataDicVonHeute
{
   /*
    lastdatenarray =     (
    12,     Jahr
    12,     Monat
    05,     Tag
    12,     Stunde
    06,     Minute
    08,     Sekunde
    "  365" Leistung
    );
    Alle Temperaturerte mit doppeltem Wert
	 */
   
   NSMutableDictionary* StromDataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSCharacterSet* CharOK=[NSCharacterSet alphanumericCharacterSet];
   
//	NSString* returnString=[NSString string];
	//if (isDownloading)
	{
      //	return nil;//[self cancel];
	}
	//else
	{
		NSString* DataSuffix=@"StromDaten.txt";
		//NSLog(@"StromDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
		NSURL *URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
		NSLog(@"StromDataVonHeute URL: %@",URL);
		NSStringEncoding *  enc=0;
		NSError* WebFehler=NULL;
		NSString* DataString=[NSString stringWithContentsOfURL:URL usedEncoding: enc error:&WebFehler];
		//NSLog(@"DataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
		if (WebFehler)
		{
			//NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
			NSLog(@"StromDataVonHeute WebFehler: :%@",[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]);
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
         NSLog(@"alertController StromDataDicVonHeute");
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fehler beim Download der Stromdaten von heute"
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
         
			//NSLog(@"SolarDataVonHeute DataString: \n%@",DataString);
			[StromDataDic setObject:DataString forKey:@"datastring"];
			//NSLog(@"StromDataArray: %@",[[DataString componentsSeparatedByString:@"\n"]description]);
         NSArray* StromDataArray = [DataString componentsSeparatedByString:@"\n"];
         //NSLog(@"StromDataArray vor: %@",[SolarDataArray description]);
         // Kopfzeilen entfernen
         StromDataArray = [StromDataArray subarrayWithRange:NSMakeRange(7, [StromDataArray count]-8)];
         if ([[StromDataArray lastObject]length] ==0)
         {
            StromDataArray = [StromDataArray subarrayWithRange:NSMakeRange(0, [StromDataArray count]-1)];
         }
         //NSLog(@"StromDataArray nach: %@",[[StromDataArray lastObject]description]);
         //NSLog(@"StromDataArray nach: %@",[StromDataArray description]);
         
         [StromDataDic setObject:StromDataArray  forKey:@"stromdata"];
         
         [StromDataDic setObject:[StromDataArray lastObject] forKey:@"laststromdata"];
         //NSLog(@"last: %@",[[StromDataArray lastObject]description]);
         // Strommonitor laden
         //return StromDataDic;
		}
		else
		{
			NSLog(@"StromDataDicVonHeute Keine Daten an URL %@",URL);
			//[self setErrString:@"DataVonHeute: keine Daten"];
		}
      
      DataSuffix=@"StromMonitor.txt";
		//NSLog(@"StromDataVonHeute  DownloadPfad: %@ DataSuffix: %@",ServerPfad,DataSuffix);
		URL = [NSURL URLWithString:[ServerPfad stringByAppendingPathComponent:DataSuffix]];
		//NSLog(@"StromMonitorDataVonHeute URL: %@",URL);
		//NSStringEncoding *  enc=0;
		WebFehler=NULL;
		DataString=[NSString stringWithContentsOfURL:URL usedEncoding: enc error:&WebFehler];
		//NSLog(@"DataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
		if (WebFehler)
		{
			//NSLog(@"SolarDataVonHeute WebFehler: :%@",[[WebFehler userInfo]description]);
			NSLog(@"StromDataVonHeute WebFehler: :%@",[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]);
			//ERROR: 503
			NSArray* ErrorArray=[[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]componentsSeparatedByString:@" "];
			NSLog(@"ErrorArray: %@",[ErrorArray description]);
         // Login-Alert zeigen
        // [self showDebug:@"StromDataDicVonHeute: Download misslungen"];
         /*
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error in Download",@"Download misslungen")
                                                           message:[[[WebFehler userInfo]objectForKey:@"NSUnderlyingError"]description]
                                                          delegate:self
                                                 cancelButtonTitle:@""
                                                 otherButtonTitles:@"OK", nil];
         [message setAlertViewStyle:UIAlertViewStyleDefault];
         [message show];
          */
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
			//[StromDataDic setObject:DataString forKey:@"datastring"];
			//NSLog(@"StromDataArray: %@",[[DataString componentsSeparatedByString:@"\n"]description]);
         NSArray* StromDataArray = [DataString componentsSeparatedByString:@"\n"];
         //NSLog(@"StromDataArray vor: %@",[SolarDataArray description]);
         if ([[StromDataArray lastObject]length] ==0)
         {
            StromDataArray = [StromDataArray subarrayWithRange:NSMakeRange(0, [StromDataArray count]-1)];
         }
         //NSLog(@"StromDataArray nach: %@",[[StromDataArray lastObject]description]);
         //NSLog(@"StromMonitorDataArray nach: %@",[StromDataArray description]);
         //NSLog(@"StromMonitorDataArray count: %d",[StromDataArray count]);
         [StromDataDic setObject:StromDataArray  forKey:@"strommonitor"];
         
      }
      else
		{
			NSLog(@"StromDataDicVonHeuteKeine Daten  an URL %@",URL);
			//[self setErrString:@"DataVonHeute: keine Daten"];
		}

      
      self.diagrammscroller.contentSize = self.diagrammview.frame.size;
      
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
	return StromDataDic;
   
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   [self setData:nil];
   [self setLeistungaktuell:nil];
   [self setZeit:nil];
   [self setDatum:nil];
   //[self setPlotfeld:nil];
   [self setDiagrammview:nil];
   [self setDiagrammscroller:nil];
   [self setDiagrammscroller:nil];
   [self setDiagrammview:nil];
   [self setAnzeigeseg:nil];
   [self setRefreshTaste:nil];
   [self setOrdinate:nil];
   [super viewDidUnload];
}
@end
