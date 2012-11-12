//
//  KarikaturaViewController.m
//  ArutzSheva7
//
//  Created by Admin on 11/2/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "KarikaturaViewController.h"

@interface KarikaturaViewController ()

@end

@implementation KarikaturaViewController
@synthesize pic;

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
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.frame=CGRectMake(145, 160, 25, 25);
    av.tag  = 100;
    
    [self.view addSubview:av];
    [av startAnimating];
    NSString* imageUrlString=@"http://a7.org/Resizer.ashx?source=album&album=1&image=45307&a=450&b=1200&save=1";
    NSURL* imageUrl=[NSURL URLWithString:imageUrlString];
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    pic.image=[UIImage imageWithData:imageDate];
    [av stopAnimating];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
