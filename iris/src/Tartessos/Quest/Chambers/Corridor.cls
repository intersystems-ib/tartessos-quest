/// Represents a corridor or passage chamber.
Class Tartessos.Quest.Chambers.Corridor Extends Tartessos.Quest.Chambers.Chamber
{

/// Approximate corridor length.
Property Length As %Integer [ InitialExpression = 1 ];

/// Indicates whether the corridor has a fork.
Property HasFork As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="CorridorDefaultData">
<Subscript>"Corridor"</Subscript>
<Value name="1">
<Value>Length</Value>
</Value>
<Value name="2">
<Value>HasFork</Value>
</Value>
</Data>
<DefaultData>CorridorDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
