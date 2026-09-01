/// Represents a storage chamber.
Class Tartessos.Quest.Chambers.Storage Extends Tartessos.Quest.Chambers.Chamber
{

/// Number of crates or storage remains found.
Property CrateCount As %Integer [ InitialExpression = 0 ];

/// Indicates whether the chamber still contains usable supplies.
Property ContainsSupplies As %Boolean [ InitialExpression = 0 ];

}
