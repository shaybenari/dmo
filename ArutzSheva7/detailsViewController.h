//
//  detailsViewController.h
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import <UIKit/UIKit.h>
@class Article;
@interface detailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet UITextView *details;
@property (strong,nonatomic) Article *current;

@property (strong, nonatomic) IBOutlet UIScrollView *scrolv;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)increase:(UIBarButtonItem *)sender;
- (IBAction)decrease:(UIBarButtonItem *)sender;
- (IBAction)share:(id)sender;
- (IBAction)response:(id)sender;
- (IBAction)saveJob:(UIBarButtonItem *)sender;
@property NSInteger fontsize;
@property (strong,nonatomic) NSString *catagory;

@end
