//
//  CameraViewController.m
//  ArutzSheva7
//
//  Created by Admin on 10/29/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController{
    BOOL mode;
    UIActivityIndicatorView* av;
}

@synthesize imageView;
@synthesize saveImageBotton;

#pragma mark - Show camera
-(IBAction)showCameraAction:(id)sender
{
    if(!mode){
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    //You can use isSourceTypeAvailable to check
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickController.showsCameraControls=YES;
    }
    else{
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;

    }
    imagePickController.delegate=self;
    imagePickController.allowsEditing=NO;

    //This method inherit from UIView,show imagePicker with animation
    [self presentModalViewController:imagePickController animated:YES];
    
    }
    else{
    UIImage *image=imageView.image;
    //save photo to photoAlbum
    //UIImageWriteToSavedPhotosAlbum(image,self, @selector(CheckedImage:didFinishSavingWithError:contextInfo:), nil);
    //saveImageBotton.enabled=NO;
            NSString* path= @"http://www.inn.co.il/Upload/Contact.ashx";
            //NSString *post = [NSString stringWithFormat:@"FormName='צילום מהשטח'&FormTo=moshel"];
            //NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        //NSData *imagedata = UIImageJPEGRepresentation(image, 90);
      ////
        NSMutableDictionary *_params= [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"צילום מהשטח", @"FormName", @"news", @"FormTo", nil];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        //Add content-type to Header. Need to use a string boundary for data uploading.
        NSString *boundary = @"0xKhTmLbOuNdArY";

        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        //NSString* BoundaryConstant=@"hotemail";
        // add params (all params are strings)
        for (NSString *param in _params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        NSString* FileParamConstant=@"redemail";
        // add image data
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set URL
        [request setURL:[NSURL URLWithString:path]];
        
        
            NSLog(@"%@",path);
//            NSURL *kjsonURL = [NSURL URLWithString:path];
  //          NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:kjsonURL];
    //        [request setHTTPMethod:@"POST"];
     //   [request setHTTPBody:imagedata];// postData];
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
        
        saveImageBotton.title=NSLocalizedString(@"show",nil);
        mode=NO;
      
        
    }
}
- (void)stopC:(NSData *)responseData{
    
    [av stopAnimating];
    
}
#pragma mark - Check Save Image Error
- (void)CheckedImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    UIAlertView *alert;
    
    if (error) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:[error description]
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"saved",nil)
                                           message:nil
                                          delegate:self
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}

#pragma mark - When Finish Shoot

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    //Show OriginalImage size
    //NSLog(@"OriginalImage width:%f height:%f",image.size.width,image.size.height);
    imageView.image=originalImage;
    saveImageBotton.enabled=YES;
    saveImageBotton.title=NSLocalizedString(@"send",nil);
    mode=YES;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - When Tap Cancel

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Release object



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImagePickerController *imagePickController=[[UIImagePickerController alloc]init];
    //You can use isSourceTypeAvailable to check
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickController.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePickController.showsCameraControls=YES;
    }
    else{
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    imagePickController.delegate=self;
    imagePickController.allowsEditing=NO;
    
    //This method inherit from UIView,show imagePicker with animation
    [self presentModalViewController:imagePickController animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)sendok:(NSData *)responseData{
    [av stopAnimating];
    UIAlertView* someError;
    if(!responseData){
        someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil) message:NSLocalizedString(@"Can't connect. Please check your internet Connection", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else{
        someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"תגובתך נשלחה",nil) message:NSLocalizedString(@"התגובה תפורסם לאחר אישור המערכת", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [someError show];

}
-(void)errorHTTPHandling:(NSURLResponse*)response{
    [av stopAnimating];
    NSString* msg;
    UIAlertView* someError;
    if(((NSHTTPURLResponse*)response).statusCode==403) msg=NSLocalizedString(@"שם או סיסמא שגויים",nil);
    else if(((NSHTTPURLResponse*)response).statusCode==500) msg=NSLocalizedString(@"בעיה בשרת",nil);
    someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"contactus",nil) message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [someError show];
}

-(void)errorHandling:(NSError*)error{
    [av stopAnimating];
    NSString* msg;
    UIAlertView* someError;
    
    NSLog(@"%d",error.code);
    if(error.code==-1009) msg=NSLocalizedString(@"אין רשת. בדוק את הרשת האלחוטית",nil);
    else msg=error.localizedDescription;
    someError= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"contactus",nil) message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];    [someError show];
    
}
@end