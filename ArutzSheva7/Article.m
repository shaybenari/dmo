//
//  Article.m
//  arutz7
//
//  Created by Admin on 10/7/12.
//
//

#import "Article.h"
#define titleKey @"titleKey"
#define pubDateKey @"pubDateKey"
#define descriptionKey @"descriptionKey"
#define imageKey @"imageKey"
#define linkKey @"linkKey"
#define itemKey @"itemKey"
#define fullitemKey @"fullitemKey"


@implementation Article
@synthesize title,pubDate,description,imagesrc,link,itemid,fullitem;
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.title = [decoder decodeObjectForKey:titleKey];
        self.pubDate = [decoder decodeObjectForKey:pubDateKey];
        self.description = [decoder decodeObjectForKey:descriptionKey];
        self.imagesrc = [decoder decodeObjectForKey:imageKey];
        self.link = [decoder decodeObjectForKey:linkKey];
        self.link = [decoder decodeObjectForKey:itemKey];
        self.link = [decoder decodeObjectForKey:fullitemKey];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:titleKey];
    [encoder encodeObject:self.pubDate forKey:pubDateKey];
    [encoder encodeObject:self.description forKey:descriptionKey];
    [encoder encodeObject:self.imagesrc forKey:imageKey];
    [encoder encodeObject:self.link forKey:linkKey];
    [encoder encodeObject:self.link forKey:itemKey];
    [encoder encodeObject:self.link forKey:fullitemKey];

}



@end
