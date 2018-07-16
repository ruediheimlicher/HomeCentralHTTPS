//
//  rEingabeViewController.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 03.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import "rVariableStore.h"
#import "rToggleTaste.h"
#import "rTagplanAnzeige.h"
#import "rStatusAnzeige.h"

#define TWIOFF          0x01
#define ADRESSEOK       0x02;
#define DATAOK          0x04;
#define SENDOK          0x08;

#define kUIControlStateCustomState (1 << 16)

@class DotColors;
@class rURLTask;

@interface TWIControl : UIControl {
   UIControlState customState;
}
-(void)setCustomState;
-(void)unsetCustomState;
- (void)stateWasUpdated;
@end

@interface rHomeController : UIViewController <UIAlertViewDelegate,UIWebViewDelegate,NSURLConnectionDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate >
{
   NSMutableData *_responseData;
   rURLTask*   URLTask;
   DotColors* Farbe;
   
   NSURL* HomeCentralURL;
   NSString*               pw;
   NSMutableString*        pwpart; // teil der URL mit daten von pw

   rToggleTaste* OnOffTaste;
   rToggleTaste* StundenTaste;
   NSTimer* confirmTimer;
	NSTimer* confirmStatusTimer;
   NSTimer* TWIStatusTimer;
	int maxAnzahl;
   NSURL* HomeServerURL;
   NSString* HomeCentralAdresseString;
   NSString* HomeServerAdresseString;
   NSString* HomeServerSendString;
   NSString* debugstring;
   NSData* receivedData;
   NSString* receivedAnswerString;
}
@property(readonly, copy) NSURL *                                 resourceURL;
@property(readonly, copy)  NSString *                             resourcePath;
@property (weak, nonatomic) IBOutlet UIScrollView *               tagplanscroller;
@property (weak, nonatomic) IBOutlet UIView *                     tagplanfeld;
@property (weak, nonatomic) IBOutlet rToggleTaste *               taste0;
@property (weak, nonatomic) IBOutlet rToggleTaste *               stundentaste;
@property (weak, nonatomic) IBOutlet UILabel *                    ipfeld;
@property (weak, nonatomic) IBOutlet UIStepper *                  wochentagstepper;
@property (weak, nonatomic) IBOutlet UIStepper *                  objektstepper;
@property (weak, nonatomic) IBOutlet UILabel *                    objektname;
@property (weak, nonatomic) IBOutlet UITextField *                wochentag;

@property (weak, nonatomic) IBOutlet UISegmentedControl *         raumseg;

@property (weak, nonatomic) IBOutlet UIButton *                   resettaste;

@property (weak, nonatomic) IBOutlet UIButton *                   onofftaste;
@property (weak, nonatomic) IBOutlet UISegmentedControl *         wochentagseg;
@property (nonatomic, readwrite) NSArray*                         WochentagArray;
@property (weak, nonatomic) IBOutlet rTagplanAnzeige *            tagplananzeige;

@property (nonatomic, readwrite) int                              aktuellerRaum;
@property (nonatomic, readwrite) int                              aktuellesObjekt;
@property (nonatomic, readwrite) NSString*                        aktuellerObjektname;
@property (nonatomic, readwrite) long                              aktuellerWochentag;
@property (nonatomic, readwrite) int                              aktuellerObjekttyp;
@property (nonatomic, readwrite) NSMutableArray*                  aktuellerstundencodearray;
@property (nonatomic, readwrite) NSArray*                         oldstundencodearray;
@property (nonatomic, readwrite) NSArray*                         wochenplanarray;
@property (nonatomic, readwrite) NSMutableDictionary*             tagplandic;

@property (nonatomic, readwrite) NSString*                        aktuellesjahr;
@property (nonatomic, readwrite) NSString*                        aktuellermonat;
@property (nonatomic, readwrite) NSString*                        aktuellertag;

@property (strong, nonatomic) IBOutlet UISwitch *                 twitaste;
@property (nonatomic, readwrite) int                              lastTWIState;

@property (weak, nonatomic) IBOutlet UIWebView *                  webfenster;

@property (weak, nonatomic) IBOutlet UIButton *                   sendtaste;
@property (weak, nonatomic) IBOutlet UILabel *                    twitimer;
@property (weak, nonatomic) IBOutlet rStatusanzeige *             statusanzeige;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *    ladeindikator;

@property (weak, nonatomic) IBOutlet UILabel *                    hexdata;
@property (weak, nonatomic) IBOutlet UITextField *                testdata;
@property (weak, nonatomic) IBOutlet UITextField *                twialarm;
@property (weak, nonatomic) IBOutlet UITextField *                connection;

@property (nonatomic, readwrite) int                              permanent;
+ (void)checkInternetConnectivityWithSuccessCompletion:(void (^)(void))completion ;
- (DotColors*)returnSwiftClassInstance;
- (void)showDebug:(NSString*)warnung;
- (NSString*)passwortstring;
- (IBAction)reportResetTaste:(id)sender;

- (IBAction)reportSendTaste:(UIButton *)sender;

- (IBAction)reportTWITaste:(UISwitch *)sender;

- (IBAction)reportStundenTaste:(id)sender;

- (IBAction)reportWochentagSeg:(id)sender;
//- (IBAction)reportWochentag:(id)sender;

- (IBAction)reportRaumSeg:(id)sender;
- (IBAction)reportOnOff:(id)sender;
- (IBAction)reportClear:(id)sender;
- (IBAction)reportObjektStepper:(id)sender;

- (NSMutableArray*)StundenCodeArrayVonByteArray:(NSArray*)bytearray;
- (NSArray*)StundenByteArrayVonStundenCodeArray:(NSArray*)stundencodearray;

- (void)setTagPlanInRaum:(int)raum fuerObjekt:(int)objekt anWochentag:(int)wochentag mitDaten:(NSArray*)stundencodearray;
- (NSMutableArray*)setTagplanInRaum:(int)raum fuerObjekt:(int)objekt anWochentag:(int)wochentag;
- (void)clearTagplan;
- (void)setTWIState:(int)status;
- (void)restartTWITimer;
- (void)loadURL:(NSURL *)URL;
@end
