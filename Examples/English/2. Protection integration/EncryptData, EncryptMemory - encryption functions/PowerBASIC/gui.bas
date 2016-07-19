'////////////////////////////////////////////////////////////////////////////////
'//
'// Example of how to use built-in encryption functions (stream cipher)
'//
'// Version        : PELock v2.0
'// Language       : PowerBASIC
'// Author         : Bartosz Wójcik (support@pelock.com)
'// Web page       : https://www.pelock.com
'//
'///////////////////////////////////////////////////////////////////////////////

#COMPILE EXE
%USEMACROS = 1

#INCLUDE "win32api.inc"
#INCLUDE "pelock.inc"

FUNCTION PBMAIN () AS LONG

    DIM test AS STRING
    DIM test_len AS INTEGER

    DIM key AS STRING
    DIM key_len AS INTEGER

    DIM output_size AS INTEGER


    test = "Sample string"
    test_len = LEN(test)

    key = "9876543210"
    key_len = LEN(key)

    '
    ' Encryption algorithm is constant and it's not going to be
    ' changed in the future, so you can use it to encrypt
    ' all kind of application files like configs, databases etc.
    '
    MSGBOX test, %MB_OK, "Plain string"

    output_size = EncryptData(key, key_len, test, test_len)

    MSGBOX test, %MB_OK, "Encrypted string"

    output_size = DecryptData(key, key_len, test, test_len)

    MSGBOX test, %MB_OK, "Decrypted string"


    '
    ' Encrypt and decrypt memory in the same process. An application
    ' running in a different process will not be able to decrypt the
    ' data.
    '
    MSGBOX test, %MB_OK, "Plain string (testing keyless encryption)"

    output_size = EncryptMemory(test, test_len)

    MSGBOX test, %MB_OK, "Encrypted string (keyless encryption)"

    output_size = DecryptMemory(test, test_len)

    MSGBOX test, %MB_OK, "Decrypted string (keyless decryption)"

END FUNCTION
