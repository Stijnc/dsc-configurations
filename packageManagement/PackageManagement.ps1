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

    Node installPackage {

        PackageManagementSource SourceRepoChocolatey {
            
            Ensure = "Present"
            Name = "Chocolatey"
            ProviderName = "Chocolatey"
            SourceUri = "http://chocolatey.org/api/v2/"
            InstallationPolicy = "Untrusted"

        }
<#
 The nugetpackage has the provider hardcoded to nuget. So setting the source to Chocolatey will fail anyhow
 TODO: update the PackageManagementProviderResource module with a ChocolateyPackage resource 
        NugetPackage Notepadplusplus {
            Ensure = "Present"
            Name = "notepadplusplus"
            Source = "Chocolatey"
            DependsOn = "[PackageManagementSource]SourceRepoChocolatey"
            DestinationPath = "$env:ProgramFiles\notepadplusplus"
            InstallationPolicy = "trusted"
        }
#>
        PSModule Pester {
            Ensure = "Present"
            Name = "Pester"
            Repository = "PSGallery"
            InstallationPolicy="trusted"
        }

        PSModule xNetworking {
            Ensure = "Present"
            Name = "xNetworking"
            Repository = "PSGallery"
            InstallationPolicy="trusted"
        }

        
    }
}
