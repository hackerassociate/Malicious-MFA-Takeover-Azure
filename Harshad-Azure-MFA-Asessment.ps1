<#
.SYNOPSIS
    Gets the MFA status for all users or a specific user in Microsoft 365.
.DESCRIPTION
    This script gets the MFA status for all users or a specific user in Microsoft 365 using Microsoft Graph PowerShell SDK.
    It shows if MFA is enabled, disabled, or enforced for each user.
.PARAMETER UserPrincipalName
    The UserPrincipalName of the user you want to check MFA status for. If not specified, all users will be checked.
.EXAMPLE
    .\Get-MFAStatus.ps1
    Gets the MFA status for all users.
.EXAMPLE
    .\Get-MFAStatus.ps1 -UserPrincipalName john.doe@contoso.com
    Gets the MFA status for the specified user.
.NOTES
    Version:        1.1
    Author:         Harshad Shah
    Creation Date:  March 1, 2025
    Purpose/Change: Fixed property parameter syntax for Get-MgUser
    
    This script requires the Microsoft Graph PowerShell SDK modules.
    Install them using: Install-Module Microsoft.Graph -Scope CurrentUser
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$UserPrincipalName
)

# Display banner
function Show-Banner {
    $banner = @"
    
 ██████╗ ███████╗███████╗███████╗███╗   ██╗███████╗██╗██╗   ██╗███████╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗ 
██╔═══██╗██╔════╝██╔════╝██╔════╝████╗  ██║██╔════╝██║██║   ██║██╔════╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗
██║   ██║█████╗  █████╗  █████╗  ██╔██╗ ██║███████╗██║██║   ██║█████╗      ██║     ██║     ██║   ██║██║   ██║██║  ██║
██║   ██║██╔══╝  ██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║██║╚██╗ ██╔╝██╔══╝      ██║     ██║     ██║   ██║██║   ██║██║  ██║
╚██████╔╝██║     ██║     ███████╗██║ ╚████║███████║██║ ╚████╔╝ ███████╗    ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝
 ╚═════╝ ╚═╝     ╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝  ╚══════╝     ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ 
                                                                                                                      
██████╗ ███████╗███╗   ██╗████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗                                     
██╔══██╗██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝                                     
██████╔╝█████╗  ██╔██╗ ██║   ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗                                    
██╔═══╝ ██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║                                    
██║     ███████╗██║ ╚████║   ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝                                    
╚═╝     ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝                                     
                                                                                                                      
"@

    $subtitle = @"
    
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                   Offensive Cloud Penetration Testing                      ║
    ║                           Testing MFA Status                               ║
    ║                                                                           ║
    ║                        Author: Harshad Shah                               ║
    ║                        Date: March 1, 2025                                ║
    ║                                                                           ║
    ║                  https://hackerassociate.com                              ║
    ║                  https://blackhattrainings.com                            ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
    
"@

    Write-Host $banner -ForegroundColor Cyan
    Write-Host $subtitle -ForegroundColor Yellow
}

# Function to check if required modules are installed
function Check-RequiredModules {
    $requiredModules = @("Microsoft.Graph.Authentication", "Microsoft.Graph.Users", "Microsoft.Graph.Identity.SignIns")
    $modulesToInstall = @()

    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            $modulesToInstall += $module
        }
    }

    if ($modulesToInstall.Count -gt 0) {
        Write-Host "The following required modules are not installed: $($modulesToInstall -join ', ')" -ForegroundColor Yellow
        $install = Read-Host "Do you want to install these modules now? (Y/N)"
        
        if ($install -eq "Y" -or $install -eq "y") {
            foreach ($module in $modulesToInstall) {
                Write-Host "Installing $module..." -ForegroundColor Cyan
                Install-Module -Name $module -Scope CurrentUser -Force
            }
        } else {
            Write-Host "Required modules are not installed. Script cannot continue." -ForegroundColor Red
            exit
        }
    }
}

# Function to connect to Microsoft Graph
function Connect-ToMicrosoftGraph {
    try {
        # Check if already connected
        $context = Get-MgContext
        if ($null -eq $context) {
            Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
            Connect-MgGraph -Scopes "User.Read.All", "UserAuthenticationMethod.Read.All", "Directory.Read.All"
        } else {
            Write-Host "Already connected to Microsoft Graph as $($context.Account)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Error connecting to Microsoft Graph: $_" -ForegroundColor Red
        exit
    }
}

# Function to get MFA status for users
function Get-UserMFAStatus {
    param (
        [string]$UserFilter
    )

    try {
        # Create an empty array to store the results
        $results = @()

        # Get users based on filter
        if ([string]::IsNullOrEmpty($UserFilter)) {
            Write-Host "Getting all users..." -ForegroundColor Cyan
            $users = Get-MgUser -All -Property "id,displayName,userPrincipalName,accountEnabled"
        } else {
            Write-Host "Getting user with UPN: $UserFilter" -ForegroundColor Cyan
            $users = Get-MgUser -Filter "userPrincipalName eq '$UserFilter'" -Property "id,displayName,userPrincipalName,accountEnabled"
        }

        $totalUsers = $users.Count
        $currentUser = 0

        foreach ($user in $users) {
            $currentUser++
            Write-Progress -Activity "Processing Users" -Status "Processing $($user.DisplayName)" -PercentComplete (($currentUser / $totalUsers) * 100)

            # Get authentication methods for the user
            $authMethods = Get-MgUserAuthenticationMethod -UserId $user.Id
            
            # Initialize MFA status variables
            $mfaStatus = "Disabled"
            $methodTypes = @()
            $defaultMethod = "None"
            
            # Check for MFA methods
            foreach ($method in $authMethods) {
                $methodType = $method.AdditionalProperties.'@odata.type'
                
                switch ($methodType) {
                    "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" { 
                        $methodTypes += "Microsoft Authenticator App"
                        $mfaStatus = "Enabled" 
                    }
                    "#microsoft.graph.phoneAuthenticationMethod" { 
                        $methodTypes += "Phone Authentication"
                        $mfaStatus = "Enabled" 
                    }
                    "#microsoft.graph.fido2AuthenticationMethod" { 
                        $methodTypes += "FIDO2 Security Key"
                        $mfaStatus = "Enabled" 
                    }
                    "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" { 
                        $methodTypes += "Windows Hello for Business"
                        $mfaStatus = "Enabled" 
                    }
                    "#microsoft.graph.softwareOathAuthenticationMethod" { 
                        $methodTypes += "Software OATH Token"
                        $mfaStatus = "Enabled" 
                    }
                    "#microsoft.graph.temporaryAccessPassAuthenticationMethod" { 
                        $methodTypes += "Temporary Access Pass"
                        # TAP alone doesn't count as MFA
                    }
                    "#microsoft.graph.passwordAuthenticationMethod" { 
                        $methodTypes += "Password"
                        # Password alone doesn't count as MFA
                    }
                    "#microsoft.graph.emailAuthenticationMethod" { 
                        $methodTypes += "Email Authentication"
                        $mfaStatus = "Enabled" 
                    }
                }
            }
            
            # If there are multiple methods, determine the default one
            if ($methodTypes.Count -gt 1) {
                # Remove "Password" from the list for determining default MFA method
                $mfaMethods = $methodTypes | Where-Object { $_ -ne "Password" -and $_ -ne "Temporary Access Pass" }
                if ($mfaMethods.Count -gt 0) {
                    $defaultMethod = $mfaMethods[0]  # Just take the first one as default for simplicity
                }
            }
            
            # Create a custom object with the user's MFA status
            $userMFAStatus = [PSCustomObject]@{
                DisplayName       = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                AccountEnabled    = $user.AccountEnabled
                MFAStatus         = $mfaStatus
                MFAMethods        = ($methodTypes | Where-Object { $_ -ne "Password" }) -join ", "
                DefaultMFAMethod  = $defaultMethod
            }
            
            # Add the user's MFA status to the results array
            $results += $userMFAStatus
        }
        
        Write-Progress -Activity "Processing Users" -Completed
        
        return $results
    } catch {
        Write-Host "Error getting MFA status: $_" -ForegroundColor Red
        return $null
    }
}

# Main script execution
try {
    # Display banner
    Show-Banner
    
    # Check for required modules
    Check-RequiredModules
    
    # Connect to Microsoft Graph
    Connect-ToMicrosoftGraph
    
    # Get MFA status for users
    $mfaStatus = Get-UserMFAStatus -UserFilter $UserPrincipalName
    
    # Display results
    if ($null -ne $mfaStatus) {
        $mfaStatus | Format-Table -AutoSize
        
        # Export to CSV
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $csvPath = "MFAStatus-$timestamp.csv"
        $mfaStatus | Export-Csv -Path $csvPath -NoTypeInformation
        
        Write-Host "Results exported to $csvPath" -ForegroundColor Green
        
        # Display summary
        $enabledCount = ($mfaStatus | Where-Object { $_.MFAStatus -eq "Enabled" }).Count
        $disabledCount = ($mfaStatus | Where-Object { $_.MFAStatus -eq "Disabled" }).Count
        $totalCount = $mfaStatus.Count
        
        Write-Host "`nMFA Status Summary:" -ForegroundColor Cyan
        Write-Host "Total Users: $totalCount" -ForegroundColor White
        Write-Host "MFA Enabled: $enabledCount ($([math]::Round(($enabledCount/$totalCount)*100, 2))%)" -ForegroundColor Green
        Write-Host "MFA Disabled: $disabledCount ($([math]::Round(($disabledCount/$totalCount)*100, 2))%)" -ForegroundColor Red
    }
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
} finally {
    # Disconnect from Microsoft Graph
    Disconnect-MgGraph | Out-Null
    Write-Host "Disconnected from Microsoft Graph" -ForegroundColor Cyan
}