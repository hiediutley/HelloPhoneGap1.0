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

#import "NativeControls.h"
#import "HelloPhoneGapAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <PhoneGap/PhoneGapDelegate.h>

@implementation NativeControls
#ifndef __IPHONE_3_0
@synthesize webView;
#endif
@synthesize navBarController;
@synthesize leftNavBarCallbackId;
@synthesize rightNavBarCallbackId;


-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (NativeControls*)[super initWithWebView:theWebView];
    if (self) 
	{
        tabBarItems = [[NSMutableDictionary alloc] initWithCapacity:5];
		originalWebViewBounds = theWebView.bounds;
        tabBarHeight = 45.0f;
        navBarHeight = 44.0f;
        
    }
    return self;
}

- (void)dealloc
{	
    [tabBar release];
    [navBar release];
    [navBarController release];
    [leftNavBarCallbackId release];
    [rightNavBarCallbackId release];
    [super dealloc];
}

-(void)correctWebViewBounds
{
    
    //always the same...
    CGFloat originX = originalWebViewBounds.origin.x;
    CGFloat width = originalWebViewBounds.size.width;
    
    //changes based on controls visible
    CGFloat originY = originalWebViewBounds.origin.y;
    CGFloat height = originalWebViewBounds.size.height;
    
    
    if ( tabBar != nil && !tabBar.hidden && navBar != nil && !navBar.hidden)
    {
        originY = navBarHeight;
        height = height - navBarHeight - tabBarHeight;
        
    }
    else if ( (tabBar == nil || tabBar.hidden) && navBar != nil && !navBar.hidden)
    {
        originY = navBarHeight;
        height = height - navBarHeight;
        
    }
    else if ( !tabBar.hidden && (navBar == nil || navBar.hidden))
    {
        height = height - tabBarHeight;
        
    }
    
    CGRect webViewBounds = CGRectMake(
                                      originX,
                                      originY,
                                      width,
                                      height
                                      );
    
    [self.webView setFrame:webViewBounds];
    
    
}

#pragma mark -
#pragma mark TabBar

/**
 * Create a native tab bar at either the top or the bottom of the display.
 * @brief creates a tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)createTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
    {
        tabBar = [[UITabBar alloc ]init];
        [tabBar sizeToFit];
        [tabBar setDelegate:self];
        [tabBar setMultipleTouchEnabled:NO];
        [tabBar setAutoresizesSubviews:YES];
        [tabBar setHidden:YES];
        [tabBar setUserInteractionEnabled:YES];
        [tabBar setOpaque:YES];
        
        
        CGRect tabBounds = CGRectMake(
                                      originalWebViewBounds.origin.x,
                                      originalWebViewBounds.size.height - tabBarHeight,
                                      originalWebViewBounds.size.width,
                                      tabBarHeight
                                      );
        
        [tabBar setFrame:tabBounds];
        
        [[[self webView] superview] addSubview:tabBar];
    }
    
   	
}

/**
 * Show the tab bar after its been created.
 * @brief show the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)showTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
	
	// if we are calling this again when its shown, reset
	if (![tabBar isHidden]) {
		return;
	}
    
    
   	NSNotification* notif = [NSNotification notificationWithName:@"PGLayoutSubviewAdded" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
	[tabBar setHidden:NO];
	[self correctWebViewBounds];
	
}

/**
 * Hide the tab bar
 * @brief hide the tab bar
 * @param arguments unused
 * @param options unused
 */
- (void)hideTabBar:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    if([tabBar isHidden])
        return;
	
	NSNotification* notif = [NSNotification notificationWithName:@"PGLayoutSubviewRemoved" object:tabBar];
	[[NSNotificationQueue defaultQueue] enqueueNotification:notif postingStyle: NSPostASAP];
	
    [tabBar setHidden:YES];
	[self correctWebViewBounds];
}

/**
 * Create a new tab bar item for use on a previously created tab bar.  Use ::showTabBarItems to show the new item on the tab bar.
 *
 * If the supplied image name is one of the labels listed below, then this method will construct a tab button
 * using the standard system buttons.  Note that if you use one of the system images, that the \c title you supply will be ignored.
 * - <b>Tab Buttons</b>
 *   - tabButton:More
 *   - tabButton:Favorites
 *   - tabButton:Featured
 *   - tabButton:TopRated
 *   - tabButton:Recents
 *   - tabButton:Contacts
 *   - tabButton:History
 *   - tabButton:Bookmarks
 *   - tabButton:Search
 *   - tabButton:Downloads
 *   - tabButton:MostRecent
 *   - tabButton:MostViewed
 * @brief create a tab bar item
 * @param arguments Parameters used to create the tab bar
 *  -# \c name internal name to refer to this tab by
 *  -# \c title title text to show on the tab, or null if no text should be shown
 *  -# \c image image filename or internal identifier to show, or null if now image should be shown
 *  -# \c tag unique number to be used as an internal reference to this button
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)createTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    NSString  *name      = [arguments objectAtIndex:0];
    NSString  *title     = [arguments objectAtIndex:1];
    NSString  *imageName = [arguments objectAtIndex:2];
    int tag              = [[arguments objectAtIndex:3] intValue];
    
    UITabBarItem *item = nil;    
    if ([imageName length] > 0) {
        UIBarButtonSystemItem systemItem = -1;
        if ([imageName isEqualToString:@"tabButton:More"])       
            systemItem = UITabBarSystemItemMore;
        if ([imageName isEqualToString:@"tabButton:Favorites"]) 
            systemItem = UITabBarSystemItemFavorites;
        if ([imageName isEqualToString:@"tabButton:Featured"])   
            systemItem = UITabBarSystemItemFeatured;
        if ([imageName isEqualToString:@"tabButton:TopRated"])   
            systemItem = UITabBarSystemItemTopRated;
        if ([imageName isEqualToString:@"tabButton:Recents"])    
            systemItem = UITabBarSystemItemRecents;
        if ([imageName isEqualToString:@"tabButton:Contacts"])   
            systemItem = UITabBarSystemItemContacts;
        if ([imageName isEqualToString:@"tabButton:History"])    
            systemItem = UITabBarSystemItemHistory;
        if ([imageName isEqualToString:@"tabButton:Bookmarks"])  
            systemItem = UITabBarSystemItemBookmarks;
        if ([imageName isEqualToString:@"tabButton:Search"])     
            systemItem = UITabBarSystemItemSearch;
        if ([imageName isEqualToString:@"tabButton:Downloads"])  
            systemItem = UITabBarSystemItemDownloads;
        if ([imageName isEqualToString:@"tabButton:MostRecent"]) 
            systemItem = UITabBarSystemItemMostRecent;
        if ([imageName isEqualToString:@"tabButton:MostViewed"]) 
            systemItem = UITabBarSystemItemMostViewed;
        if (systemItem != -1)
            item = [[UITabBarItem alloc] initWithTabBarSystemItem:systemItem tag:tag];
    }
    
    if (item == nil) {
        item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] tag:tag];
    }
    
    if ([options objectForKey:@"badge"])
        item.badgeValue = [options objectForKey:@"badge"];
    
    [tabBarItems setObject:item forKey:name];
	[item release];
}


/**
 * Update an existing tab bar item to change its badge value.
 * @brief update the badge value on an existing tab bar item
 * @param arguments Parameters used to identify the tab bar item to update
 *  -# \c name internal name used to represent this item when it was created
 * @param options Options for customizing the individual tab item
 *  - \c badge value to display in the optional circular badge on the item; if nil or unspecified, the badge will be hidden
 */
- (void)updateTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    NSString  *name = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:name];
    if (item)
        [item setBadgeValue:[options objectForKey:@"badge"]];
}


/**
 * Show previously created items on the tab bar
 * @brief show a list of tab bar items
 * @param arguments the item names to be shown
 * @param options dictionary of options, notable options including:
 *  - \c animate indicates that the items should animate onto the tab bar
 * @see createTabBarItem
 * @see createTabBar
 */
- (void)showTabBarItems:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    int i, count = [arguments count];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (i = 0; i < count; i++) {
        NSString *itemName = [arguments objectAtIndex:i];
        UITabBarItem *item = [tabBarItems objectForKey:itemName];
        if (item)
            [items addObject:item];
    }
    
    BOOL animateItems = NO;
    if ([options objectForKey:@"animate"])
        animateItems = [(NSString*)[options objectForKey:@"animate"] boolValue];
    [tabBar setItems:items animated:animateItems];
	[items release];
}

/**
 * Manually select an individual tab bar item, or nil for deselecting a currently selected tab bar item.
 * @brief manually select a tab bar item
 * @param arguments the name of the tab bar item to select
 * @see createTabBarItem
 * @see showTabBarItems
 */
- (void)selectTabBarItem:(NSArray*)arguments withDict:(NSDictionary*)options
{
    if (!tabBar)
        [self createTabBar:nil withDict:nil];
    
    NSString *itemName = [arguments objectAtIndex:0];
    UITabBarItem *item = [tabBarItems objectForKey:itemName];
    if (item)
    {
        [tabBar setSelectedItem:item];
        
    }else
    {
        [tabBar setSelectedItem:nil];
    }
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls.tabBarItemSelected(%d);", item.tag];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}

#pragma mark -
#pragma mark navBar




/*********************************************************************************/

-(void) createNavBar:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (!navBar)
    {
        navBarController = [[PGNavigationBarController alloc] init];
        navBar = [navBarController view];
        [navBarController setDelegate:self];
        
        NSLog(@"navBar width: %f",[navBar frame].size.width);
        [[navBarController view] setFrame:CGRectMake(0, 0, originalWebViewBounds.size.width , navBarHeight)];
        [[[self webView] superview] addSubview:[navBarController view]];
        [navBar setHidden:YES];
        
    }
    
}

- (void)setupLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * logoURL = [arguments objectAtIndex:1];
    [self setLeftNavBarCallbackId:[arguments objectAtIndex:2]];
    
    if (title && title != @"")
    {
        [[navBarController leftButton] setTitle:title];
        [[navBarController leftButton] setImage:nil];
    }
    else if (logoURL && logoURL != @"")
    {
        NSData * image = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
        if (image)
        {
            [[navBarController leftButton] setImage:[UIImage imageWithData:image]];
            [[navBarController leftButton] setTitle:nil];
            
        }
    }
    
}
- (void)setupRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString * title = [arguments objectAtIndex:0];
    NSString * logoURL = [arguments objectAtIndex:1];
    [self setRightNavBarCallbackId:[arguments objectAtIndex:2]];
    
    if (title && title != @"")
    {
        [[navBarController rightButton] setTitle:title];
        [[navBarController rightButton] setImage:nil];
        
    }
    else if (logoURL && logoURL != @"")
    {
        NSData * image = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
        if (image)
        {
            [[navBarController rightButton] setImage:[UIImage imageWithData:image]];
            [[navBarController rightButton] setTitle:nil];
            
        }
    }
    
}

- (void)hideLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    [[navBarController navItem] setLeftBarButtonItem:nil];
    
}
- (void)showLeftNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    [[navBarController navItem] setLeftBarButtonItem:[navBarController leftButton]];
    
}
- (void)hideRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    [[navBarController navItem] setRightBarButtonItem:nil];
    
}
- (void)showRightNavButton:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
    [[navBarController navItem] setRightBarButtonItem:[navBarController rightButton]];
    
}

-(void) leftNavButtonTapped
{
    NSString * jsCallBack = [NSString stringWithFormat:@"%@();", leftNavBarCallbackId];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
	
}

-(void) rightNavButtonTapped
{
    NSString * jsCallBack = [NSString stringWithFormat:@"%@();", rightNavBarCallbackId];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
    
}

-(void) showNavBar:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (!navBar)
        [self createNavBar:nil withDict:nil];
    
    if ([navBar isHidden])
    {
        [navBar setHidden:NO];
        [self correctWebViewBounds];
        
    }
    
}


-(void) hideNavBar:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (navBar && ![navBar isHidden])
    {
        [navBar setHidden:YES];
        [self correctWebViewBounds];
    }
    
}

-(void) setNavBarTitle:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    if (navBar)
    {
        NSString  *name = [arguments objectAtIndex:0];
        [navBarController navItem].title = name;
        
        // Reset otherwise overriding logo reference
        [navBarController navItem].titleView = NULL;
    }
}

-(void) setNavBarLogo:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options
{
    
    NSString * logoURL = [arguments objectAtIndex:0];
    UIImage * image = nil;
    
    if (logoURL && logoURL != @"")
    {
    
        
        if ([logoURL hasPrefix:@"http://"] || [logoURL hasPrefix:@"https://"])
        {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoURL]];
            image = [UIImage imageWithData:data];
        }
        else
        {
     
            NSString * path = [HelloPhoneGapAppDelegate pathForResource:logoURL];
            if (!path)
            {
                NSMutableArray *dirs = [NSMutableArray arrayWithArray:[logoURL componentsSeparatedByString:@"/"]];
                NSString *filename = [dirs lastObject];
                NSArray *nameParts = [filename componentsSeparatedByString:@"."];
                path = [[NSBundle mainBundle] pathForResource:[nameParts objectAtIndex:0] ofType:[nameParts lastObject]];

            }
            if (path)
            {
                image = [UIImage imageWithContentsOfFile:path];
            }
        }
        
    
        if (image)
        {
            UIImageView * view = [[[UIImageView alloc] initWithImage:image] autorelease];
            [view setContentMode:UIViewContentModeScaleAspectFit];
            [view setBounds: CGRectMake(0, 0, 100, 30)];
            [[navBarController navItem] setTitleView:view];
        }
    }

}


#pragma mark -
#pragma mark ActionSheet

- (void)createActionSheet:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
	NSString* title = [options objectForKey:@"title"];
    
	
	UIActionSheet* actionSheet = [ [UIActionSheet alloc ] 
                                  initWithTitle:title 
                                  delegate:self 
                                  cancelButtonTitle:nil 
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                  ];
	
	int count = [arguments count];
	for(int n = 0; n < count; n++)
	{
		[ actionSheet addButtonWithTitle:[arguments objectAtIndex:n]];
	}
	
	if([options objectForKey:@"cancelButtonIndex"])
	{
		actionSheet.cancelButtonIndex = [[options objectForKey:@"cancelButtonIndex"] intValue];
	}
	if([options objectForKey:@"destructiveButtonIndex"])
	{
		actionSheet.destructiveButtonIndex = [[options objectForKey:@"destructiveButtonIndex"] intValue];
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;//UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.webView.superview];
    [actionSheet release];
	
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSString * jsCallBack = [NSString stringWithFormat:@"window.plugins.nativeControls._onActionSheetDismissed(%d);", buttonIndex];    
    [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
}


@end