//
//  savedViewController.m
//  ArutzSheva7
//
//  Created by Admin on 11/1/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//
#import "detailsViewController.h"
#import "savedViewController.h"
#import "Article.h"
@interface savedViewController (){
    NSMutableArray *jsonResults;
    NSUserDefaults *prefs;
    UIBarButtonItem *but;
    

}

@end

@implementation savedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    but=        self.tabBarController.navigationItem.rightBarButtonItem;
        self.tabBarController.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewWillAppear:animated];
    prefs = [NSUserDefaults standardUserDefaults];
    
    
    NSData *myDecodedObject = [prefs objectForKey:@"saved"];
    NSMutableArray *lastSeen =[NSKeyedUnarchiver unarchiveObjectWithData: myDecodedObject];
    
    jsonResults=[NSMutableArray arrayWithArray:lastSeen];

    [self.tableView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
                self.tabBarController.navigationItem.rightBarButtonItem = but;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.tableView setRowHeight:70];

    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [jsonResults count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Article* line =[jsonResults objectAtIndex:indexPath.row] ;
    if([line.title length]>22){
        NSString* last =[line.title substringToIndex:22];
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
    NSData* imageDate=[NSData dataWithContentsOfURL:imageUrl];
    cell.imageView.image=[UIImage imageWithData:imageDate];
    
    return cell;
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [jsonResults removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        [prefs setObject:jsonResults forKey:@"saved"];
        
        [prefs synchronize];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] hasPrefix:@"details"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailsViewController* vc= (detailsViewController*)[segue destinationViewController];
        Article* line =[jsonResults objectAtIndex:indexPath.row] ;
        vc.current=line;
    }
}
@end
