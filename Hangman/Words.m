//
//  Words.m
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import "Words.h"

@interface Words ()

@property (nonatomic, strong) NSString *hangmanWord;
@property (strong, nonatomic) NSString *usedLetters;
@property (nonatomic) int wrongGuesses;

@end


@implementation Words

- (void)startNewGame
{
    self.wrongGuesses = 0;
}

-(NSString *)usedLetters
{
    if(!_usedLetters)
        _usedLetters = [[NSString alloc] init];

    return _usedLetters;
}

- (NSString *)hangmanWord
{
    if (!_hangmanWord)
        _hangmanWord = [[NSString alloc] init];

    return _hangmanWord;
}


- (NSDictionary *) wordList
{
    NSString     *path      = [[NSBundle mainBundle] pathForResource:@"WordList" ofType:@"plist"];
    NSDictionary *wordList  = [NSDictionary dictionaryWithContentsOfFile:path];
    return wordList;
}

- (NSString *) randomWordFromCategory :(NSString *)category
{
    NSDictionary *allWords = [self wordList];
    NSArray *allWordsInCategory = [[allWords objectForKey:category] allKeys];
    if (allWordsInCategory.count != 0) {
    int position = arc4random() % allWordsInCategory.count;
    self.hangmanWord            = [allWordsInCategory objectAtIndex:position];
    }
    NSLog(@"Hangman: %@", self.hangmanWord);
    //reset the number of wrong guesses when getting a new word
    self.wrongGuesses  = 0;
    return self.hangmanWord;
}

- (NSString *) randomCategory
{
    NSArray *allCategories = [self.wordList allKeys];
    int position = arc4random() % allCategories.count;
    return [allCategories objectAtIndex:position];
}

- (NSArray *) checkLetter:(NSString *)letter
{
    //keep track of all used letters
    //self.hangmanWord = @"CHICO";
    self.usedLetters = [self.usedLetters stringByAppendingString:letter];
    NSLog(@"Used Letters: %@", self.usedLetters);
    
    NSMutableArray *position = [[NSMutableArray alloc]init];
    
    NSLog(@"Hangman Word: %@", self.hangmanWord);
    NSLog(@"Letter to Guess: %@", letter);
    
    for (int index = 0; index < self.hangmanWord.length; index++) {
        if ([letter characterAtIndex:0] == [self.hangmanWord characterAtIndex:index]) {
            [position addObject:[NSNumber numberWithInt:index]];
            //NSLog(@"%@", position[i]);
        }
    }
    
    NSLog(@"Model array size: %d", position.count);
    NSArray *indexPosition = [position copy];
    
    if (indexPosition.count == 0) {
        self.wrongGuesses++;
    }
    
    return indexPosition;
}

- (int)numberOfWrongGuesses
{
    return self.wrongGuesses;
}

- (BOOL)didPlayerWin:(NSString *)guessedWord
{
    return [self.hangmanWord isEqualToString:guessedWord];
}

- (BOOL) enableButton:(NSString *)letter
{
    for (int index = 0; index < self.usedLetters.length; index++) {
        if ([letter characterAtIndex:0] == [self.usedLetters characterAtIndex:index]) {
            return NO;
        }
    }
    
    return YES;
}

@end
