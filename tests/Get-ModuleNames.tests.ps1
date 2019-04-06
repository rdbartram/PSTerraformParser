#requires -Modules Pester

$ScriptName = "Get-ModuleNames"

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Import Functions from script
. (Resolve-Path "$here\..\src\private\$ScriptName.ps1")

describe $ScriptName {

    BeforeAll {
        ,$(gci $here\..\src\public) + ,$(gci $here\..\src\private) | % { . $_.fullname }
    }

    it "should return <expected> when path is <path>" -TestCases (
        @{path = "module.test1.module.test2.module.test3.test4"; expected = "test1.test2.test3";},
        @{path = "module.test1.module.test2.test3.test4"; expected = "test1.test2";},
        @{path = "module.test1.test2.test3"; expected = "test1";}
    ) {
        param($path, $expected)
        $path | Get-ModuleNames | Should -Be $expected
    }
}
