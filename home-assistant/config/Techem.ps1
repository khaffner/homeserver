$uri = 'https://techemadmin.no/graphql'
$tenancyID = $env:TECHEMTENANCYID
$email = $env:TECHEMEMAIL
$password = $env:TECHEMPASSWORD

class DistrictHeating {
    [int]$kWhLast30Days
    [int]$UsageComparedToNeighbors
}

class HotWater {
    [int]$LitersLast30Days
    [int]$UsageComparedToNeighbors
}

class Usage {
    [DistrictHeating]$DistrictHeating
    [HotWater]$HotWater
}

# Auth
$authBody = ConvertFrom-Json -InputObject '{"operationName":"tokenAuth","variables":{"email":"EMAIL","password":"PASSWORD"},"query":"mutation tokenAuth($email: String!, $password: String!) {\n  tokenAuth(email: $email, password: $password) {\n    payload\n    refreshExpiresIn\n    token\n    refreshToken\n    __typename\n  }\n}\n"}'
$authBody.variables.email = $email
$authBody.variables.password = $password
$auth = Invoke-RestMethod -Uri $uri -Method Post -Body ($authBody | ConvertTo-Json -Compress) -ContentType application/json

# Get general usage
$timeFormat = 'yyyy-MM-ddTHH:mm:ss.fffZ'
$periodBegin = Get-Date ((Get-Date).AddDays(-30).ToUniversalTime()) -Format $timeFormat
$periodEnd = Get-Date ((Get-Date).ToUniversalTime()) -Format $timeFormat
$usageBody = ConvertFrom-Json -InputObject '{"operationName":"getDashboardPage","variables":{"tenancyId":"1133658","periodBegin":"2021-12-14T22:22:01.661Z","periodEnd":"2022-01-13T22:22:01.661Z","compareWith":"property"},"query":"query getDashboardPage($tenancyId: Int!, $periodBegin: String, $periodEnd: String, $compareWith: String!) {\n  dashboard(\n    tenancyId: $tenancyId\n    periodBegin: $periodBegin\n    periodEnd: $periodEnd\n    compareWith: $compareWith\n  ) {\n    tenancy {\n      id\n      propertyNumber\n      tenant\n      energyGrade\n      apartment {\n        apartment\n        address\n        __typename\n      }\n      latestAllocationStatement {\n        fileName\n        url\n        periodEndDate\n        expenseTypes\n        __typename\n      }\n      __typename\n    }\n    consumptions {\n      value\n      unit\n      kind\n      comparePercent\n      __typename\n    }\n    climateAverages {\n      value\n      valueCompare\n      kind\n      unit\n      __typename\n    }\n    __typename\n  }\n}\n"}'
$usageBody.variables.tenancyId = $tenancyID
$usageBody.variables.periodBegin = $periodBegin
$usageBody.variables.periodEnd = $periodEnd

$usageRaw = Invoke-RestMethod -Uri $uri -Method Post -Body ($usageBody | ConvertTo-Json -Compress) -ContentType application/json -Headers @{'authorization' = "JWT $($auth.data.tokenAuth.token)"}
$energyUsage = $usageRaw.data.dashboard.consumptions | Where-Object kind -EQ 'energy'
$hotWaterUsage = $usageRaw.data.dashboard.consumptions | Where-Object kind -EQ 'hotwater'

$DistrictHeating = New-Object -TypeName DistrictHeating
$DistrictHeating.kWhLast30Days = $energyUsage.value
$DistrictHeating.UsageComparedToNeighbors = $energyUsage.comparePercent
$HotWater = New-Object -TypeName HotWater
$HotWater.LitersLast30Days = $hotWaterUsage.value * 1000
$HotWater.UsageComparedToNeighbors = $hotWaterUsage.comparePercent

$usage = New-Object -TypeName Usage
$usage.DistrictHeating = $DistrictHeating
$usage.HotWater = $HotWater

$usage | ConvertTo-Json