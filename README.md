Copy a file or directory from your local Windows machine to a set of remote Windows machines for which you have only IP addresses.

Parameters:

* IPsFile: File path to a text file with the IP address of each machine on a different line. The example.txt file has an example of what this file might look like
* Source: The file or directory on your local machine that you want to copy
* Destination: The directory on the remote machines where the file or directory should be copied to

Example usage:

```PowerShell
.\multicopy.ps1 -IPsFile "example.txt" -Source "C:\data\example.csv" -Destination "C:\data\copied"
```

When you run the script, you will be presented with a box to enter the credentials for the remote machines. The remote machines must already be configured to have remote access enabled and must all be accessible using the same credentials.

**Caution**: This script temporarily modifies the TrustedHosts of your local machine, which is required when accessing remote machines by IP address. You must therefore run this script from an elevated PowerShell process. Authentication protocol is NTLM, not Kerberos. 
