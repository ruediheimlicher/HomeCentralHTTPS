//
//  rBrowserController.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 27.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rBrowserController : UIViewController
{
   
}
@property (copy, nonatomic) NSString * websitename;
@property (weak, nonatomic) IBOutlet UIWebView *webfenster;
@property (weak, nonatomic) IBOutlet UITextField *webadresse;

@end
