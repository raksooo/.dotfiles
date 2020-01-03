#InstallKeybdHook
SetCapsLockState, alwaysoff

BindKey("a", "!")
BindKey("s", """")
BindKey("d", "<")
BindKey("f", ">")
BindKey("g", "@")
BindKey("h", "{")
BindKey("j", "[")
BindKey("k", "(")
BindKey("l", ")")
BindKey("SC027", "]")
BindKey("SC028", "}")
BindKey("u", "/")
BindKey("i", "&")
BindKey("o", "|")
BindKey("p", "=")
BindKey("SC01A", "\")
BindKey("m", "$")
BindKey("SC01B", "~")

BindKey(key, char) {
	fn := Func("SendKey").Bind(char)
	Hotkey, CapsLock & %key%, %fn%
	Hotkey, <^>!%key%, %fn%
}

SendKey(key) {
	SendRaw % key
}

CapsLock up::
	Send {Esc}
	return

RAlt up::
	Send {Esc}
	return