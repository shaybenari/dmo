//
//  ViewController.m
//  arutz7
//
//  Created by Admin on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define LOGINURL @"http://www.inn.co.il/wap/JS.ashx?act=loginios"
#define FORUMURL @"http://www.inn.co.il/wap/forumapp.aspx"
#define PRIVATEURL @"http://www.inn.co.il/wap/imapp.aspx"

#import "ViewController.h"
@interface ViewController (){
    int status;
    NSString* name;
    NSString* password;
    NSString* token;
    NSString* privateid;
    NSString* session;
    NSString* randomnumber;
    UIAlertView* al;
}

@end

@implementation ViewController
@synthesize toolBar7;
@synthesize forumButton;
@synthesize webview;
@synthesize mode=_mode;

-(void)loadPage:(NSString*)link withPostData:(NSString*)post{
    NSURL *url =[NSURL URLWithString:link];
    NSMutableURLRequest *requestUrl =[NSMutableURLRequest requestWithURL:url];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [requestUrl setHTTPMethod:@"POST"];
    [requestUrl setHTTPBody:postData];
    [webview loadRequest:requestUrl];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //name=@"";
    if(_mode>1){
        toolBar7.hidden=YES;
        [self toTheForum:nil];
    }
    else{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        name = [prefs stringForKey:@"name"];
        
        if([name length]>1){
            //toolBar7.hidden=YES;
            forumButton.title=NSLocalizedString(@"החלף משתמש",nil);
        }
        
        password=@"";
        //NSString *website =   NSLocalizedString(@"newsurl",nil);
        //[self loadPage:website withPostData:@"userid=81674&usercode=2904647487060967424&session=2505461"];
        [self toTheForum:nil];
        //[self loadPage:website withPostData:@""];
    }
}

- (void)viewDidUnload
{
    [self setWebview:nil];
    [self setToolBar7:nil];
    [self setForumButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == NSURLErrorCancelled){}
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html" inDirectory:@"internal"];
        NSURL *url =[NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webview loadRequest:request];
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                                        message:NSLocalizedString(@"Can't connect. Please check your internet Connection",nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)toTheForum:(UIBarButtonItem *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    name = [prefs stringForKey:@"name"];
    password = [prefs stringForKey:@"password"];
    token = [prefs stringForKey:@"token"];
    if([token length]>30){
        [self askForName:NSLocalizedString(@"התחברות לצאט שיחה אישית  ",nil) withText:NSLocalizedString(@"הזן שם משתמש וסיסמא",nil)];
        
        
        if([name length]>1){
            ([al textFieldAtIndex:0]).text=name;
            ([al textFieldAtIndex:1]).text=password;
            
            
        }
    }
    else{
        NSString *website =  FORUMURL;// NSLocalizedString(@"newsurl",nil);//!!
        //[self loadPage:website withPostData:@"userid=81674&usercode=2904647487060967424&session=2505461"];
        [self loadPage:website withPostData:@""];//!!
        toolBar7.hidden=NO;//!!
        al= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"אין תקשורת מתאימה להתחברות",nil) message:NSLocalizedString(@"נסה מאוחר יותר",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"בטל",nil) otherButtonTitles:nil];
        
        [al show];
        //[self askForName];
    }
    
}
-(void)loadForum{
    NSString *forum = FORUMURL;
    NSString *post = [NSString stringWithFormat:@"userid=%@&usercode=%@&token=%@&session=%@",privateid,randomnumber,token,session];
    [self loadPage:forum   withPostData:post];
    toolBar7.hidden=YES;
    NSLog(@" %@  + %@",forum,post);
    
    
}

-(void)askForName:(NSString*)title withText:(NSString*)msg{
    al= [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"בטל",nil) otherButtonTitles:NSLocalizedString(@"התחבר",nil),nil];
    al.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    [al show];
}
- (IBAction)hideBar:(id)sender {
    toolBar7.hidden=YES;
    //    [toolBar7 removeFromSuperview];
}
- (void)showBar{
    toolBar7.hidden=NO;
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:NSLocalizedString(@"התחבר",nil)])
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        UITextField *passwordview = [alertView textFieldAtIndex:1];
        
        NSLog(@"Username: %@\nPassword: %@", username.text, passwordview.text);
        name=username.text;
        password=passwordview.text;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:name forKey:@"name"];
        [prefs setObject:password forKey:@"password"];
        [prefs synchronize];
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&token=%@",name,password,token];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSURL *kjsonURL = [NSURL URLWithString:LOGINURL];
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
    }
}
-(void)errorHTTPHandling:(NSURLResponse*)response{
    NSString* msg;
    if(((NSHTTPURLResponse*)response).statusCode==403) msg=NSLocalizedString(@"שם או סיסמא שגויים",nil);
    else if(((NSHTTPURLResponse*)response).statusCode==500) msg=NSLocalizedString(@"בעיה בשרת",nil);
    [self askForName:NSLocalizedString(@"תקלת רישום.נסה שוב",nil) withText:msg];
}

-(void)errorHandling:(NSError*)error{
    NSString* msg;
    NSLog(@"%d",error.code);
    if(error.code==-1009) msg=NSLocalizedString(@"אין רשת. בדוק את הרשת האלחוטית",nil);
    else msg=error.localizedDescription;
    [self askForName:NSLocalizedString(@"תקלת רישום.נסה שוב",nil) withText:msg];
}
-(void)sendok:(NSData *)responseData{
    
    NSString *responseString =[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"short response= %@",responseString);
    if(!responseString){
        [self askForName:NSLocalizedString(@"תקלת רישום.נסה שוב",nil) withText:responseString];
    }
    else{
        
        NSArray* returnIds= [responseString componentsSeparatedByString:@"||"];
        privateid=[returnIds objectAtIndex:0];
        randomnumber=[returnIds objectAtIndex:1];
        session=[returnIds objectAtIndex:2];
        NSLog(@"%@, %@, %@",privateid,randomnumber,session);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:privateid forKey:@"id"];
        [prefs setObject:randomnumber forKey:@"random"];
        [prefs setObject:session forKey:@"session"];
        [prefs synchronize];
        [self loadForum];
        
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText0 = [[alertView textFieldAtIndex:0] text];
    NSString *inputText1 = [[alertView textFieldAtIndex:1] text];
    NSLog(@"%@  %@",inputText0,inputText1);
    
    if( [inputText0 length] > 2 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end