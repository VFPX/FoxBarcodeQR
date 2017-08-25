*--------------------------------------------------------------------------------------
* FoxBarcodeQR.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR is a application free software and offers a Barcode tool for the Visual
* FoxPro Community. This is a supplement of FoxBarcode class only for QR Code barcodes.
* This software is provided "as is" without express or implied warranty.
* Use it at your own risk
*--------------------------------------------------------------------------------------
* Version: 1.17
* Date   : 2016.12.21
* Author : VFPEncoding
* Email  : vfpencoding@gmail.com
*
* Note   : VFPEncoding are
*          Guillermo Carrero (QEPD) (Barcelona, Spain) and
*          Luis Maria Guayan (Tucuman, Argentina)
*--------------------------------------------------------------------------------------
* Note   : This application use the free library BarCodeLibrary.DLL
*          of Dario Alvarez Aranda (Mexico)
*--------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------------
* FoxBarcodeQR Class Definition
*--------------------------------------------------------------------------------------
DEFINE CLASS FoxBarcodeQR AS CUSTOM

  m.cTempPath = "" && Windows Temp folder + SYS(2015)
  m.cAppPath = "" && App folder
  m.lDeleteTempFiles = .T. && Delete the temporary folder and image files

  *---------------------------------------------------------
  * PROCEDURE QRBarcodeImage()
  *---------------------------------------------------------
  * Generated QR Barcode image with BarCodeLibrary.DLL
  *  Parameters:
  *   tcText: Text to encode
  *   tcFile: Imagen File Name (optional)
  *   tnSize: Imagen Size [2..12] (default = 4)
  *     2 = 66 x 66 (in pixels)
  *     3 = 99 x 99
  *     4 = 132 x 132
  *     5 = 165 x 165
  *     6 = 198 x 198
  *     7 = 231 x 231
  *     8 = 264 x 264
  *     9 = 297 x 297
  *    10 = 330 x 330
  *    11 = 363 x 363
  *    12 = 396 x 396
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
      IF NOT DIRECTORY(m.lcFolder)
        MD (m.lcFolder)
      ENDIF
      m.tcFile = FORCEEXT(m.tcFile, m.lcType)
    ENDIF

    *- Declare the functions of BarCodeLibrary.dll
    DECLARE INTEGER GenerateFile IN BarCodeLibrary.DLL ;
      STRING cData, STRING cFileName

    DECLARE INTEGER SetConfiguration IN BarCodeLibrary.DLL ;
      INTEGER nSize, INTEGER nImageType

    SetConfiguration(m.tnSize, m.tnType)
    GenerateFile(m.tcText, m.tcFile)

    CLEAR DLLS SetConfiguration, GenerateFile

    RETURN m.tcFile
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

