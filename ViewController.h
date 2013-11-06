//
//  ViewController.h
//  ShapeDetection
//
//  Created by Ryan DeCosmo on 8/3/13.
//  Copyright (c) 2013 Ryan DeCosmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFormatViewController.h"

@interface ViewController : AVFormatViewController
{
    double _min, _max;
    __weak IBOutlet UISlider *_slider;
    __weak IBOutlet UILabel *_labelValue;
    
     
    
    
}

- (IBAction)sliderValueChanged:(id)sender;




@end
