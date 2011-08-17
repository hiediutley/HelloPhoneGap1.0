//
//  iPodCommand.m
//  HelloPhoneGap
//
//  Created by Hiedi Utley on 4/1/11.
//  Copyright 2011 Chariot Solutions, LLC. All rights reserved.
//

#import "iPodCommand.h"
#import <MediaPlayer/MediaPlayer.h>

#import "HelloPhoneGapAppDelegate.h"

@implementation iPodCommand
@synthesize successCallback, failureCallback;

- (void) selectSong:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    NSUInteger argc = [arguments count];
	
	if (argc > 0) 
    {
        [self setSuccessCallback:[arguments objectAtIndex:0]];
    }
    
	if (argc > 1) 
    {
        
        [self setFailureCallback:[arguments objectAtIndex:1]];   
    }
	
	if (argc < 1) {
		NSLog(@"iPodCommand.selectSong: Missing 1st parameter: successCallback");
		return;
	}
    
    
    
    [self showMediaPicker];
    
}
- (void) playSong:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    MPMediaItemCollection * items = [(HelloPhoneGapAppDelegate*)[self appDelegate] selectedSong];
    if (items)
    {
        [musicPlayer setQueueWithItemCollection: items];
        
        MPMusicPlaybackState playbackState = [musicPlayer playbackState];
        
        if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
            [musicPlayer play];
        } else if (playbackState == MPMusicPlaybackStatePlaying) {
            [musicPlayer pause];
        }
    }
    
}


// Configures and displays the media item picker.
- (void) showMediaPicker {
    
	MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
	
    if (picker)
    {
        picker.delegate						= self;
        picker.allowsPickingMultipleItems	= NO;
        picker.prompt						= @"Select a song.";
        
        [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
        
        [[self appViewController] presentModalViewController: picker animated: YES];
        [picker release];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must be running on a device for this to work!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    
	[[self appViewController] dismissModalViewControllerAnimated: YES];
    
    if (mediaItemCollection)
    {
        if ([mediaItemCollection count] == 1)
        {
            MPMediaItem * song = [[mediaItemCollection items] objectAtIndex:0];
            
            [(HelloPhoneGapAppDelegate*)[self appDelegate] setSelectedSong:mediaItemCollection];            
            NSMutableDictionary * songInfo = [NSMutableDictionary dictionary];
            [songInfo setValue:[song valueForProperty:MPMediaItemPropertyTitle] forKey:@"title"];
            [songInfo setValue:[song valueForProperty:MPMediaItemPropertyAlbumTitle] forKey:@"albumTitle"];
            [songInfo setValue:[song valueForProperty:MPMediaItemPropertyArtist] forKey:@"artist"];
            [songInfo setValue:[song valueForProperty:MPMediaItemPropertyGenre] forKey:@"genre"];
            
            NSString * json = [songInfo JSONFragment];
            [[self webView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"songInfo = %@;%@(songInfo);", json, successCallback]];
        }
        
    }
    
    else
    {
        [(HelloPhoneGapAppDelegate*)[self appDelegate] setSelectedSong:nil];
    }
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
	[[self appViewController] dismissModalViewControllerAnimated: YES];
    
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}

-(void) dealloc
{
    [successCallback release];
    [failureCallback release];
    [super dealloc];
}

@end
