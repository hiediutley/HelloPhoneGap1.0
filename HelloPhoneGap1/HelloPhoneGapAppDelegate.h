//
//  HelloPhoneGapAppDelegate.h
//  HelloPhoneGap
//
//  Created by Hiedi Utley on 3/14/11.
//  Copyright Chariot Solutions, LLC 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PhoneGapDelegate.h>
#else
#import "PhoneGapDelegate.h"

#endif
#import <MediaPlayer/MediaPlayer.h>

@interface HelloPhoneGapAppDelegate : PhoneGapDelegate {

    MPMediaItemCollection * selectedSong;

}
@property (nonatomic, retain) MPMediaItemCollection * selectedSong;
+ (NSString*) pathForResource:(NSString*)resourcepath;

@end

