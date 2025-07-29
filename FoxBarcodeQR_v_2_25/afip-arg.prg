
SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Creo el objeto FoxBarcodeQR
LOCAL loFbc AS OBJECT
LOCAL lcQRImage, lcQR AS STRING
loFbc = CREATEOBJECT("FoxBarcodeQR")
LOCAL lRutaArchivoObtenido AS STRING
lRutaArchivoObtenido = SYS(5) + CURDIR()+"Barcodeqr"

TEXT to lcstring2 noshow
{"ver":1,"fecha":"2020-10-13","cuit":30000000007,"ptoVta":10,"tipoCmp":1,"nroCmp":94,"importe":12100,"moneda":"DOL","ctz":65,"tipoDocRec":80,"nroDocRec":20000000001,"tipoCodAut":"E","codAut":70417054367476}
ENDTEXT


lcString64 = STRCONV(lcString2, 13)

lcQR = [https://www.afip.gob.ar/fe/qr/?p=] + lcString64

*-- Cambio el ancho de los módulos (5 por default)
loFbc.nModuleWidth = 2
*-- optimizo tamaño multiplo de 33 y > 100
lcQRImage = loFbc.FullQRCodeImage(lcQR, lRutaArchivoObtenido, 333)

*-- Create form
LOCAL loForm AS FORM
m.loForm = CREATEOBJECT("Form")
WITH m.loForm
  .CAPTION = "FoxBarcodeQR example form QR AFIP (Agentina)"
  .WIDTH = 600
  .HEIGHT = 600
  .BACKCOLOR = RGB(255,255,255)
  .AUTOCENTER = .T.
  .ADDOBJECT("Image1", "MyImage")
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

RETURN

DEFINE CLASS MyImage AS IMAGE
  PROCEDURE DESTROY
    THIS.PICTURE = ""
  ENDPROC
ENDDEFINE
