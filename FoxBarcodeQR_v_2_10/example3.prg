*--------------------------------------------------------------------------------------
* Example3.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example label
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

*-- New properties
m.poFbc.nCorrectionLevel = 2 && Level_Q
m.poFbc.nBarColor = RGB(128, 0, 0) && Dark Red

USE (HOME(2) + "Northwind\Customers.dbf") IN SELECT("Customers")

LABEL FORM FBC_QR_Label PREVIEW

USE IN SELECT("Customers")

m.poFbc = NULL

*--------------------------------------------------------------------------------------
* End Example3.prg
*--------------------------------------------------------------------------------------