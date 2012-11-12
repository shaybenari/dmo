//
//  CameraViewController.h
//  ArutzSheva7
//
//  Created by Admin on 10/29/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *saveImageBotton;

-(IBAction)showCameraAction:(id)sender;


@end
