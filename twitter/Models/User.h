//
//  User.h
//  twitter
//
//  Created by Zavien Sibilia on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

//Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *profileBanner;
@property (nonatomic, strong) NSString *profileBio;
@property (nonatomic) int *followerCount;
@property (nonatomic) int *followingCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;



@end

NS_ASSUME_NONNULL_END
