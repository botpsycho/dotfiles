"""
This is a faulty calculator. This will give all the correct answers except these three:
45 * 3 = 555, 56+9 = 77, 56/6 = 4
"""
first = int(input("Enter your first number: "))
operator = input("Enter your operator (+, -, *, /, **): ")
second = int(input("Enter your second number: "))

if first == 45 and second == 3 and operator == '*':
    print("Answer:", 555)
elif first == 56 and second == 9 and operator == '+':
    print("Answer:", 77)
elif first == 56 and second == 6 and operator == '/':
    print("Answer:", 4)
elif operator == '+':
    print("Answer:", first + second)
elif operator == '-':
    print("Answer:", first - second)
elif operator == '*':
    print("Answer:", first * second)
elif operator == '/':
    print("Answer:", operator / second)
elif operator == '**':
    print("Answer:", first ** second)
else:
    print("Invalid input")
