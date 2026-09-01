Class Tartessos.Quest.ExcavationTools Extends %RegisteredObject
{

ClassMethod PrepareTool(tool As %String, total As %Integer) As %Boolean
{
    If tool = "trowel" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.ExcavationKitUtils).AddTrowel()
        }

        Return 1
    }

    If tool = "hat" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.ExcavationKitUtils).AddHat()
        }

        Return 1
    }

    If tool = "flashlight" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.ExcavationKitUtils).AddFlashlight()
        }

        Return 1
    }

    If tool = "batteries" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.ExcavationKitUtils).AddBattery()
        }

        Return 1
    }

    Return 0
}

}