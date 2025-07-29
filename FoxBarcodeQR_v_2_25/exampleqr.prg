*--------------------------------------------------------------------------------------
* Example1.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example form
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR object and QR Code barcode image
LOCAL loFbc, lcQRImage
m.loFbc = CREATEOBJECT("FoxBarcodeQR")

*-- JSON con los datos requeridos por AFIP
TEXT TO lcString NOSHOW
{"ver":1,"fecha":"2020-10-13","cuit":30000000007,"ptoVta":10,"tipoCmp":1,"nroCmp":94,"importe":12100,"moneda":"DOL","ctz":65,"tipoDocRec":80,"nroDocRec":20000000001,"tipoCodAut":"E","codAut":70417054367476}
ENDTEXT

lcString64 = STRCONV(lcString, 13)

lcQR = [https://www.afip.gob.ar/fe/qr/?p=] + lcString64

WITH loFbc
  loFbc.nVersion = 2.00 && Version
  loFbc.lAutoConfigurate = .T.
  loFbc.lAutoFit = .F.
  loFbc.nCorrectionLevel = 1 && Medium 15%
  loFbc.nEncoding = 4 && Automatic encoding algorithm
  loFbc.nMarginPixels = 0 && pixels
  loFbc.nModuleWidth = 2 && pixels
  loFbc.nHeight = 171
  loFbc.nWidth = 171
ENDWITH
  

*-- With QRCodeLib.dll supports more than 255 characters
m.lcQRImage = loFbc.FullQRCodeImage(lcQR)
*m.lcQRImage = loFbc.FastQRCodeImage(lcQR)

*-- Create form
LOCAL loForm AS FORM
m.loForm = CREATEOBJECT("Form")
WITH m.loForm
  .CAPTION = "Ejemplo de QR de AFIP con FoxBarcodeQR"
  .WIDTH = 400
  .HEIGHT = 400
  *.BACKCOLOR = RGB(255,255,255)
  .AUTOCENTER = .T.
  .ADDOBJECT("Image1", "Image")
  WITH .Image1
    .WIDTH = 171
    .HEIGHT = 171
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

