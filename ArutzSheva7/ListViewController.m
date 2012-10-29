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

@implementation ListViewController
@synthesize allArticles;
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
    UIImage *image = [UIImage imageNamed: @"mainlogo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    
    self.navigationItem.titleView = imageView;
    [self.tableView setRowHeight:70];

    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    av.frame=CGRectMake(145, 160, 25, 25);
    av.tag  = 100;
    
    [self.view addSubview:av];
    [av startAnimating];
    NSString* category;
    if ([self.title isEqualToString:@"1"]) {
        category=@".1&full=1";
    } else if ([self.title isEqualToString:@"0"]){
        category=@"1";
    }
    else if ([self.title isEqualToString:@"2"]){
        category=@"";
    }
    NSURL *kjsonURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"rssurl", nil),category]] ;
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
             [self.tableView reloadData];

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
         [av stopAnimating];
     
     
     }];
    //[av stopAnimating];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
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
    if([line.title length]>22){
        NSString* last =[line.title substringToIndex:22];
        cell.textLabel.text=[last substringToIndex:[last rangeOfString:@" " options:NSBackwardsSearch].location];
    }
    else{
        cell.textLabel.text=line.title;
        
    }
    cell.detailTextLabel.text=[line.pubDate substringToIndex:22];
    NSString* imageUrlString=line.image;
    NSURL* imageUrl=[NSURL URLWithString:imageUrlString];
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    cell.imageView.image=[UIImage imageWithData:imageDate];
   
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"details"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailsViewController* vc= (detailsViewController*)[segue destinationViewController];
        Article* line =[allArticles objectAtIndex:indexPath.row] ;

        vc.picturePath=line.image;
        vc.detailsText=line.description;
        vc.titleString=line.title;
        vc.link=line.link;
        vc.date=[line.pubDate substringToIndex:22];
    }
}


@end
