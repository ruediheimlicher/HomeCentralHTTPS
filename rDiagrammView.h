//
//  rDiagrammView.h
//  HomeCentral
//
//  Created by Ruedi Heimlicher on 06.Dezember.12.
//  Copyright (c) 2012 Ruedi Heimlicher. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface rDiagrammView : UIView
{
   #define kGraphHeight          300
   #define kDefaultGraphWidth    900
   #define kOffsetX              0
   #define kStepX                20
   #define kStepY                20
   #define kOffsetY              0


   #define kGraphBottom          300
   #define kGraphTop             0
   NSDictionary*                 DataDic;
   
}
@property (weak,nonatomic, readwrite) NSDictionary* datadic;
@property (nonatomic, readwrite) int graphheight;
@property (nonatomic, readwrite) int graphwidth;

-(void)DiagrammZeichnenMitDic:(NSDictionary*)derDataDic;
@end
