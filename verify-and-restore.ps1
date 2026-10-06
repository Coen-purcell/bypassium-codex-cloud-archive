param(
    [Parameter(Mandatory = $true)]
    [string]$Destination
)

$ErrorActionPreference = 'Stop'
$archiveRoot = $PSScriptRoot
$destinationRoot = [IO.Path]::GetFullPath($Destination)
New-Item -ItemType Directory -Path $destinationRoot -Force | Out-Null

$archives = Get-ChildItem -LiteralPath $archiveRoot -File -Filter '*.zip' |
    Where-Object { $_.Name -notin @('workspace-outputs.zip', 'workspace-work.zip') } |
    Sort-Object Name

foreach ($archive in $archives) {
    Write-Host "Extracting $($archive.Name)..."
    Expand-Archive -LiteralPath $archive.FullName -DestinationPath $destinationRoot -Force
}

$manifestPath = Join-Path $archiveRoot 'manifest-sha256.csv'
$manifest = Import-Csv -LiteralPath $manifestPath
$failures = [System.Collections.Generic.List[string]]::new()

foreach ($entry in $manifest) {
    $relativePath = $entry.path.Replace('/', [IO.Path]::DirectorySeparatorChar)
    $restoredPath = Join-Path $destinationRoot $relativePath
    if (-not (Test-Path -LiteralPath $restoredPath -PathType Leaf)) {
        $failures.Add("MISSING $($entry.path)")
        continue
    }
    $file = Get-Item -LiteralPath $restoredPath
    if ($file.Length -ne [long]$entry.bytes) {
        $failures.Add("SIZE $($entry.path) expected=$($entry.bytes) actual=$($file.Length)")
        continue
    }
    $actualHash = (Get-FileHash -LiteralPath $restoredPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actualHash -ne $entry.sha256) {
        $failures.Add("HASH $($entry.path) expected=$($entry.sha256) actual=$actualHash")
    }
}

if ($failures.Count) {
    $failurePath = Join-Path $archiveRoot 'restore-failures.txt'
    $failures | Set-Content -LiteralPath $failurePath -Encoding utf8
    throw "Restore verification failed for $($failures.Count) file(s). See $failurePath"
}

Write-Host "Verified $($manifest.Count) files at $destinationRoot"
