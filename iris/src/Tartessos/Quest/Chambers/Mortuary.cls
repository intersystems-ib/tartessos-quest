/// Represents a mortuary chamber.
Class Tartessos.Quest.Chambers.Mortuary Extends Tartessos.Quest.Chambers.Chamber
{

/// Number of tombs or burial structures found.
Property TombCount As %Integer [ InitialExpression = 0 ];

/// Indicates whether the chamber is considered sacred.
Property IsSacred As %Boolean [ InitialExpression = 1 ];

}
