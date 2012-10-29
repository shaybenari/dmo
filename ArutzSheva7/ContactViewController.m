//
//  ContactViewController.m
//  arutz7
//
//  Created by Admin on 10/25/12.
//
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize mail=_mail;
@synthesize phone=_phone;
@synthesize name=_name;
@synthesize content=_content;
@synthesize type=_type;

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
    [self setType:nil];
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
        someError= [[UIAlertView alloc] initWithTitle:@"בעית רשת" message:@"בדוק את הרשת שלך" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [someError show];
    }
    else{
        
            someError= [[UIAlertView alloc] initWithTitle:@"צור קשר" message:@"נשלח בהצלחה" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [someError show];
    }
}

- (IBAction)send:(UIButton *)sender {
    NSString* content=[_content.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if([content length]>1) {
        NSString* path= @"http://www.inn.co.il/More/FormCollector.aspx";
        NSString *post = [NSString stringWithFormat:@"FormName='טופס_צור_קשר'&title=cellular&FormTo=%d&content=%@&name=%@&email=%@&phone=%@",_type.selectedSegmentIndex,content,_name.text,_mail.text,_phone.text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        NSLog(@"%@",path);
        NSURL *kjsonURL = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kjsonURL];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             //             NSLog(@"res=  %d err= %@",((NSHTTPURLResponse*)response).statusCode,error);
             if(error) [self performSelectorOnMainThread:@selector(errorHandling:) withObject:error waitUntilDone:YES];
             else if(((NSHTTPURLResponse*)response).statusCode!=200) [self performSelectorOnMainThread:@selector(errorHTTPHandling:) withObject:response waitUntilDone:YES];
             else [self performSelectorOnMainThread:@selector(sendok:) withObject:data waitUntilDone:YES];
         }];
        //[NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
       //  {
       //      [self performSelectorOnMainThread:@selector(sendok:) withObject:data waitUntilDone:YES];
       //  }];
    }
}
-(void)errorHTTPHandling:(NSURLResponse*)response{
    NSString* msg;
    UIAlertView* someError;
    if(((NSHTTPURLResponse*)response).statusCode==403) msg=NSLocalizedString(@"שם או סיסמא שגויים",nil);
    else if(((NSHTTPURLResponse*)response).statusCode==500) msg=NSLocalizedString(@"בעיה בשרת",nil);
    someError= [[UIAlertView alloc] initWithTitle:@"צור קשר" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [someError show];
}

-(void)errorHandling:(NSError*)error{
    NSString* msg;
    UIAlertView* someError;

    NSLog(@"%d",error.code);
    if(error.code==-1009) msg=NSLocalizedString(@"אין רשת. בדוק את הרשת האלחוטית",nil);
    else msg=error.localizedDescription;
    someError= [[UIAlertView alloc] initWithTitle:@"צור קשר" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [someError show];

}

- (IBAction)finishEdit:(UITextField *)sender {
    
    [sender resignFirstResponder];}
@end
