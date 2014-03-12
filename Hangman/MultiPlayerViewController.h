//
//  MultiPlayerViewController.h
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MultiPlayerViewController : UIViewController <GKPeerPickerControllerDelegate, GKSessionDelegate, UITextFieldDelegate>

- (GKSession *)getGameSession;

@end
