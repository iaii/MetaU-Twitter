//
//  User.m
//  twitter
//
//  Created by Apoorva Chilukuri on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)tweetDictionary {
    self = [super init];

    if (self) {
        self.name = tweetDictionary[@"name"];
        self.screenName = tweetDictionary[@"screen_name"];
        self.profilePicture = tweetDictionary[@"profile_image_url_https"];
    // Initialize any other properties
    }
    return self;
}
@end
