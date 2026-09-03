/// Represents a main hall or ceremonial chamber.
Class Tartessos.Quest.Chambers.Hall Extends Tartessos.Quest.Chambers.Chamber
{

/// Number of preserved pillars in the hall.
Property PillarCount As %Integer [ InitialExpression = 0 ];

/// Indicates whether the hall contains mosaic remains.
Property HasMosaic As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="HallDefaultData">
<Subscript>"Hall"</Subscript>
<Value name="1">
<Value>PillarCount</Value>
</Value>
<Value name="2">
<Value>HasMosaic</Value>
</Value>
</Data>
<DefaultData>HallDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
