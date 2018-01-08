# PreCommit

A Powershell Git hook for preventing checking in of source code with potential Azure secrets  

1.	If storing application settings, create a file named PrivateSettings.config in each of your projects at the parent level, with the following structure, and use for storing secret configuration items:  
&lt;?xml version="1.0" encoding="utf-8" ?>  
&lt;appSettings>  
&lt;/appSettings>  
2.  If storing connection strings, create a file named PrivateConnectionStrings.config in each of your projects at the parent level, with the following structure, and use for storing secret connection strings:  
&lt;?xml version="1.0" encoding="utf-8" ?>  
&lt;connectionStrings>  
&lt;/connectionStrings>  
3.  In Visual Studio, ensure the files are included in the solution, and set them to have the value ‘Copy if newer’ for the property ‘Copy to Output Directory’  
4.  Edit the solutions App.config or Web.config file(s) and modify the appSettings element to contain a file attribute as follows:  
&lt;appSettings file="PrivateSettings.config">  
5.  Edit the solutions App.config or Web.config file(s) and modify the connectionStrings element to contain a configSource attribute as follows:  
&lt;connectionStrings configSource="PrivateConnectionStrings.config">  
6.  Edit your repositories .gitignore file and add the following directly beneath the beginning 4 comment lines:  
&#35; Secrets  
&#42;&#42;/PrivateSettings.config  
&#42;&#42;/PrivateConnectionStrings.config  
7.  Place the following files from this repo into the .git\hooks directory in your solution directory (you may need to show hidden files and directories):  
&#42; PreCommit.ps1  
&#42; pre-commit

### Application Insights
If using application insights ensure the InstrumentationKey node is removed from the InstrumentationKey.config file (it will be detected by the script). Instead, populate the key in a suitable location within the application, storing the value in a PrivateSettings.config.

#### MVC Application Example

*Global.asax.cs*  
protected void Application_Start()  
{  
    Microsoft.ApplicationInsights.Extensibility.TelemetryConfiguration.Active.InstrumentationKey =  
        ConfigurationManager.AppSettings["InstrumentationKey"];  
        // ...  
}  

*PrivateSettings.config*  
&lt;?xml version="1.0" encoding="utf-8" ?>  
&lt;appSettings>  
    &lt;add key="InstrumentationKey" value="..." />  
    &lt;!-- ... -->  
&lt;/appSettings>
