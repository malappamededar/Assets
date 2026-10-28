# PowerShell script to rename files in the current directory to bg1.jpg, bg2.jpg, ..., bg16.jpg

$files = Get-ChildItem -File | Where-Object { $_.Extension -eq '.jpg' } | Sort-Object Name

for ($i = 0; $i -lt 16; $i++) {
    if ($i -ge $files.Count) { break }
    $newName = "$($i + 1).jpg"
    Rename-Item -Path $files[$i].FullName -NewName $newName
}
