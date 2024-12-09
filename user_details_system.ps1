# Function to get all users on the system
function Get-SystemUsers {
    Write-Output "Retrieving user details..."
    
    # Get local users
    $users = Get-LocalUser | Select-Object Name, Enabled, Description, LastLogon
    if ($users) {
        Write-Output "Local User Accounts:"
        $users | Format-Table -AutoSize
    } else {
        Write-Output "No local user accounts found."
    }
}

# Execute the function
Get-SystemUsers
