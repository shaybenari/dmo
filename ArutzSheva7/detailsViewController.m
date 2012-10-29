//
//  detailsViewController.m
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import "detailsViewController.h"
#import "ResponsesViewController.h"
#import "ShareKit/Core/SHK.h"
@interface detailsViewController ()

@end

@implementation detailsViewController
@synthesize picture;
@synthesize details;
@synthesize picturePath;
@synthesize detailsText;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize titleString;
@synthesize date;
@synthesize fontsize;
@synthesize link;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    fontsize=10;
    NSLog(@"details:  %@",detailsText);
    details.text=detailsText;
    dateLabel.text=date;
    titleLabel.text=titleString;
    NSURL* imageUrl=[NSURL URLWithString:picturePath];
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    picture.image=[UIImage imageWithData:imageDate];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPicture:nil];
    [self setDetails:nil];
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)increase:(UIBarButtonItem *)sender {
    fontsize++;
    NSLog(@"%d",fontsize);
    [dateLabel setFont:[UIFont systemFontOfSize:fontsize]];
    [titleLabel setFont:[UIFont systemFontOfSize:fontsize+10]];
    [details setFont:[UIFont systemFontOfSize:fontsize+4]];
    
}

- (IBAction)decrease:(UIBarButtonItem *)sender {
    fontsize--;
    NSLog(@"%d",fontsize);
    [dateLabel setFont:[UIFont systemFontOfSize:fontsize]];
    [titleLabel setFont:[UIFont systemFontOfSize:fontsize+10]];
   
    [details setFont:[UIFont systemFontOfSize:fontsize+4]];

}

- (IBAction)share:(id)sender {
    NSURL *url=[NSURL URLWithString:link];
    SHKItem *item = [SHKItem URL:url title:titleString];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar];

   
    
}

- (IBAction)response:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"toTheResponses"]) {
        ResponsesViewController* vc= (ResponsesViewController*)[segue destinationViewController];
        vc.item=[[[link componentsSeparatedByString:@"/"] lastObject] integerValue];
        
    }
}

@end
