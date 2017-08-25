*--------------------------------------------------------------------------------------
* Example2.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

CREATE CURSOR TempQR (TempQR I)
INSERT INTO TempQR VALUES (0)
REPORT FORM FBC_QR_report PREVIEW
USE IN TempQR

m.poFbc = NULL
