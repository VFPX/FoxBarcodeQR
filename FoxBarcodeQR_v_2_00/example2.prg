*--------------------------------------------------------------------------------------
* Example2.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

*-- New properties
m.poFbc.nCorrectionLevel = 3 && Level_H
m.poFbc.nBarColor = RGB(0,128,0) && Green

CREATE CURSOR TempQR (TempQR I)
INSERT INTO TempQR VALUES (0)
REPORT FORM FBC_QR_report PREVIEW
USE IN TempQR

m.poFbc = NULL
