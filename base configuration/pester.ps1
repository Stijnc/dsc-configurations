Invoke-Pester -Path .\baseline.Tests.ps1 -CodeCoverage .\baseline.ps1

Invoke-Pester -OutputFile output.xml -OutputFormat NUnitXml -Quiet


Invoke-ScriptAnalyzer . -Recurse -Severity Error, Information, Warning