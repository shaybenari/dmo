//
//  buttonsViewController.m
//  arutz7
//
//  Created by Admin on 9/15/12.
//
//

#import "buttonsViewController.h"

@interface buttonsViewController ()

@end

@implementation buttonsViewController
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    int tag=((UIButton*)sender).tag;
    UIViewController *vc=[segue destinationViewController];
    ((ViewController*)vc).mode=tag;
}
@end
