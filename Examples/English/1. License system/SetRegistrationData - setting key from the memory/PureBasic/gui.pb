;///////////////////////////////////////////////////////////////////////////////
;//
;// Setting license key from external file (placed, somewhere else than
;// protected application directory)
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

    regname.s{#PELOCK_MAX_USERNAME}
    keysize.l
    dwStatus.l

    ; default value
    regname = "Evaluation version"

    ; open keyfile
    If (ReadFile(0, "C:\key.lic") <> 0)

      keysize = Lof(0)

      ; check key size
      If (keysize <> 0)

        ; allocate memory for the keydata
        *keydata = AllocateMemory(keysize)

        ; check allocated memory pointer
        If (*keydata <> #Null)

          ; read file
          If (ReadData(0, *keydata, keysize) <> 0)

            ; set license data
            dwStatus = SetRegistrationData(*keydata, keysize)

          EndIf

          ; release memory
          FreeMemory(*keydata)

        EndIf

      EndIf

    EndIf

    ; close file handle
    CloseFile(0)

    ; read registration name
    If (dwStatus = 1)

        DEMO_START

        ; get registered user name
        GetRegistrationName(regname, SizeOf(regname))

        DEMO_END

    EndIf

    ; show registered user name
    MessageRequester("PELock", "Registered to " + regname)
