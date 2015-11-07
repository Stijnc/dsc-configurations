$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$here
$parent = Split-Path -Path $here
$sut = ($MyInvocation.MyCommand.ToString()).Replace('.Tests.','.')
$sut
. $(Join-Path -Path $here -ChildPath $sut)

if(! (Get-module xWebAdministration -ListAvailable)){
    
}

Describe 'baseline configuration' {
    
    Context 'Configuration Script' {
    
        It 'Should be a DSC configuration script' {
            (get-command baseline).CommandType | Should be 'Configuration'
        }

        It 'Should not be a DSC Meta-configuration' {
            (Get-Command baseline).IsMetaConfiguration | Should Not be $true
        }

        It 'Should use the xNetworking DSC resource module' {
            (Get-command baseline).Definition | Should Match 'xNetworking'
        }
    }

    Context 'Node Configuration' {
        $OutputPath = 'TestDrive:\'

        It 'Should generate a single mof file' {
             baseline -OutputPath $OutputPath
            (Get-ChildItem -Path $OutputPath -File -Filter '*.mof' -Recurse).count | Should be 1
        }
           
        It 'Should generate a mof file with the name "localhost"' {
            baseline -OutputPath $OutputPath
            Join-Path -Path $OutputPath -ChildPath 'localhost.mof' | Should Exist
        }

        AfterEach{
            Remove-Item TestDrive:\* -Recurse
        }
    }
}

