Class Tartessos.Quest.ExcavationTools Extends %RegisteredObject
{

ClassMethod PrepareTool(tool As %String, total As %Integer) As %Boolean
{
    If tool = "trowel" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.Utils).AddTrowel()
        }

        Return 1
    }

    If tool = "hat" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.Utils).AddHat()
        }

        Return 1
    }

    If tool = "flashlight" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.Utils).AddFlashlight()
        }

        Return 1
    }

    If tool = "batteries" {
        For counter = 1:1:total {
            Do ##class(Tartessos.Quest.Utils).AddBattery()
        }

        Return 1
    }

    Return 0
}

}
