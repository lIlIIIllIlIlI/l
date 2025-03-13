$adminGroup = (New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount]).Value.Split('\')[-1]
try { $groupOutput = net localgroup "$adminGroup" } catch { exit 1 }
$members = $groupOutput -split "`r`n" | Select-String '^-----' -Context 0,1000 | ForEach-Object { $_.Context.PostContext } |Where-Object { $_ -notmatch '命令成功完成|The command completed successfully' } |ForEach-Object { $_.Trim() }
if($members -contains $Env:UserName) { $t = "ok" } else { $t = "n" }; $t;
