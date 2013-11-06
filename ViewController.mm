//
//  ViewController.m
//  ShapeDetection
//
//  Created by Ryan DeCosmo on 8/3/13.
//  Copyright (c) 2013 Ryan DeCosmo. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/objdetect/objdetect.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#import "opencv2/opencv.hpp"
#import <AVFoundation/AVFoundation.h>


 
using namespace std; 
using namespace cv;


@implementation ViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(id)sender
{
    double rangeMIN = 0;
    double rangeMAX = 250;
    double step = 20;
    
    _min = rangeMIN + _slider.value * (rangeMAX - rangeMIN - step);
    _max = _min + step;
    
    _labelValue.text = [NSString stringWithFormat:@"%.2f - %.2f", _min, _max];
}




static BOOL _debug = YES;


- (void)didCaptureIplImage:(IplImage *)iplImage
{
    
    /*
    IplImage *imgGray = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 1);
    cvCvtColor(iplImage, imgGray, CV_BGR2GRAY);
    Mat matGray = Mat(imgGray);
    
    IplImage *imgThreshed = cvCreateImage(cvGetSize(iplImage), 8, 1);
    Mat matThreshed = Mat(imgThreshed);
    
    cvReleaseImage(&iplImage);
    
    //filter
    cv::Size size(3,3);
    cv::GaussianBlur(matGray, matThreshed, size, 0);
    adaptiveThreshold(matGray, matThreshed, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, 75, 10);
    cv::bitwise_not(matThreshed, matThreshed);
    
    vector<Vec4i> lines;
    HoughLinesP(matThreshed, lines, 1, CV_PI/180, 80);
    */
    
    
              
    
    //ipl image is in BGR format, it needs to be converted to RGB for display in UIImageView
    IplImage *imgRGB = cvCreateImage(cvGetSize(iplImage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplImage, imgRGB, CV_BGR2RGB);
    Mat matRGB = Mat(imgRGB);
    
    //ipl image is also converted to HSV; hue is used to find certain color
    IplImage *imgHSV = cvCreateImage(cvGetSize(iplImage), 8, 3);
    cvCvtColor(iplImage, imgHSV, CV_BGR2HSV);
    
    IplImage *imgThreshed = cvCreateImage(cvGetSize(iplImage), 8, 1);
    
    /*it is important to release all images EXCEPT the one that is going to be passed to the didFinishProcessingImage: method and displayed in the UIImageView*/
    cvReleaseImage(&iplImage);
    
    //filter all pixels in defined range, everything in range will be white, everything else
    //is going to be black
    cvInRangeS(imgHSV, cvScalar(_min, 100, 100), cvScalar(_max, 255, 255), imgThreshed);
    
    cvReleaseImage(&imgHSV);
    
    Mat matThreshed = Mat(imgThreshed);
    
    //smooths edges
    cv::GaussianBlur(matThreshed,
                     matThreshed,
                     cv::Size(13, 13),
                     2,
                     2);
    
   
    
    
    
    //debug shows threshold image, otherwise the circles are detected in the
    //threshold image and shown in the RGB image
    if (_debug)
    {  	
        cvReleaseImage(&imgRGB);
        [self didFinishProcessingImage:imgThreshed];
    }
    else
    {
        vector<Vec3f> circles;
        
        //get circles
        HoughCircles(matThreshed,
                     circles,
                     CV_HOUGH_GRADIENT,
                     2,
                     matThreshed.rows / 4,    
                     150,                    
                     75,                      
                     10,                      
                     150);                    
        
        for (size_t i = 0; i < circles.size(); i++)
        {
            cout << "Circle position x = " << (int)circles[i][0] << ", y = " << (int)circles[i][1] << ", radius = " << (int)circles[i][2] << "\n";
            
         
            
            cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
            
            int radius = cvRound(circles[i][2]);
            
            circle(matRGB, center, 3, Scalar(0, 255, 0), -1, 8, 0);
            circle(matRGB, center, radius, Scalar(0, 0, 255), 3, 8, 0);
        }
    
        //threshed image is not needed any more and needs to be released
        cvReleaseImage(&imgThreshed);
        
        //imgRGB will be released once it is not needed, the didFinishProcessingImage:
        //method will take care of that
        [self didFinishProcessingImage:imgRGB];
    }

}



@end
