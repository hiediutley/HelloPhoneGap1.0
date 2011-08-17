//
//  iPodCommand.h
//  HelloPhoneGap
//
//  Created by Hiedi Utley on 4/1/11.
//  Copyright 2011 Chariot Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapDelegate.h>
#else
#import "PhoneGapDelegate.h"
#endif

@interface iPodCommand : PGPlugin <MPMediaPickerControllerDelegate, UITableViewDelegate> {
    
    
    NSString * successCallback;
    NSString * failureCallback;
    
}

@property (nonatomic, retain) NSString * successCallback;
@property (nonatomic, retain) NSString * failureCallback;

- (void) selectSong:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) playSong:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) showMediaPicker;


@end
