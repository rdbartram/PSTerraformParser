using module .\error.psm1
using module .\change.psm1

class terraformplan {
    [error[]] $errors
    [change[]] $changedResources
    [change[]] $changedDataSources
}
