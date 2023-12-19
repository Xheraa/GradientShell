# Make a function to loop through the length of an input string and output something based on that
# The goal of this function is to create a color gradient based on 2 input colors
# The gradient should fade smoothly from the first color to the second color and back to the first color
# The gradient should be the length of the input string
# The output should be in the following format: [color=#HEXCODE]CURRENTCHATRACTER[/color]


# This function takes 2 colors and a string as input
# It outputs a string with the same length as the input string
# The output string is a gradient between the 2 input colors
# Create an empty string to store the output

function calculateColor($color1, $color2, $index, $length, $mirror) {
    if ($mirror -ne $true) {
        $percentage = $index / $length
    } else {
        $percentage = [Math]::Min($index, $length - $index - 1) / ($length / 2)
    }
    $red = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(1, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(1, 2), 16))
    $green = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(3, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(3, 2), 16))
    $blue = [int]((1 - $percentage) * [Convert]::ToInt32($color1.Substring(5, 2), 16) + $percentage * [Convert]::ToInt32($color2.Substring(5, 2), 16))
    $red = [string]::Format("{0:X2}", $red)
    $green = [string]::Format("{0:X2}", $green)
    $blue = [string]::Format("{0:X2}", $blue)
    return "#" + $red + $green + $blue
}

function createGradient($color1, $color2, $string, $bold, $mirror) {
    $output = ""
    if ($fontsize -ne 0) {
        $output += "[size=$fontsize]"
    }
    if ($bold) {
        $output += "[b]"
    }
    for ($i = 0; $i -lt $string.Length; $i++) {
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

$color1 = "#bd5289" # Outer color
$color2 = "#daba96" # Inter color
$string = 'TANO*C Sound Team - BATTLE NO.1'
$bold = $true
$mirror = $true
$fontsize = 150

$result = createGradient $color1 $color2 $string $bold $mirror

Write-Output $result