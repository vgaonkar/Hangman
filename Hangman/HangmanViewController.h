//
//  HangmanViewController.h
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface HangmanViewController : UIViewController

@property (strong, nonatomic) NSString                             *category;
@property (strong, nonatomic) GKSession                            *session;
@property (strong, nonatomic) GKPeerPickerController               *peerPicker;
@property (strong, nonatomic) NSString                             *receivedData;

@end
