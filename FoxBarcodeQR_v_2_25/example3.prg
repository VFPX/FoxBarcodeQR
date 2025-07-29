*--------------------------------------------------------------------------------------
* Example3.prg
*--------------------------------------------------------------------------------------
* FoxBarcodeQR example report VCARD
*--------------------------------------------------------------------------------------

SET PROCEDURE TO LOCFILE("FoxBarcodeQR.prg") ADDITIVE

*--- Create FoxBarcodeQR private object
PRIVATE poFbc
m.poFbc = CREATEOBJECT("FoxBarcodeQR")

*-- New properties
m.poFbc.nCorrectionLevel = 2 && Level_Q
m.poFbc.nBarColor = RGB(96,0,0) && Blue

USE (HOME(2)+ "northwind\customers") IN SELECT("Customers")

LABEL FORM FBC_QR_Vcard PREVIEW

m.poFbc = NULL

RETURN

FUNCTION VCARD
  SCATTER NAME loReg
  ALINES(la,loReg.Contactname ,1+4," ")
  TEXT TO lcVcard TEXTMERGE NOSHOW PRETEXT 3
	BEGIN:VCARD
	VERSION:3.0
	N;CHARSET=UTF-8:<<la[2]>>;<<la[1]>>;;;
	FN;CHARSET=UTF-8:<<ALLTRIM(loReg.Contactname)>>
	TITLE;CHARSET=UTF-8:<<ALLTRIM(loReg.Contacttitle)>>
	EMAIL;TYPE=WORK,INTERNET:<<LEFT(CHRTRAN(loreg.Contactname," .,'",""),20)+[@]+LEFT(CHRTRAN(loreg.Companyname," .,'",""),20)+[.com]>>
	TEL;TYPE=CELL,PREF:<<ALLTRIM(loReg.Phone)>>
	TEL;TYPE=WORK,VOICE:<<ALLTRIM(loReg.Fax)>>
	ORG;CHARSET=UTF-8:<<ALLTRIM(loReg.companyname)>>
	ADR;TYPE=WORK;CHARSET=UTF-8:;;<<ALLTRIM(loReg.Address)>>;<<ALLTRIM(loReg.City)>>;<<ALLTRIM(loReg.Region)>>;<<ALLTRIM(loReg.Postalcode)>>;<<ALLTRIM(loReg.Country)>>
	URL:<<[www.]+LEFT(CHRTRAN(loreg.Companyname," .,'",""),20)+[.com]>>
	END:VCARD
  ENDTEXT

  RETURN lcVcard
ENDFUNC

