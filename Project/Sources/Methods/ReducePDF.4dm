//%attributes = {"invisible":true,"shared":true}
//ReducePDF
//Créé par Stanislas Caron le 23/07/21
//Réduit le poids des images dans un document pdf
//Paramètres :
C_VARIANT:C1683($1; $file)
C_REAL:C285($2; $quality)
C_LONGINT:C283($3; $resolution)
$file:=$1
If (Count parameters:C259>=2)
	$quality:=$2
End if 
If (Count parameters:C259>=3)
	$resolution:=$3
End if 

C_OBJECT:C1216($o)
C_TEXT:C284($content; $fluxIn; $fluxOut; $fluxErr)

If (Is macOS:C1572)
	$o:=New object:C1471()
	$o.valueType:=Value type:C1509($file)
	Case of 
		: ($o.valueType=Is text:K8:3)
			$o.file:=File:C1566($file; fk platform path:K87:2)
			
		: ($o.valueType=Is object:K8:27)
			$o.file:=$file
	End case 
	If ($o.file#Null:C1517)
		If ($o.file.exists)
			$o.resFolder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2)
			$o.tempFolder:=Folder:C1567(Temporary folder:C486; fk platform path:K87:2)
			GET SYSTEM FORMAT:C994(Decimal separator:K60:1; $content)
			$o.quality:=Replace string:C233(String:C10($quality; "#0.0"); $content; ".")
			
			$o.filter:=$o.resFolder.file("ReducePDF.qfilter")
			$o.filterTemp:=$o.filter.copyTo($o.tempFolder; "f"+Generate UUID:C1066+$o.filter.extension; fk overwrite:K87:5)
			$o.filterContent:=$o.filterTemp.getText()
			PROCESS 4D TAGS:C816($o.filterContent; $content; $o.filterTemp.name; $o.quality; $resolution)
			$o.filterTemp.setText($content)
			
			$o.workflow:=$o.resFolder.folder("ReducePDF.workflow")
			$o.workflowTemp:=$o.workflow.copyTo($o.tempFolder; "w"+Generate UUID:C1066+$o.workflow.extension; fk overwrite:K87:5)
			$o.workflowDoc:=$o.workflowTemp.folder("Contents").file("document.wflow")
			$o.workflowContent:=$o.workflowDoc.getText()
			PROCESS 4D TAGS:C816($o.workflowContent; $content; $o.filterTemp.name; $o.filterTemp.path; $o.quality; $resolution)
			$o.workflowDoc.setText($content)
			
			$o.cmd:="automator -i \""+$o.file.path+"\" \""+$o.workflowTemp.path+"\""
			LAUNCH EXTERNAL PROCESS:C811($o.cmd; $fluxIn; $fluxOut; $fluxErr)
			$o.filterTemp.delete()
			$o.workflowTemp.delete(Delete with contents:K24:24)
		End if 
	End if 
	
End if 
