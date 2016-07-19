; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CPelock_setkeyDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "pelock_setkey.h"

ClassCount=2
Class1=CPelock_setkeyApp
Class2=CPelock_setkeyDlg

ResourceCount=4
Resource2=IDR_MAINFRAME
Resource3=IDD_PELOCK_SETKEY_DIALOG
Resource4=IDD_PELOCK_SETKEY_DIALOG (English (U.S.))

[CLS:CPelock_setkeyApp]
Type=0
HeaderFile=pelock_setkey.h
ImplementationFile=pelock_setkey.cpp
Filter=N

[CLS:CPelock_setkeyDlg]
Type=0
HeaderFile=pelock_setkeyDlg.h
ImplementationFile=pelock_setkeyDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=IDC_USERNAME



[DLG:IDD_PELOCK_SETKEY_DIALOG]
Type=1
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342308352
Class=CPelock_setkeyDlg

[DLG:IDD_PELOCK_SETKEY_DIALOG (English (U.S.))]
Type=1
Class=CPelock_setkeyDlg
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDC_STATIC,static,1342308352
Control3=IDC_USERNAME,edit,1350631552

