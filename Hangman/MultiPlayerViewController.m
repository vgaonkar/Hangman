//
//  MultiPlayerViewController.m
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import "MultiPlayerViewController.h"
#import "Words.h"
#import "HangmanViewController.h"

@interface MultiPlayerViewController ()

@property (strong, nonatomic) NSString *receivedData;
@property (strong, nonatomic) Words    *hangman;
@property (strong, nonatomic) GKPeerPickerController *myPicker;
@property (strong, nonatomic) GKSession *mySession;
@property (strong, nonatomic) NSString *playerName;


@end


@implementation MultiPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"defaultBackground.png"]];
}

- (NSString *)receivedData
{
    if (!_receivedData)
        _receivedData = [[NSString alloc] init];
    
    return _receivedData;
}

- (Words *)hangman
{
    if (!_hangman)
        _hangman = [[Words alloc]init];
    
    return _hangman;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.playerName = textField.text;
    [textField resignFirstResponder];

    return NO;
}

- (IBAction)startTapped:(id)sender
{
    [self showPeerPicker];
}

- (void)sendChatText:(NSString *)newText
{
    NSData *sendData = [newText dataUsingEncoding:NSUTF8StringEncoding];
    [self.mySession sendDataToAllPeers:sendData withDataMode:GKSendDataReliable error:nil];
}

- (void) showPeerPicker
{
    self.myPicker                     = [[GKPeerPickerController alloc] init];
    self.myPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    self.myPicker.delegate            = self;
    
    [self.myPicker show];
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    self.mySession = [[GKSession alloc] initWithSessionID:@"MultiplayerHangman" displayName:nil sessionMode:GKSessionModePeer];
    self.mySession.delegate = self;
    
    return self.mySession;
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateConnected:
        {
            [self.mySession setDataReceiveHandler:self withContext:nil];
            [self.myPicker dismiss];
            NSString *randomCategory = [self.hangman randomCategory];
            [self sendChatText:randomCategory];
            break;
        }
        case GKPeerStateDisconnected:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SORRY"
                                                                message:@"You lost!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Back", nil];
            [alertView show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *   )ctx
{
    self.receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString *peerName = [[NSString alloc] initWithString:[session displayNameForPeer:peer]];
    
}

- (GKSession *)getGameSession
{
    return self.mySession;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([segue.identifier isEqualToString:@"Play Hangman"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setCategory:)]) {
                HangmanViewController *hangman = segue.destinationViewController;
                
                hangman.category = self.receivedData;
                //hangman.session  = self.mySession;
                hangman.peerPicker = self.myPicker;
                hangman.title     = self.playerName;
                //[segue.destinationViewController setTitle:self.playername];
            }
        }
    }
    
}

@end
