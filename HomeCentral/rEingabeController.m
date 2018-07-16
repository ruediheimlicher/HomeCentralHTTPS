//
//  rViewController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 28.November.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rEingabeController.h"

@interface rEingabeController ()

@end

@implementation rEingabeController
/*
@synthesize DatumPicker;
@synthesize monat, wochentag;
@synthesize Datumfeld;
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
   self.datumpicker.date = [NSDate date];
}

- (IBAction)reportHeute:(id)sender
{
   NSLog(@"reportHeute");
   self.datumpicker.date = [NSDate date];
   [self changeDateInLabel:sender];
   
}

- (IBAction)reportDatumPicker:(id)sender
{
   [self changeDateInLabel:sender];
}

- (IBAction)reportLogin:(id)sender
{
   NSLog(@"reportLogin");
   self.datumfeld.text = [NSString stringWithFormat:@"%@",self.datumpicker.date.description];
   self.datumpicker.date = [NSDate date];

  self.wochentag = self.datumpicker.date.description;
   NSDate *currDate = [NSDate date];   //Current Date

   NSDateFormatter *df = [[NSDateFormatter alloc] init];
   
   //Day
   [df setDateFormat:@"dd"];
   NSString* myDayString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Month
   [df setDateFormat:@"MM"]; //MM will give you numeric "03", MMM will give you "Mar"
   NSString* myMonthString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   //Year
   [df setDateFormat:@"yy"];
   NSString* myYearString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Hour
   [df setDateFormat:@"hh"];
   NSString* myHourString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   //Minute
   [df setDateFormat:@"mm"];
   NSString* myMinuteString = [NSString stringWithFormat:@"%@",[df stringFromDate:currDate]];
   
   //Second
   [df setDateFormat:@"ss"];
   NSString* mySecondString = [NSString stringWithFormat:@"%@", [df stringFromDate:currDate]];
   
   NSLog(@"Year: %@, Month: %@, Day: %@, Hour: %@, Minute: %@, Second: %@", myYearString, myMonthString, myDayString, myHourString, myMinuteString, mySecondString);
   
   
   // Login-Alert zeigen
   /*
   UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Einloggen"
                                                     message:@"Name und Passwort für den Login"
                                                    delegate:self
                                           cancelButtonTitle:@"Abbrechen"
                                           otherButtonTitles:@"Login", nil];
   [message setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
   [message show];
   */
   
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Einloggen"
                                                                  message:@"Name und Passwort für den Login."
                                                           preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
   
   [alert addAction:defaultAction];
   UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Abbrechen" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
   
   [alert addAction:cancelAction];
   
   [self presentViewController:alert animated:YES completion:nil];

   

}

// Antworten auf Login-Button
/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
   if([title isEqualToString:@"Login"])
   {
      NSLog(@"Button Login was selected.");
      NSLog(@"Benutzername: %@",[[alertView textFieldAtIndex:0]text] );
      self.Benutzernamefeld.text = [alertView textFieldAtIndex:0].text;
      self.BenutzerPasswortfeld.text = [alertView textFieldAtIndex:1].text;
      
       - (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion

       
      
   }
   else if([title isEqualToString:@"Abbrechen"])
   {
      NSLog(@"Button Abbrechen was selected.");
   }
   else if([title isEqualToString:@"Button 3"])
   {
      NSLog(@"Button 3 was selected.");
   }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
   NSString *Benutzername = [[alertView textFieldAtIndex:0] text];
    NSString *Passwort = [[alertView textFieldAtIndex:1] text];
   if( [Benutzername isEqualToString:@"ruediheimlicher" ])
   {
      if( [Passwort isEqualToString:@"ideur00" ])
      {
         
         return YES;
      }
      else
      {
         return NO;
      }
      
   }
   else
   {
      return NO;
   }
}
*/
- (IBAction)reportAktualisieren:(id)sender
{
   NSLog(@"reportAktualisieren");
   [self changeDateInLabel:sender];
}
- (void)changeDateInLabel:(id)sender
{
   NSLog(@"changeDateInLabel %@",self.datumpicker.date);
	//Use NSDateFormatter to write out the date in a friendly format
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterShortStyle;
	self.pickerdatumfeld.text = [NSString stringWithFormat:@"%@",
                 [df stringFromDate:self.datumpicker.date]];
   NSDateFormatter *WochentagFormat = [[NSDateFormatter alloc] init];
   [WochentagFormat setDateFormat:@"d"];
   self.wochentag = [WochentagFormat stringFromDate:self.datumpicker.date];
   
   NSLog(@"changeDateInLabel wochentag: %@",self.wochentag);
   
   NSDateFormatter *StundeFormat = [[NSDateFormatter alloc] init];
   [StundeFormat setDateFormat:@"HH"];
   self.stunde = [StundeFormat stringFromDate:self.datumpicker.date];
   NSLog(@"changeDateInLabel stunde: %@",self.stunde);
   
   NSDateFormatter *MonatFormat = [[NSDateFormatter alloc] init];
   [MonatFormat setDateFormat:@"M"];
   self.monat = [MonatFormat stringFromDate:self.datumpicker.date];
	//self.monat = [NSString stringWithFormat:@"%@",[df stringFromDate:self.datumpicker.date]];
   NSString* pickerdatumString =[NSString stringWithFormat:@"mt: %@ wt: %@ std: %@",self.monat,self.wochentag,self.stunde];
   self.datumfeld.text = pickerdatumString;
   NSLog(@"changeDateInLabel monat: %@",self.monat);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   //Scene2ViewController *destination =
   NSLog(@"prepareForSegue: %@",[segue description]);
   
   //destination.labelText = @"Arrived from Scene 1";
}

- (IBAction)reportTextFieldReturn:(id)sender
{
   NSLog(@"reportTextFieldReturn");
   [sender resignFirstResponder];
}

-(IBAction)reportBackgroundTouched:(id)sender
{
   NSLog(@"reportBackgroundTouched");
   [self.datumfeld resignFirstResponder];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
   [self setBenutzernamefeld:nil];
   [self setBenutzerPasswortfeld:nil];
   [self setHomeButton:nil];
   [self setDatumpicker:nil];
   [self setDatumfeld:nil];
   [self setPickerdatumfeld:nil];
   [super viewDidUnload];
}
@end
