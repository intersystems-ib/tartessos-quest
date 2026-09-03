/// Represents a storage chamber.
Class Tartessos.Quest.Chambers.Storage Extends Tartessos.Quest.Chambers.Chamber
{

/// Number of crates or storage remains found.
Property CrateCount As %Integer [ InitialExpression = 0 ];

/// Indicates whether the chamber still contains usable supplies.
Property ContainsSupplies As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="StorageDefaultData">
<Subscript>"Storage"</Subscript>
<Value name="1">
<Value>CrateCount</Value>
</Value>
<Value name="2">
<Value>ContainsSupplies</Value>
</Value>
</Data>
<DefaultData>StorageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
