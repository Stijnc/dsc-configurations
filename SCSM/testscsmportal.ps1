configuration testscsmportal {
    


    import-dscresource -moduleName cSCSM

    $pwd = ConvertTo-SecureString "Azure911-" -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential ("vnextdemo\scinstaller", $pwd)
 $scsmadmin = New-Object System.Management.Automation.PSCredential ("vnextdemo\stijn", $pwd)

 node 'scsm4-test' {

    cSCSMPortal Portal {
        installPath = 'C:\inetpub\wwwroot\SCSMPortal'
        Ensure = 'Present'
        WebSiteName  = 'scsm1'
        WebSitePort = '80'
        SourcePath = 'C:\Setup\Setup'
        Credential = $creds
        PsDscRunAsCredential = $scsmadmin
    }
    }
}

#$cred = get-credential -username vnextdemo\scinstaller -Message 'a'
#$admin = Get-Credential -UserName vnextdemo\stijn -Message 'a'

$ConfigData = @{
    AllNodes = @(
         @{
            NodeName = "scsm4-test"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser= $true
        }
       )}



testscsmportal  -ConfigurationData $configdata -Verbose 

#Start-DscConfiguration .\testscsmportal -Wait -Verbose -Debug -force