function Get-AitumUri {
    param(
        [string] $endpoint = ""
    )
    return "http://localhost:7777/aitum$endpoint"
}

function Get-AitumState {
    $content = Invoke-WebRequest -URI (Get-AitumUri "/state") | ConvertFrom-JSON;
    if ($content.status -ne "OK") {
        throw "Could not get variables";
    }

    return $content.data;
}

function Get-AitumStateId {
    param(
        [string] $Name = ""
    )

    if ([string]::IsNullOrEmpty($Name)) {
        throw "Name not specified, aborting.";
    }

    $data = Get-AitumState

    if (-Not [string]::IsNullOrEmpty($Name)) {
        $results = $data | Where-Object { $_.name -eq $Name }
    }

    if ($results.Length -eq 0) {
        throw "Could not match variable!";
    }

    return $results._id;
}

function Get-AitumStateValue {
    param(
        [string] $Id = ""
    )

    if ([string]::IsNullOrEmpty($Id)) {
        throw "Neither a Name or ID specified, aborting.";
    }

    $results = Get-AitumState | Where-Object { $_._id.Trim() -eq $Id.Trim() };

    $results

    if (!$results) {
        throw "Variable does not exist";
    }

    return $results.value;
}

function Set-AitumStateValue {
    param(
        [string] $Id = "",
        [object] $Value
    )

    if ([string]::IsNullOrEmpty($Id)) {
        throw "Id not specified.";
    }
    
    $uri = Get-AitumUri ("/state/" + $Id);
    $body = (@{value = $Value} | ConvertTo-Json -Compress)
    
    $response = Invoke-WebRequest -Uri $uri -Method Put -Body $body -ContentType "application/json"
    $response.Content
}

Export-ModuleMember -Function Get-AitumUri
Export-ModuleMember -Function Get-AitumState
Export-ModuleMember -Function Get-AitumStateId
Export-ModuleMember -Function Get-AitumStateValue
Export-ModuleMember -Function Set-AitumStateValue