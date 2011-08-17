//
//  ActivityIndicatorCommand.m
//  HelloPhoneGap
//
//  Created by Hiedi Utley on 4/8/11.
//  Copyright 2011 Chariot Solutions, LLC. All rights reserved.
//

#import "ActivityIndicatorCommand.h"
#import "DSActivityView.h"

@implementation ActivityIndicatorCommand

- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString * message = [arguments objectAtIndex:0];
    [DSBezelActivityView newActivityViewForView:[[self appViewController] view] withLabel:message];
}
- (void) hide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    [DSBezelActivityView removeViewAnimated:YES];
}
- (void) updateMessage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString * message = [arguments objectAtIndex:0];
    [DSBezelActivityView updateMessage:message];
}

@end
