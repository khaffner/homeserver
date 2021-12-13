$ApiKey = $args[0]

# To get api key
#Invoke-RestMethod -Uri http://server.local:8081/api -Method Post -Body '{ "devicetype": "pwsh"}'

$Graph = [string]::Empty
$Graph += 'graph {' + [System.Environment]::NewLine
$Graph += '    bgcolor="transparent"' + [System.Environment]::NewLine
$Graph += '    color="white"' + [System.Environment]::NewLine
$Graph += '    fontcolor="white"' + [System.Environment]::NewLine

$Base = "http://server.local:8081/api$ApiKey"
$DeviceTypes = @("lights") # array in case sensors support connectivity2
foreach ($DeviceType in $DeviceTypes) {
    $Devices = Invoke-RestMethod -Uri "$Base/$DeviceType"
    $Devices | Get-Member -MemberType NoteProperty | foreach {
        $Id = $PSItem.Name
        #$FriendlyName = $Devices."$Id".name
        $Neighbours = Invoke-RestMethod -Uri "$Base/$DeviceType/$Id/connectivity2" | Select-Object -ExpandProperty Neighbours
        $Neighbours | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty name | foreach {
            if ($Graph -notlike "*$PSItem -- $Id*") { # avoid duplicates
                $Graph += "    $Id -- $PSItem"
                $Graph += [System.Environment]::NewLine
            }
        }
        Clear-Variable -Name Neighbours
    }
}

$Graph += '}'

$Graph | Out-File -FilePath ./graph.gv
dot -Tsvg -Kcirco ./graph.gv > ./graph.svg