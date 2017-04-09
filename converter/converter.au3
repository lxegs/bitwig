
; DEBUG POSSIBLE AVEC: MsgBox (0, "Test de variable", "NomDeLaVariable = " & $NomDeLaVariable)

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Include <Date.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <XML.au3>

; Options AutoIt:
#NoTrayIcon
AutoItSetOption("MustDeclareVars", 1)

; Variables:
Dim $ApplicationName, $AutoItName, $LogPath, $AutoItLogFile, $ErrorCode
Dim $WorkingFolder
Dim $ADVSourceList, $ADVSource,$MultiSampleDestination
Dim $7zip, $unzipcmdline, $zipcmdline
Dim $multisamplenamesource,$multisamplenamedest

$WorkingFolder = "D:\temp\converter\"

$ApplicationName = "ADV Converter"
$AutoItName = "ADV_Converter.exe"
$LogPath = $WorkingFolder

$7zip = "D:\temp\converter\7z.exe"



; Log:
DirCreate($LogPath)
$AutoItLogFile = FileOpen($LogPath & $AutoItName & ".log",1)
WriteLog("--> Starting Converting")

; Main

; Construct adv array to convert
$ADVSourceList = _FileListToArray ($WorkingFolder, "*.adv")
$ADVSource = PrintList($ADVSourceList)
WriteLog("--> ADV source files are " & """" & $ADVSource & """")

; prepare multisample parameters
$MultiSampleDestination = _GetFileNameExExt($ADVSource)
WriteLog("--> Multisample will be called " & $MultiSampleDestination & ".multisample")
FileCopy($WorkingFolder & "template.xml",$WorkingFolder & "multisample.xml",1)

; unzip adv file
$unzipcmdline = $7zip & ' x ' & $ADVSource & ' -o"d:\temp\converter"'
WriteLog("--> ADV extract ")
;~ RunWait($unzipcmdline,$WorkingFolder)

; change multisample name
$multisamplenamesource = '<multisample name="template">'
$multisamplenamedest = '<multisample name=' & """" & $MultiSampleDestination & """" & '>'
WriteLog("remplacement du multisample name dans la template :" & $multisamplenamedest)
_ReplaceStringInFile($WorkingFolder & "multisample.xml",$multisamplenamesource,$multisamplenamedest)
















; END :


; Fonction WriteLog:
Func WriteLog($Log)
	FileWriteLine($AutoItLogFile, $Log)
EndFunc

; Fonction de sortie avec gestion de code d'erreur:
Func ExitProgram($ErrorCode)
	If $ErrorCode = 0 Then
		WriteLog(" ->  SUCCES")
	Else
		WriteLog(" ->  ERREUR")
	EndIf
	FileClose($AutoItLogFile)
	Exit($ErrorCode)
EndFunc


Func PrintList($List)
    Local $txt = ""
        For $i = 1 to UBound($List) -1
            $txt = $txt & "," & $List[$i]
        Next
        Local $out = StringMid($txt,2)
        Global $Result = $out
        ConsoleWrite($Result)
        Return $Result
EndFunc

Func _GetFileNameExExt($gFileName) ; Requires A Full Path Or FileName. [C:\Program Files\AutoIt3.chm Or AutoIt3.chm]
    #cs
        Description: Removes The FileName Extension.
        Returns: FileName Without The Extension.
    #ce
    Local $gTempString = StringRight($gFileName, 1)
    While 1
        If $gTempString = "." Then
            $gFileName = StringTrimRight($gFileName, 1)
            Return $gFileName
        Else
            $gFileName = StringTrimRight($gFileName, 1)
            $gTempString = StringRight($gFileName, 1)
        EndIf
    WEnd
EndFunc   ;==>_GetFileNameExExt

