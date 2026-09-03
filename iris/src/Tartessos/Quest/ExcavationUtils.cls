Class Tartessos.Quest.ExcavationUtils Extends %RegisteredObject
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

ClassMethod addPage(chamber As Tartessos.Quest.Chambers.Chamber) As %Status
{
    If '$ISOBJECT(chamber) {
        Return $System.Status.Error(5001, "Invalid chamber")
    }

    Set status = chamber.%ValidateObject()

    If '$System.Status.IsOK(status) {
        Return status
    }

    Set chamber.IsRelevant = 0

    If chamber.%IsA("Tartessos.Quest.Chambers.Hall") {
        If chamber.HasMosaic = 1 {
            Set chamber.IsRelevant = 1
        }
    } ElseIf chamber.%IsA("Tartessos.Quest.Chambers.Mortuary") {
        If chamber.TombCount > 1 {
            Set chamber.IsRelevant = 1
        }
    } ElseIf chamber.%IsA("Tartessos.Quest.Chambers.Storage") {
        If chamber.ContainsSupplies = 1 {
            Set chamber.IsRelevant = 1
        }
    } ElseIf chamber.%IsA("Tartessos.Quest.Chambers.Corridor") {
        Set chamber.IsRelevant = 0
    } Else {
        Return $System.Status.Error(5001, "Unsupported chamber type")
    }

    Return chamber.%Save()
}

}
