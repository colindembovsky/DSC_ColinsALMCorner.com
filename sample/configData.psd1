@{
    AllNodes = @(
        @{
            NodeName = "*"
            CommonConfigMessage = "Hello this is common"
         },

        @{
            NodeName = "localhost"
            Role = "WebServer"
            NodeConfigMessage = "Localhost message"
         }

        <#@{
            NodeName = "otherserver"
            Role = "SqlServer"
            NodeConfigMessage = "otherserver message"
         }#>
    );
}