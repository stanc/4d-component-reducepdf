//%attributes = {"invisible":true,"shared":true}
//ReducePDF
//Créé par Stanislas Caron le 23/07/21
//Réduit le poids des images dans un document pdf
//Paramètres :
C_VARIANT:C1683($1; $file)
C_REAL:C285($2; $quality)
$file:=$1
If (Count parameters:C259>=2)
	$quality:=$2
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
		$o.resFolder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11).platformPath; fk platform path:K87:2)
		$o.filter:=$o.resFolder.file("ReducePDF.qfilter")
		$o.filterContent:=$o.filter.getText()
		PROCESS 4D TAGS:C816($o.filterContent; $content; String:C10($quality; "&xml"))
		$o.filter.setText($content)
		
		$o.workflow:=$o.resFolder.folder("ReducePDF.workflow")
		$o.workflowDoc:=$o.workflow.folder("Contents").file("document.wflow")
		$o.workflowContent:=$o.workflowDoc.getText()
		PROCESS 4D TAGS:C816($o.workflowContent; $content; $o.filter.name; $o.filter.path)
		$o.workflowDoc.setText($content)
		
		$o.cmd:="automator -i \""+$o.file.path+"\" \""+$o.workflow.path+"\""
		LAUNCH EXTERNAL PROCESS:C811($o.cmd; $fluxIn; $fluxOut; $fluxErr)
		$o.filter.setText($o.filterContent)
		$o.workflowDoc.setText($o.workflowContent)
	End if 
	
End if 
