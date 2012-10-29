//
//  Article.h
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import <Foundation/Foundation.h>

@interface Article : NSObject{
    NSString *title;
    NSString *link;
    NSString *image;
    NSString *description;
    NSString *pubDate;
    
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *pubDate;


@end
