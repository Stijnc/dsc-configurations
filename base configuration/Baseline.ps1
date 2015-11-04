Configuration Baseline {

    Import-DscResource -ModuleName xTimezone, xSystemSecurity, xNetworking, PSDesiredStateConfiguration
    
    #timezone

    #UAC

    #Servermanager
    Registry ServerManager {
        Ensure = "Present"
        Key = "HKLM:\SOFTWARE\Microsoft\ServerManager"
        ValueName = "DoNotOpenServerManagerAtLogon"
        ValueData = "1"
        ValueType = "Dword" }
    #IEESC
    xSystemSecurity


    #xNetworking --> firewall

}