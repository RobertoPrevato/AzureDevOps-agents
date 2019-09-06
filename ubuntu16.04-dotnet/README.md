# Azure DevOps image for .NET Core workloads
This Docker image includes the .NET Core sdks listed below, and also: `PowerShell Core`, `Az Module`.

**⚠️ Attention**: this image includes only most recent versions of .NET Core. If you need different versions of .NET Core SDKs, edit `dotnetcore-sdk.sh` to match your needs.

```bash
# dotnet --info
.NET Core SDK (reflecting any global.json):
 Version:   2.2.401
 Commit:    729b316c13

Runtime Environment:
 OS Name:     ubuntu
 OS Version:  16.04
 OS Platform: Linux
 RID:         ubuntu.16.04-x64
 Base Path:   /usr/share/dotnet/sdk/2.2.401/

Host (useful for support):
  Version: 2.2.6
  Commit:  7dac9b1b51

.NET Core SDKs installed:
  2.1.100 [/usr/share/dotnet/sdk]
  2.1.301 [/usr/share/dotnet/sdk]
  2.2.401 [/usr/share/dotnet/sdk]

.NET Core runtimes installed:
  Microsoft.AspNetCore.All 2.1.12 [/usr/share/dotnet/shared/Microsoft.AspNetCore.All]
  Microsoft.AspNetCore.All 2.2.6 [/usr/share/dotnet/shared/Microsoft.AspNetCore.All]
  Microsoft.AspNetCore.App 2.1.12 [/usr/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.AspNetCore.App 2.2.6 [/usr/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 2.0.5 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 2.1.12 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 2.2.6 [/usr/share/dotnet/shared/Microsoft.NETCore.App]
```
