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
        It "Is valid Powershell (Has no script errors)" {

                $contents = Get-Content -Path $sut -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
                $errors.Count | Should Be 0
            }
        It 'Should only contain exactly one configuration' {
            ((get-command baseline).CommandType).Count | Should BeExactly 1
            
        }
        It 'Should have help' {
            (get-command baseline).Definition | should Match '\.SYNOPSIS'
            (get-command baseline).Definition | should Match '\.DESCRIPTION'
            (get-command baseline).Definition | should Match '\.EXAMPLE'
            
        }
        It 'Should fail if the xNetworking dsc module is not available' {
            
            
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
        
        It 'Should generate a valid mof' {
            baseline -OutputPath $OutputPath
            mofcomp -check $OutputPath\localhost.mof | select-string 'Error*' | Should Not Exist
            
        }
        AfterEach{
            Remove-Item TestDrive:\* -Recurse
        }
    }
}

