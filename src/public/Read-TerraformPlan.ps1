using module ..\classes\terraformplan.psm1

function Read-TerraformPlan {
    param(
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )

    begin {
        $noChangesStr = 'No changes. Infrastructure is up-to-date.'
        $contentStartStr = 'Terraform will perform the following actions:'
        $contentEndStr = 'Plan:'
        $changesSeperator = ' => '
        $newResourceForced = ' (forces new resource)'

        $actionMapping = @{
            '+'   = [action]::create
            '-'   = [action]::destroy
            '-/+' = [action]::replace
            '~'   = [action]::update
            '<='  = [action]::read
        }
    }

    process {
        $Data = Get-Content $Path

        $result = [terraformplan]::new()

        # error out if no start is found
        if (($data -match "^$contentStartStr").count -eq 0) {
            $result.errors += [error]@{
                code    = "UNABLE_TO_FIND_STARTING_POSITION_WITHIN_FILE"
                message = "Did not find magic starting string: $contentStartStr"
            }
            return $result
        }

        # error out if no end is found
        if (($data -match "^$contentEndStr").count -eq 0) {
            $result.errors += [error]@{
                code    = "UNABLE_TO_FIND_ENDING_POSITION_WITHIN_FILE"
                message = "Did not find magic ending string: $contentEndStr"
            }
            return $result
        }

        # return empty result because no changes were found
        if ($data -match $noChangesStr) {
            return $result
        }

        $startDetected = $false
        $newResource = $true

        foreach ($line in $data) {
            # start processing since we've found the start
            if ($false -eq $startDetected -and $line -match "^$contentStartStr") {
                $startDetected = $true
                continue
            }

            # stop if at the end
            if ($startDetected -and $line -match "^$contentEndStr") {
                break;
            }

            if ($true -eq $startDetected) {
                # ignore blanks lines and start new resources
                if ([string]::IsNullOrWhiteSpace($line)) {
                    if ($null -ne $changedResource) {
                        if ($changedResource.action -eq [action]::read) {
                            $result.changedDataSources += $changedResource
                        } else {
                            $result.changedResources += $changedResource
                        }
                        $changedResource = $null
                    }
                    $newResource = $true
                    continue
                }

                # process new resources
                if ($true -eq $newResource) {
                    $newResource = $false
                    $changedResource = [change]::new()

                    if ($line -match '^ *(?<action>[\+\-\/~<=]+) (?<resource>\S+)(( \(((?<tainted>tainted)|(?<newresource>new resource required))\))*)?') {
                        $changedResource.action = $actionMapping[$matches.action]
                        $changedResource.path = $matches.resource

                        $resourceComponents = $matches.resource.Split(".")
                        $changedResource.name = $resourceComponents[-1]
                        $changedResource.type = $resourceComponents[-2]
                        $changedResource.tainted = (![string]::IsNullOrEmpty($matches.tainted))
                        $changedResource.newResourceRequired = (![string]::IsNullOrEmpty($matches.newresource))
                        $changedResource.module = $changedResource.path | Get-ModuleNames

                    } else {
                        $result.errors += [error]@{
                            code    = "UNABLE_TO_PARSE_CHANGE_LINE"
                            message = "Unable to parse '$line' (ignoring)"
                        }
                    }
                }

                # add properties to new resource
                if ($null -ne $changedResource -and $line -match '^ +(?<attribute>\S+): *(?<value>.+)') {
                    $attributechanges = [changedattribute]::new()

                    $old, $new = $matches.Value.split("=>").trim()

                    $attributechanges.old = [attributevalue]::new($old)

                    if ($null -ne $new) {
                        $attributechanges.new = [attributevalue]::new($new)
                    }

                    $attributechanges.forcesNewResource = $value -match ' \(forces new resource\) *$'

                    $attribute = @{$matches.attribute = $attributechanges }

                    $changedResource.changedAttributes += $attribute
                }
            }
        }

        return $result
    }
}
