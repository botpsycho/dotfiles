# This is a number guessing game, where you will get 5 chances to guess the number.

n = n = random.randint(0, 100)
def game():
    print("GUESS THE NUMBER" "\nNUMBER OF GUESSES YOU WILL GET: 5")
    guess = 1
    while guess<6:
        try:
            take = int(input("Enter your guess: "))
            if take<n:
                print("You have guessed a smaller number, try guessing a greater number")
                guess += 1
                print("Number of guesses left:", 6 - guess)
                continue
            elif take>n:
                print("You have guessed a greater number, try guessing a smaller number")
                guess += 1
                print("Number of guesses left:", 6 - guess)
                continue
            else:
                print("Congratulations you have guessed right", "\nNumber of times you guessed:", guess)
                break
        except Exception as error:
            print(error)
    if guess > 5:
        print("##### GAME OVER #####")
        ask = input("Do you want to play again? ")
        if ask == 'y':
            game()
        elif ask == 'n':
            exit()
        else:
            print ("Invalid input")
game()
