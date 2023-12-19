# Calculate the length between 2 colors and return the color at a specific index
function calculateColor($color1, $color2, $index, $length, $mirror) {
    # If mirror is true, the gradient will be mirrored across the middle
    if ($mirror -ne $true) {
        $percentage = $index / $length
    } else {
        # If the index is greater than half the length, calculate the percentage from the end
        $percentage = [Math]::Min($index, $length - $index - 1) / ($length / 2)
    }
    # Isolate the red, green and blue values from the hex color 
    $red = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(1, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(1, 2), 16))
    $green = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(3, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(3, 2), 16))
    $blue = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(5, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(5, 2), 16))
    # Convert the values back to hex and return the color
    # The [string]::Format("{0:X2}", $value) will convert the value to hex and pad it with a 0 if it's only 1 digit
    $red = [string]::Format("{0:X2}", $red)
    $green = [string]::Format("{0:X2}", $green)
    $blue = [string]::Format("{0:X2}", $blue)
    return "#" + $red + $green + $blue
}

# Create the gradient from 2 colors
function createGradient($color1, $color2, $string, $bold, $mirror) {
    $output = ""
    # If fontsize is 0, don't add the size tag, else add the fontsize inside the tag
    if ($fontsize -ne 0) {
        $output += "[size=$fontsize]"
    }
    # If bold is true, add the bold tag
    if ($bold) {
        $output += "[b]"
    }
    # Loop through each character in the string and calculate the color at that index
    for ($i = 0; $i -lt $string.Length; $i++) {
        # Calculate the color at the current index
        $currentColor = calculateColor $color1 $color2 $i $string.Length $mirror
        $output += "[color=$currentColor]" + $string[$i] + "[/color]"
    }
    if ($bold) {
        $output += "[/b]"
    }
    if ($fontsize -ne 0) {
        $output += "[/size]"
    }
    return $output
}

# Change values here for usage
$color1 = "#bd5289" # Outer color
$color2 = "#daba96" # Inter color
$string = 'TANO*C Sound Team - BATTLE NO.1'
$bold = $true
$mirror = $true
$fontsize = 150

$result = createGradient $color1 $color2 $string $bold $mirror

Write-Output $result
