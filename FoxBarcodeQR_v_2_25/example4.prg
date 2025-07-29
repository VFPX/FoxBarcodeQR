*--------------------------------------------------------------------------------------
* Example4.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example form QR Server API
*--------------------------------------------------------------------------------------

LOCAL lcString, lnI
SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR object and QR Code barcode image
LOCAL loFbc, lcQRImage
m.loFbc = CREATEOBJECT("FoxBarcodeQR")

m.lcString = ""
m.lnI = 0
DO WHILE LEN(m.lcString) < 512
  m.lnI = m.lnI + 1
  m.lcString = m.lcString + TRANSFORM(m.lnI) + ". - Using the QR Server API - "
ENDDO


*-- With BarcodeLibrary.dll cut to 255 characters
*m.lcQRImage = m.loFbc.QRBarcodeImage(LEFT(lcString,255), , 5, 2)

*-- With QRCodeLib.dll supports more than 255 characters
*m.lcQRImage = loFbc.FullQRCodeImage(lcString, , 333)

*-- With QR Server API (must have internet connection)
m.lcQRImage = m.loFbc.SvrQRCodeImage(m.lcString, , 333, 2)

*-- Create form
LOCAL loForm AS FORM
m.loForm = CREATEOBJECT("Form")
WITH m.loForm
  .CAPTION = "FoxBarcodeQR example form QR Server API"
  .WIDTH = 600
  .HEIGHT = 600
  .BACKCOLOR = RGB(255, 255, 255)
  .AUTOCENTER = .T.
  .ADDOBJECT("Image1", "Image")
  WITH .Image1
    .WIDTH = 600
    .HEIGHT = 600
    .STRETCH = 0
    .PICTURE = m.lcQRImage
    .TOP = 20
    .LEFT = 20
    .VISIBLE = .T.
  ENDWITH
  .SHOW(1)
ENDWITH

m.loForm = NULL
m.loFbc = NULL

*--------------------------------------------------------------------------------------
* End Example1.prg
*--------------------------------------------------------------------------------------
