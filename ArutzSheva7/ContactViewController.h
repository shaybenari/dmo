//
//  ContactViewController.h
//  arutz7
//
//  Created by Admin on 10/25/12.
//
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mail;
@property (strong, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *content;
@property (strong, nonatomic) IBOutlet UISegmentedControl *type;
- (IBAction)finishEdit:(UITextField *)sender;
- (IBAction)send:(UIButton *)sender;
@end
