//
//  NativeControls.h
//
//
//  Created by Jesse MacFadyen on 10-02-03.
//  MIT Licensed

//  Originally this code was developed my Michael Nachbaur
//  Formerly -> PhoneGap :: UIControls.h
//  Created by Michael Nachbaur on 13/04/09.
//  Copyright 2009 Decaf Ninja Software. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITabBar.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
#import "PGNavigationBarController.h"

@interface NativeControls : PGPlugin <UITabBarDelegate, UIActionSheetDelegate, PGNavigationBarDelegate> {
	UITabBar* tabBar;
    UIView * navBar;
    
	NSMutableDictionary* tabBarItems;
    
	CGRect	originalWebViewBounds;
    CGFloat navBarHeight;
    CGFloat tabBarHeight;
    NSString * rightNavBarCallbackId; 
    NSString * leftNavBarCallbackId; 
    
    PGNavigationBarController * navBarController;
    
}

@property (nonatomic, retain) NSString * rightNavBarCallbackId;
@property (nonatomic, retain) NSString * leftNavBarCallbackId;
@property (nonatomic, retain) PGNavigationBarController * navBarController;

/* Tab Bar methods
 */
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options;

/* Nav Bar methods
 */
- (void)createNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setNavBarTitle:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)setNavBarLogo:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options;
- (void)showNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)hideNavBar:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)setupRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)leftNavButtonTapped;
- (void)rightNavButtonTapped;

/* ActionSheet
 */
- (void)createActionSheet:(NSArray*)arguments withDict:(NSDictionary*)options;


@end