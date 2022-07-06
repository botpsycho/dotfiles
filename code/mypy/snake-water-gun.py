# This is a python program of snake, water, gun game. Here you have to choose between snake, water and gun and the computer will do the same (each time choices will change as it will use random module to do so). Snake drinks the water, Gun kills the snake and Water wins against gun as gun will drown in it.

import random
choices = ["Snake", "Water", "Gun"]
print("SNAKE WATER GUN")
def game():
    try:
        r = 7
        won = 0
        lose = 0
        draw = 0
        while r>0:
            unknown = random.choice(choices)
            selected = input("\n Enter your choice: \n S for Snake \n W for water \n G for Gun \n >> ")
            if selected == 'S':
                if unknown == "Snake":
                    print("DRAW")
                    draw += 1
                elif unknown == "Water":
                    print("YOU WON!")
                    won += 1
                else:
                    print("YOU LOSE!")
                    lose += 1
                r -= 1
            elif selected == 'W':
                if unknown == "Snake":
                    print("DRAW")
                    draw += 1
                elif unknown == "Water":
                    print("YOU WON!")
                    won += 1
                else:
                    print("YOU LOSE!")
                    lose += 1
                r -= 1
            elif selected == 'G':
                if unknown == "Snake":
                    print("DRAW")
                    won += 1
                elif unknown == "Water":
                    print("YOU WON!")
                    won += 1
                else:
                    print("YOU LOSE!")
                    lose += 1
                r -= 1
            else:
                print("Invalid Input")

        if won > 0:
            print(f"\nNumber of times you won: {won}")
        if lose > 0:
            print(f"Number of times you lose: {lose}")
        if draw > 0:
            print(f"Number of times you and computer had a draw: {draw}")
        print("####### GAME OVER #######")

    except Exception as e:
        print("Invalid Input, exiting...")
        exit()

game()

opt = input("Want to play again \n y for yes \n n for no \n >> ")
if opt == 'y':
    game()
elif opt == 'n':
    exit()
else:
    print("Invalid input, exiting...")




