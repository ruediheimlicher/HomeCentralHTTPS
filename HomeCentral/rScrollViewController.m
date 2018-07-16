//
//  rScrollViewController.m
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 06.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import "rScrollViewController.h"

@interface rScrollViewController ()

@end

@implementation rScrollViewController

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
	// Do any additional setup after loading the view.
   self.scroller.contentSize = self.scrollbild.image.size;
   self.scrollbild.frame =
   CGRectMake(0, 0, self.scrollbild.image.size.width*2, self.scrollbild.image.size.height);
   
   self.diagrammscroller.contentSize = self.diagrammview.frame.size;
    
   NSMutableDictionary*  DiagrammdatenDic = [[NSMutableDictionary alloc]initWithCapacity:0];
   NSMutableArray* LineArray = [[NSMutableArray alloc]initWithCapacity:0];
   for (int i=0;i<3;i++) // linien
   {
      // Array: dataarray mit datadics
      NSMutableArray* tempDataArray = [[NSMutableArray alloc]initWithCapacity:0];
      for (int k=0;k<5;k++)// Datenarray
      {
         // Datadic mit Koordinaten
         NSDictionary* tempDataDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:k*50],@"x",[NSNumber numberWithFloat:4*k*k+10*i],@"y", nil];
         
         [tempDataArray addObject:tempDataDic];
      }
      UIColor* tempColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.4 alpha:1.0];
      NSDictionary* tempLineDic = [NSDictionary dictionaryWithObjectsAndKeys:tempDataArray,@"dataarray",tempColor,@"linecolor", nil];
      [LineArray addObject:tempLineDic];
   }
   
   //NSLog(@"LineArray: %@",[LineArray description]);
   [DiagrammdatenDic setObject:LineArray forKey:@"linearray"];
   //NSLog(@"DiagrammdatenDic: %@",[DiagrammdatenDic description]);
   [self.diagrammview DiagrammZeichnenMitDic:DiagrammdatenDic];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

- (void)viewDidUnload {
    [self setScroller:nil];
   [self setScrollbild:nil];
   [self setDiagrammscroller:nil];
   [self setDiagrammview:nil];
    [super viewDidUnload];
}
@end
