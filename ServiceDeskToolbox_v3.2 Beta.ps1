Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Service Desk Toolbox v3.2'
$form.Size = New-Object System.Drawing.Size(450, 750)
$form.StartPosition = 'CenterScreen'

# Disclaimer label
$disclaimerLabel = New-Object System.Windows.Forms.Label
$disclaimerLabel.Location = New-Object System.Drawing.Point(10, 20)
$disclaimerLabel.Size = New-Object System.Drawing.Size(420, 40)
$disclaimerLabel.Text = 'Ensure you have client consent before initiating any remote actions.'
$form.Controls.Add($disclaimerLabel)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 70)
$label.Size = New-Object System.Drawing.Size(420, 20)
$label.Text = 'Please enter the IP address or Hostname for connection:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 100)
$textBox.Size = New-Object System.Drawing.Size(420, 20)
$form.Controls.Add($textBox)

# Ping Button ( may add all 4 lines of output later on)
$pingButton = New-Object System.Windows.Forms.Button
$pingButton.Location = New-Object System.Drawing.Point(10, 130)
$pingButton.Size = New-Object System.Drawing.Size(420, 30)
$pingButton.Text = 'Ping Device'
$form.Controls.Add($pingButton)

# Query Current DC Button
$dcQueryButton = New-Object System.Windows.Forms.Button
$dcQueryButton.Location = New-Object System.Drawing.Point(10, 170)
$dcQueryButton.Size = New-Object System.Drawing.Size(420, 30)
$dcQueryButton.Text = 'Query Current DC'
$form.Controls.Add($dcQueryButton)

# Remote Assistance Button
$raButton = New-Object System.Windows.Forms.Button
$raButton.Location = New-Object System.Drawing.Point(10, 210)
$raButton.Size = New-Object System.Drawing.Size(420, 30)
$raButton.Text = 'Offer Remote Assistance'
$form.Controls.Add($raButton)

# Restart Button
$restartButton = New-Object System.Windows.Forms.Button
$restartButton.Location = New-Object System.Drawing.Point(10, 250)
$restartButton.Size = New-Object System.Drawing.Size(210, 30)
$restartButton.Text = 'Force Restart Device'
$form.Controls.Add($restartButton)

# Shutdown Button
$shutdownButton = New-Object System.Windows.Forms.Button
$shutdownButton.Location = New-Object System.Drawing.Point(220, 250)
$shutdownButton.Size = New-Object System.Drawing.Size(210, 30)
$shutdownButton.Text = 'Force Shutdown Device'
$form.Controls.Add($shutdownButton)

# Password Generation Button
$passwordButton = New-Object System.Windows.Forms.Button
$passwordButton.Location = New-Object System.Drawing.Point(10, 290)
$passwordButton.Size = New-Object System.Drawing.Size(420, 30)
$passwordButton.Text = 'Generate Password'
$form.Controls.Add($passwordButton)

$historyLabel = New-Object System.Windows.Forms.Label
$historyLabel.Location = New-Object System.Drawing.Point(10, 330)
$historyLabel.Size = New-Object System.Drawing.Size(280, 20)
$historyLabel.Text = 'Toolbox Log:'
$form.Controls.Add($historyLabel)

$textBoxHistory = New-Object System.Windows.Forms.TextBox
$textBoxHistory.Location = New-Object System.Drawing.Point(10, 360)
$textBoxHistory.Size = New-Object System.Drawing.Size(420, 350)
$textBoxHistory.Multiline = $true
$textBoxHistory.ScrollBars = 'Vertical'
$form.Controls.Add($textBoxHistory)

# Function - Get Current DateTime
function Get-CurrentDateTime {
    return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
}

# Function - Generate Simple Password (Daryl's method)
function Generate-SimplePassword {
    $length = 16
    $characters = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    $password = -join ((1..$length) | ForEach-Object { Get-Random -Maximum $characters.length } | ForEach-Object { $characters[$_] })
    return $password
}

# Event handler for querying current DC
$dcQueryButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $hostname = $textBox.Text
    if ($hostname -eq '') {
        [System.Windows.Forms.MessageBox]::Show("Please enter an IP address or hostname.", "Input Required")
        return
    }
    $output = & nltest /server:$hostname /sc_query:cenovus.com 2>&1
    $textBoxHistory.AppendText("$currentDateTime - nltest output for ${hostname}:`r`n$output`r`n")
    $textBox.Text = ''
})

# Event handlers for other buttons
$pingButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $pingResult = Test-Connection -ComputerName $textBox.Text -Count 1 -ErrorAction SilentlyContinue
    if ($pingResult) {
        $textBoxHistory.AppendText("$currentDateTime - Ping to " + $textBox.Text + " successful.`r`n")
    } else {
        $textBoxHistory.AppendText("$currentDateTime - Ping to " + $textBox.Text + " failed.`r`n")
    }
    $textBox.Text = ''
})

$raButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $textBoxHistory.AppendText("$currentDateTime - Remote Assistance Requested to: " + $textBox.Text + " (client consent verified)`r`n")
    $msraPath = "msra.exe"
    $arguments = "/offerRA " + $textBox.Text
    Start-Process $msraPath $arguments
    $textBox.Text = ''
})

$restartButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $credential = Get-Credential -Message "Enter credentials to perform the restart"
    $scriptBlock = {
        Restart-Computer -Force
    }
    Invoke-Command -ComputerName $textBox.Text -ScriptBlock $scriptBlock -Credential $credential -ErrorAction SilentlyContinue
    $textBoxHistory.AppendText("$currentDateTime - Force restart command sent to " + $textBox.Text + " (client consent verified).`r`n")
    $textBox.Text = ''
})

$shutdownButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $credential = Get-Credential -Message "Enter credentials to perform the shutdown"
    $scriptBlock = {
        Stop-Computer -Force
    }
    Invoke-Command -ComputerName $textBox.Text -ScriptBlock $scriptBlock -Credential $credential -ErrorAction SilentlyContinue
    $textBoxHistory.AppendText("$currentDateTime - Force shutdown command sent to " + $textBox.Text + " (client consent verified).`r`n")
    $textBox.Text = ''
})

$passwordButton.Add_Click({
    $currentDateTime = Get-CurrentDateTime
    $password = Generate-SimplePassword
    $textBoxHistory.AppendText("$currentDateTime - Generated Password: $password`r`n")
})

$form.ShowDialog()
<# 
Version 3.2 - Added Query Current DC functionality
Author: Harry Virdi
Date: 2024-10-10
Disclaimer: This script is for authorized personnel only.
#>


<# Version 3.1 - added shutdown and restart buttons Removed the RDP button
 Author: Harry Virdi
    Date: 2024-08-27
    Version: 3.1
This script is intended for use by authorized personnel only. #>