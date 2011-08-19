//
//  PGNavigationBarController.h
//  HelloPhoneGap1
//
//  Created by Hiedi Utley on 8/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGNavigationBarDelegate <NSObject>
-(void)leftNavButtonTapped;
-(void)rightNavButtonTapped;
@end 

@interface PGNavigationBarController : UIViewController{

    IBOutlet UIBarButtonItem * leftButton;
    IBOutlet UIBarButtonItem * rightButton;
    IBOutlet UIImageView * logoImage;
    IBOutlet UILabel * titleLabel;
    id<PGNavigationBarDelegate>  delegate;
    
}

@property (nonatomic, retain) UIImageView * logoImage;
@property (nonatomic, retain) UILabel * titleLabel;
@property (nonatomic, retain) UIBarButtonItem * leftButton;
@property (nonatomic, retain) UIBarButtonItem * rightButton;
@property (nonatomic, retain) id<PGNavigationBarDelegate>  delegate;

-(IBAction)leftNavButtonTapped:(id)sender;
-(IBAction)rightNavButtonTapped:(id)sender;

@end
