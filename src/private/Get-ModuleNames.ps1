function Get-ModuleNames {
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [string]
        $string
    )

    process {
        $output = @()
        $sendIt = $false
        foreach ($element in $string.split(".")) {
            if ($true -eq $sendIt) {
                $output += $element
            }

            $sendIt = $element -eq "module"
        }

        Write-Output ($output -join '.')
    }
}
