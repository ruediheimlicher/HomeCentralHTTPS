//
//  rStromDiagrammView.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 07.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rStromDiagrammView : UIView
{
#define kGraphHeight          300
#define kDefaultGraphWidth    900
#define kOffsetX              0
#define kStepX                60
#define kStepY                20
#define kOffsetY              0
   
   
#define kGraphBottom          300
#define kGraphTop             0
NSDictionary*                 DataDic;
   
}
@property (weak,nonatomic, readwrite) NSDictionary* datadic;
@property (nonatomic, readwrite) int graphheight;
@property (nonatomic, readwrite) int graphwidth;
@property (nonatomic, readwrite) int randoben;
@property (nonatomic, readwrite) int randlinks;
@property (nonatomic, readwrite) int randunten;

@property (nonatomic, readwrite) float diagrammhoehe;
@property (nonatomic, readwrite) float diagrammbreite;

@property (nonatomic, readwrite) int lastzeit;

-(void)DiagrammZeichnenMitDic:(NSDictionary*)derDataDic;

@end
