/// Represents a corridor or passage chamber.
Class Tartessos.Quest.Chambers.Corridor Extends Tartessos.Quest.Chambers.Chamber
{

/// Approximate corridor length.
Property Length As %Integer [ InitialExpression = 1 ];

/// Indicates whether the corridor has a fork.
Property HasFork As %Boolean [ InitialExpression = 0 ];

}
