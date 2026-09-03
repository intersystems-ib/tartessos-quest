/// Field notebook used to record explored chambers.
Class Tartessos.Quest.Notebook Extends %RegisteredObject
{

/// Recorded hall chambers.
Property HallEntries As list Of Tartessos.Quest.Chambers.Hall;

/// Recorded mortuary chambers.
Property MortuaryEntries As list Of Tartessos.Quest.Chambers.Mortuary;

/// Recorded storage chambers.
Property StorageEntries As list Of Tartessos.Quest.Chambers.Storage;

/// Recorded corridor chambers.
Property CorridorEntries As list Of Tartessos.Quest.Chambers.Corridor;

/// Returns the total number of chamber entries recorded in the notebook.
Method GetTotalLines() As %Integer
{
    Set total = 0

    Set total = total + ..HallEntries.Count()
    Set total = total + ..MortuaryEntries.Count()
    Set total = total + ..StorageEntries.Count()
    Set total = total + ..CorridorEntries.Count()

    Return total
}

/// Returns the specific chamber type for a chamber object.
ClassMethod GetChamberType(chamber As Tartessos.Quest.Chambers.Chamber) As %String
{
    If '$ISOBJECT(chamber) {
        Return "Unknown"
    }

    If chamber.%IsA("Tartessos.Quest.Chambers.Hall") {
        Return "Hall"
    }

    If chamber.%IsA("Tartessos.Quest.Chambers.Mortuary") {
        Return "Mortuary"
    }

    If chamber.%IsA("Tartessos.Quest.Chambers.Storage") {
        Return "Storage"
    }

    If chamber.%IsA("Tartessos.Quest.Chambers.Corridor") {
        Return "Corridor"
    }

    Return "Unknown"
}

}
