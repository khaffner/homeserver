#!/bin/bash

# Stupid busybox date
STARTTIME=$(date -d "@$(($(date +%s) - 7 * 24 * 60 * 60))" -u +"%Y-%m-%dT%H:%M:%S.000Z")
ENDTIME=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Body wrapped in double quotes to expand variables. I tried printf, but that removed \n among other shenanigans.
TOKENBODY="{\"query\":\"mutation tokenAuth(\$email: String\!, \$password: String\!) { tokenAuth(email: \$email, password: \$password) { payload refreshExpiresIn token refreshToken } }\",\"variables\":{\"email\":\"$TECHEMEMAIL\",\"password\":\"$TECHEMPASSWORD\"}}"

# Remove escape characters which was needed above
TOKENBODY="$(echo $TOKENBODY | sed 's/\\!/!/g')"

# Get token
TOKEN=$(curl 'https://techemadmin.no/graphql' -s -X POST --compressed -H 'Accept: */*' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://beboer.techemadmin.no/' -H 'Content-Type: application/json' --data "$TOKENBODY" | jq -r '.data.tokenAuth.token')

# Body for getting data
DATABODY="{\"operationName\":\"getDashboardPage\",\"variables\":{\"tenancyId\":\"$TECHEMTENANTID\",\"periodBegin\":\"$STARTTIME\",\"periodEnd\":\"$ENDTIME\",\"compareWith\":\"property\"},\"query\":\"query getDashboardPage(\$tenancyId: Int\!, \$periodBegin: String, \$periodEnd: String, \$compareWith: String\!) {\n  dashboard(\n    tenancyId: \$tenancyId\n    periodBegin: \$periodBegin\n    periodEnd: \$periodEnd\n    compareWith: \$compareWith\n  ) {\n    consumptions {\n      value\n      kind\n      comparePercent\n      __typename\n    }\n    climateAverages {\n      value\n      valueCompare\n      kind\n      __typename\n    }\n    __typename\n  }\n}\"}"

# Remove escape characters which was needed above
DATABODY="$(echo $DATABODY | sed 's/\\!/!/g')"

# Command that gets the data and outputs json
curl 'https://techemadmin.no/graphql' -s -X POST --compressed -H 'Accept: */*' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://beboer.techemadmin.no/' -H 'content-type: application/json' -H "authorization: JWT $TOKEN" -H 'Origin: https://beboer.techemadmin.no' --data "$DATABODY" | jq '.data.dashboard.consumptions' | jq 'map(del(.__typename))' | jq -r tostring
