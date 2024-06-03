#!/bin/bash

myDir=$(pwd)

echo $myDir
echo --

echo "winget install TobyAllen.DocTo"

docto -WD -f FirstPage_Binder_Owner.docx -o .\PDFs\FirstPage_Binder_Owner.pdf -t wdFormatPDF
docto -WD -f MapOfPigott.docx -o .\PDFs\MapOfPigott.pdf -t wdFormatPDF
docto -WD -f EmergencyAndSafetyInfo.docx -o .\PDFs\EmergencyAndSafetyInfo.pdf -t wdFormatPDF
docto -WD -f PatrolRoster.docx -o .\PDFs\PatrolRoster.pdf -t wdFormatPDF
docto -WD -f Staff.docx -o .\PDFs\Staff.pdf -t wdFormatPDF
