# Function to reset a user's password
function Reset-UserPassword {
    # Prompt for the target username
    $userName = Read-Host "Enter the username of the account you want to reset the password for"
    
    # Check if the user exists
    $user = Get-LocalUser -Name $userName -ErrorAction SilentlyContinue
    if (-not $user) {
        Write-Host "User '$userName' does not exist on this system." -ForegroundColor Red
        return
    }

    # Prompt for the new password
    $newPassword = Read-Host "Enter the new password for $userName" -AsSecureString

    # Confirm the new password
    $confirmPassword = Read-Host "Confirm the new password for $userName" -AsSecureString

    # Validate that both passwords match
    if ([Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword)) -ne 
        [Runtime.InteropServices.Marshal]::PtrToStringBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))) {
        Write-Host "Passwords do not match. Please try again." -ForegroundColor Red
        return
    }

    # Change the user's password
    try {
        Set-LocalUser -Name $userName -Password $newPassword
        Write-Host "Password for user '$userName' has been successfully reset." -ForegroundColor Green
    } catch {
        Write-Host "Failed to reset the password. Error: $_" -ForegroundColor Red
    }
}

# Execute the function
Reset-UserPassword
