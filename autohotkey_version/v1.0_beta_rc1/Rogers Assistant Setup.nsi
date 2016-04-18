;--------------------------------
; Copyrights by Roger Jaggi
;--------------------------------
;
; Installer for Rogers Assistant


;--------------------------------
;Constants

!define PRODUCT_NAME "Rogers Assistant"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Roger Jaggi"
!define PRODUCT_WEB_SITE "http://rogersassistant.rogerworld.ch"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\RogersAssistant.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

;--------------------------------
;Include Modern UI

  !include "MUI.nsh"

;--------------------------------
;General

  Name "${PRODUCT_NAME}"
  OutFile "Rogers Assistant Setup.exe"
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
;Language Selection Dialog Settings

  !define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
  !define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "RASetupLanguage"
  
  
;--------------------------------
;Pages
  
  !insertmacro MUI_PAGE_WELCOME
  !define MUI_LICENSEPAGE_RADIOBUTTONS
  !insertmacro MUI_PAGE_LICENSE "lizenz.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  Page custom CusPageSettings
  !insertmacro MUI_PAGE_INSTFILES
  !define MUI_FINISHPAGE_RUN "$INSTDIR\RogersAssistant.exe"
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_INSTFILES

;  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "German"

;--------------------------------
;Reserve Files

  ReserveFile "instpage_settings.ini"
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

;--------------------------------
;Variables

  var autostartvalue
  var autoupdatevalue

;--------------------------------
;Installer Sections

Section "Programmdateien" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "header.png"
  File "lizenz.txt"
  File "logo.gif"
  File "raicon.ico"
  File "RogersAssistant.exe"
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Rogers Assistant.lnk" "$INSTDIR\RogersAssistant.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\RogersAssistant.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Einstellungen.lnk" "$INSTDIR\RogersAssistant.exe"
  SetOutPath "$APPDATA"
  SetOverwrite ifnewer
  File "Rogers Assistant.ini"
  !insertmacro MUI_INSTALLOPTIONS_READ $autostartvalue "instpage_settings.ini" "Field 1" "State"
  !insertmacro MUI_INSTALLOPTIONS_READ $autoupdatevalue "instpage_settings.ini" "Field 2" "State"
  WriteINIStr "$APPDATA\Rogers Assistant.ini" "Allgemein" "AutoUpdate" "$autoupdatevalue"
  WriteINIStr "$APPDATA\Rogers Assistant.ini" "Allgemein" "Sprache" $LANGUAGE
  StrCmp $autostartvalue "1" "" +2
	WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Rogers Assistant" "$INSTDIR\RogersAssistant.exe"
	
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\RogersAssistant.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\RogersAssistant.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

;--------------------------------
;Installer Functions

Function CusPageSettings
  !insertmacro MUI_HEADER_TEXT "Einstellungen setzen" "Diese Einstellungen können später auch in ${PRODUCT_NAME} eingestellt werden."
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY "instpage_settings.ini"
FunctionEnd

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "instpage_settings.ini"
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) wurde erfolgreich deinstalliert."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Möchten Sie $(^Name) und alle seinen Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd


;--------------------------------
;Uninstaller Section

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$APPDATA\Rogers Assistant.ini"
  Delete "$INSTDIR\RogersAssistant.exe"
  Delete "$INSTDIR\raicon.ico"
  Delete "$INSTDIR\logo.gif"
  Delete "$INSTDIR\lizenz.txt"
  Delete "$INSTDIR\header.png"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Website.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Einstellungen.lnk"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Rogers Assistant.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "Rogers Assistant"
  SetAutoClose true
SectionEnd