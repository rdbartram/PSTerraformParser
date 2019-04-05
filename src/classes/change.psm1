class change {
    [string] $module
    [action] $action
    [string] $type
    [string] $name
    [string] $path
    [hashtable] $changedAttributes
    [bool] $newResourceRequired
    [bool] $tainted
}

enum action {
    create
    destroy
    replace
    update
    read
}
