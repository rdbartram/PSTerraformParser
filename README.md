# PSTerraformParser

> I hope someday this functionality ends up native in Terraform, but for now, we have PowerShell.

PSTerraformParser is a module designed to take the string output from your terraform plans and return them in a standardised json format.

🐱‍💻 PSTerraformParser is built and tested in Azure DevOps and is distributed via the PowerShell gallery.

[![pester](https://img.shields.io/azure-devops/tests/rdbartram/GitHubPipelines/8.svg?label=pester&logo=azuredevops&style=for-the-badge)](https://dev.azure.com/rdbartram/GithubPipelines/_build/latest?definitionId=8?branchName=master)
[![latest version](https://img.shields.io/powershellgallery/v/PSTerraformParser.svg?label=latest+version&style=for-the-badge)](https://www.powershellgallery.com/packages/PSTerraformParser)
[![downloads](https://img.shields.io/powershellgallery/dt/PSTerraformParser.svg?label=downloads&style=for-the-badge)](https://www.powershellgallery.com/packages/PSTerraformParser)



## Installation

PSTerraformParser is compatible with Windows PowerShell 5.x and PowerShell Core 6.x.

```powershell
Install-Module -Name PSTerraformParser -Scope CurrentUser -Force
```

## Features

### Terraform Plan Parsing

Since the output from Terraform plan is just plan text and not easily readable for automation, I've done the hard work and provided it in
json format for you. Just use the following command

```powershell
terraform plan -no-color >> .\MyPlan.txt

Read-TerraformPlan -Path .\MyPlan.txt
```

> IMPORTANT: I can't parse the file produced by the -out=path argument for terraform plan which is a binary file. There is not a stable specification for this binary file format so, at this time, it is safer to parse the somewhat structured textual output that gets written to stdout.


## Further reading

For more information pertaining to Terraform, head to their website [terraform](https://terraform.io).

## Got questions?

Got questions or you just want to get in touch? Use our issues page or one of these channels:

[![Pester Twitter](https://img.icons8.com/color/96/000000/twitter.png)](https://twitter.com/rd_bartram)
