//
//  detailsViewController.h
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import <UIKit/UIKit.h>

@interface detailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UITextView *details;
@property (strong,nonatomic) NSString* picturePath;
@property (strong,nonatomic) NSString* detailsText;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) NSString* titleString;
- (IBAction)increase:(UIBarButtonItem *)sender;
- (IBAction)decrease:(UIBarButtonItem *)sender;
- (IBAction)share:(id)sender;
- (IBAction)response:(id)sender;
@property (strong,nonatomic) NSString* date;
@property NSInteger fontsize;
@property (strong,nonatomic) NSString* link;
@end
