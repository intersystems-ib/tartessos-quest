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

ClassMethod CountInscriptions(mortuaryCodePrefix As %String) As %Integer
{
    Set pattern = mortuaryCodePrefix_"%"
    Set sarcophagusInscriptions = 0
    Set offeringInscriptions = 0

    &sql(
        SELECT COUNT(*)
        INTO :sarcophagusInscriptions
        FROM Tartessos_Quest_Finds.Sarcophagus AS S
        INNER JOIN Tartessos_Quest_Chambers.Mortuary AS M
            ON S.Mortuary = M.ID
        WHERE M.Code LIKE :pattern
        AND S.Inscriptions IS NOT NULL
        AND S.Inscriptions <> ''
    )

    If SQLCODE < 0 {
        Return 0
    }

    &sql(
        SELECT COUNT(*)
        INTO :offeringInscriptions
        FROM Tartessos_Quest_Finds.Offering AS O
        INNER JOIN Tartessos_Quest_Finds.Sarcophagus AS S
            ON O.Sarcophagus = S.ID
        INNER JOIN Tartessos_Quest_Chambers.Mortuary AS M
            ON S.Mortuary = M.ID
        WHERE M.Code LIKE :pattern
        AND O.Inscription IS NOT NULL
        AND O.Inscription <> ''
    )

    If SQLCODE < 0 {
        Return 0
    }

    Return sarcophagusInscriptions + offeringInscriptions
}

ClassMethod GetGoldOfferingMortuaryDetails(mortuaryCodePrefix As %String) As %ListOfDataTypes
{
    Set items = ##class(%ListOfDataTypes).%New()
    Set pattern = mortuaryCodePrefix_"%"

    Set sql = "SELECT DISTINCT M.Level AS FloorLevel, M.Code AS Code, M.Description AS Description "_
              "FROM Tartessos_Quest_Chambers.Mortuary AS M "_
              "INNER JOIN Tartessos_Quest_Finds.Sarcophagus AS S ON S.Mortuary = M.ID "_
              "INNER JOIN Tartessos_Quest_Finds.Offering AS O ON O.Sarcophagus = S.ID "_
              "WHERE M.Code LIKE ? "_
              "AND O.Material = ? "_
              "ORDER BY M.Level, M.Code"

    Set statement = ##class(%SQL.Statement).%New()
    Set status = statement.%Prepare(sql)

    If '$System.Status.IsOK(status) {
        Return items
    }

    Set result = statement.%Execute(pattern,"gold")

    If result.%SQLCODE < 0 {
        Return items
    }

    While result.%Next() {
        Set line = "floorLevel="_result.%Get("FloorLevel")_
                   ";code="_result.%Get("Code")_
                   ";description="_result.%Get("Description")

        Do items.Insert(line)
    }

    Return items
}

}
