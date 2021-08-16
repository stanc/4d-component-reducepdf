//%attributes = {"invisible":true}
C_OBJECT:C1216($o)
$o:=New object:C1471()

If (Shift down:C543)  //ReducePDF(Nom doc)
	$o.doc:=Select document:C905("";".pdf";"Document pdf";0)
	If (OK=1)
		ReducePDF (Document)
	End if 
	
End if 

If (Shift down:C543)  //ReducePDF(File)
	$o.doc:=Select document:C905("";".pdf";"Document pdf";0)
	If (OK=1)
		ReducePDF (File:C1566(Document;fk platform path:K87:2))
	End if 
	
End if 
