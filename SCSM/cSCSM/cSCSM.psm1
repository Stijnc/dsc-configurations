enum Ensure {
    Absent
    Present
}

[DscResource()]
class cSCSMPortal {

    [DscProperty(Mandatory)]
    [Ensure]$Ensure

    #sdkservername
    [DscProperty(key)]
    [string]$WebSiteName

    [DscProperty(Mandatory)]
    [PSCredential]$Credential

    [DscProperty()]
    [string]$installPath = 'C:\inetpub\wwwroot\SelfServicePortal'

    [DscProperty()]
    [string]$WebSitePort = '80'

    [DscProperty()]
    [string]$Certificate

    [DscProperty(Mandatory)]
    [string]$SourcePath

    [DscProperty()]
    [ValidateSet('No','Yes')]
    [System.String]$CustomerExperienceImprovementProgram

    [DscProperty()]
    [ValidateSet('No','Yes')]
    [System.String]
    $EnableErrorReporting = 'No'

    [DscProperty(NotConfigurable)]
    [Nullable[System.Byte]]$UseComputerName
<#
    /SDKServerName:<Self-service portal name>
   	/PortalWebSitePort:<Port number for Self-service portal>
   	/PortalWebSiteCertificate:<SSL Certificate for Self-service portal>
	/PortalAccount:<DomainName>\<AccountName>\<AccountPassword>
		Use this account for self-service portal
		DomainName - Valid domain name
		AccountName - Valid account name on this domain
		AccountPassword - Valid password for this account
	/Installpath:<FolderPath>
    SetupWizard.exe /Install:SelfServicePortal /silent /accepteula  /SDKServerName:<SDK Server Name> /PortalWebSitePort:4148 /PortalAccount:<domain>\<user>\<pwd>
    #>
    [void]Set(){
        $path = Join-path -Path $this.sourcePath -ChildPath 'setup.exe'
        $Path = ResolvePath $Path
        $Version = (Get-Item -Path $Path).VersionInfo.ProductVersion

        switch($Version) {
            "7.5.3079.500" {
                $IdentifyingNumber = '{17F5D20F-47FB-485E-8CFC-4768C3C3F460}'
                $MSIIdentifyingNumber = '{17F5D20F-47FB-485E-8CFC-4768C3C3F460}'
            }
            Default {
                throw 'Unknown version of the SCSM Portal!'
            }
        }

        switch($this.Ensure){
            'Present' { 
                $Arguments = '/Install:SelfServicePortal /silent /accepteula'
                #username is already in format domain\username. we could also use the domain - username properties of GetNetworkCredential if needed
                $ArgumentVars = @{
                    SDKServerName = $this.WebSiteName
                    InstallPath = $this.installPath
                    PortalWebsitePort = $this.WebSitePort
                    PortalAccount = -Join $this.Credential.UserName, '\', $this.Credential.GetNetworkCredential().Password
                    CustomerExperienceImprovementProgram = $this.CustomerExperienceImprovementProgram
                    EnableErrorReporting = $this.EnableErrorReporting
                }

                if($this.Certificate) {
                    $ArgumentVars.Add('PortalWebSiteCertificate', $this.Certificate)
                }
                $ArgumentVars.GetEnumerator() | ForEach-Object {
                    $Arguments += "/$_`:" + $_.Value
                }
                
                Write-Verbose "Path: $Path"
                Write-Verbose "Arguments: $Arguments"

                $Process = Start-Process -Path $Path -Arguments $Arguments -Wait
                Write-Verbose $Process

                if((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations' -ErrorAction SilentlyContinue) -ne $null)
                {
                    $global:DSCMachineStatus = 1
                }
                else
                {
                    if(!($this.Test()))
                    {
                        throw "Set() failed"
                    }
                }
            }
            'Absent'{
                $Arguments = '/uninstall:SelfServicePortal /Silent'
            }
        }
    }

    [bool] Test(){
        $present = $this.Get()
        if($this.Ensure -eq [Ensure]::Present){
            return $present
        }
        else {
            return -not $present
        }
    }

    [cSCSMPortal] Get() {
        $path = Join-path -Path $this.sourcePath -ChildPath 'setup.exe';
        $Path = ResolvePath $Path
        $Version = (Get-Item -Path $Path).VersionInfo.ProductVersion

        switch($Version) {
            "7.5.3079.500" {
                $IdentifyingNumber = '{17F5D20F-47FB-485E-8CFC-4768C3C3F460}'
                $InstallRegVersion = '2010'
            }
            Default {
                throw "Unknown version of the SCSM Portal!"
            }
        }

        if(Get-CimInstance win32_product -Filter "IdentifyingNumber = $this.IdentifyingNumber"){
            $PortalAccountDomain = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalAccountDomain
            $PortalAccountName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalAccountName
            $PortalUseComputerName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalUseComputerName
            $PortalVirtualDirectory = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalVirtualDirectory
            $PortalWebSiteCertificate = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalWebSiteCertificate
            $PortalWebSiteName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalWebSiteName
            $PortalWebSitePort = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\System Center\$this.InstallRegVersion\Service Manager\Setup" -Name "PortalAccountDomain").PortalWebSitePort
        
            $this.Ensure = [Ensure]::Present
            $this.WebSiteName = $PortalWebSiteName
            $this.WebSitePort = $PortalWebSitePort
            $this.Certificate = $PortalWebSiteCertificate
            $this.InstallPath = $PortalVirtualDirectory
            $this.Credential = [PSCredential]::Empty
            $this.UseComputerName = $PortalUseComputerName
        }
        else {
            $this.Ensure = [Ensure]::Absent
            $this.UsecomputerName = $null
                
        }
        return $this
    }
}