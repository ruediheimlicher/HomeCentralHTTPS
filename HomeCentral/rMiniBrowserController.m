//
//  rMiniBrowserController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 04.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rMiniBrowserController.h"

@interface rMiniBrowserController ()

@end

@implementation rMiniBrowserController

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
   self.browser.delegate = self;
   self.browser.scalesPageToFit = YES;
	self.browser.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight);
	// Do any additional setup after loading the view.
   
   
   
}
                                    
- (IBAction)reportTextFieldGo:(id)sender
   {
      NSLog(@"reportTextFieldGo eingabe: %@",[self.urlfeld text]);
      [sender resignFirstResponder];
      NSString* url = self.urlfeld.text;
      if (url == @"home")
      {
         NSLog(@"reportTextFieldGo NO");
         [super dismissModalViewControllerAnimated:YES];
         //do close window magic here!!
         return ;
      }
      
      url = [NSString stringWithFormat:@"http://%@",url];
      NSLog(@"reportTextFieldGo url: %@",url);
      
      //[self produceHTMLForPage:1];
      [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
      
   }

- (void)viewWillAppear:(BOOL)animated
{
   NSLog(@"viewWillAppear");
	self.browser.delegate = self;	// setup the delegate as the web view is shown
   
   
}

- (void)viewWillDisappear:(BOOL)animated
{
   [self.browser stopLoading];	// in case the web view is still loading its content
	self.browser.delegate = nil;	// disconnect the delegate as the webview is hidden
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
   if ([[request URL] absoluteString] == @"http://home/")
   {
      NSLog(@"shouldStartLoadWithRequest NO");
      [super dismissModalViewControllerAnimated:YES];
      //do close window magic here!!
      return NO;
   }
   if ([[[request URL] absoluteString] isEqualToString:@"plus.google.com/"])
   { [super dismissModalViewControllerAnimated:YES]; return NO; }
   
   NSLog(@"shouldStartLoadWithRequest YES %@",[request URL]);
   [[UIApplication sharedApplication] openURL:[request URL]];
   return YES;
   
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBrowser:nil];
    [self setTaste:nil];
    [self setAdresse:nil];
    [self setBack:nil];
    [self setTaste:nil];
    [self setTopbar:nil];
    [self setFootbar:nil];
    [super viewDidUnload];
}
- (IBAction)tasteaktion:(UIBarButtonItem *)sender {
}

- (IBAction)reportURL:(UITextField *)sender
{
   NSLog(@"reportTextFieldReturn eingabe: %@",[self.urlfeld text]);
   [sender resignFirstResponder];
   NSString* url = self.urlfeld.text;
   NSLog(@"reportTextFieldReturn url raw: %@",url);
   if (url == @"home")
   {
      NSLog(@"reportTextFieldGo NO");
      [super dismissModalViewControllerAnimated:YES];
      //do close window magic here!!
      return ;
   }
   
   url = [NSString stringWithFormat:@"http://%@",url];
   NSLog(@"reportTextFieldReturn url: %@",url);
   
   //[self produceHTMLForPage:1];
   [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
   
}

- (IBAction)reportEingabe:(id)sender
{
   NSLog(@"reportTextFieldReturn eingabe: %@",[self.urlfeld text]);
   [sender resignFirstResponder];
   NSString* url = self.urlfeld.text;
   if (url == @"home")
   {
      NSLog(@"reportTextFieldGo NO");
      [super dismissModalViewControllerAnimated:YES];
      //do close window magic here!!
      return ;
   }
   
   url = [NSString stringWithFormat:@"http://%@",url];
   NSLog(@"reportTextFieldReturn url: %@",url);
   
   //[self produceHTMLForPage:1];
   [self.browser loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
   

}
 @end
