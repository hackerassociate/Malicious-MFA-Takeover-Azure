# Malicious-MFA-Takeover-Azure
This PowerShell script is designed for malicious purposes to facilitate MFA account takeover. It identifies dormant accounts, and if MFA is not configured, the attacker can initiate an MFA handshake. Once the handshake is completed, they can gain direct access using an authenticator app.

# Offensive Azure AD Attack [ Malicious MFA Takeover ] Powered by Hacker Associate 

[![Author](https://img.shields.io/badge/Author-Harshad%20Shah-blue.svg)](https://hackerassociate.com)
[![Website](https://img.shields.io/badge/Website-hackerassociate.com-green.svg)](https://hackerassociate.com)
[![Training](https://img.shields.io/badge/Training-blackhattrainings.com-red.svg)](https://blackhattrainings.com)

### [HackerAssociate](https://hackerassociate.com) | [BlackHatTrainings](https://blackhattrainings.com)

## Overview
Use Harshad Powershell Latest Script [ We  have created a new script which used microsoft graph API to get all the information and export  the file in CSV format ]. It will look for dormant accounts.

# 📸 Console Interface

![Console Interface](https://github.com/hackerassociate/Malicious-MFA-Takeover-Azure/blob/main/Malicious-MFA-Takeover.png)

## Main Interface

Modern Authentication: Uses Microsoft Graph PowerShell SDK instead of the deprecated MSOnline or AzureAD modules



## Features

### Enhanced MFA Detection: Detects various authentication methods including:
- Microsoft Authenticator App.
- Phone Authentication (SMS/Voice).
- FIDO2 Security Keys.
- Windows Hello for Business.
- Software OATH Tokens.
- Email Authentication.

### Better UI Experience 

- Progress bar for processing users.
- Automatic module installation if required.
- Summary statistics at the end.
- CSV export with timestamp.

### Security Improvements:

- Uses modern authentication with proper scopes.
- Properly disconnects from Microsoft Graph when done.

### Error Handling:

- Comprehensive error handling throughout the script.
- Informative error messages.


## Installation Steps

1. **Download the Script**
   Save the script to your system using `git clone <reponame>`


2. **Run it in PowerShell with administrator privileges**.

3. **It will prompt to install required modules if needed**.

4. **It will connect to Microsoft Graph with proper permissions**.

5. **It will generate a CSV report with the results**.

## 📜 License
This code is licensed under Hacker Associate™. Any unauthorized use, reproduction, or distribution of this code without explicit written permission from Hacker Associate is strictly prohibited. 

For licensing inquiries, please contact:

🌐 [www.hackerassociate.com](https://www.hackerassociate.com)
📧 info@hackerassociate.com

---

## 👨‍💻 Author

- **Harshad Shah**
- 🌐 Website: [Hacker Associate](https://www.hackerassociate.com)
  
---

## 🛡️ For Offensive Black Hat Trainings

If you're interested in **Offensive Black Hat Trainings**, check out [Hacker Associate](https://www.hackerassociate.com) for more information and resources.

![Cybersecurity Certifications](https://github.com/hackerassociate/json-analyzer-for-pentester/blob/main/certification.png)

---

## 🆘 Support

If you encounter any issues or have questions, feel free to:
- 🐛 Open an issue in the repository.
- 📧 Contact the author via the [Hacker Associate website](https://www.hackerassociate.com).

---


