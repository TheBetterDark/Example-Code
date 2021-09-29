# Variables
Criteria = "Password must follow:\nAt least 1 letter between [a-z]\n"\
           "At least 1 number between [0-9]\n"\
           "At least 1 letter between [A-Z]\n"\
           "At least 1 character from [$#@]\n"\
           "Minimum length of transaction password: 6\n"\
           "Maximum length of transaction password: 12"
Password_Is_Correct = 0

# Loops password input until all criteria is met
while Password_Is_Correct == 0:
    Password = input("Please enter a new password:\n")

    # Variables to check if criteria is met
    Numbers = sum(num.isdigit() for num in Password)
    Lowercase = sum(char.islower() for char in Password)
    Uppercase = sum(char.isupper() for char in Password)
    SpecialChar = sum(not char.isalnum() for char in Password)

    # Checks if criteria hs been met
    if 5 < len(Password) < 13 and Uppercase > 0 and Lowercase > 0 and Numbers > 0 and SpecialChar > 0:
        print('Your password has been saved!')
        Password_Is_Correct = 1
        break
    else:
        print(Criteria)
