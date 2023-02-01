# Check Line length in scripts in the current folder

Set-Location Scripts:

$Files = Get-ChildItem *.ps1 -Recurse

"$($Files.count) script files"

Foreach ($file in $Files) {
  $Lines = Get-Content $file.FullName
  $Maxlen = 0
  Foreach ($Line in $Lines){
    if ($line -like '#*') {continue}
    if ($line.length -gt $Maxlen) {
      $Maxlen = $Line.length
    } 
   }
   $FName = $File.Name.Substring(0,15)
   " {0:4} longest line: [{1}]" -f $FName,$Maxlen
   
}

