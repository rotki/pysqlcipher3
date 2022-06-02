$BUILD_DIR = $PWD

function ExitOnFailure {
    param([string]$ExitMessage)
    if (-not ($LASTEXITCODE -eq 0)) {
        echo "`n------------`n"
        echo "$ExitMessage"
        echo "`n------------`n"
        exit 1;
    }
}

if ((-not (Test-Path "$Env:Temp\.venv-ci" -PathType Container))) {
    cd "$Env:Temp"
    pip install virtualenv --user
    echo "Creating .venv"
    python -m virtualenv .venv-ci
    ExitOnFailure("Failed to create rotki VirtualEnv")
}

echo "Activating .venv-ci"
& $Env:Temp\.venv-ci\Scripts\activate.ps1
pip install cibuildwheel==2.6.1
ExitOnFailure("Failed to activate rotki VirtualEnv")

$env:CIBW_BEFORE_BUILD = 'PowerShell.exe -File .\build.ps1'
$env:CIBW_BUILD = 'cp39-*'
$env:CIBW_ARCHS = 'native'
$env:CIBW_BUILD_VERBOSITY = 1

cd $BUILD_DIR\build

python -m cibuildwheel --output-dir wheelhouse --platform windows