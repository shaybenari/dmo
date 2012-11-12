//
//  ListViewController.m
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import "ListViewController.h"
#import "XMLParser.h"
#import "Article.h"
#import "detailsViewController.h"
@implementation ListViewController{
    UIActivityIndicatorView *av;
     NSString* category;
}
@synthesize allArticles;
@synthesize mainPic;
- (id)initWithStyle:(UITableViewStyle)style
{

    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    //NSLog(@"hi");
    //UIImage *image = [UIImage imageNamed: @"mainlogo.png"];
    //UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    //self.navigationItem.titleView = imageView;
    //[self.tableView setRowHeight:70];

    av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.frame=CGRectMake(145, 160, 25, 25);
    av.tag  = 100;
    
    [self.view addSubview:av];
    [av startAnimating];
   
    if ([self.title isEqualToString:@"1"]) {
        category=@".1";//&full=1";
    } else if ([self.title isEqualToString:@"0"]){
        category=@"1";
    }
    else if ([self.title isEqualToString:@"99"]){
        category=@"";
    }
    else{
        category=[NSString stringWithFormat:@".1&cat=%@",self.title];
    }
    NSURL *kjsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&source=iphone",NSLocalizedString(@"rssurl", nil),category]] ;
    NSLog(@"%@",kjsonURL);
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
    
   
}
- (void)stopC:(NSData *)responseData{

    [av stopAnimating];
    [self.tableView reloadData];
}
- (void)viewDidUnload
{
    [self setMainPic:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   
    return [allArticles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Article* line =[allArticles objectAtIndex:indexPath.row] ;
    if(![self.title isEqualToString:@"99"] && [line.title length]>30 && !([self.title isEqualToString:@"1"] && indexPath.row==0)){
        NSString* last =[line.title substringToIndex:30];
        cell.textLabel.text=[last substringToIndex:[last rangeOfString:@" " options:NSBackwardsSearch].location];
    }
    else{
        cell.textLabel.text=line.title;
        
    }
    cell.detailTextLabel.text=[line.pubDate substringToIndex:22];
    NSString* imageUrlString=line.imagesrc;
//    AsynchronousImageView *asyncImage=[[AsynchronousImageView alloc] init];
  //  [asyncImage loadImageFromURLString:imageUrlString];
        
    NSURL* imageUrl=[NSURL URLWithString:imageUrlString];
    if ([self.title isEqualToString:@"1"] && indexPath.row==0) {
        
        NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
        mainPic.image=[UIImage imageWithData:imageDate];
        cell.imageView.image=nil;
    } else {
      
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    cell.imageView.image=[UIImage imageWithData:imageDate];
    }
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"details"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailsViewController* vc= (detailsViewController*)[segue destinationViewController];
        Article* line =[allArticles objectAtIndex:indexPath.row] ;
        vc.current=line;
        vc.catagory=category;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // if ([self.title isEqualToString:@"1"] && indexPath.row==0) {
     //   return 200;
    //} else {
        return 70;
    //}
}


@end
