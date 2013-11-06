//
//  AVFormatViewController.h
//  ShapeDetection
//
//  Created by Ryan DeCosmo on 8/3/13.
//  Copyright (c) 2013 Ryan DeCosmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <opencv2/imgproc/imgproc_c.h>

@interface AVFormatViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    __weak IBOutlet UIImageView *_imageView;
   
    AVCaptureSession *_session;
    AVCaptureDevice *_captureDevice;
    
    BOOL _useBackCamera; 
    

}


- (UIImage*)getUIImageFromIplImage:(IplImage *)iplImage;
- (void)didCaptureIplImage:(IplImage *)iplImage;
- (void)didFinishProcessingImage:(IplImage *)iplImage;

@end
