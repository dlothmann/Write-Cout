<#
 .Synopsis
  Write-Output with color

 .Description
  Use Write-Cout to Write-Output but with color. No more boring Output.

 .Parameter InputObject
  The Text or Object that would be written in the console output.

 .Parameter Color
  Foreground Color of the Output

 .Parameter CWarning
  Set >[WARNING]< before the Output in the color that is defined in -Color

 .Parameter CError
  Set >[ERROR]< before the Output in the color that is defined in -Color

 .Example
   # Write "My name is Ted" in console output in color gray.
   Write-Cout -InputObject "My name is Ted."

 .Example
   # Write "Our planet is called Earth." in console output in color green.
   Write-Cout -InputObject "Our planet is called Earth." -Color Green

 .Example
   # Write "[WARNING] Coffee is a hot drink." in console output in color yellow.
   Write-Cout -InputObject "Coffee is a hot drink." -Color Yellow -CWarning $true

 .Example
   # Write "[ERROR] The Coffee is too hot to drink." in console output in color darkred.
   Write-Cout -InputObject "The Coffee is too hot to drink." -Color DarkRed -CError $true
#>

function Write-Cout{
    [CmdletBinding()]Param (
        [Parameter(Position=1)]
        [string] $InputObject,
        [ValidateSet("Black","Blue","Cyan","DarkBlue","DarkCyan","DarkGrey","DarkGreen","DarkMagenta","DarkRed","DarkYellow","Gray","Green","Magenta","Red","White","Yellow")]
        [System.ConsoleColor] $Color,
        [bool] $CWarning,
        [bool] $CError
    )

    #Set the color to gray if there is no color selection. (Default)

    if($null -eq $Color){
        [System.ConsoleColor]$Color = "Gray"
    }

    #Check if CWarning and CError are both set to true. If yes error is thrown.

    if(($CWarning -eq $true) -and ($CError -eq $true)){
        Write-Error -Message "You can't use -CWarning and -CError at the same time." -Category InvalidArgument
        return
    }

    #Save the actual foreground color

    $Foreground = $host.ui.RawUI.ForegroundColor

    #Set the foreground color based on the -Color parameter

    $host.ui.RawUI.ForegroundColor = $Color


    #Set the [WARNING] tag before the InputObject

    if ($CWarning -eq $true) {
        Write-Output -InputObject "[WARNING] $($InputObject)"
        $host.ui.RawUI.ForegroundColor = $Foreground
        return
    }

    #Set the [ERROR] tag before the InputObject

    if ($CError -eq $true){
        Write-Output -InputObject "[ERROR] $($InputObject)"
        $host.ui.RawUI.ForegroundColor = $Foreground
        return
    }

    #Write the InputObject to console.

    Write-Output -InputObject $InputObject

    #Set the foreground color back to the saved value
    $host.ui.RawUI.ForegroundColor = $Foreground


    return


}