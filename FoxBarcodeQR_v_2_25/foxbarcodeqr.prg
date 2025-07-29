*--------------------------------------------------------------------------------------
* FoxBarcodeQR.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR is a application free software and offers a Barcode tool for the Visual
* FoxPro Community. This is a supplement of FoxBarcode class only for QR Code barcodes.
* This software is provided "as is" without express or implied warranty.
* Use it at your own risk
*--------------------------------------------------------------------------------------
* Version: 2.25
* Date   : 2025.07.30
* Author : VFPEncoding
* Email  : vfpencoding@gmail.com
*
* Note   : VFPEncoding are
*          Guillermo Carrero (QEPD) (Barcelona, Spain) and
*          Luis Maria Guayan (Tucuman, Argentina)
*--------------------------------------------------------------------------------------
* Note   : This application use the libraries
*          BarCodeLibrary.dll (by: Dario Alvarez Aranda, Mexico)
*          QRCodeLib.dll (www.validacfd.com)
*          Google Charts API (https://developers.google.com/chart/interactive/docs) DEPPRECATED - DO NOT USE
*          QR Server API (https://goqr.me/api/doc)
*--------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------
* FoxBarcodeQR Class Definition
*--------------------------------------------------------------------------------------
DEFINE CLASS FoxBarcodeQR AS CUSTOM

  m.cTempPath = "" && Windows Temp folder + SYS(2015)
  m.cAppPath = "" && App folder
  m.lDeleteTempFiles = .T. && Delete the temporary folder and image files

  m.nVersion = 2.00 && Version
  m.lAutoConfigurate = .T.
  m.lAutoFit = .F.
  m.nBackColor = RGB(255,255,255) && White
  m.nBarColor = RGB(0,0,0) && Black
  m.nCorrectionLevel = 1 && Medium 15%
  m.nEncoding = 4 && Automatic encoding algorithm
  m.nMarginPixels = 0 && pixels
  m.nModuleWidth = 5 && pixels
  m.nHeight = 200
  m.nWidth = 200

  *---------------------------------------------------------
  * PROCEDURE QRBarcodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with BarCodeLibrary.dll
  *  Parameters:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *   tnSize: Imagen Size [2..12] (default = 4)
  *     (Width in pixels is tnSize x 33 pixels)
  *     (tnSize = 4 -> 132 x 132 pixels)
  *   tnType: Imagen Type [BMP, JPG or PNG] (default = 0)
  *     0 = BMP
  *     1 = JPG
  *     2 = PNG
  *---------------------------------------------------------
  PROCEDURE QRBarcodeImage(tcText, tcFile, tnSize, tnType)
    LOCAL lcType, lcFolder

    IF VARTYPE(m.tnSize) <> "N"
      m.tnSize = 4 && default size:  132 x 132 pixels
    ENDIF

    IF VARTYPE(m.tnType) <> "N"
      m.tnType = 0  && defaul type: BMP
    ENDIF

    m.tnSize = MIN(MAX(m.tnSize, 2), 12)
    m.tnType = MIN(MAX(m.tnType, 0), 2)
    m.lcType = IIF(m.tnType = 1, "JPG", IIF(m.tnType = 2, "PNG", "BMP"))

    IF EMPTY(m.tcFile)
      m.lcFolder = THIS.cTempPath
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.lcFolder + SYS(2015), m.lcType)
    ELSE
      m.lcFolder = JUSTPATH(m.tcFile)
      IF NOT DIRECTORY(m.lcFolder) AND NOT EMPTY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF

    *-- Declare the functions of BarCodeLibrary.dll
    DECLARE INTEGER GenerateFile IN "BarCodeLibrary.dll" ;
      STRING cData, STRING cFileName

    DECLARE INTEGER SetConfiguration IN "BarCodeLibrary.dll" ;
      INTEGER nSize, INTEGER nImageType

    SetConfiguration(m.tnSize, m.tnType)
    GenerateFile(m.tcText, m.tcFile)

    CLEAR DLLS "SetConfiguration", "GenerateFile"

    RETURN m.tcFile
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE FullQRCodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with QRCodeLib.dll (visit: www.validacfd.com)
  *  Parameters:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *   tnSize: Imagen Size in pixels
  *   tnType: Imagen Type [Only 0=BMP]
  *---------------------------------------------------------
  PROCEDURE FullQRCodeImage(tcText, tcFile, tnSize, tnType)
    LOCAL lcType, lcFolder

    IF VARTYPE(m.tnSize) <> "N"
      m.tnSize = 200
    ENDIF
    m.tnSize = MIN(MAX(m.tnSize, 64), 1280)
    STORE m.tnSize TO THIS.nHeight, THIS.nWidth

    *-- Only BMP type
    *!* IF VARTYPE(m.tnType) <> "N"
    m.tnType = 0
    m.lcType = "BMP"
    *!* ENDIF

    IF EMPTY(m.tcFile)
      m.lcFolder = THIS.cTempPath
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.lcFolder + SYS(2015), m.lcType)
    ELSE
      m.lcFolder = JUSTPATH(m.tcFile)
      IF NOT DIRECTORY(m.lcFolder) AND NOT EMPTY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF
    CLEAR RESOURCES m.tcFile

    *-- Declare the functions of QRCodeLib.dll (visit: www.validacfd.com)
    DECLARE FullQRCode IN "QRCodeLib.dll" ;
      INTEGER lAutoConfigurate, ;
      INTEGER lAutoFit, ;
      LONG nBackColor, ;
      LONG nBarColor, ;
      STRING cText, ;
      INTEGER nCorrectionLevel, ;
      INTEGER nEncoding, ;
      INTEGER nMarginPixels, ;
      INTEGER nModuleWidth, ;
      INTEGER nHeight, ;
      INTEGER nWidth, ;
      STRING cFileName

    FullQRCode(THIS.lAutoConfigurate, THIS.lAutoFit, THIS.nBackColor, THIS.nBarColor, ;
      m.tcText, THIS.nCorrectionLevel, THIS.nEncoding, THIS.nMarginPixels, THIS.nModuleWidth, ;
      THIS.nHeight, THIS.nWidth, m.tcFile)

    CLEAR DLLS "FullQRCode"

    RETURN m.tcFile
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE SvrQRCodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with QR Server API (requires internet connection)
  * https://goqr.me/api/
  *  Parametes:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *   tnSize: Imagen Size in pixels
  *   tnType: Imagen Type [png, gif, jpeg, jpg, svg, eps] (everything lowercase)
  *     1 = JPG
  *     2 = PNG
  *     3 = GIF
  *     4 = SVG
  *     5 = EPS
  *   tcECC : Error Correction [L]ow, [M]iddle, [Q]uality, [H]ight,
  *---------------------------------------------------------
  PROCEDURE SvrQRCodeImage(tcText, tcFile, tnSize, tnType)
    LOCAL lcType, lcFolder, lcUrl, lcCorrection, lnMargin

    IF VARTYPE(m.tnSize) <> "N"
      m.tnSize = THIS.nSize && Defaul size = 132 x 132 pixels
    ENDIF

    m.tnSize = MIN(MAX(m.tnSize, 72), 1000)
    m.lnMargin = MIN(MAX(THIS.nMarginPixels, 0), 10)

    IF VARTYPE(m.tnType) <> "N"
      m.tnType = 2 && png
    ENDIF
    
    *-- type [jpg|png|gif|svg|eps]
    m.tnType = MIN(MAX(m.tnType, 1), 5)
    m.lcType = GETWORDNUM([jpg|png|gif|svg|eps],m.tnType,[|])
    
    IF EMPTY(m.tcFile)
      m.lcFolder = THIS.cTempPath
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.lcFolder + SYS(2015), m.lcType)
    ELSE
      m.lcFolder = JUSTPATH(m.tcFile)
      IF NOT DIRECTORY(m.lcFolder) AND NOT EMPTY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF
    CLEAR RESOURCES m.tcFile

    m.lcCorrection = SUBSTR([LMQH], THIS.nCorrectionLevel + 1, 1)
    IF EMPTY(m.lcCorrection)
      m.lcCorrection = [M] && Default
    ENDIF

    m.lcUrl = [https://api.qrserver.com/v1/create-qr-code/] + ;
      [?data=] + m.tcText + ;
      [&size=] + TRANSFORM(m.tnSize) + [x] + TRANSFORM(m.tnSize) + ;
      [&ecc=] + m.lcCorrection + ;
      [&margin=] + TRANSFORM(m.lnMargin) + ;
      [&format=] + m.lcType


    *-- Declare URLDownloadToFile function
    DECLARE LONG URLDownloadToFile IN URLMON.DLL ;
      LONG, STRING, STRING, LONG, LONG

    ERASE (m.tcFile)
    IF 0 = URLDownloadToFile(0, m.lcUrl, m.tcFile, 0, 0)
      RETURN m.tcFile
    ELSE
      RETURN ""
    ENDIF
  ENDPROC


  *---------------------------------------------------------
  * DEPRECATED - DO NOT USE
  *---------------------------------------------------------
  * PROCEDURE GooQRCodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with Google API (requires internet connection)
  * https://developers.google.com/chart/infographics/docs/qr_codes
  *  Parametes:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *   tnSize: Imagen Size in pixels
  *   tnType: Imagen Type [Only 2=PNG]
  *---------------------------------------------------------
  * DEPRECATED - DO NOT USE
  *---------------------------------------------------------
  PROCEDURE GooQRCodeImage(tcText, tcFile, tnSize, tnType)
    LOCAL lcType, lcFolder, lcUrl, lcCorrection, lnMargin

    IF VARTYPE(m.tnSize) <> "N"
      m.tnSize = THIS.nSize && Defaul size = 132 x 132 pixels
    ENDIF

    m.tnSize = MIN(MAX(m.tnSize, 72), 540)
    m.lnMargin = MIN(MAX(THIS.nMarginPixels, 0), 10)

    *-- Only PNG type
    m.tnType = 2
    m.lcType = "PNG"

    IF EMPTY(m.tcFile)
      m.lcFolder = THIS.cTempPath
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.lcFolder + SYS(2015), m.lcType)
    ELSE
      m.lcFolder = JUSTPATH(m.tcFile)
      IF NOT DIRECTORY(m.lcFolder) AND NOT EMPTY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF
    CLEAR RESOURCES m.tcFile

    m.lcCorrection = SUBSTR([LMQH], THIS.nCorrectionLevel + 1, 1)
    IF EMPTY(m.lcCorrection)
      m.lcCorrection = [M] && Default
    ENDIF

    m.lcUrl = [https://chart.googleapis.com/chart?cht=qr] + ;
      [&chs=] + TRANSFORM(m.tnSize) + [x] + TRANSFORM(m.tnSize) + ;
      [&chld=] + m.lcCorrection + [|] + TRANSFORM(m.lnMargin) + ;
      [&chl=] + m.tcText

    *-- Declare URLDownloadToFile function
    DECLARE LONG URLDownloadToFile IN URLMON.DLL ;
      LONG, STRING, STRING, LONG, LONG

    ERASE (m.tcFile)
    IF 0 = URLDownloadToFile(0, m.lcUrl, m.tcFile, 0, 0)
      RETURN m.tcFile
    ELSE
      RETURN ""
    ENDIF
  ENDPROC
  *---------------------------------------------------------
  * DEPRECATED - DO NOT USE
  *---------------------------------------------------------

  *---------------------------------------------------------
  * PROCEDURE FastQRCodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with QRCodeLib.dll (visit: www.validacfd.com)
  *  Parameters:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *---------------------------------------------------------
  PROCEDURE FastQRCodeImage(tcText, tcFile)
    LOCAL lcFolder, lcType

    *-- Only BMP type
    m.lcType = "BMP"

    IF EMPTY(m.tcFile)
      m.lcFolder = THIS.cTempPath
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.lcFolder + SYS(2015), m.lcType)
    ELSE
      m.lcFolder = JUSTPATH(m.tcFile)
      IF NOT DIRECTORY(m.lcFolder) AND NOT EMPTY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF
    CLEAR RESOURCES m.tcFile

    *-- Declare the functions of QRCodeLib.dll (visit: www.validacfd.com)
    DECLARE FastQRCode IN "QRCodeLib.dll" ;
      STRING cText, ;
      STRING cFileName

    FastQRCode(m.tcText, m.tcFile)

    CLEAR DLLS "FastQRCode"

    RETURN m.tcFile
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE QRCodeVersion()
  *------------------------------------------------------
  * Returns the version of the QRCodeLib.dll library
  *------------------------------------------------------
  PROCEDURE QRCodeVersion()
    LOCAL lcVersion
    DECLARE STRING QRCodeLibVer IN "QRCodeLib.dll"
    m.lcVersion = QRCodeLibVer()
    CLEAR DLLS "QRCodeLibVer"
    RETURN m.lcVersion
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE QRBarcodeVersion()
  *------------------------------------------------------
  * Returns the version of the BarCodeLibrary.dll library
  *------------------------------------------------------
  PROCEDURE QRBarcodeVersion()
    LOCAL lcVersion
    DECLARE INTEGER LibraryVersion IN "BarCodeLibrary.dll"
    m.lcVersion = LibraryVersion()
    CLEAR DLLS "LibraryVersion"
    RETURN m.lcVersion
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Init()
  *------------------------------------------------------
  PROCEDURE INIT()
    THIS.cTempPath = ADDBS(THIS.TempPath() + SYS(2015))
    THIS.cAppPath = FULLPATH("")
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE Destroy()
  *------------------------------------------------------
  PROCEDURE DESTROY()
    IF THIS.lDeleteTempFiles
      THIS.EmptyFolder(THIS.cTempPath)
      IF DIRECTORY(THIS.cTempPath)
        RD (THIS.cTempPath)
      ENDIF
    ENDIF
  ENDPROC

  *------------------------------------------------------
  * PROCEDURE EmptyFolder(tcFolder)
  *------------------------------------------------------
  * Empty temporary image folder
  *------------------------------------------------------
  PROCEDURE EmptyFolder(tcFolder)
    LOCAL loFso AS OBJECT
    LOCAL lcMask
    DO CASE
      CASE EMPTY(m.tcFolder)
        RETURN .F.
      CASE NOT DIRECTORY(m.tcFolder)
        RETURN .F.
    ENDCASE
    m.lcMask = ADDBS(m.tcFolder) + "*.*"
    #IF .T. && Use FSO
      m.loFso  = CREATEOBJECT("Scripting.FileSystemObject")
      m.loFso.DeleteFile(m.lcMask, .T.)
    #ELSE && Not Use FSO
      ERASE (m.lcMask)
    #ENDIF
    RETURN  .T.
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE TempPath()
  *---------------------------------------------------------
  * Returns the path for temporary files
  *---------------------------------------------------------
  PROCEDURE TempPath()
    LOCAL lcPath, lnRet
    LOCAL lnSize
    m.lcPath = SPACE(255)
    m.lnSize = 255
    DECLARE INTEGER GetTempPath IN WIN32API ;
      INTEGER nBufSize, ;
      STRING @cPathName
    m.lnRet = GetTempPath(m.lnSize, @m.lcPath)
    IF m.lnRet <= 0
      m.lcPath = ADDBS(FULLPATH("TEMP"))
    ELSE
      m.lcPath = ADDBS(SUBSTR(m.lcPath, 1, m.lnRet))
    ENDIF
    RETURN m.lcPath
  ENDPROC

  *---------------------------------------------------------
  * PROCEDURE Error
  *---------------------------------------------------------
  * Error procedure
  *---------------------------------------------------------
  PROCEDURE ERROR
    LPARAMETERS nError, cMethod, nLine
    LOCAL lcErrMsg
    LOCAL la[1]
    AERROR(la)
    m.lcErrMsg =  "Error number: " + TRANSFORM(m.la(1, 1)) + CHR(13) + ;
      "Error message: " + m.la(1, 2) + CHR(13) + CHR(13) + ;
      "Method: " + m.cMethod + CHR(13) + ;
      "Line: " + TRANSFORM(m.nLine)
    MESSAGEBOX(m.lcErrMsg, 0 + 16, "FoxBarcodeQR error")
  ENDPROC

  *---------------------------------------------------------

ENDDEFINE && FoxBarcodeQR

*--------------------------------------------------------------------------------------
* END DEFINE FoxBarcodeQR Class
*--------------------------------------------------------------------------------------

