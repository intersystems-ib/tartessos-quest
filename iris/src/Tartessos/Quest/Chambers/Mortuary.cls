/// Represents a mortuary chamber.
Class Tartessos.Quest.Chambers.Mortuary Extends Tartessos.Quest.Chambers.Chamber
{

/// Number of tombs or burial structures found.
Property TombCount As %Integer [ InitialExpression = 0 ];

/// Indicates whether the chamber is considered sacred.
Property IsSacred As %Boolean [ InitialExpression = 1 ];

Relationship Sarcophagi As Tartessos.Quest.Finds.Sarcophagus [ Cardinality = many, Inverse = Mortuary ];

Storage Default
{
<Data name="MortuaryDefaultData">
<Subscript>"Mortuary"</Subscript>
<Value name="1">
<Value>TombCount</Value>
</Value>
<Value name="2">
<Value>IsSacred</Value>
</Value>
</Data>
<DefaultData>MortuaryDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
