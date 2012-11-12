//
//  ResponsesViewController.m
//  arutz7
//
//  Created by Admin on 10/27/12.
//
//

#import "ResponsesViewController.h"

@interface ResponsesViewController ()

@end

@implementation ResponsesViewController{
    UIActivityIndicatorView *av;
}
@synthesize mail=_mail;
@synthesize phone=_phone;
@synthesize name=_name;
@synthesize content=_content;
@synthesize item;

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
    [self setMail:nil];
    [self setPhone:nil];
    [self setName:nil];
    [self setContent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(void)sendok:(NSData *)responseData{
    UIAlertView* someError;
    if(!responseData){
         someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"Can't connect. Please check your internet Connection", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [someError show];
    }
    else{
         someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"תגובתך נשלחה",nil) message:NSLocalizedString(@"התגובה תפורסם לאחר אישור המערכת", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [someError show];
    }
}

- (IBAction)send:(UIButton *)sender {
    NSString* content=[_content.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if([content length]>1) {
        NSString* path= @"http://www.inn.co.il/wap/wap_PostReply.aspx";
        NSString *post = [NSString stringWithFormat:@"type=0&item=%d&topic=0&Message=%@&Name=%@&mail=%@&phone=%@",item,content,_name.text,_mail.text,_phone.text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSLog(@"%@",path);
        NSURL *kjsonURL = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kjsonURL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        av.frame=CGRectMake(145, 160, 25, 25);
        av.tag  = 100;
        
        [self.view addSubview:av];
        [av startAnimating];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
                        NSLog(@"res=  %d err= %@",((NSHTTPURLResponse*)response).statusCode,error);
             if(error) [self performSelectorOnMainThread:@selector(errorHandling:) withObject:error waitUntilDone:YES];
             else if(((NSHTTPURLResponse*)response).statusCode!=200) [self performSelectorOnMainThread:@selector(errorHTTPHandling:) withObject:response waitUntilDone:YES];
             else [self performSelectorOnMainThread:@selector(sendok:) withObject:data waitUntilDone:YES];
             
             [self performSelectorOnMainThread:@selector(stopC:) withObject:nil waitUntilDone:YES];
             
             
         }];
    }
        
    }
    - (void)stopC:(NSData *)responseData{
        
        [av stopAnimating];

    }
-(void)errorHTTPHandling:(NSURLResponse*)response{
    NSString* msg;
    UIAlertView* someError;
    if(((NSHTTPURLResponse*)response).statusCode==403) msg=NSLocalizedString(@"שם או סיסמא שגויים",nil);
    else if(((NSHTTPURLResponse*)response).statusCode==500) msg=NSLocalizedString(@"בעיה בשרת",nil);
    someError= [[UIAlertView alloc] initWithTitle:@"שלח תגובה" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [someError show];
}

-(void)errorHandling:(NSError*)error{
    NSString* msg;
    UIAlertView* someError;
    
    NSLog(@"%d",error.code);
    if(error.code==-1009) msg=NSLocalizedString(@"אין רשת. בדוק את הרשת האלחוטית",nil);
    else msg=error.localizedDescription;
    someError= [[UIAlertView alloc] initWithTitle:@"שלח תגובה" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [someError show];
    
}
- (IBAction)finishEdit:(UITextField *)sender {
    
    [sender resignFirstResponder];}
@end

