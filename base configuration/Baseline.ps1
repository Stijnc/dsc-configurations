configuration baseline {
<#
.SYNOPSIS
    this is some automatically-update-help-files-for-windows-powershell
#>
param(
    [PSCredential]$credential
)
    import-dscresource -ModuleName xNetworking
    import-dscresource -ModuleName PsDesiredStateConfiguration
    import-dscresource -ModuleName xSystemSecurity
    import-dscresource -ModuleName xTimeZone
    import-dscresource -ModuleName xInternetExplorerHomePage
    import-dscresource -ModuleName xPowerShellExecutionPolicy

     Registry ServerManagerOobe {
        Ensure = 'Present'
        Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Oobe'
        ValueName = 'DoNotOpenInitialConfigurationTasksAtLogon'
        ValueData = '1'
        ValueType = 'DWORD'
    }

     Registry ServerManager {
        Ensure = 'Present'
        Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager'
        ValueName = 'DoNotOpenServerManagerAtLogon'
        ValueData = '1'
        ValueType = 'DWORD'
    }
   
     #bad practice
     xIEEsC ESCAdmin {
       UserRole = 'Administrators'
       IsEnabled = $false
    }

     #bad practice
     xIEEsC ESCUser {
        UserRole = 'Users'
        ISEnabled = $false
    }

     xUAC NotifyChanges {
        Setting = 'NotifyChanges'
    }

     #(UTC+01:00) Brussels, Copenhagen, Madrid, Paris
     xTimeZone UTC1 {
        TimeZone = 'Romance Standard Time'
        IsSingleInstance = 'Yes'
    }

     xInternetExplorerHomePage Google {
        StartPage = 'http://www.google.be'
        Ensure = 'Present'
    }

     #This is a good setting, if needed, can be changed but after interval it gets put back to RemoteSigned
     xPowerShellExecutionPolicy RemoteSigned{
        ExecutionPolicy = 'RemoteSigned'
    }

    #http://blog.powershell.no/2013/03/09/automatically-update-help-files-for-windows-powershell/

    <#services
        task scheduler
        windows firewall
        windows time
        winrm
        WinMgmt
        TrustedInstaller
        WindowsUpdate

    #>

}
