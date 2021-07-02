//
//  ProfileViewController.m
//  twitter
//
//  Created by Zavien Sibilia on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "User.h"


@interface ProfileViewController ()



@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.createProfileButton.layer.cornerRadius = 24;
    self.createProfileButton.layer.borderWidth = 1;
    self.createProfileButton.layer.borderColor = [UIColor systemBlueColor].CGColor;
    self.createProfileButton.layer.masksToBounds = YES;

    
    [self loadUserInfo];
}

//API Call
- (void)loadUserInfo {
    [[APIManager shared] getUserInformation:^(NSDictionary *userInfo, NSError *error) {
        if (userInfo) {
            self.arrayOfUserInfo = [[User alloc] initWithDictionary:userInfo];
            [self updateProfileView];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)updateProfileView{
    self.user = self.arrayOfUserInfo;
    self.screenName.text = self.user.screenName;
    self.userName.text = self.user.name;
    self.userBio.text = self.user.profileBio;
    self.userFollowerCount.text = [NSString stringWithFormat:@"%i", self.user.followerCount];
    self.userFollowingCOunt.text = [NSString stringWithFormat:@"%i", self.user.followingCount];
    
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    
    // Profile image styling
    [self.userProfileImage setImageWithURL:url];
    self.userProfileImage.layer.borderWidth = 1;
    self.userProfileImage.layer.masksToBounds = false;
    self.userProfileImage.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]);
    self.userProfileImage.layer.cornerRadius = 24;
    self.userProfileImage.clipsToBounds = true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
