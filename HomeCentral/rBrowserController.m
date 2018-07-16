//
//  rBrowserController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 27.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rBrowserController.h"

@interface rBrowserController ()

@end

@implementation rBrowserController

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
   // http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http/32560433#32560433
    [super viewDidLoad];
   // https
   self.websitename = @"ruediheimlicherhome.dyndns.org";
	// Do any additional setup after loading the view.
//self.title = self.websitename;
   // https
   NSString *fullURL = [NSString stringWithFormat:@"https://%@", self.websitename];
   NSURL *websiteURL = [NSURL URLWithString:fullURL];
   NSURLRequest *requestObj = [NSURLRequest requestWithURL:websiteURL];
   [self.webfenster loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    // Dispose of any resources that can be recreated.
}

@end
