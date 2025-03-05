# Malicious-MFA-Takeover-Azure
This PowerShell script is designed for malicious purposes to facilitate MFA account takeover. It identifies dormant accounts, and if MFA is not configured, the attacker can initiate an MFA handshake. Once the handshake is completed, they can gain direct access using an authenticator app.

# Offensive Azure AD Attack [ Malicious MFA Takeover ] Powered by Hacker Associate 

[![Author](https://img.shields.io/badge/Author-Harshad%20Shah-blue.svg)](https://hackerassociate.com)
[![Website](https://img.shields.io/badge/Website-hackerassociate.com-green.svg)](https://hackerassociate.com)
[![Training](https://img.shields.io/badge/Training-blackhattrainings.com-red.svg)](https://blackhattrainings.com)

### [HackerAssociate](https://hackerassociate.com) | [BlackHatTrainings](https://blackhattrainings.com)

## Overview
Use Harshad Powershell Latest Script [ We  have created a new script which used microsoft graph API to get all the information and export  the file in CSV format ]. It will look for dormant accounts.

## Main Interface

Modern Authentication: Uses Microsoft Graph PowerShell SDK instead of the deprecated MSOnline or AzureAD modules

## Features

### Enhanced MFA Detection: Detects various authentication methods including:
- Microsoft Authenticator App
- Phone Authentication (SMS/Voice)
- FIDO2 Security Keys
- Windows Hello for Business
- Software OATH Tokens
- Email Authentication
