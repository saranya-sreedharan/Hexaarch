# Function to check and fetch system details
function Get-LaptopDetails {
    # Get Manufacturer and Model
    $manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
    $model = (Get-WmiObject -Class Win32_ComputerSystem).Model
    Write-Output "Manufacturer: $manufacturer"
    Write-Output "Model: $model"

    # Get Serial Number
    $serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber
    Write-Output "Serial Number: $serialNumber"

    # Get RAM Details
    $ramModules = Get-CimInstance -ClassName Win32_PhysicalMemory
    if ($ramModules) {
        $totalRAM = ($ramModules | Measure-Object -Property Capacity -Sum).Sum
        $totalRAMInGB = [math]::Round($totalRAM / 1GB, 2)
        Write-Output "Total RAM: $totalRAMInGB GB"
    } else {
        Write-Output "Total RAM: Unable to retrieve"
    }

    # Get SSD/Storage Details
    $drives = Get-CimInstance -ClassName Win32_DiskDrive | Where-Object { $_.MediaType -eq "Fixed hard disk media" }
    if ($drives) {
        $totalStorage = ($drives | Measure-Object -Property Size -Sum).Sum
        $totalStorageInGB = [math]::Round($totalStorage / 1GB, 2)
        Write-Output "Number of Drives: $($drives.Count)"
        Write-Output "Total Storage: $totalStorageInGB GB"
    } else {
        Write-Output "Number of Drives: Unable to retrieve"
        Write-Output "Total Storage: Unable to retrieve"
    }

    # Check Touch Screen Availability
    try {
        $touchScreen = Get-WmiObject -Namespace "root\CIMv2" -Query "SELECT * FROM Win32_PnPEntity WHERE Name LIKE '%Touch Screen%'"
        if ($touchScreen) {
            Write-Output "Touch Screen: Available"
        } else {
            Write-Output "Touch Screen: Not Available"
        }
    } catch {
        Write-Output "Touch Screen: Unable to detect"
    }

    # Get Processor Information
    $processor = (Get-CimInstance -ClassName Win32_Processor).Name
    Write-Output "Processor: $processor"
}

# Execute the function
Get-LaptopDetails
