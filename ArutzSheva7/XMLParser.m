//
//  XMLParser.m
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import "XMLParser.h"
#import "Article.h"

@implementation XMLParser
@synthesize article, articles;

- (XMLParser *) initXMLParser {
    self=[super init];
    // init array of user objects
    articles = [[NSMutableArray alloc] init];
    return self;
}
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"item"]) {
        NSLog(@"user element found – create a new instance of User class...");
        article = [[Article alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        // init the ad hoc string with the value
        currentElementValue = [[NSMutableString alloc] initWithString:[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    } else {
        // append value to the ad hoc string
        [currentElementValue appendString:string];
    }
    NSLog(@"Processing value for : %@ and %@", string,currentElementValue);
}
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    NSLog(@"title ===%@",elementName);
    if ([elementName isEqualToString:@"rss"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"item"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        [articles addObject:article];
        // release user object
        article = nil;
    }
   /* else if ([elementName isEqualToString:@"description"] && [currentElementValue length]>1) {
        NSArray* des =[currentElementValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
        //NSArray* des2 =[currentElementValue componentsSeparatedByString:@"left>" ];
       // NSArray* des3 = [currentElementValue componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];

        if ([des count]>1){
            NSLog(@"in %@",currentElementValue);

        NSArray* imagestyle = [[des objectAtIndex:1] componentsSeparatedByString:@" "];
        NSString* imageNoTag= [[imagestyle objectAtIndex:0] stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        [article setValue:imageNoTag forKey:@"image"];
        }
        NSRange r;
            NSString* desc=[currentElementValue copy];
            while ((r= [desc rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location!=NSNotFound){
                desc=[desc stringByReplacingCharactersInRange:r withString:@""] ;
            
            }
            [article setValue:desc forKey:@"description"];
            NSLog(@"%@",desc);
       
       

    }*/
    else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [article setValue:currentElementValue forKey:elementName];
    }
    
    currentElementValue = nil;
}
@end
