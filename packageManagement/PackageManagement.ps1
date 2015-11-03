Configuration PackageManagement {
    
    Import-DscResource -ModuleName PackageManagementProviderResource

    Node Test {
        
        PackageManagementSource SourceRepoChocolatey {
            
            Ensure = "Present"
            Name = "Chocolatey"
            ProviderName = "Chocolatey"
            SourceUri = "http://chocolatey.org/api/v2/"
            InstallationPolicy = "Untrusted"

        }

        PackageManagementSource SourceRepoInovativ {
            
            Ensure = "Present"
            Name = "InovativPackage"
            ProviderName = "Chocolatey"
            SourceUri = "http://inovativapplicationgallery.azurewebsites.net/api/v2"
            InstallationPolicy = "Trusted"

        }

    }
}