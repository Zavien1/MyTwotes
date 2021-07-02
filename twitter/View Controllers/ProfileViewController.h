//
//  ProfileViewController.h
//  twitter
//
//  Created by Zavien Sibilia on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *userBackDrop;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userBio;
@property (strong,nonatomic) User *arrayOfUserInfo;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *userFollowerCount;
@property (weak, nonatomic) IBOutlet UILabel *userFollowingCOunt;
@property (weak, nonatomic) IBOutlet UIButton *createProfileButton;


@end

NS_ASSUME_NONNULL_END
