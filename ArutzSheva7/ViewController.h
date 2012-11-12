//
//  ViewController.h
//  arutz7
//
//  Created by Admin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)toTheForum:(UIBarButtonItem *)sender;
- (IBAction)hideBar:(id)sender;
- (void)showBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar7;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forumButton;
@property int mode;
-(void)loadPage:(NSString*)link withPostData:(NSString*)post;
@end

