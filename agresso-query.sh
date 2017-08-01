#!/bin/sh

envsubst=/usr/local/opt/gettext/bin/envsubst
WSURL="https://csportal01.u4a.se/p666200-agresso-webservices/service.svc?TimesheetService/TimesheetV201205"
SOAPACTION="http://services.agresso.com/TimesheetService/TimesheetV201205/GetTimesheet"
NS="http://services.agresso.com/TimesheetService/TimesheetV201205"
CONTENTTYPE="Content-Type: text/xml; charset=utf-8"

CERT="${HOME}/.agresso/u4a-client.crt"
KEY="${HOME}/.agresso/u4a-client.key"
. ~/.agresso/conf

export USERNAME
export CLIENT
export PASSWORD

cat GetTimesheet.xml|${envsubst} | curl -s  --cert ${CERT} --key ${KEY} -XPOST ${WSURL}  -H "${CONTENTTYPE}" -H "SOAPAction: ${SOAPACTION}" -d @- |  xmlstarlet sel  -N "a=${NS}" -T -t -m "//a:WorkDay" -v "concat(a:Day,' ',../../a:TimeCode,' ',../../a:Project,' ',../../a:Activity,' ', a:HoursWorked)"  -n  |column -t|sed -e 's/T00:00:00//'|sort 
