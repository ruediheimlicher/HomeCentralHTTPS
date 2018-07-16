//
//  rScrollViewController.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 06.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rDiagrammView.h"

@interface rScrollViewController : UIViewController
{
   
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *scrollbild;
@property (weak, nonatomic) IBOutlet UIScrollView *diagrammscroller;
@property (weak, nonatomic) IBOutlet rDiagrammView *diagrammview;

@end
