//
//  User.m
//  twitter
//
//  Created by Zavien Sibilia on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSString *profileURL = dictionary[@"profile_image_url_https"];
        
        self.profilePicture = [profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    // Initialize any other properties
    }
    return self;
}

@end
