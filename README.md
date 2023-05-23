# Requirements
- Ask for authentication every time the app is put in the background
- Securely encrypt diary entries

# How does the security work?
1. User enters using fingerprint
2. user enters password
3. password is hashed
4. Using the hashed password, decrypt the diary entry encryption key
5. using the decrypted key, decrypt the diary entry
## In Reverse:
1. encrypt the diary entry using the key
2. encrypt the key using the password hash
3. store the encrypted key securely
4. dispose of hashed password