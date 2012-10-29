//
//  XMLParser.h
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import <Foundation/Foundation.h>
@class Article;
@interface XMLParser : NSObject<NSXMLParserDelegate>{

NSMutableString *currentElementValue;
// user object
Article *article;
// array of user objects
NSMutableArray *articles;
}

@property (nonatomic, retain) Article *article;
@property (nonatomic, retain) NSMutableArray *articles;

- (XMLParser *) initXMLParser;
@end
