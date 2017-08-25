*--------------------------------------------------------------------------------------
* Example3.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

USE (HOME(2)+ "northwind\customers") IN 0

LABEL FORM FBC_QR_Label PREVIEW

m.poFbc = NULL
