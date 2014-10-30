#DSC_ColinsALMCorner.com
This is a custom set of custom DSC resources. The following resources are included:
- cScriptWithParams

To use the resource, place the entire DSC_ColinsALMCorner.com directory into %ProgramFiles%\WindowsPowerShell\Modules. Be aware that you need this to be on the server you're "compiling" your DSC scripts on, as well as on any target servers you're going to deploy to.

##cScriptWithParams
This is a customization of the Script Resource that allows you to gracefully handle variables. Here's an example script:
```powershell
Configuration TestScript
{
    param (
        $ScriptMessage
    )

    Import-DscResource -Name cScriptWithParams

    Node $AllNodes.NodeName
    {
        cScriptWithParams Testing
        {
            GetScript =
            {
                @{ Name = "Testing script" }
            }
            SetScript =
            {
                Write-Verbose "Running set script"
                Write-Verbose "ScriptMessage = [$ScriptMessage]"
                Write-Verbose "globalVar = [$globalVar]"
                Write-Verbose "CommonConfigMessage = [$CommonConfigMessage]"
                Write-Verbose "NodeConfigMessage = [$NodeConfigMessage]"
            }
            TestScript =
            {
                Write-Verbose "Running test script"
                $false
            }
            cParams =
            @{ 
                globalVar = $globalVar;
                ScriptMessage = $ScriptMessage;
                CommonConfigMessage = $Node.CommonConfigMessage;
                NodeConfigMessage = $Node.NodeConfigMessage;
            }
        }
    }
}

# uncomment below to debug
#$DebugPreference = "Continue"

$globalVar = "I'm a little global var"

# test from command line
TestScript -ConfigurationData configData.psd1 -ScriptMessage "This is a script message!"
Start-DscConfiguration -Path .\TestScript -Verbose -Wait
```
The cScriptWithParams is imported using `Import-DscResource -Name cScriptWithParams` at the top of the script. Thereafter, you'll see the Get-/Set-/Test- Scripts that the normal Script resource has (you'll also be able to use `Credential` and `DependsOn`).

The parameters you want to pass into the scripts are defined in `cParams`. This is a hash-table of key-value pairs, where the key is the variable name which you reference in the scripts with a $ (so `globalVar` is referenced by `$globalVar` inside the Get-/Set-/Test- scripts). The values can come from global variables, configData (like `$Node.SomeProperty`) or hard-coded.

The only limitation is that the values must be strings.

To see this resource in action, see the following blog post: http://colinsalmcorner.com/post/real-config-handling-for-dsc-in-rm
