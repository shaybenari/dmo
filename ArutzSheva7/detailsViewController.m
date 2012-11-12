//
//  detailsViewController.m
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import "detailsViewController.h"
#import "ResponsesViewController.h"
#import "SHK.h"
#import "Article.h"
#import "XMLParser.h"
@interface detailsViewController (){
    UIActivityIndicatorView *av;
    NSMutableArray *allArticles;

}

@end

@implementation detailsViewController
@synthesize picture;
@synthesize details;
@synthesize catagory;

@synthesize titleLabel;
@synthesize dateLabel;

@synthesize current;
@synthesize scrolv;
@synthesize fontsize;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[scrolv setContentOffset:CGPointZero animated:NO];

}
- (void)viewDidLoad
{
    //---set the viewable frame of the scroll view---
    //scrolv.frame = CGRectMake(0, 0, 320, 400);
    
    //---set the content size of the scroll view---
   
    [super viewDidLoad];
    NSLog(@"id === %@",current.itemid);
    fontsize=10;

    
    
    
    
    
    details.text=current.description;
    dateLabel.text=[current.pubDate substringToIndex:22];

    
   // if( [current.title length]>45){
   //     NSString* last =[current.title substringToIndex:45];
   //     titleLabel.text=[last substringToIndex:[last rangeOfString:@" " //options:NSBackwardsSearch].location];
  //  }
    //else{
       titleLabel.text=current.title;
    //}
    NSURL* imageUrl=[NSURL URLWithString:current.imagesrc];
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    picture.image=[UIImage imageWithData:imageDate];
	// Do any additional setup after loading the view.
    av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.frame=CGRectMake(145, 160, 25, 25);
    av.tag  = 100;
    
    [self.view addSubview:av];
    [av startAnimating];
    
    NSURL *kjsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&item=%@&source=iphone",NSLocalizedString(@"rssurl", nil),catagory, current.itemid]] ;
    NSLog(@"path==%@ and%@!!!",kjsonURL, current.itemid);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kjsonURL];
    [request setHTTPMethod:@"GET"];
    //[request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     
     {
         if(!error){
             NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:data];
             
             // create and init our delegate
             XMLParser *parser = [[XMLParser alloc] initXMLParser];
             
             // set delegate
             [nsXmlParser setDelegate:parser];
             
             // parsing...
             BOOL success = [nsXmlParser parse];
             // test the result
             if (success) {
                 // get array of users here
                 allArticles = [parser articles];
                 
                 
             } else {
                 UIAlertView* someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"בעיה בשרת", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [someError show];
                 
             }
             
             parser=nil;
             nsXmlParser=nil;
             
         }
         else{
             UIAlertView* someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)  message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [someError show];
         }
         [self performSelectorOnMainThread:@selector(stopC:) withObject:nil waitUntilDone:YES];
         
         
     }];
    //[scrolv setContentSize:CGSizeMake(320, 2000)];
    //[scrolv setContentOffset:CGPointZero animated:NO];

    
}
- (void)stopC:(NSData *)responseData{
    
    [av stopAnimating];
    //[scrolv setContentOffset:CGPointZero animated:NO];

    //NSLog(@"full === %@");
    details.text=((Article*)[allArticles objectAtIndex:0]).fullitem;
    [scrolv setContentSize:CGSizeMake(320, 2000)];



}


- (void)viewDidUnload
{
    [self setPicture:nil];
    [self setDetails:nil];
    [self setTitleLabel:nil];
    [self setDateLabel:nil];
    [self setScrolv:nil];
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
    [scrolv setContentOffset:CGPointZero animated:NO];
    
}

- (IBAction)decrease:(UIBarButtonItem *)sender {
    fontsize--;
    NSLog(@"%d",fontsize);
    [dateLabel setFont:[UIFont systemFontOfSize:fontsize]];
    [titleLabel setFont:[UIFont systemFontOfSize:fontsize+10]];
   
    [details setFont:[UIFont systemFontOfSize:fontsize+4]];
    [scrolv setContentOffset:CGPointZero animated:NO];

}

- (IBAction)share:(id)sender {

    NSURL *url=[NSURL URLWithString:current.link];
    SHKItem *item = [SHKItem URL:url title:current.title contentType:SHKURLContentTypeWebpage];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
	[actionSheet showFromToolbar:self.navigationController.toolbar];

   
    
}

- (IBAction)response:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"toTheResponses"]) {
        ResponsesViewController* vc= (ResponsesViewController*)[segue destinationViewController];
        vc.item=[[[current.link componentsSeparatedByString:@"/"] lastObject] integerValue];
        
    }
}
- (IBAction)saveJob:(UIBarButtonItem *)sender {
    NSLog(@"hiii");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myDecodedObject = [prefs objectForKey:@"saved"];
//    NSMutableArray *saved =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    NSLog(@"hiii");

    NSMutableArray* saved = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject]];
    NSLog(@"hiii");

    if(!saved) {
        
    saved= [[NSMutableArray alloc] initWithObjects:current, nil];
    }
    else {
        
    if(![saved containsObject:current] && current!=nil)[saved insertObject:current atIndex:0];
    }

    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:saved];
    [prefs setObject:myEncodedObject forKey:@"saved"];
    NSLog(@"hiii");

    [prefs synchronize];
  
    UIAlertView* al= [[UIAlertView alloc] initWithTitle:@"נשמר בהצלחה" message:@"תודה" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
    [al show];
    
    
    
}
@end
