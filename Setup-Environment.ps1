$preRequisites = @('Helm.Helm', 'Kubernetes.kubectl')
$clusterCtlVersion = "1.7.3"

$preRequisites | ForEach-Object {
    $package = $_
    Write-Host Installing $package ... -ForegroundColor Green

    winget install --id=$package  -e
}

function Install-BinaryTool($Name, $Uri, $Output) {
    $directory = [System.IO.Path]::GetDirectoryName($Output)
    Write-Host Installing $Name -ForegroundColor Green

    if (Test-Path $Output) {
        Write-Host Tool already installed >> $Name ... -ForegroundColor Yellow
        return
    }

    Write-Host Creating Install Directory ... $Name -ForegroundColor Green
    New-Item $directory -ItemType Directory -Force

    curl.exe -L $Uri -o $Output
}

function Test-Kubernetes() {
    $result = kubectl cluster-info
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to connect to kubernetes (Exit Code: $LASTEXITCODE):" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
    }
    else
    {
        Write-Host "Successfully Connected to Kubernetes!" -ForegroundColor Green
        Write-Host $result
    }
}

function Add-SessionPath {
    param (
        $Path
    )
    
    $env:Path = "$Path;" + $env:Path
}

Add-SessionPath "$PSScriptRoot\tools"

Install-BinaryTool `
    -Name "ClusterCTL v$clusterCtlVersion" `
    -Uri "https://github.com/kubernetes-sigs/cluster-api/releases/download/v$clusterCtlVersion/clusterctl-windows-amd64.exe" `
    -Output "$PSScriptRoot\tools\clusterctl.exe"

Test-Kubernetes