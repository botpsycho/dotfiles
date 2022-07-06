import time
time = time.asctime(time.localtime(time.time()))

opt = int(input("What you want to do: \nPress 1 to log \nPress 2 to retrieve \n>> "))
if opt == 1:
    ask = int(input("Whose data you want to log? \nPress 1 for Harry \nPress 2 for Rohan \nPress 3 for Hammad \n>> "))
    if ask == 1:
        do = int(input("What you want to log: \nPress 1 for Food \nPress 2 for Exercise \n>> "))
        if do == 1:
            with open("harry-food-log.txt", "a") as harry:
                harry.write(f"\n[Time: {time}] {input('What did you ate: ')}")
        elif do == 2:
            with open("harry-exercise-log.txt", "a") as harry:
                harry.write(f"\n[Time: {time}] {input('What exercise have you done: ')}")
        else:
            print("Invalid input, exiting...")
    elif ask == 2:
        do = int(input("What you want to log: \nPress 1 for Food \nPress 2 for Exercise \n>> "))
        if do == 1:
            with open("rohan-food-log.txt", "a") as rohan:
                rohan.write(f"\n[Time: {time}] {input('What did you ate: ')}")
        elif do == 2:
            with open("rohan-exercise-log.txt", "a") as rohan:
                rohan.write(f"\n[Time: {time}] {input('What exercise have you done: ')}")
        else:
            print("Invalid input, exiting...")
    elif ask == 3:
        do = int(input("What you want to log: \nPress 1 for Food \nPress 2 for Exercise \n>> "))
        if do == 1:
            with open("rohan-food-log.txt", "a") as hammad:
                hammad.write(f"\n[Time: {time}] {input('What did you ate: ')}")
        elif do == 2:
            with open("rohan-exercise-log.txt", "a") as hammad:
                hammad.write(f"\n[Time: {time}] {input('What exercise have you done: ')}")
        else:
            print("Invalid input, exiting...")
    else:
        print("Invalid input, exiting...")

if opt == 2:
    ask = int(input("Whose data you want to retrieve: \nPress 1 for Harry \nPress 2 for Rohan \nPress 3 for hammad \n>> "))
    if ask == 1:
        do = int(input("What you want to retrieve: \nPress 1 for Food log \nPress 2 for Exercise log \n>>"))
        if do == 1:
            with open("harry-food-log.txt", "rt") as harry:
                print(harry.read())
        elif do == 2:
            with open("harry-exercise-log.txt", "rt") as harry:
                print(harry.read())
        else:
            print("Invalid input, exiting...")
    if ask == 2:
        do = int(input("What you want to retrieve: \nPress 1 for Food log \nPress 2 for Exercise log \n>> "))
        if do == 1:
            with open("rohan-food-log.txt", "rt") as rohan:
                print(rohan.read())
        elif do == 2:
            with open("rohan-exercise-log.txt", "rt") as rohan:
                print(rohan.read())
        else:
            print("Invalid input, exiting...")
    if ask == 3:
        do = int(input("What you want to retrieve: \nPress 1 for Food log \nPress 2 for Exercise log \n>> "))
        if do == 1:
            with open("hammad-food-log.txt", "rt") as hammad:
                print(hammad.read())
        elif do == 2:
            with open("hammad-exercise-log.txt", "rt") as hammad:
                print(hammad.read())
        else:
            print("Invalid input, exiting...")

