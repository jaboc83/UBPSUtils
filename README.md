## UnsignedBytes PowerShell Utilities

The UnsignedBytes PowerShell Utilities provide a miscellaneous set of helper
functions that come in handy while performing PowerShell development.

**To Build:**

Building this project is not required to use it. You can just download the
zip file for the version you would like from the location listed below if
you don't want to build the artifacts yourself.

[Download Latest Stable Release (v0.0.1)](https://github.com/unsignedbytes/UBPSUtils/raw/master/dist/UnsignedBytes.PowerShellUtilities-0.0.1.zip)

Prerequesites: UnsignedBytes BuildTools (https://github.com/unsignedbytes/UBBuildTools/)

```PowerShell
git clone https://github.com/unsignedbytes/UBPSUtils/
cd ./UBPSUtils/
psbuild
```

**To Install:**

Grab the latest UnsignedBytes.PowerShellUtilities-x.x.x.zip file to get all the required
artifacts and unzip the contents to:

```PowerShell
%UserProfile%\Documents\WindowsPowerShell\Modules\UnsignedBytes.PowerShellUtilities\
```

**Available Utilities**

*See the PS help for each of the following Utility functions for details and examples*
```PowerShell
Get-Help about_UnsignedBytes.PowerShellUtilities
```

Use Get-Help to view the help file for any specific Comdlet.

* Export-ZipFile - Unzips a zip file

