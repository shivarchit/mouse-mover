param([int]$minutes = 200)  # Input parameter, 200 minutes provided
Clear-Host;
Import-Module BurntToast
$wsh = New-Object -ComObject WScript.Shell
$startTime = Get-Date  # Current time
$endTime = $startTime.AddMinutes($minutes)  # Target end time
$InputRange = 60..350  # Range of sleep times in seconds
$Exclude = 65,66  # Exclude these sleep times

$totalDuration = ($endTime - $startTime).TotalSeconds  # Total time in seconds

while ((Get-Date) -lt $endTime) {   # Fixed date comparison

    # Calculate remaining time
    $remainingTime = ($endTime - (Get-Date)).ToString("hh\:mm\:ss")

    # Get a random sleep duration, excluding certain values
    $RandomRange = $InputRange | Where-Object { $Exclude -notcontains $_ }
    $randomSleep = Get-Random -InputObject $RandomRange

    # Calculate elapsed time and percent complete
    $currentTime = Get-Date
    $elapsedTime = ($currentTime - $startTime).TotalSeconds
    $percentComplete = [math]::Round(($elapsedTime / $totalDuration) * 100, 2)

    # Ensure that the script terminates if time is up
    if ((Get-Date) -gt $endTime) {
        break;
    }

    # Create a loop to update the sleep progress in real-time
    for ($i = $randomSleep; $i -gt 0; $i--) {
        # Update remaining time
        $remainingTime = ($endTime - (Get-Date)).ToString("hh\:mm\:ss")

        # Update the progress bar with the current countdown
        Write-Progress -Activity "Destroyer of Worlds" -Status "$percentComplete% Complete, Pinging for $i seconds - Time to Destruct: $remainingTime" -PercentComplete $percentComplete

        # Sleep for 1 second to simulate real-time countdown
        Start-Sleep -Seconds 1

        # Break the loop if the time is up
        if ((Get-Date) -gt $endTime) {
            break
        }
    }

    # Send Shift+F15 key press
    $wsh.SendKeys('+{F15}')

    # Update the current time after the random sleep
    $currentTime = Get-Date
    $elapsedTime = ($currentTime - $startTime).TotalSeconds
    $percentComplete = [math]::Round(($elapsedTime / $totalDuration) * 100, 2)

    # Break the main loop if 100% is reached or time is over
    if ($percentComplete -ge 100 -or (Get-Date) -gt $endTime) {
        $percentComplete = 100;
        break;
    }
}

# Final completion message
New-BurntToastNotification -Text "World Saved at $(Get-Date)", "Say, Thank you!"
# Write-Host "Script execution completed at $(Get-Date)"
