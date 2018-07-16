//
//  rMiniBrowserController.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 04.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rMiniBrowserController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *adresse;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *taste;
@property (weak, nonatomic) IBOutlet UIToolbar *topbar;
@property (weak, nonatomic) IBOutlet UIToolbar *footbar;
@property (weak, nonatomic) IBOutlet UITextField *urlfeld;
- (IBAction)tasteaktion:(UIBarButtonItem *)sender;
- (IBAction)reportURL:(UITextField *)sender;
- (IBAction)reportEingabe:(id)sender;

@end
