;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                                                                                            ≥
;≥ PELock header file                                                                         ≥
;≥                                                                                            ≥
;≥ Version        : PELock v2.09                                                              ≥
;≥ Language       : win32asm / MASM                                                           ≥
;≥ Author         : Bartosz WÛjcik (support@pelock.com)                                       ≥
;≥ Web page       : https://www.pelock.com                                                    ≥
;≥                                                                                            ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

ifndef __PELOCK__
__PELOCK__ equ 1

;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ
; define which protection procedures will be available
; if you don't want to include some of the procedures
; comment out selected declaration
;ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ

PELOCK_LICENSE_APIS		equ 1
PELOCK_TIMETRIAL_APIS		equ 1
PELOCK_CRYPTO_APIS		equ 1
PELOCK_PRESENT_CHECKS		equ 1
PELOCK_PROTECTED_CONST		equ 1

.code

;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; license system apis
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

ifdef PELOCK_LICENSE_APIS

; max. size of registered user name stored in the keyfile, including terminating null at the end
PELOCK_MAX_USERNAME		equ 8193

; max. number of hardware id characters, including terminating null at the end
PELOCK_MAX_HARDWARE_ID		equ 17

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get registration key status information
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

; return codes for GetKeyStatus()
PELOCK_KEY_NOT_FOUND		equ 0		; key not found
PELOCK_KEY_OK			equ 1		; key is valid
PELOCK_KEY_INVALID		equ 2		; invalid key format
PELOCK_KEY_STOLEN		equ 3		; key is stolen
PELOCK_KEY_WRONG_HWID		equ 4		; hardware id doesn't match
PELOCK_KEY_EXPIRED		equ 5		; key is expired

GetKeyStatus proc near

	push	256
	push	0
	push	-17
	call	GetWindowText

	ret

GetKeyStatus endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; is the key locked to the hardware identifier
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

IsKeyHardwareIdLocked proc

	push	128
	push	0
	push	-24
	call	GetWindowText

	ret

IsKeyHardwareIdLocked endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; retrieve registration name from license key file
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetRegistrationName proc szRegistrationName:dword, nMaxCount:dword

	push	nMaxCount
	push	szRegistrationName
	push	-1
	call	GetWindowText

	ret

GetRegistrationName endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get raw registration data (read username as a raw byte array)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetRawRegistrationName proc lpRegistrationRawName:dword, nMaxCount:dword

	push	nMaxCount
	push	lpRegistrationRawName
	push	-21
	call	GetWindowText

	ret

GetRawRegistrationName endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; set license key path (other than application's directory)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

SetRegistrationKey proc szRegistrationKeyPath:dword

	push	0
	push	szRegistrationKeyPath
	push	-2
	call	GetWindowText

	ret

SetRegistrationKey endp


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; set license data buffer
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

SetRegistrationData proc lpBuffer:dword, nSize:dword

	push	nSize
	push	lpBuffer
	push	-7
	call	GetWindowText

	ret

SetRegistrationData endp


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; set license data from the text buffer (in MIME Base64 format)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

SetRegistrationText proc szRegistrationKey:dword

	push	0
	push	szRegistrationKey
	push	-22
	call	GetWindowText

	ret

SetRegistrationText endp


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; disable current registration key, do not allow to set a new key again
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

DisableRegistrationKey proc bPermamentLock:dword

	push	bPermamentLock
	push	0
	push	-17
	call	GetWindowText

	ret

DisableRegistrationKey endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; reload registration key from the default search locations
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ReloadRegistrationKey proc

	push	256
	push	0
	push	-16
	call	GetWindowText

	ret

ReloadRegistrationKey endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get user defined key data
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetKeyData proc iValue

	push	iValue
	push	0
	push	-3
	call	GetWindowText

	ret

GetKeyData endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get user defined key features
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

IsFeatureEnabled proc iIndex:dword

	push	iIndex
	push	0
	push	-6
	call	GetWindowText

	ret

IsFeatureEnabled endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get hardware id
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetHardwareId proc szHardwareId:dword, nMaxCount:dword

	push	nMaxCount
	push	szHardwareId
	push	-4
	call	GetWindowText

	ret

GetHardwareId endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; set hardware id callback routine
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

SetHardwareIdCallback proc lpHardwareIdFunc:dword

	push	256
	push	lpHardwareIdFunc
	push	-20
	call	GetWindowText

	ret

SetHardwareIdCallback endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get key expiration date
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetKeyExpirationDate proc lpSystemTime:dword

	push	256
	push	lpSystemTime
	push	-5
	call	GetWindowText

	ret

GetKeyExpirationDate endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get key creation date
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetKeyCreationDate proc lpSystemTime:dword

	push	256
	push	lpSystemTime
	push	-15
	call	GetWindowText

	ret

GetKeyCreationDate endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get key running time (since it was set)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetKeyRunningTime proc lpSystemTime:dword

	push	256
	push	lpSystemTime
	push	-23
	call	GetWindowText

	ret

GetKeyRunningTime endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get key integers (from 1-16)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetKeyInteger proc iIndex:dword

	push	iIndex
	push	0
	push	-8
	call	GetWindowText

	ret

GetKeyInteger endp

;ifdef PELOCK_LICENSE_APIS
endif

;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; time trial apis
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

ifdef PELOCK_TIMETRIAL_APIS

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; return codes for time trial procedures
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

PELOCK_TRIAL_ABSENT		equ 0		; time trial protection not used, or the application is already registered
PELOCK_TRIAL_ACTIVE		equ 1		; trial period active
PELOCK_TRIAL_EXPIRED		equ 2		; trial period expired (returned when "Allow application to expire" option is used

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get trial days
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetTrialDays proc lpdwTotalDays:dword, lpdwLeftDays:dword

	push	lpdwLeftDays
	push	lpdwTotalDays
	push	-10
	call	GetWindowText

	ret

GetTrialDays endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get trial executions
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetTrialExecutions proc lpdwTotalExecutions:dword, lpdwLeftExecutions:dword

	push	lpdwLeftExecutions
	push	lpdwTotalExecutions
	push	-11
	call	GetWindowText

	ret

GetTrialExecutions endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get expiration date
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetExpirationDate proc lpstExpirationDate:dword

	push	512
	push	lpstExpirationDate
	push	-12
	call	GetWindowText

	ret

GetExpirationDate endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; get trial period
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

GetTrialPeriod proc lpstPeriodBegin:dword, lpstPeriodEnd:dword

	push	lpstPeriodEnd
	push	lpstPeriodBegin
	push	-13
	call	GetWindowText

	ret

GetTrialPeriod endp

; ifdef PELOCK_TIMETRIAL_APIS
endif

;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; built-in encryption functions
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

ifdef PELOCK_CRYPTO_APIS

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; encryption functions (stream cipher)
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

EncryptData proc lpKey:dword, dwKeyLen:dword, lpBuffer:dword, nSize:dword

	push	0
	push	0
	push	1
	push	nSize
	push	lpBuffer
	push	dwKeyLen
	push	-1
	push	lpKey
	call	DeferWindowPos

	ret

EncryptData endp

DecryptData proc lpKey:dword, dwKeyLen:dword, lpBuffer:dword, nSize:dword

	push	0
	push	0
	push	0
	push	nSize
	push	lpBuffer
	push	dwKeyLen
	push	-1
	push	lpKey
	call	DeferWindowPos

	ret

DecryptData endp

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;
; encrypt memory with current session keys
;
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

EncryptMemory proc lpBuffer:dword, nSize:dword

	push	0
	push	0
	push	1
	push	nSize
	push	lpBuffer
	push	0
	push	-1
	push	0
	call	DeferWindowPos

	ret

EncryptMemory endp

DecryptMemory proc lpBuffer:dword, nSize:dword

	push	0
	push	0
	push	0
	push	nSize
	push	lpBuffer
	push	0
	push	-1
	push	0
	call	DeferWindowPos

	ret

DecryptMemory endp

; ifdef PELOCK_CRYPTO_APIS
endif

;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; protection checks
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

ifdef PELOCK_PRESENT_CHECKS

_IsPELockPresent1 macro

	push	256
	push	0
	push	0
	call	GetAtomName
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent1 proc near

	_IsPELockPresent1
	ret

IsPELockPresent1 endp

_IsPELockPresent2 macro

	push	0
	push	512
	push	0
	push	128
	push	0
	call	LockFile
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent2 proc near

	_IsPELockPresent2
	ret

IsPELockPresent2 endp

_IsPELockPresent3 macro

	push	1024
	push	0
	push	0
	push	1 ;FILE_MAP_COPY
	push	0
	call	MapViewOfFile
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent3 proc near

	_IsPELockPresent3
	ret

IsPELockPresent3 endp

_IsPELockPresent4 macro

	push	0
	push	0
	push	0
	call	SetWindowRgn
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent4 proc near

	_IsPELockPresent4
	ret

IsPELockPresent4 endp

_IsPELockPresent5 macro

	push	0
	push	0
	call	GetWindowRect
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent5 proc near

	_IsPELockPresent5
	ret

IsPELockPresent5 endp

_IsPELockPresent6 macro

	push	0
	call	GetFileAttributes
	cmp	eax,-1
	setne	al
	and	eax,1

endm

IsPELockPresent6 proc near

	_IsPELockPresent6
	ret

IsPELockPresent6 endp

_IsPELockPresent7 macro

	push	0
	push	0
	push	0
	push	0
	call	GetFileTime
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent7 proc near

	_IsPELockPresent7
	ret

IsPELockPresent7 endp

_IsPELockPresent8 macro

	push	0
	call	SetEndOfFile
	neg	eax
	sbb	eax,eax
	and	eax,1

endm

IsPELockPresent8 proc near

	_IsPELockPresent8
	ret

IsPELockPresent8 endp

; helper macros
IS_PELOCK_1	equ _IsPELockPresent1
IS_PELOCK_2	equ _IsPELockPresent2
IS_PELOCK_3	equ _IsPELockPresent3
IS_PELOCK_4	equ _IsPELockPresent4
IS_PELOCK_5	equ _IsPELockPresent5
IS_PELOCK_6	equ _IsPELockPresent6
IS_PELOCK_7	equ _IsPELockPresent7
IS_PELOCK_8	equ _IsPELockPresent8

; ifdef PELOCK_PRESENT_CHECKS
endif


;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; protected constants
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

ifdef PELOCK_PROTECTED_CONST

GetPELockDWORD proc uses ecx edx, dwValue:dword, dwRandomizer:dword, dwMagic1:dword, dwMagic2:dword

	local	dwReturnValue:dword
	local	dwParams[3]:dword
	local	dwDecodedValue:dword

	lea	ecx,dwReturnValue
	and	dword ptr[ecx],0

	lea	edx,dwParams

	mov	eax,dwValue
	sub	eax,dwRandomizer
	mov	dwDecodedValue,eax

	mov	dword ptr[edx],eax

	mov	eax,dwMagic1
	mov	dword ptr[edx+4],eax

	mov	eax,dwMagic2
	mov	dword ptr[edx+8],eax

	push	edx
	push	ecx
	push	-9
	call	GetWindowText
	test	eax,eax
	je	_return_value

	mov	eax,dwReturnValue

	jmp	_return_value_exit

_return_value:

	mov	eax,dwDecodedValue

_return_value_exit:

	ret

GetPELockDWORD endp

; PELock protected constants (don't change the params)
PELOCK_DWORD macro dwValue:req

	local	dwRandomizer

	dwRandomizer = @Line

	push	044332211h
	push	011223344h
	push	dwRandomizer
	push	dwValue + dwRandomizer
	call	GetPELockDWORD

endm

; secure form of a PUSH instruction for the protected contants
; e.g. "pushx 1" saves 1 on the stack
pushx macro dwValue:req

	push	eax
	PELOCK_DWORD <dwValue>
	xchg	eax,dword ptr[esp]

endm

; secure form of a MOV instruction for the protected contants
; e.g. "movx edx,0FFFFFFFFh" saves -1 to the EDX register
movx macro regDest, dwValue:req

	IFDIFI <regDest>, <eax>
		push	eax
	ENDIF

	PELOCK_DWORD <dwValue>

	IFDIFI <regDest>, <eax>
		mov	regDest,eax
		pop	eax
	ENDIF

endm

; ifdef PELOCK_PROTECTED_CONST
endif

;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
;
;
; macros
;
;
;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€

DEMO_START macro
	db 0EBh,007h,0EBh,0FCh,0EBh,0FAh,0EBh,0FAh,0C7h
endm

DEMO_END macro
	db 0EBh,006h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0C8h
endm

DEMO_START_MT macro
	db 0EBh,007h,0EBh,0FCh,0EBh,0FAh,0EBh,0FAh,0D7h
endm

DEMO_END_MT macro
	db 0EBh,006h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0D8h
endm

CRYPT_START macro
	db 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0C7h
endm

CRYPT_END macro
	db 0EBh,006h,0EBh,000h,0EBh,000h,0EBh,000h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0C8h
endm

CRYPT_START_MT macro
	db 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0D7h
endm

CRYPT_END_MT macro
	db 0EBh,006h,0EBh,000h,0EBh,000h,0EBh,000h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,005h,0EBh,003h,0EBh,001h,0D8h
endm

CLEAR_START macro
	db 0EBh,007h,0EBh,0FCh,0EBh,000h,0EBh,001h,0C9h
endm

CLEAR_END macro
	db 0EBh,006h,0EBh,002h,0EBh,0FCh,0EBh,000h,0EBh,006h,0CDh,021h,0EBh,0FAh,0CDh,021h
	db 0EBh,007h,0EBh,0FCh,0EBh,0FCh,0EBh,001h,0C9h
endm

CLEAR_START_MT macro
	db 0EBh,007h,0EBh,0FCh,0EBh,000h,0EBh,001h,0D9h
endm

CLEAR_END_MT macro
	db 0EBh,006h,0EBh,002h,0EBh,0FCh,0EBh,000h,0EBh,006h,0CDh,021h,0EBh,0FAh,0CDh,021h
	db 0EBh,007h,0EBh,0FCh,0EBh,0FCh,0EBh,001h,0D9h
endm


FILE_CRYPT_START macro
	db 0EBh,007h,0EBh,002h,0EBh,0FCh,0EBh,001h,0CAh
endm

FILE_CRYPT_END macro
	db 0EBh,006h,0EBh,0FCh,0EBh,0FCh,0EBh,000h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FCh,0EBh,003h,0EBh,0FCh,0CAh
endm

FILE_CRYPT_START_MT macro
	db 0EBh,007h,0EBh,002h,0EBh,0FCh,0EBh,001h,0DAh
endm

FILE_CRYPT_END_MT macro
	db 0EBh,006h,0EBh,0FCh,0EBh,0FCh,0EBh,000h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FCh,0EBh,003h,0EBh,0FCh,0DAh
endm

UNPROTECTED_START macro
	db 0EBh,006h,08Bh,0E4h,089h,0EDh,0EBh,0FCh
endm

UNPROTECTED_END macro
	db 0EBh,006h,089h,0EDh,08Bh,0E4h,0EBh,0FAh
endm

UNREGISTERED_START macro
	db 0EBh,007h,0EBh,002h,0EBh,0FAh,0EBh,001h,0CBh
endm

UNREGISTERED_END macro
	db 0EBh,006h,0EBh,004h,0EBh,002h,0EBh,000h,0EBh,006h,0CDh,022h,0EBh,0FCh,0CDh,022h
	db 0EBh,007h,0EBh,0FCh,0EBh,0FCh,0EBh,001h,0CBh
endm

UNREGISTERED_START_MT macro
	db 0EBh,007h,0EBh,002h,0EBh,0FAh,0EBh,001h,0DBh
endm

UNREGISTERED_END_MT macro
	db 0EBh,006h,0EBh,004h,0EBh,002h,0EBh,000h,0EBh,006h,0CDh,022h,0EBh,0FCh,0CDh,022h
	db 0EBh,007h,0EBh,0FCh,0EBh,0FCh,0EBh,001h,0DBh
endm

SKIP_START macro
	db 0EBh,006h,08Bh,0E4h,08Bh,0C0h,0EBh,0FCh
endm

SKIP_END macro
	db 0EBh,006h,08Bh,0C0h,08Bh,0E4h,0EBh,0FAh
endm

FEATURE_X_START macro x
	db 0EBh,008h,0EBh,0FCh,0EBh,x,0FAh,0EBh,0FAh,0CAh
endm

FEATURE_END macro
	db 0EBh,006h,0EBh,0F1h,0EBh,0F2h,0EBh,0F3h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0CAh
endm

FEATURE_1_START macro
	FEATURE_X_START	0
endm

FEATURE_2_START macro
	FEATURE_X_START	1
endm

FEATURE_3_START macro
	FEATURE_X_START	2
endm

FEATURE_4_START macro
	FEATURE_X_START	3
endm

FEATURE_5_START macro
	FEATURE_X_START	4
endm

FEATURE_6_START macro
	FEATURE_X_START	5
endm

FEATURE_7_START macro
	FEATURE_X_START	6
endm

FEATURE_8_START macro
	FEATURE_X_START	7
endm

FEATURE_9_START macro
	FEATURE_X_START	8
endm

FEATURE_10_START macro
	FEATURE_X_START	9
endm

FEATURE_11_START macro
	FEATURE_X_START	10
endm

FEATURE_12_START macro
	FEATURE_X_START	11
endm

FEATURE_13_START macro
	FEATURE_X_START	12
endm

FEATURE_14_START macro
	FEATURE_X_START	13
endm

FEATURE_15_START macro
	FEATURE_X_START	14
endm

FEATURE_16_START macro
	FEATURE_X_START	15
endm

FEATURE_17_START macro
	FEATURE_X_START	16
endm

FEATURE_18_START macro
	FEATURE_X_START	17
endm

FEATURE_19_START macro
	FEATURE_X_START	18
endm

FEATURE_20_START macro
	FEATURE_X_START	19
endm

FEATURE_21_START macro
	FEATURE_X_START	20
endm

FEATURE_22_START macro
	FEATURE_X_START	21
endm

FEATURE_23_START macro
	FEATURE_X_START	22
endm

FEATURE_24_START macro
	FEATURE_X_START	23
endm

FEATURE_25_START macro
	FEATURE_X_START	24
endm

FEATURE_26_START macro
	FEATURE_X_START	25
endm

FEATURE_27_START macro
	FEATURE_X_START	26
endm

FEATURE_28_START macro
	FEATURE_X_START	27
endm

FEATURE_29_START macro
	FEATURE_X_START	28
endm

FEATURE_30_START macro
	FEATURE_X_START	29
endm

FEATURE_31_START macro
	FEATURE_X_START	30
endm

FEATURE_32_START macro
	FEATURE_X_START	31
endm

FEATURE_1_END equ FEATURE_END
FEATURE_2_END equ FEATURE_END
FEATURE_3_END equ FEATURE_END
FEATURE_4_END equ FEATURE_END
FEATURE_5_END equ FEATURE_END
FEATURE_6_END equ FEATURE_END
FEATURE_7_END equ FEATURE_END
FEATURE_8_END equ FEATURE_END
FEATURE_9_END equ FEATURE_END
FEATURE_10_END equ FEATURE_END
FEATURE_11_END equ FEATURE_END
FEATURE_12_END equ FEATURE_END
FEATURE_13_END equ FEATURE_END
FEATURE_14_END equ FEATURE_END
FEATURE_15_END equ FEATURE_END
FEATURE_16_END equ FEATURE_END
FEATURE_17_END equ FEATURE_END
FEATURE_18_END equ FEATURE_END
FEATURE_19_END equ FEATURE_END
FEATURE_20_END equ FEATURE_END
FEATURE_21_END equ FEATURE_END
FEATURE_22_END equ FEATURE_END
FEATURE_23_END equ FEATURE_END
FEATURE_24_END equ FEATURE_END
FEATURE_25_END equ FEATURE_END
FEATURE_26_END equ FEATURE_END
FEATURE_27_END equ FEATURE_END
FEATURE_28_END equ FEATURE_END
FEATURE_29_END equ FEATURE_END
FEATURE_30_END equ FEATURE_END
FEATURE_31_END equ FEATURE_END
FEATURE_32_END equ FEATURE_END

FEATURE_X_START_MT macro x
	db 0EBh,008h,0EBh,0FCh,0EBh,x,0FAh,0EBh,0FAh,0DAh
endm

FEATURE_END_MT macro
	db 0EBh,006h,0EBh,0F1h,0EBh,0F2h,0EBh,0F3h,0EBh,006h,0CDh,020h,0EBh,0FDh,0CDh,020h
	db 0EBh,007h,0EBh,0FBh,0EBh,0FAh,0EBh,0FCh,0DAh
endm

FEATURE_1_START_MT macro
	FEATURE_X_START_MT	0
endm

FEATURE_2_START_MT macro
	FEATURE_X_START_MT	1
endm

FEATURE_3_START_MT macro
	FEATURE_X_START_MT	2
endm

FEATURE_4_START_MT macro
	FEATURE_X_START_MT	3
endm

FEATURE_5_START_MT macro
	FEATURE_X_START_MT	4
endm

FEATURE_6_START_MT macro
	FEATURE_X_START_MT	5
endm

FEATURE_7_START_MT macro
	FEATURE_X_START_MT	6
endm

FEATURE_8_START_MT macro
	FEATURE_X_START_MT	7
endm

FEATURE_9_START_MT macro
	FEATURE_X_START_MT	8
endm

FEATURE_10_START_MT macro
	FEATURE_X_START_MT	9
endm

FEATURE_11_START_MT macro
	FEATURE_X_START_MT	10
endm

FEATURE_12_START_MT macro
	FEATURE_X_START_MT	11
endm

FEATURE_13_START_MT macro
	FEATURE_X_START_MT	12
endm

FEATURE_14_START_MT macro
	FEATURE_X_START_MT	13
endm

FEATURE_15_START_MT macro
	FEATURE_X_START_MT	14
endm

FEATURE_16_START_MT macro
	FEATURE_X_START_MT	15
endm

FEATURE_17_START_MT macro
	FEATURE_X_START_MT	16
endm

FEATURE_18_START_MT macro
	FEATURE_X_START_MT	17
endm

FEATURE_19_START_MT macro
	FEATURE_X_START_MT	18
endm

FEATURE_20_START_MT macro
	FEATURE_X_START_MT	19
endm

FEATURE_21_START_MT macro
	FEATURE_X_START_MT	20
endm

FEATURE_22_START_MT macro
	FEATURE_X_START_MT	21
endm

FEATURE_23_START_MT macro
	FEATURE_X_START_MT	22
endm

FEATURE_24_START_MT macro
	FEATURE_X_START_MT	23
endm

FEATURE_25_START_MT macro
	FEATURE_X_START_MT	24
endm

FEATURE_26_START_MT macro
	FEATURE_X_START_MT	25
endm

FEATURE_27_START_MT macro
	FEATURE_X_START_MT	26
endm

FEATURE_28_START_MT macro
	FEATURE_X_START_MT	27
endm

FEATURE_29_START_MT macro
	FEATURE_X_START_MT	28
endm

FEATURE_30_START_MT macro
	FEATURE_X_START_MT	29
endm

FEATURE_31_START_MT macro
	FEATURE_X_START_MT	30
endm

FEATURE_32_START_MT macro
	FEATURE_X_START_MT	31
endm

FEATURE_1_END_MT equ FEATURE_END_MT
FEATURE_2_END_MT equ FEATURE_END_MT
FEATURE_3_END_MT equ FEATURE_END_MT
FEATURE_4_END_MT equ FEATURE_END_MT
FEATURE_5_END_MT equ FEATURE_END_MT
FEATURE_6_END_MT equ FEATURE_END_MT
FEATURE_7_END_MT equ FEATURE_END_MT
FEATURE_8_END_MT equ FEATURE_END_MT
FEATURE_9_END_MT equ FEATURE_END_MT
FEATURE_10_END_MT equ FEATURE_END_MT
FEATURE_11_END_MT equ FEATURE_END_MT
FEATURE_12_END_MT equ FEATURE_END_MT
FEATURE_13_END_MT equ FEATURE_END_MT
FEATURE_14_END_MT equ FEATURE_END_MT
FEATURE_15_END_MT equ FEATURE_END_MT
FEATURE_16_END_MT equ FEATURE_END_MT
FEATURE_17_END_MT equ FEATURE_END_MT
FEATURE_18_END_MT equ FEATURE_END_MT
FEATURE_19_END_MT equ FEATURE_END_MT
FEATURE_20_END_MT equ FEATURE_END_MT
FEATURE_21_END_MT equ FEATURE_END_MT
FEATURE_22_END_MT equ FEATURE_END_MT
FEATURE_23_END_MT equ FEATURE_END_MT
FEATURE_24_END_MT equ FEATURE_END_MT
FEATURE_25_END_MT equ FEATURE_END_MT
FEATURE_26_END_MT equ FEATURE_END_MT
FEATURE_27_END_MT equ FEATURE_END_MT
FEATURE_28_END_MT equ FEATURE_END_MT
FEATURE_29_END_MT equ FEATURE_END_MT
FEATURE_30_END_MT equ FEATURE_END_MT
FEATURE_31_END_MT equ FEATURE_END_MT
FEATURE_32_END_MT equ FEATURE_END_MT

PELOCK_CHECKPOINT macro

	db 0EBh,07Eh,00Dh,00Ah,054h,068h,072h,06Fh,075h,067h,068h,020h,074h,068h,065h,020h
	db 064h,061h,072h,06Bh,020h,06Fh,066h,020h,066h,075h,074h,075h,072h,065h,073h,020h
	db 070h,061h,073h,074h,021h,00Dh,00Ah,054h,068h,065h,020h,06Dh,061h,067h,069h,063h
	db 069h,061h,06Eh,020h,06Ch,06Fh,06Eh,067h,073h,020h,074h,06Fh,020h,073h,065h,065h
	db 021h,00Dh,00Ah,04Fh,06Eh,065h,020h,063h,068h,061h,06Eh,074h,073h,020h,06Fh,075h
	db 074h,020h,062h,065h,074h,077h,065h,065h,06Eh,020h,074h,077h,06Fh,020h,077h,06Fh
	db 072h,06Ch,064h,073h,021h,00Dh,00Ah,046h,049h,052h,045h,020h,057h,041h,04Ch,04Bh
	db 020h,057h,049h,054h,048h,020h,04Dh,045h,021h,00Dh,00Ah,042h,04Fh,042h,00Dh,00Ah

endm

PELOCK_WATERMARK macro

	db 0EBh,07Eh,044h,06Fh,077h,06Eh,020h,069h,06Eh,020h,074h,068h,065h,020h,070h,061h
	db 072h,06Bh,00Dh,00Ah,057h,068h,065h,072h,065h,020h,074h,068h,065h,020h,063h,068h
	db 061h,06Eh,074h,020h,069h,073h,020h,064h,065h,061h,074h,068h,02Ch,020h,064h,065h
	db 061h,074h,068h,02Ch,020h,064h,065h,061h,074h,068h,00Dh,00Ah,055h,06Eh,074h,069h
	db 06Ch,020h,074h,068h,065h,020h,073h,075h,06Eh,020h,063h,072h,069h,065h,073h,020h
	db 06Dh,06Fh,072h,06Eh,069h,06Eh,067h,00Dh,00Ah,044h,06Fh,077h,06Eh,020h,069h,06Eh
	db 020h,074h,068h,065h,020h,070h,061h,072h,06Bh,020h,077h,069h,074h,068h,020h,066h
	db 072h,069h,065h,06Eh,064h,073h,020h,06Fh,066h,020h,06Dh,069h,06Eh,065h,00Dh,00Ah

endm

PELOCK_CPUID macro

	db 0EBh,07Eh,00Dh,00Ah,00Dh,00Ah,043h,06Fh,06Dh,065h,020h,061h,073h,020h,079h,06Fh
	db 075h,020h,061h,072h,065h,02Ch,020h,061h,073h,020h,079h,06Fh,075h,020h,077h,065h
	db 072h,065h,00Dh,00Ah,041h,073h,020h,049h,020h,077h,061h,06Eh,074h,020h,079h,06Fh
	db 075h,020h,074h,06Fh,020h,062h,065h,00Dh,00Ah,041h,073h,020h,061h,020h,066h,072h
	db 069h,065h,06Eh,064h,02Ch,020h,061h,073h,020h,061h,020h,066h,072h,069h,065h,06Eh
	db 064h,00Dh,00Ah,041h,073h,020h,061h,06Eh,020h,06Fh,06Ch,064h,020h,065h,06Eh,065h
	db 06Dh,079h,00Dh,00Ah,054h,061h,06Bh,065h,020h,079h,06Fh,075h,072h,020h,074h,069h
	db 06Dh,065h,02Ch,020h,068h,075h,072h,072h,079h,020h,075h,070h,00Dh,00Ah,00Dh,00Ah

endm

PELOCK_MEMORY_GAP macro

	db 0E9h,004h,020h,000h,000h,08Fh,0F1h,012h,034h
	db 8192 dup(0)

endm

PELOCK_INIT_CALLBACK macro
	db 0EBh,008h,010h,011h,022h,033h,033h,022h,011h,000h
endm

HARDWARE_ID_CALLBACK macro
	db 0EBh,008h,04Fh,05Ah,0F7h,038h,031h,0CDh,0E0h,053h
endm

TRIAL_EXPIRED macro
	db 0EBh,008h,000h,011h,022h,033h,033h,022h,011h,000h
endm

TRIAL_TOTAL_EXPIRED macro
	db 0EBh,008h,001h,011h,022h,033h,033h,022h,011h,000h
endm

; ifndef __PELOCK__
endif
