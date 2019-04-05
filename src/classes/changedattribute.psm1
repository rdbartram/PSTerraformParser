using module .\attributevalue.psm1

class changedattribute {
    [attributevalue] $old
    [attributevalue] $new
    [bool] $forcesNewResource
}
