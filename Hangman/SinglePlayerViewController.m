//
//  SinglePlayerViewController.m
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "HangmanViewController.h"

#define MESSAGE       @"Please choose a category from the Word List"
#define CANCEL_BUTTON @"OK"

@interface SinglePlayerViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSString                             *chosenCategory;
@property (strong, nonatomic) NSString                             *playerName;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categories;
@property (nonatomic) int                                           senderTag;
@end

@implementation SinglePlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"defaultBackground.png"]];

}
//
//- (NSString *)chosenCategory
//{
//    if (!_chosenCategory)
//        _chosenCategory = [[NSString alloc] init];
//    
//    return _chosenCategory;
//   
//}

- (NSString *)playerName
{
    if (!_playerName)
        _playerName = [[NSString alloc] init];
    
    return _playerName;
}

- (IBAction)categorySelected:(UIButton *)sender
{
    self.chosenCategory = sender.titleLabel.text;
    sender.selected = YES;
    self.senderTag      = sender.tag;
    
    for (UIButton *button in self.categories) {
        if (button.tag != self.senderTag) {
            button.selected = NO;
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.playerName = textField.text;
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)startGame:(UIButton *)sender
{
    if (self.chosenCategory == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:MESSAGE
                                                       delegate:self
                                              cancelButtonTitle:CANCEL_BUTTON
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        [self performSegueWithIdentifier:@"Play Hangman" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString:@"Play Hangman"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setCategory:)]) {
                HangmanViewController *hangman = segue.destinationViewController;
                hangman.category = self.chosenCategory;
                [segue.destinationViewController setTitle:self.playerName];
            }
        }

}
@end
