Configuration SCSM {

    Import-DscResource -ModuleName xPSDesiredStateConfiguration, PSDesiredStateCongfi
    
    Node Portal {
        #install windows features
        WindowsFeature webServerIIS
        {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature aspNet45 {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature httpActivation {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature dotNet35 {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature basicAuthentication {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature windowsAuthentication {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature netExtensibility45 {
            Ensure = 'Present'
            Name = ''
        }

        WindowsFeature asp {
            Ensure = 'Present'
            Name = ''
        }
        WindowsFeature aspNet452 {
            Ensure = 'Present'
            Name = ''
        }

        File tmpFolder {
            Ensure = 'Present'
            Type = 'Directory'
            DestinationPath = "$env:Systemdrive\tmp"
        }
        #install package

        #copy logo
        xRemoteFile 
        #AppSettings


    }
}