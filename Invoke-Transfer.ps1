#================================================#
#    Invoke-Transfer by @JoelGMSec & @3v4Si0N    #
#  https://github.com/JoelGMSec/Invoke-Transfer  #
#================================================#

# Namespace
using namespace Windows.Storage
using namespace Windows.Graphics.Imaging

# Design
$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "SilentlyContinue"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Gray"

# Banner
Write-Host
Write-Host "  ___                 _           _____                     __            " -ForegroundColor Blue
Write-Host " |_ _|_ __ _   __ __ | | __ __   |_   _| __ __ _ _ __  ___ / _| ___ _ __  " -ForegroundColor Blue
Write-Host "  | || '_ \ \ / / _ \| |/ / _ \____| || '__/ _' | '_ \/ __| |_ / _ \ '__| " -ForegroundColor Blue
Write-Host "  | || | | \ V / (_) |   <  __/____| || | | (_| | | | \__ \  _|  __/ |    " -ForegroundColor Blue
Write-Host " |___|_| |_|\_/ \___/|_|\_\___|    |_||_|  \__,_|_| |_|___/_|  \___|_|    " -ForegroundColor Blue
Write-Host "                                                                           " -ForegroundColor Blue
Write-Host "  ----------------------- by @JoelGMSec & @3v4Si0N ---------------------  " -ForegroundColor Green
Write-Host

# Help
function Show-Help {
   Write-host ; Write-Host " Info: " -ForegroundColor Yellow -NoNewLine ; Write-Host " This tool helps you to send files in highly restricted environments"
   Write-Host "        such as Citrix, RDP, VNC, Guacamole... using the clipboard function"
   Write-Host ; Write-Host " Usage: " -ForegroundColor Yellow -NoNewLine ; Write-Host ".\Invoke-Transfer.ps1 -split {FILE} -sec {SECONDS}" -ForegroundColor Blue 
   Write-Host "          Send 120KB chunks with a set time delay of seconds" -ForegroundColor Green
   Write-Host "          Add -guaca to send files through Apache Guacamole" -ForegroundColor Green
   Write-Host ; Write-Host "        .\Invoke-Transfer.ps1 -plain {FILE} -sec {SECONDS}" -ForegroundColor Blue 
   Write-Host "          Send raw keystrokes with a set time delay of seconds" -ForegroundColor Green
   Write-Host ; Write-Host "        .\Invoke-Transfer.ps1 -merge {B64FILE} -out {FILE}" -ForegroundColor Blue 
   Write-Host "          Merge Base64 file into original file in desired path" -ForegroundColor Green
   Write-Host ; Write-Host "        .\Invoke-Transfer.ps1 -read {IMGFILE} -out {FILE}" -ForegroundColor Blue 
   Write-Host "          Read screenshot with Windows OCR and save output to file" -ForegroundColor Green
   Write-Host ; Write-Host " Warning: " -ForegroundColor Red -NoNewLine  ; Write-Host "This tool only works on Windows 10 or greater"
   Write-Host "         " -NoNewLine ; Write-Host " OCR reading may not be entirely accurate" ; Write-Host }

# Variables
$infile = $args[1]
$filename = $infile.split("\")[-1]
$seconds = $args[3]
$extfile = $args[3]
$outfile = "C:\programdata\chunk"
$ext = "txt"
$size = 120KB

# Assembly
Add-Type -AssemblyName System.Windows.Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

# Functions
function Split-File {
  $infileFile = [io.file]::OpenRead($outfile)
  $buff = new-object byte[] $size
  $count = $idx = 1
  try { do {
    $count = $infileFile.Read($buff, 0, $buff.Length)
    if ($count -gt 0) {
      $to = "{0}.{1}.{2}" -f ($outfile, $idx, $ext)
      $toFile = [io.file]::OpenWrite($to)
      try {$tofile.Write($buff, 0, $count)}
      finally {$tofile.Close()}}
    $idx ++ }
    while ($count -gt 0)}
  finally {$infileFile.Close()}
  $global:idx = $idx - 2 }

function Write-ToB64 {
  Write-Host "[+] Converting $filename to Base64.." -ForegroundColor Magenta
  $raw_file = [System.IO.File]::ReadAllBytes($infile)
  $b64_file = [convert]::ToBase64String($raw_file)
  [System.IO.File]::WriteAllText($outfile, $b64_file)}

function Write-FromB64 {
  Write-Host "[+] Converting $filename from Base64.." -ForegroundColor Magenta
  $b64_file = [System.IO.File]::ReadAllText($infile)
  $raw_file = [convert]::FromBase64String($b64_file)
  [System.IO.File]::WriteAllBytes($extfile, $raw_file)}

function Invoke-Split {
  Write-ToB64 ; Split-File
  Write-Host "[+] Spliting file in $idx chunks.." -ForegroundColor Blue
  Start-Sleep -Seconds 2 }

function Invoke-Merge {
  Write-FromB64 $infile $extfile;
  Write-Host "[+] Copying bytes to file.." -ForegroundColor Blue
  Start-Sleep -Seconds 2 }

function LeftClick {
  $x = 150 ; $y = 350
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  Start-Sleep -Seconds $seconds
  $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
  $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
  Start-Sleep -Seconds $seconds }

function PopUpWindow {
  $instance = Get-WmiObject Win32_Process -Filter "ProcessId = '$pid'"
  $parentProcess = (Get-Process -Id $instance.ParentProcessId).ProcessName
  if ($parentProcess -ne "WindowsTerminal") { $parentProcess = "powershell" }
  ($sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);') 2>&1> $null
  Add-Type -MemberDefinition $sig -Name NativeMethods -Namespace Win32
  $hwnd = @(Get-Process $parentProcess)[0].MainWindowHandle
  [Win32.NativeMethods]::ShowWindowAsync($hwnd, 6) 2>&1> $null ; Start-Sleep -Seconds 0.1
  [Win32.NativeMethods]::ShowWindowAsync($hwnd, 9) 2>&1> $null }

function Send-PlainFile {
  Write-Host "[+] Reading plain file content.." -ForegroundColor Blue
  $File = Get-Content -raw $infile ; Start-Sleep -Seconds 1
  Write-Host "[>] Ready! Press enter to send file! " -ForegroundColor Yellow -NoNewLine
  $Host.UI.ReadLine() 2>&1> $null ; Start-Sleep -Seconds 4
  Write-Host "[+] Sending keystrokes.." -ForegroundColor Red
  Start-Sleep -Seconds $seconds
  foreach ($char in $File.ToCharArray()) {
    switch ($char) {
      "`r" { }
      " " { [System.Windows.Forms.SendKeys]::SendWait(" ") }
      "`n" { [System.Windows.Forms.SendKeys]::SendWait("~") }
      "{"  { [System.Windows.Forms.SendKeys]::SendWait("{{}") }
      "}"  { [System.Windows.Forms.SendKeys]::SendWait("{}}") }
      "%"  { [System.Windows.Forms.SendKeys]::SendWait("{%}") }
      "+"  { [System.Windows.Forms.SendKeys]::SendWait("{+}") } 
      "^"  { [System.Windows.Forms.SendKeys]::SendWait("{^}") }
      "~"  { [System.Windows.Forms.SendKeys]::SendWait("{~}") }
      "("  { [System.Windows.Forms.SendKeys]::SendWait("({(}") }
      ")"  { [System.Windows.Forms.SendKeys]::SendWait("{)}") }
      "["  { [System.Windows.Forms.SendKeys]::SendWait("({[}") }
      "]"  { [System.Windows.Forms.SendKeys]::SendWait("{]}") }
      default { [System.Windows.Forms.SendKeys]::SendWait("$char") }}
      
  Start-Sleep -Milliseconds 100 }
  Start-Sleep -Seconds 2 ; PopUpWindow }

function Send-File { 
  Write-Host "[>] Ready! Press enter to send file! " -ForegroundColor Yellow -NoNewLine
  $Host.UI.ReadLine() 2>&1> $null ; Start-Sleep -Seconds 4
  Write-Host "[+] Sending chunks.." -ForegroundColor Red
  Get-ChildItem | Where-Object { 
    $_.Name -match '^chunk.[0-9]+\.txt$' } | Sort-Object -Property LastWriteTime, CreationTime, Name | % {
    $File = Get-Content -raw $_.fullname | Set-Clipboard ; Start-Sleep -Seconds $seconds
    if ($guacamole) {
      [System.Windows.Forms.SendKeys]::SendWait("+^%")       
      Start-Sleep -Seconds $seconds ; LeftClick
      [System.Windows.Forms.SendKeys]::SendWait("^{a}")
      Start-Sleep -Seconds $seconds
      [System.Windows.Forms.SendKeys]::SendWait("{DEL}")
      Start-Sleep -Seconds $seconds
      [System.Windows.Forms.SendKeys]::SendWait("^{v}")
      Start-Sleep -Seconds $seconds
      [System.Windows.Forms.SendKeys]::SendWait("+^%")
      Start-Sleep -Seconds $seconds
      [System.Windows.Forms.SendKeys]::SendWait("^{v}")}

    else { [System.Windows.Forms.SendKeys]::SendWait("^{v}") }}
  Start-Sleep -Seconds 2 ; PopUpWindow }

function Invoke-OCR {
  [CmdletBinding()] Param ([Parameter()]$Path)

  Begin {
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $null = [Windows.Storage.StorageFile,                Windows.Storage,         ContentType = WindowsRuntime]
    $null = [Windows.Media.Ocr.OcrEngine,                Windows.Foundation,      ContentType = WindowsRuntime]
    $null = [Windows.Foundation.IAsyncOperation`1,       Windows.Foundation,      ContentType = WindowsRuntime]
    $null = [Windows.Graphics.Imaging.SoftwareBitmap,    Windows.Foundation,      ContentType = WindowsRuntime]
    $null = [Windows.Storage.Streams.RandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]

    $ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $getAwaiterBaseMethod = [WindowsRuntimeSystemExtensions].GetMember('GetAwaiter').
    Where({ $PSItem.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' }, 'First')[0]

    Function Await {
      param($AsyncTask, $ResultType)
      $getAwaiterBaseMethod.
      MakeGenericMethod($ResultType).
      Invoke($null, @($AsyncTask)).
      GetResult()}}

  Process { foreach ($p in $Path) {
    $p = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p)
    
    $params = @{ 
      AsyncTask  = [StorageFile]::GetFileFromPathAsync($p)
      ResultType = [StorageFile]}
    $storageFile = Await @params

    $params = @{ 
      AsyncTask  = $storageFile.OpenAsync([FileAccessMode]::Read)
      ResultType = [Streams.IRandomAccessStream]}
    $fileStream = Await @params

    $params = @{
      AsyncTask  = [BitmapDecoder]::CreateAsync($fileStream)
      ResultType = [BitmapDecoder]}
    $bitmapDecoder = Await @params

    $params = @{ 
      AsyncTask = $bitmapDecoder.GetSoftwareBitmapAsync()
      ResultType = [SoftwareBitmap]}
    $softwareBitmap = Await @params

    Await $ocrEngine.RecognizeAsync($softwareBitmap) ([Windows.Media.Ocr.OcrResult])}
    Write-Host "[+] Reading $filename with OCR.." -ForegroundColor Magenta ; Start-Sleep -Seconds 2
    Write-Host "[+] Copying text to file.." -ForegroundColor Blue ; Start-Sleep -Seconds 2 }}

# Main
if (!$seconds) { $seconds = 2 }
if ($args[0] -like "-h*") { Show-Help ; break }
if ($args[1] -eq $null) { Show-Help ; Write-Host "[!] Not enough parameters!`n" -ForegroundColor Red ; break }
if ($args -like "-plain*") { Send-PlainFile $args }
if ($args -like "-split*") { Invoke-Split $args ; Send-File $args }
if ($args -like "-merge*") { Invoke-Merge $args }
if ($args -like "-guaca*") { $guacamole = "True" }
if ($args -like "-read*") { (Invoke-OCR $args[1]).text >> $args[3] }
Remove-Item ".\chunk*" -Force ; Write-Host "[+] Done!`n" -ForegroundColor Green
