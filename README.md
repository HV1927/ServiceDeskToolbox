# ServiceDeskToolbox
PowerShell script to assist Service Desk tasks
# Service Desk Toolbox v3.2

A **PowerShell GUI** designed to streamline common Service Desk tasks, including pinging devices, querying domain controllers, initiating remote assistance, generating passwords, and more. This tool helps IT support teams work more efficiently by providing a single interface for multiple maintenance and troubleshooting functions.

---

## Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Customization](#customization)
- [Version History](#version-history)
- [Disclaimer](#disclaimer)
- [License](#license)
- [Author](#author)

---

## Features

- **Ping Device**  
  Quickly test network connectivity with a specified IP address or hostname.

- **Query Current DC**  
  Runs `nltest` to find the current domain controller for a specific host in the domain.

- **Offer Remote Assistance**  
  Launches Microsoft Remote Assistance for the specified device.

- **Force Restart/Shutdown**  
  Allows authorized personnel to issue remote restart or shutdown commands (with credentials).

- **Generate Random Password**  
  Creates a simple 16-character password with alphanumeric characters (excluding ambiguous characters).

- **Activity Log**  
  Displays an in-tool history of all commands run, complete with timestamps.

---

## Requirements

1. **Operating System**: Windows 10 or later (should also work on Windows Server environments).
2. **PowerShell**: Version 5.1 or higher recommended.
3. **Permissions**: 
   - Local admin rights (in most cases) for remote commands such as restart or shutdown.
   - Domain credentials for running certain commands (e.g., domain controller queries).

4. **.NET Framework**:  
   The script uses Windows Forms (WinForms) which relies on .NET Framework. Typically included on modern Windows machines.

---

## Installation

1. **Clone or Download** this repository to your local system.
   ```bash
   git clone https://github.com/<username>/ServiceDeskToolbox.git
