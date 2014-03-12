//
//  HangmanViewController.m
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import "HangmanViewController.h"
#import "Words.h"
#import "MultiPlayerViewController.h"


#define MAX_WRONG_GUESSES 7

@interface HangmanViewController () <UIAlertViewDelegate, GKPeerPickerControllerDelegate ,GKSessionDelegate>

@property (weak, nonatomic)   IBOutlet UIImageView                 *hangmanImage;
@property (weak, nonatomic)   IBOutlet UILabel                     *guessWordLabel;
@property (weak, nonatomic)   IBOutlet UILabel                     *chosenCategoryLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keyboard;
@property (strong, nonatomic) NSString                             *correctWord;
@property (strong, nonatomic) NSString                             *guessedLetter;
@property (strong, nonatomic) NSString                             *correctGuesses;
@property (strong, nonatomic) Words                                *hangman;
@property (nonatomic)         BOOL                                  connectionState;
@property (nonatomic)         int                                   numberOfWrongGuesses;


@end

@implementation HangmanViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureHangman];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"defaultBackground.png"]];
    MultiPlayerViewController *multiplayer;
    self.session = [multiplayer getGameSession];
}

- (Words *)hangman
{
    if (!_hangman)
        _hangman = [[Words alloc]init];
    
    return _hangman;
}

- (NSString *)correctWord
{
    if (!_correctWord)
        _correctWord = [[NSString alloc] init];
    
    return _correctWord;
}

- (NSString *)guessedLetter
{
    if (!_guessedLetter)
        _guessedLetter = [[NSString alloc] init];
    
    return _guessedLetter;
}

- (NSString *)correctGuesses
{
    if (!_correctGuesses)
        _correctGuesses = [[NSString alloc] init];

    return _correctGuesses;
}

- (void)setCategory:(NSString *)category
{
    if (_category != category) {
        _category  = category;
    }
    //[self configureHangman];
}


- (IBAction)letterTapped:(UIButton *)sender
{
    
    self.guessedLetter = sender.titleLabel.text;
    //NSLog(@"%@", [self.guessedLetter substringToIndex:1]);
    
    NSRange  letterRange;
    NSArray *letterPosition = [self.hangman checkLetter:self.guessedLetter];
    //NSLog(@"Letter Positon: %d", letterPosition.count);
    
    // if the guessed letter is present in the word, update the word to be guessed on screen
    if (letterPosition.count != 0) {
        for (int index = 0; index < self.guessWordLabel.text.length; index++) {
            for (int i = 0; i < letterPosition.count; i++) {
                //NSLog(@"%d", i);
                if (index == [letterPosition[i]integerValue]) {
                    letterRange = NSMakeRange(index, 1);
                    self.guessWordLabel.text = [self.guessWordLabel.text stringByReplacingCharactersInRange:letterRange
                                                                                                 withString:self.guessedLetter];
                    self.correctGuesses = self.guessWordLabel.text;
                    
                    if ([self.hangman didPlayerWin:self.correctGuesses]) {
                        [self sendData:@"WON"];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"CONGRATS!"
                                                                            message:@"You saved the stick man!"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Play Again"
                                                                  otherButtonTitles:@"Back", nil];
                        [alertView show];
                    }
                    NSLog(@"correct guesses: %@", self.correctGuesses);
                    //  NSLog(@"%@",self.guessWordLabel.text);
                }
            }
        }
    }
    
    //else display the next image
    else
    {
        self.numberOfWrongGuesses = [self.hangman numberOfWrongGuesses];
        switch (self.numberOfWrongGuesses) {
            case 1:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman1.png"];
                break;
            }
                
            case 2:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman2.png"];
                break;
            }

                
            case 3:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman3.png"];
                break;
            }
            
            case 4:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman4.png"];
                break;
            }
                
            case 5:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman5.png"];
                break;
            }

            case 6:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman6.png"];
                break;
            }

            case 7:
            {
                self.hangmanImage.image = [UIImage imageNamed:@"hangman7.png"];
                
                NSString *message = @"You couldn't save the stick man! The word was ";
                message           = [message stringByAppendingString:self.correctWord];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SORRY"
                                                                    message:message
                                                                   delegate:self  
                                                          cancelButtonTitle:@"Try Again"
                                                          otherButtonTitles:@"Back", nil];
                [alertView show];
                break;
            }

            default:
                break;
        }
    }
     
    sender.enabled = [self.hangman enableButton:self.guessedLetter];
    if (sender.enabled == NO) {
        sender.alpha = 0.3;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self configureHangman];
            break;
        }
            
        case 1:
        {
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController popViewControllerAnimated:NO];
            break;
        }
    }
}

- (void)configureHangman
{
    NSLog(@"Chosen Category: %@", self.category);
    self.hangmanImage.image       = nil;
    for (UIButton *button in self.keyboard) {
        button.enabled = YES;
        button.alpha   = 1.0;
    }
    self.numberOfWrongGuesses     = 0;
    self.correctWord              = [self.hangman randomWordFromCategory:self.category];
    self.chosenCategoryLabel.text = self.category;
    self.guessWordLabel.text      = @"";
    for (int i = 0; i < self.correctWord.length; i++) {
        self.guessWordLabel.text  = [self.guessWordLabel.text stringByAppendingString:@"_"];
    }
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateConnected:
        {
            [self.session setDataReceiveHandler:self withContext:nil];
            [self.peerPicker dismiss];
            NSString *randomCategory = [self.hangman randomCategory];
            [self sendData:randomCategory];
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
            break;
    }
}

- (void)sendData:(NSString *)newData
{
    NSData *data = [newData dataUsingEncoding:NSUTF8StringEncoding];
    [self.session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}


- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *   )ctx
{
    self.receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([self.receivedData isEqualToString:@"WON"]) {
        [self.session disconnectFromAllPeers];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
