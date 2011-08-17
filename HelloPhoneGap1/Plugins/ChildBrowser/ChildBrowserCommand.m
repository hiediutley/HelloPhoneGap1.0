//

// 
//
//  Created by Jesse MacFadyen on 10-05-29.
//  Copyright 2010 Nitobi. All rights reserved.
//

#import "ChildBrowserCommand.h"
#import "HelloPhoneGapAppDelegate.h"
#ifdef PHONEGAP_FRAMEWORK
	#import <PhoneGap/PhoneGapViewController.h>
	
#else
	#import "PhoneGapViewController.h"
#endif


//HACK for bug in iOS5 beta
//https://devforums.apple.com/message/507796#507796
@implementation UIImage (initWithCoder)

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

@end

@implementation ChildBrowserCommand

@synthesize childBrowser;

- (void) showWebPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{	
	if(childBrowser == NULL)
	{
		childBrowser = [[ ChildBrowserViewController alloc ] initWithScale:FALSE ];
		childBrowser.delegate = self;
	}

	PhoneGapViewController* cont = (PhoneGapViewController*)[ super appViewController ];
	childBrowser.supportedOrientations = cont.supportedOrientations;
  	
    [cont presentModalViewController:childBrowser animated:YES ];

    NSString *url = (NSString*) [arguments objectAtIndex:0];
    
    if (![url hasPrefix:@"http"])
    {
        
        NSURL *appURL = [NSURL URLWithString:url];
        if(![appURL scheme])
        {
            HelloPhoneGapAppDelegate* delegate = (HelloPhoneGapAppDelegate*)[ self appDelegate ];

            appURL = [NSURL fileURLWithPath:[[delegate class] pathForResource:url]];
            url = [appURL absoluteString];
        }
        
    }

    
	[childBrowser loadURL:url  ];

}



-(void) close:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options // args: url
{
	[ childBrowser closeBrowser];
	
}

-(void) onClose
{
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onClose();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}

-(void) onOpenInSafari
{
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onOpenExternal();",@""];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];
}


-(void) onChildLocationChange:(NSString*)newLoc
{
	
	NSString* tempLoc = [NSString stringWithFormat:@"%@",newLoc];
	NSString* encUrl = [tempLoc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	 
	NSString* jsCallback = [NSString stringWithFormat:@"ChildBrowser._onLocationChange('%@');",encUrl];
	[self.webView stringByEvaluatingJavaScriptFromString:jsCallback];

}




@end
