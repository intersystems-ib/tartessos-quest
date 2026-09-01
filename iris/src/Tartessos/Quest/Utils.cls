Class Tartessos.Quest.Utils Extends %RegisteredObject
{

ClassMethod Reset()
{
    Kill ^excavationKit

    Return
}

ClassMethod AddTrowel()
{
    Set ^excavationKit("trowel") = $Get(^excavationKit("trowel"), 0) + 1

    Return
}

ClassMethod AddHat()
{
    Set ^excavationKit("hat") = $Get(^excavationKit("hat"), 0) + 1

    Return
}

ClassMethod AddFlashlight()
{
    Set ^excavationKit("flashlight") = $Get(^excavationKit("flashlight"), 0) + 1

    Return
}

ClassMethod AddBattery()
{
    Set ^excavationKit("batteries") = $Get(^excavationKit("batteries"), 0) + 1

    Return
}

ClassMethod GetCount(tool As %String) As %Integer
{
    Return +$Get(^excavationKit(tool), 0)
}


}