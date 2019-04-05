class attributevalue {
    [attributetype] $type
    [string] $value

    attributevalue([string]$data) {
        if ($data -eq "<computed>") {
            $this.type = [attributetype]::computed
        } elseif ($data -like '"*') {
            $this.type = [attributetype]::string
            $this.value = $data.trim('"')
        } else {
            $this.type = [attributetype]::unknown
            $this.value = $data
        }
    }
}

enum attributetype {
    unknown
    string
    computed
}
