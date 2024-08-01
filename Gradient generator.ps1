# Calculate the length between 2 colors and return the color at a specific index
function calculateColor($color1, $color2, $index, $length, $mirror) {
    # If mirror is true, the gradient will be mirrored across the middle
    $percentage = if( $mirror ) { 
        # If the index is greater than half the length, calculate the percentage from the end
        [Math]::Min($index, $length - $index - 1) / ($length / 2)
    } else { $index / $length }

    # Isolate the red, green and blue values from the hex color 
    $red   = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(1, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(1, 2), 16))
    $green = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(3, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(3, 2), 16))
    $blue  = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(5, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(5, 2), 16))
    
    # Convert the values back to hex and return the color
    return ("#{0:X2}{1:X2}{2:X2}" -f $red,$green,$blue)
}

# Create the gradient from 2 colors
function createGradient($color1, $color2, $string, [int]$fontsize = 0, [switch]$bold = $false, [switch]$mirror = $false, [switch]$Align = $false) {
    
    [array]$strings = $string -split "`n|`r`n"
    if( $Align ){ $length = ($Strings | Measure-Object -Maximum).Maximum.Length }

    [array]$Lines = Foreach($Str in $strings){
        # Loop through each character in the string and calculate the color at that index
        [array]$chars = for ($i = 0; $i -lt $Str.Length; $i++) {
            # Calculate the color at the current index
            if( !$Align ){ $length = $Str.Length }
            if( $Str[$i] -eq ' '){
                ' '
            } else{ ("[color={0}]{1}[/color]" -f (calculateColor $color1 $color2 $i $length $mirror),$Str[$i])  }
        }
        $chars -Join ''
    }
    $output = $Lines -join "`n"

    # If bold: add the bold tag
    if( $bold ){ $output = "[b]$output[/b]" }

    # If fontsize: add the fontsize tag
    if( $fontsize ){ $Output = "[size=$fontsize]$output[/size]" }

    return $output
}

# Change values here for usage
$color1 = "#E98750" # Outer color
$color2 = "#D0E87B" # inner color
$string = 'GradientShell'
$fontsize = 150

$result = createGradient $color1 $color2 $string $fontsize $bold $mirror

Write-Output $result
