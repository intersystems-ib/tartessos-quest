Include %occErrors

Class Tartessos.Quest.Finds.Offering Extends %Persistent
{

Property Material As %String(MAXLEN = 30, VALUELIST = ",gold,clay,iron,bronze,stone") [ Required ];

Property Classification As %String(MAXLEN = 30, VALUELIST = ",jewel,vessel,weapon,tool,ritual") [ Required ];

Property Description As %String(MAXLEN = 250);

Property Inscription As %String(MAXLEN = 250);

Relationship Sarcophagus As Tartessos.Quest.Finds.Sarcophagus [ Cardinality = one, Inverse = Offerings ];

Index ClassificationIdx On Classification;

Method %OnValidateObject() As %Status
{
    If '$ISOBJECT(..Sarcophagus) {
        Return $$$ERROR($$$GeneralError,"Sarcophagus is required")
    }

    Return $$$OK
}

Storage Default
{
<Data name="OfferingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Material</Value>
</Value>
<Value name="3">
<Value>Classification</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Inscription</Value>
</Value>
<Value name="6">
<Value>Sarcophagus</Value>
</Value>
</Data>
<DataLocation>^Tartessos.Quest.FFD6E.OfferingD</DataLocation>
<DefaultData>OfferingDefaultData</DefaultData>
<IdLocation>^Tartessos.Quest.FFD6E.OfferingD</IdLocation>
<IndexLocation>^Tartessos.Quest.FFD6E.OfferingI</IndexLocation>
<StreamLocation>^Tartessos.Quest.FFD6E.OfferingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
