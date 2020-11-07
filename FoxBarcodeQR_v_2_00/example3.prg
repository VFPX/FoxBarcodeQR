*--------------------------------------------------------------------------------------
* Example3.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

*-- New properties
m.poFbc.nCorrectionLevel = 2 && Level_Q
m.poFbc.nBarColor = RGB(0,0,192) && Blue

USE (HOME(2)+ "northwind\customers") IN SELECT("Customers")

LABEL FORM FBC_QR_Label PREVIEW

m.poFbc = NULL
