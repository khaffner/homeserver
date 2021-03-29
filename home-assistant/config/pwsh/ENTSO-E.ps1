# A script to get electricity prices from the European Network of Transmission System Operators for Electricity (ENTSO-E)

class PricePoint {
    [DateTime]$Start
    [DateTime]$End
    [Decimal]$PriceRaw
    [Decimal]$PriceNOKwithVAT
}
$entsoetimeformat = "yyyyMMddHH00"
$start = Get-Date
$end = Get-Date -Date (Get-Date).AddHours(24)
$startentsoe = Get-Date $start -Format $entsoetimeformat
$endentsoe = Get-Date $end -Format $entsoetimeformat

$baseurl = "https://transparency.entsoe.eu"
$token = $args[0]
$Period = "periodStart=$startentsoe&periodEnd=$endentsoe"
$url = "$baseurl/api?documentType=A44&in_Domain=10YNO-1--------2&out_Domain=10YNO-1--------2&$Period&securityToken=$token"

$r = Invoke-RestMethod -Method Get -Uri $url

$currency = Invoke-RestMethod -Method Get -Uri 'https://api.exchangeratesapi.io/latest'
[decimal]$rate = $currency.rates.NOK

$Points = @()
$Time = (Get-Date -Date $Start -Hour 0 -Minute 0 -Second -0 -Millisecond 0).DateTime
for ($i = 0; $i -lt 48; $i++) {
    $obj = New-Object -TypeName PricePoint
    $obj.Start = $Time
    $Time = (Get-Date $Time).AddHours(1)
    $obj.End = $Time
    $obj.PriceRaw = $r.Publication_MarketDocument.TimeSeries.Period.Point[$i].'price.amount'
    #Multiply with currency conversion rate, add VAT and, divide by 1000 for MW to KW, but multiply by 100 for NOK to Øre. So divide by 10.
    $obj.PriceNOKwithVAT = $obj.PriceRaw*$rate*1.25/10
    $Points += $obj
}

class HAdash {
    [int]$PriceNow
    [int]$PriceIn12Hours # But is "now" in 12 hours
}

# Get prices for now and in 12 hours, add Tibber surcharge
$dash = New-Object -TypeName HAdash
$dash.PriceNow = ($Points | Where-Object Start -EQ (Get-Date -Hour (Get-Date).Hour -Minute 0 -Second 0 -Millisecond 0)).PriceNOKwithVAT + 0.79
$dash.PriceIn12Hours = ($Points | Where-Object Start -EQ (Get-Date -Hour (Get-Date).Hour -Minute 0 -Second 0 -Millisecond 0).AddHours(12)).PriceNOKwithVAT + 0.79

return ($dash | ConvertTo-Json)