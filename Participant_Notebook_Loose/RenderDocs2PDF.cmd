#!/bin/bash

myDir=$(pwd)

echo $myDir
echo --

echo "winget install TobyAllen.DocTo"

copy .\MapOfPigott.pdf .\WB1_609-24_Specific\Day0_Prep\PDFs\MapOfPigott.pdf
echo -- docto -WD -f MapOfPigott.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\MapOfPigott.pdf -t wdFormatPDF


docto -WD -f BINDER_FrontCover.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\BINDER_FrontCover.pdf -t wdFormatPDF

docto -WD -f BlankNotePage.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\BlankNotePage.pdf -t wdFormatPDF

docto -WD -f FirstPage_Binder_Owner.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\FirstPage_Binder_Owner.pdf -t wdFormatPDF

docto -WD -f EmergencyAndSafetyInfo.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\EmergencyAndSafetyInfo.pdf -t wdFormatPDF
docto -WD -f PatrolRoster.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\PatrolRoster.pdf -t wdFormatPDF
docto -WD -f Staff.docx -o .\WB1_609-24_Specific\Day0_Prep\PDFs\Staff.pdf -t wdFormatPDF
