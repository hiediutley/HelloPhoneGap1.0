//
//  ActivityIndicatorCommand.h
//  HelloPhoneGap
//
//  Created by Hiedi Utley on 4/8/11.
//  Copyright 2011 Chariot Solutions, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif
@interface ActivityIndicatorCommand : PGPlugin {
    
}

- (void) show:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) hide:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) updateMessage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
@end
