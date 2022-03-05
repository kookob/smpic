;###########################################################
; @author ob
; @version 2.0.1
; @date 20220305
; http://github.com/kookob/smpic
;###########################################################
#SingleInstance,Force
#NoEnv
SendMode,Input
DetectHiddenWindows,On
SetWinDelay,0
SetKeyDelay,0
SetControlDelay,0
SetBatchLines,10ms
CoordMode,Mouse,Screen

applicationname=smpic
Gosub,READINI
Gosub,TRAYMENU

#Include %A_ScriptDir%\CreateFormData.ahk
#Include %A_ScriptDir%\JSON.ahk

;上传图片
upload(file, secretToken){
	IfExist % file 
	{
		objParam := {"format":"json", "smfile": [file]}
		CreateFormData(PostData, hdr_ContentType, objParam)
		whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		whr.Open("POST", "https://sm.ms/api/v2/upload", True)
		whr.SetRequestHeader("Content-Type", hdr_ContentType)
		whr.SetRequestHeader("Authorization", secretToken)
		whr.Send(PostData)
		whr.WaitForResponse()
		return whr.ResponseText
	}
}

IniRead, key, %applicationname%.ini, Settings, key, ^!s
IniRead, urlType, %applicationname%.ini, Settings, urlType, 0
IniRead, secretToken, %applicationname%.ini, Settings, secretToken, ReplaceWithYourSecretToken
Hotkey, %key%, UploadLabel, On
return

UploadLabel:
clipboard =
send,^c
ClipWait
filepathList = %clipboard%
clipboard = 
Loop, parse, filepathList, `n, `r
{
	filepath = %A_LoopField%
	SplitPath, filepath, filename
	result := upload(filepath, secretToken)
	if(result <> ""){
		resultJson := JSON.Load(result)
		if(resultJson.code = "success"){
			if(clipboard <> "") {
				clipboard := clipboard . "`n"
			}
			if(urlType = 1) {
				clipboard := clipboard . "![" . filename . "](" . resultJson.data.url . ")" ;markdown地址
			} else {
				clipboard := clipboard . resultJson.data.url	;原始地址
			}
			ToolTip, (%A_Index%)上传成功，url已复制到剪切板, A_CaretX, A_CaretY+20
			Sleep 1000
			ToolTip, 
		} else if(resultJson.code = "image_repeated"){
			msg := "(" . A_Index . ")" . resultJson.error . "`n上传图片已存在，原有url已复制到剪切板"
			msgbox % msg
			if(clipboard <> "") {
				clipboard := clipboard . "`n"
			}
			clipboard := clipboard . resultJson.images	;原始地址
		} else {
			msgbox % resultJson.error
		}
	} else {
		msgbox 上传失败，请稍候再试！
	}
}
return

TRAYMENU:
Menu,Tray,NoStandard
Menu,Tray,DeleteAll
Menu,Tray,Add,启用(&E),TOGGLE
Menu,Tray,Add,
Menu,Tray,Add,设置(&S),SETTINGS
Menu,Tray,Add,重启(&R),RESTART
Menu,Tray,Add,
Menu,Tray,Add,关于(&A),ABOUT
Menu,Tray,Add,退出(&Q),EXIT
Menu,Tray,ToggleCheck,启用(&E)
Menu,Tray,Tip,%applicationname%
Return

TOGGLE:
Menu,Tray,ToggleCheck,启用(&E)
Pause,Toggle
Return

SETTINGS:
Gosub,READINI
Run,%applicationname%.ini
Return

RESTART:
Reload
Return

EXIT:
ExitApp

READINI:
IfNotExist,%applicationname%.ini
{
	ini=;%applicationname%.ini
	ini=%ini%`n`;key: 快捷键设置：对应按键win(#),ctrl(^),alt(!),shitf(+)，默认是(^!s)
	ini=%ini%`n`;urlType: 返回结果url：0-原始地址(默认)，1-markdown地址
	ini=%ini%`n`;secretToken: sm.ms账号登录获取: https://sm.ms/home/apitoken
	ini=%ini%`n`;(改完配置，重启生效)
	ini=%ini%`n
	ini=%ini%`n[Settings]
	ini=%ini%`nkey=^!s
	ini=%ini%`nurlType=0
	ini=%ini%`nsecretToken=请配置自己的Secret Token
	ini=%ini%`n
	FileAppend,%ini%,%applicationname%.ini
	ini=
}
Return

ABOUT:
Gui,99:Destroy
Gui,99:Margin,15,15

Gui,99:Font,Bold
Gui,99:Add,Text,y+10, %applicationname% v2.0.1 (20220305)
Gui,99:Font
Gui,99:Add,Text,y+10,选中图片(可多选)按快捷键(默认:Ctrl+Alt+S)上传图片到sm.ms，保存图片地址到剪切板
Gui,99:Font,CBlue Underline
Gui,99:Font

Gui,99:Font,Bold
Gui,99:Add,Text,y+20,github地址(★)
Gui,99:Font
Gui,99:Font,CBlue Underline
Gui,99:Add,Link,y+5, <a href="http://github.com/kookob/smpic">http://github.com/kookob/smpic</a>

Gui,99:Font,Bold
Gui,99:Add,Text,y+20,致谢
Gui,99:Font
Gui,99:Add,Text,y+10,感谢 https://sm.ms 提供的图床

Gui,99:Show,,%applicationname% About
hCurs:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt")
OnMessage(0x200,"WM_MOUSEMOVE") 
Return
