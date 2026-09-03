/// Base class for all chamber types discovered in Tartessos.
Class Tartessos.Quest.Chambers.Chamber Extends %Persistent [ Abstract ]
{

/// Internal chamber code.
Property Code As %String(MAXLEN = 20) [ Required ];

/// Chamber display name.
Property Name As %String(MAXLEN = 80) [ Required ];

/// Short chamber description.
Property Description As %String(MAXLEN = 250);

/// Depth level of the chamber inside the ruins.
Property FloorLevel As %Integer [ InitialExpression = 1 ];

/// Indicates whether the chamber is still sealed.
Property IsSealed As %Boolean [ InitialExpression = 1 ];

/// Indicates whether the chamber is relevant.
Property IsRelevant As %Boolean [ InitialExpression = 0 ];

Storage Default
{
<Data name="ChamberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>FloorLevel</Value>
</Value>
<Value name="6">
<Value>IsSealed</Value>
</Value>
<Value name="7">
<Value>IsRelevant</Value>
</Value>
</Data>
<DataLocation>^Tartessos.Quest.Ch2A5D.ChamberD</DataLocation>
<DefaultData>ChamberDefaultData</DefaultData>
<IdLocation>^Tartessos.Quest.Ch2A5D.ChamberD</IdLocation>
<IndexLocation>^Tartessos.Quest.Ch2A5D.ChamberI</IndexLocation>
<StreamLocation>^Tartessos.Quest.Ch2A5D.ChamberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
