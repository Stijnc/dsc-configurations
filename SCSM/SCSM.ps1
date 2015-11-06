Configuration SCSM {
    
    Import-DscResource -ModuleName  xPSDesiredStateConfiguration, 
                                    PSDesiredStateConfiguration,
                                    xWebadministration
    
    $uriLogo = 'https://raw.githubusercontent.com/Stijnc/dsc-configurations/master/SCSM/LogoStar.gif'


    Node Portal {
        #install windows features
        WindowsFeature webServerIIS {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        WindowsFeature webAspNet45 {
            Ensure = 'Present'
            Name = 'Web-Asp-Net45'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        WindowsFeature httpActivation {
            Ensure = 'Present'
            Name = 'NET-HTTP-Activation'
        }

        WindowsFeature dotNet35 {
            Ensure = 'Present'
            Name = 'NET-Framework-Core'
        }

        WindowsFeature basicAuthentication {
            Ensure = 'Present'
            Name = 'Web-Basic-Auth'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        WindowsFeature windowsAuthentication {
            Ensure = 'Present'
            Name = 'Web-Windows-Auth'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        WindowsFeature netExtensibility45 {
            Ensure = 'Present'
            Name = 'Web-Net-Ext45'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        WindowsFeature asp {
            Ensure = 'Present'
            Name = 'Web-ASP'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        WindowsFeature aspNet45 {
            Ensure = 'Present'
            Name = 'NET-Framework-45-ASPNET'
            DependsOn = '[WindowsFeature]webServerIIS'
        }

        xWebsite DefaultSite {
            Ensure = 'Present'
            Name = 'Default Web Site'
            State = 'Stopped'
            PhysicalPath = "$env:Systemdrive\intepub\wwwroot"
            DependsOn = '[WindowsFeature]webServerIIS'
        }


        #SCSM portal --> TODO custom resource needed
        #AppSettings --> TODO

        File tmpFolder {
            Ensure = 'Present'
            Type = 'Directory'
            DestinationPath = "$env:Systemdrive\tmp"
        }

        #copy logo --> Change after package deployment
        xRemoteFile logo {
            DestinationPath = "$env:Systemdrive\tmp"
            Uri = $uriLogo
            UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent]::InternetExplorer
            Headers = @{"Accept-Language" = "en-US"}
            DependsOn = '[File]tmpFolder'
        }
        

        


    }
}