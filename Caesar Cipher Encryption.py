# Variables
Is_Correct = 0


# Caesar Cipher Encryption
def encrypt(text, s):
	result = ""

	# Loop that encrypts data using Caesar Cipher
	for i in range(len(text)):
		char = text[i]
		if char.isupper():
			result += chr((ord(char) + s - 65) % 26 + 65)
		else:
			result += chr((ord(char) + s - 97) % 26 + 97)
	return result


while Is_Correct == 0:
	ReferenceID = input("Please enter your Reference ID:\n")

	Numbers = sum(num.isdigit() for num in ReferenceID)
	Alphabet = sum(char.isalpha() for char in ReferenceID)
	SpecialChar = sum(not char.isalnum() for char in ReferenceID)

	if len(ReferenceID) == 12 and Alphabet > 0 and Numbers > 0 and SpecialChar > 0:
		Is_Correct = 1
		print("Keep this for reference: " + encrypt(ReferenceID, 4))
		break
	else:
		print("Not a Reference ID")
