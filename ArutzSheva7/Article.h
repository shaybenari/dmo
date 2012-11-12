//
//  Article.h
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import <Foundation/Foundation.h>

@interface Article : NSObject<NSCoding>{
    NSString *title;
    NSString *link;
    NSString *image;
    NSString *description;
    NSString *pubDate;
    
    
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *imagesrc;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *pubDate;
@property (nonatomic, retain) NSString *itemid;
@property (nonatomic, retain) NSString *fullitem;


@end
