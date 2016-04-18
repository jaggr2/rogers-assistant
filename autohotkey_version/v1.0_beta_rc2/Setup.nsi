;--------------------------------
; Copyrights by Roger Jaggi
;--------------------------------
;
; Installer for Rogers Assistant


;--------------------------------
;Constants

!define PRODUCT_NAME "Rogers Assistant"
!define PRODUCT_VERSION "1.0.2 Beta"
!define PRODUCT_PUBLISHER "Roger Jaggi"
!define PRODUCT_WEB_SITE "http://rogersassistant.rogerworld.ch"
!define PRODUCT_DIR_REGKEY "Software\Rogers Assistant"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;--------------------------------
;Include Modern UI

  !include "MUI.nsh"

;--------------------------------
;General

  Name "${PRODUCT_NAME}"
  OutFile "Rogers Assistant Setup.exe"
  BrandingText "${PRODUCT_NAME} - ${PRODUCT_VERSION}"
  InstallDir "$PROGRAMFILES\Rogers Assistant"
  InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
  ShowInstDetails show
  ShowUnInstDetails show
  SetCompressor lzma

  !define MUI_ABORTWARNING

  !define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-r.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall-r.bmp"

  !define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange-uninstall.bmp"
  
;--------------------------------
;Pages
  
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !define MUI_FINISHPAGE_RUN "$INSTDIR\RogersAssistant.exe"
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_INSTFILES

  ;!insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "German"

;--------------------------------
;Installer Sections

Section "Progammdateien" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "licence.txt"
  File "Config.exe"
  File "RogersAssistant.exe"
  File "Defaultsettings.reg"
  
  SetOutPath "$INSTDIR\images"
  SetOverwrite ifnewer
  File "images\logo.png"
  File "images\rogersassistant.ico"
  File "images\title.png"
  
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Rogers Assistant.lnk" "$INSTDIR\RogersAssistant.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Einstellungen.lnk" "$INSTDIR\Config.exe"

  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallDir" "$INSTDIR\RogersAssistant.exe"
  WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Rogers Assistant" "$INSTDIR\RogersAssistant.exe"

  Exec 'REGEDIT.EXE /S "$INSTDIR\Defaultsettings.reg"'

SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\RogersAssistant.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

;--------------------------------
;Installer Functions

Function .onInit
  ;!insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) wurde erfolgreich deinstalliert."
FunctionEnd

Function un.onInit
  ;!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Möchten Sie $(^Name) und alle seinen Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd


;--------------------------------
;Uninstaller Section

Section Uninstall
  RMDir /r /REBOOTOK "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir /r /REBOOTOK "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Rogers Assistant"
  SetAutoClose true
SectionEnd