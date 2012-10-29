//
//  ResponsesViewController.h
//  arutz7
//
//  Created by Admin on 10/27/12.
//
//

#import <UIKit/UIKit.h>

@interface ResponsesViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *mail;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *content;
- (IBAction)finishEdit:(UITextField *)sender;
- (IBAction)send:(UIButton *)sender;
@property NSInteger item;
@end
