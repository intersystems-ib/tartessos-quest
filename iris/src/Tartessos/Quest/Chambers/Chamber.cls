/// Base class for all chamber types discovered in Tartessos.
Class Tartessos.Quest.Chambers.Chamber Extends %RegisteredObject [ Abstract ]
{

/// Internal chamber code.
Property Code As %String(MAXLEN = 20) [ Required ];

/// Chamber display name.
Property Name As %String(MAXLEN = 80) [ Required ];

/// Short chamber description.
Property Description As %String(MAXLEN = 250);

/// Depth level of the chamber inside the ruins.
Property Level As %Integer [ InitialExpression = 1 ];

/// Indicates whether the chamber is still sealed.
Property IsSealed As %Boolean [ InitialExpression = 1 ];

}
