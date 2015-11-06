configuration baseline {

    import-module xNetworking, 
                  PsDesiredStateConfiguration, 
                  xPSDesiredStateConfiguration, 
                  xSystemSecurity, 
                  xTimeZone, 
                  xInternetExplorerHomePage,
                  xPowerShellExecutionPolicy

     $admin = get-credential
     $adminMembers = @($admin.UserName)
     if((Get-ciminstance Win32_ComputerSystem).PartOfDomain){
        
          switch ((Get-ciminstance Win32_ComputerSystem).Domain){
              'vnextdemo1' {
                $adminmembers += 'vnextdemo\serveradmins'
              }
          }
      }

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

    User InovativLocalAdmin {
        Ensure = 'Present'
        UserName = $admin.UserName
        Description = 'Inovativ local admin'
        FullName = 'Inovativ Local Admin'
        Password = $admin
        PasswordChangeNotAllowed = $true
        PasswordChangeRequired = $false
        PasswordNeverExpires = $true
    }

    xGroup AdministratorsIncludeLocalAdmin {
        Ensure = 'Present'
        GroupName = 'Administrators'
        MembersToInclude = $adminMembers
        DependsOn = '[User]InovativLocalAdmin'
    }
   
   #bad
    xIEEsC ESCAdmin {
       UserRole = 'Administrators'
       IsEnabled = $false
    }

    #bad
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

    xPowerShellExecutionPolicy RemoteSigned{
        ExecutionPolicy = 'RemoteSigned'
    }
}