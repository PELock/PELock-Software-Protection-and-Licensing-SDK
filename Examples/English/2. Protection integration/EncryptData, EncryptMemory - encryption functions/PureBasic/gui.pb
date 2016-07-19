;///////////////////////////////////////////////////////////////////////////////
;//
;// Example of how to use built-in encryption functions (stream cipher)
;//
;// Version        : PELock v2.0
;// Language       : PureBasic
;// Author         : Bartosz Wójcik (support@pelock.com)
;// Web page       : https://www.pelock.com
;//
;///////////////////////////////////////////////////////////////////////////////

IncludePath "..\..\..\..\..\SDK\English\PureBasic\"
XIncludeFile "pelock.pb"

; start

    test.s = "Sample string"
    test_len.l = Len(test) ; or StringByteLength for Unicode or UTF-8 encoded strings

    key.s = "9876543210"
    key_len.l = Len(key) ; or StringByteLength for Unicode or UTF-8 encoded strings

    ;
    ; Encryption algorithm is constant and it's not going to be
    ; changed in the future, so you can use it to encrypt
    ; all kind of application files like configs, databases etc.
    ;
    MessageRequester("Plain string", test)

    output_size = EncryptData(key, key_len, test, test_len)

    MessageRequester("Encrypted string", test)

    output_size = DecryptData(key, key_len, test, test_len)

    MessageRequester("Decrypted string", test)


    ;
    ; Encrypt and decrypt memory in the same process. An application
    ; running in a different process will not be able to decrypt the
    ; data.
    ;
    MessageRequester("Plain string (testing keyless encryption)", test)

    output_size = EncryptMemory(test, test_len)

    MessageRequester("Encrypted string (keyless encryption)", test)

    output_size = DecryptMemory(test, test_len)

    MessageRequester("Decrypted string (keyless decryption)", test)
