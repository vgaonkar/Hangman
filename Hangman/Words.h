//
//  Words.h
//  Hangman
//
//  Created by Vijay R. Gaonkar on 5/8/13.
//  Copyright (c) 2013 Vijay R. Gaonkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Words : NSObject

- (NSDictionary *) wordList;
- (NSString *) randomWordFromCategory:(NSString *)category;
- (NSString *) randomCategory;
- (NSArray *) checkLetter:(NSString *)letter;
- (BOOL) enableButton:(NSString *)letter;
- (int) numberOfWrongGuesses;
- (BOOL)didPlayerWin:(NSString *)guessedWord;

- (void)startNewGame;

@end
