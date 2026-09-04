Include %occErrors

Class Tartessos.Quest.Finds.Sarcophagus Extends %Persistent
{

Property Owner As %String(MAXLEN = 80) [ Required ];

Property StateConservation As %String(MAXLEN = 30, VALUELIST = ",intact,damaged,fragmented") [ Required ];

Property Material As %String(MAXLEN = 30, VALUELIST = ",stone,wood,limestone,marble") [ Required ];

Property Inscriptions As %String(MAXLEN = 500);

Relationship Mortuary As Tartessos.Quest.Chambers.Mortuary [ Cardinality = one, Inverse = Sarcophagi ];

Relationship Offerings As Tartessos.Quest.Finds.Offering [ Cardinality = many, Inverse = Sarcophagus ];

Method %OnValidateObject() As %Status
{
    If '$ISOBJECT(..Mortuary) {
        Return $$$ERROR($$$GeneralError,"Mortuary is required")
    }

    Return $$$OK
}

Storage Default
{
<Data name="SarcophagusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Owner</Value>
</Value>
<Value name="3">
<Value>StateConservation</Value>
</Value>
<Value name="4">
<Value>Material</Value>
</Value>
<Value name="5">
<Value>Inscriptions</Value>
</Value>
<Value name="6">
<Value>Mortuary</Value>
</Value>
</Data>
<DataLocation>^Tartessos.QuesFD6E.SarcophagusD</DataLocation>
<DefaultData>SarcophagusDefaultData</DefaultData>
<IdLocation>^Tartessos.QuesFD6E.SarcophagusD</IdLocation>
<IndexLocation>^Tartessos.QuesFD6E.SarcophagusI</IndexLocation>
<StreamLocation>^Tartessos.QuesFD6E.SarcophagusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
