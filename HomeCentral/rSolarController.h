//
//  rSolarController.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 04.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "rSolarDiagrammView.h"
#import "rBoilerView.h"
#import "rOrdinate.h"
#import "rAbszisse.h"
#import "rVariableStore.h"

@interface rSolarController : UIViewController <UITextFieldDelegate, UIWebViewDelegate>

{
   
   IBOutlet UILabel*       KT;
   IBOutlet UILabel*       KV;
   IBOutlet UILabel*       KR;
   IBOutlet UILabel*       BO;
   IBOutlet UILabel*       BM;
   IBOutlet UILabel*       BU;
   IBOutlet UIImageView*   Pumpe;
   
   NSString*               ServerPfad;
   int                     isDownloading;
   int                     lastDataZeit;
   NSString*               SolarDataVonHeuteString;
   NSString*               lastSolarDataString;
   int std;
   int min;
   int data;
   int art;
   int randlinks;
   int randrechts;
   int randunten;
   int randoben;
   float b;
   int intervally;
   int intervallx;
   int teile;
   int startwert;
   

   
}
@property (weak, nonatomic) IBOutlet UILabel *     kt;
@property (weak, nonatomic) IBOutlet UILabel *     kv;
@property (weak, nonatomic) IBOutlet UILabel *     kr;
@property (weak, nonatomic) IBOutlet UILabel *     bo;
@property (weak, nonatomic) IBOutlet UILabel *     bm;
@property (weak, nonatomic) IBOutlet UILabel *     bu;
@property (weak, nonatomic) IBOutlet UITextField * urlfeld;
@property (weak, nonatomic) IBOutlet UIWebView *   webfenster;
@property (weak, nonatomic) IBOutlet UILabel *     solardata;
@property (weak, nonatomic) IBOutlet UILabel *     heizung;
@property (weak, nonatomic) IBOutlet UIImageView * pumpe;

@property (weak, nonatomic) IBOutlet UINavigationItem *backtaste;
@property (weak, nonatomic) IBOutlet UIButton *RefreshTaste;


- (IBAction)reportRefresh:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *AussentempFeld;

@property (weak, nonatomic) IBOutlet rBoilerView *boilerfeld;

@property (weak, nonatomic) IBOutlet UIScrollView *diagrammscroller;
@property (weak, nonatomic) IBOutlet rSolarDiagrammView *diagrammview;
@property (weak, nonatomic) IBOutlet UIImageView *wolke;
@property (weak, nonatomic) IBOutlet UIImageView *anlage;
@property (weak, nonatomic) IBOutlet UIButton *diagrammtaste;
@property (weak, nonatomic) IBOutlet rOrdinate *ordinate;
@property (weak, nonatomic) IBOutlet rAbszisse *abszisse;
@property (nonatomic,readwrite) float zoomfaktorx;
@property (nonatomic,readwrite) float zoomfaktory;


- (void)showDebug:(NSString*)warnung;

- (IBAction)reportDiagrammTaste:(id)sender;



- (IBAction)switch2Strom:(id)sender;
- (IBAction)reportTextFieldGo:(id)sender;
- (NSDictionary*)SolarDataDicVonHeute;
- (NSDictionary*)lastSolarDataDic;
- (void)loadLastData;
- (void)loadDiagrammData;
- (int)lastDataZeitVon:(NSString*)derDatenString;

@end
