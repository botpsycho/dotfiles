first = input("Enter the first number: ")
operator = input("Enter your operator (+.-.*,/,%,**) : ")
second = input("Enter your second number: ")
first = float(first)
second = float(second)

if operator == "+":
    print(first + second)
elif operator == "-":
    print(first - second)
elif operator == "*":
    print(first * second)
elif operator == "/":
    print(first / second)
elif operator == "**":
    print(first ** second)
else:
    print("Invalid value")
