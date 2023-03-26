Import-Module ./Aitum.psm1

Write-Host "Fetch the global state variable Id named 'GregScore' from Aitum"
$globalVariableId = Get-AitumStateId -Name "GregScore";

Write-Host "Fetch the value of the variable with Id = $globalVariableId from Aitum"
$currentValue = Get-AitumStateValue -Id $globalVariableId;

Write-Host "Parse the value of the variable as an integer (Whole Number)"
$currentScore = [Int32]::Parse($currentValue);

Write-Host "The current score stored in variable ($globalVariableId) is $currentScore";

Write-Host "Add 100 to the value of the variable"
$newValue = $currentScore + 100

Write-Host "Save the new value to Aitum"
Set-AitumStateValue -Id $globalVariableId -Value $newValue;