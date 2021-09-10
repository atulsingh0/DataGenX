Add-Type -AssemblyName System.Windows.Forms
Add-Type -Name ConsoleUtils -Namespace WPIA -MemberDefinition @'
   [DllImport("Kernel32.dll")]
   public static extern IntPtr GetConsoleWindow();
   [DllImport("user32.dll")]
   public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@

# Hide Powershell window
# $hWnd = [WPIA.ConsoleUtils]::GetConsoleWindow()
# [WPIA.ConsoleUtils]::ShowWindow($hWnd, 0)

# Clear-Host

$sleep = @(240..599) | Get-Random
#param($sleep = $sec)  # Seconds
#$plusOrMinus = 1 # Mouse position increment or decrement
$WShell = New-Object -com "Wscript.Shell"

#$index = 0
while ($true)
{
#  Press ScrollLock key
#  $WShell.sendkeys("{SCROLLLOCK}")
#  Start-Sleep -Milliseconds 200
#  $WShell.sendkeys("{SCROLLLOCK}")
  
  $val = @("{^}","{+}","{ESCAPE}", "{%}") | Get-Random
  $WShell.sendkeys($val)

  # Move mouse
#  $p = [System.Windows.Forms.Cursor]::Position
#  $x = $p.X + $plusOrMinus
#  $y = $p.Y + $plusOrMinus
#  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
#  $plusOrMinus *= -1
  
  # Sleep
  Start-Sleep -Seconds $sleep	
}
