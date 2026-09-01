Class Tartessos.REST.API Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter EXERCISE1CODE = "TQ01A1";

Parameter DEFAULTLEVEL = "level-00-intro";

Parameter EXERCISE1LEVEL = "level-01-adventurer-registration";

Parameter EXERCISE2CODE = "TQ02B2";

Parameter EXERCISE2LEVEL = "level-02-excavation-tools";

Parameter EXERCISE2TESTTOTAL = 3;

Parameter EXERCISE3CODE = "TQ03C3";

Parameter EXERCISE3LEVEL = "level-03-chamber-model";

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/progress" Method="GET" Call="GetProgress"/>
    <Route Url="/exercise/1/validate" Method="GET" Call="ValidateExercise1"/>
    <Route Url="/exercise/2/validate" Method="GET" Call="ValidateExercise2"/>
    <Route Url="/exercise/3/validate" Method="GET" Call="ValidateExercise3"/>
</Routes>
}

ClassMethod GetProgress() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set currentLevel = $Get(^progress, ..#DEFAULTLEVEL)

    Set completedLevels = []
    Set activationCodes = {}

    If $Data(^progress("completed")) {
        Set levelId = ""

        For {
            Set levelId = $Order(^progress("completed", levelId))

            If levelId = "" {
                Quit
            }

            Do completedLevels.%Push(levelId)
        }
    }

    If $Data(^progress("activationCodes")) {
        Set levelId = ""

        For {
            Set levelId = $Order(^progress("activationCodes", levelId))

            If levelId = "" {
                Quit
            }

            Do activationCodes.%Set(levelId, $Get(^progress("activationCodes", levelId)))
        }
    }

    Set response = {
        "currentLevel": (currentLevel),
        "completedLevels": (completedLevels),
        "activationCodes": (activationCodes)
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateExercise1() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Try {
        Set adventurerName = $CLASSMETHOD("Tartessos.Quest.Boot", "GetAdventurerName")
    } Catch ex {
        Return ..WriteError(500, "BOOT_METHOD_ERROR", ex.DisplayString())
    }

    If adventurerName = "" {
        Return ..WriteError(400, "ADVENTURER_NAME_EMPTY", "GetAdventurerName returned an empty value")
    }

    If adventurerName = "CHANGE_ME" {
        Return ..WriteError(400, "ADVENTURER_NAME_NOT_CHANGED", "You must change the ADVENTURERNAME class parameter")
    }

    If '$Data(^adventurerName) {
        Return ..WriteError(400, "GLOBAL_NOT_FOUND", "Global ^adventurerName was not created")
    }

    If $Get(^adventurerName) = "" {
        Return ..WriteError(400, "GLOBAL_EMPTY", "Global ^adventurerName has no value")
    }

    If $Get(^adventurerName) '= adventurerName {
        Return ..WriteError(400, "GLOBAL_VALUE_MISMATCH", "Global ^adventurerName does not match the method return value")
    }

    Set ^progress = ..#EXERCISE1LEVEL
    Set ^progress("completed", ..#EXERCISE1LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE1LEVEL) = ..#EXERCISE1CODE

    Set response = {
        "success": true,
        "exercise": 1,
        "validationCode": (..#EXERCISE1CODE),
        "adventurerName": (adventurerName),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateExercise2() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set className = "Tartessos.Quest.ExcavationTools"
    Set testTotal = ..#EXERCISE2TESTTOTAL

    Do ##class(Tartessos.Quest.Utils).Reset()

    Try {
        Do $CLASSMETHOD(className, "PrepareTool", "trowel", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "hat", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "flashlight", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "batteries", testTotal)
    } Catch ex {
        Return ..WriteError(500, "EXCAVATION_TOOLS_METHOD_ERROR", ex.DisplayString(), 2)
    }

    Set trowel = ##class(Tartessos.Quest.Utils).GetCount("trowel")
    Set hat = ##class(Tartessos.Quest.Utils).GetCount("hat")
    Set flashlight = ##class(Tartessos.Quest.Utils).GetCount("flashlight")
    Set batteries = ##class(Tartessos.Quest.Utils).GetCount("batteries")

    If trowel '= testTotal {
        Return ..WriteError(400, "TROWEL_CHECK_FAILED", "There are problems with the trowel", 2)
    }

    If hat '= testTotal {
        Return ..WriteError(400, "HAT_CHECK_FAILED", "There are problems with the hat", 2)
    }

    If flashlight '= testTotal {
        Return ..WriteError(400, "FLASHLIGHT_CHECK_FAILED", "There are problems with the flashlight", 2)
    }

    If batteries '= testTotal {
        Return ..WriteError(400, "BATTERIES_CHECK_FAILED", "There are problems with the batteries", 2)
    }

    Do ##class(Tartessos.Quest.Utils).Reset()

    Set ^progress = ..#EXERCISE2LEVEL
    Set ^progress("completed", ..#EXERCISE2LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE2LEVEL) = ..#EXERCISE2CODE

    Set response = {
        "success": true,
        "exercise": 2,
        "validationCode": (..#EXERCISE2CODE),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateExercise3() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set baseClass = "Tartessos.Quest.Chambers.Chamber"

    If '..ClassExists(baseClass) {
        Return ..WriteError(400, "CHAMBER_CLASS_NOT_FOUND", "The Chamber class was not found", 3)
    }

    If '..ClassExtends(baseClass, "%RegisteredObject") {
        Return ..WriteError(400, "CHAMBER_INVALID_SUPERCLASS", "Chamber must extend %RegisteredObject", 3)
    }

    If '..ClassIsAbstract(baseClass) {
        Return ..WriteError(400, "CHAMBER_MUST_BE_ABSTRACT", "Chamber must be abstract", 3)
    }

    If '..PropertyMatches(baseClass, "Code", "%String", 1, "") {
        Return ..WriteError(400, "CHAMBER_CODE_PROPERTY_INVALID", "Chamber must define Code as required %String", 3)
    }

    If '..PropertyMatches(baseClass, "Name", "%String", 1, "") {
        Return ..WriteError(400, "CHAMBER_NAME_PROPERTY_INVALID", "Chamber must define Name as required %String", 3)
    }

    If '..PropertyMatches(baseClass, "Description", "%String", "", "") {
        Return ..WriteError(400, "CHAMBER_DESCRIPTION_PROPERTY_INVALID", "Chamber must define Description as %String", 3)
    }

    If '..PropertyMatches(baseClass, "Level", "%Integer", "", "1") {
        Return ..WriteError(400, "CHAMBER_LEVEL_PROPERTY_INVALID", "Chamber must define Level as %Integer with InitialExpression 1", 3)
    }

    If '..PropertyMatches(baseClass, "IsSealed", "%Boolean", "", "1") {
        Return ..WriteError(400, "CHAMBER_ISSEALED_PROPERTY_INVALID", "Chamber must define IsSealed as %Boolean with InitialExpression 1", 3)
    }

    Set status = ..ValidateDerivedChamberClass(
        "Tartessos.Quest.Chambers.Corridor",
        "Length",
        "%Integer",
        "1",
        "HasFork",
        "%Boolean",
        "0",
        "CORRIDOR"
    )

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "CORRIDOR_MODEL_INVALID", $System.Status.GetErrorText(status), 3)
    }

    Set status = ..ValidateDerivedChamberClass(
        "Tartessos.Quest.Chambers.Hall",
        "PillarCount",
        "%Integer",
        "0",
        "HasMosaic",
        "%Boolean",
        "0",
        "HALL"
    )

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "HALL_MODEL_INVALID", $System.Status.GetErrorText(status), 3)
    }

    Set status = ..ValidateDerivedChamberClass(
        "Tartessos.Quest.Chambers.Mortuary",
        "TombCount",
        "%Integer",
        "0",
        "IsSacred",
        "%Boolean",
        "1",
        "MORTUARY"
    )

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "MORTUARY_MODEL_INVALID", $System.Status.GetErrorText(status), 3)
    }

    Set status = ..ValidateDerivedChamberClass(
        "Tartessos.Quest.Chambers.Storage",
        "CrateCount",
        "%Integer",
        "0",
        "ContainsSupplies",
        "%Boolean",
        "0",
        "STORAGE"
    )

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "STORAGE_MODEL_INVALID", $System.Status.GetErrorText(status), 3)
    }

    Set ^progress = ..#EXERCISE3LEVEL
    Set ^progress("completed", ..#EXERCISE3LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE3LEVEL) = ..#EXERCISE3CODE

    Set derivedClasses = []
    Do derivedClasses.%Push("Tartessos.Quest.Chambers.Corridor")
    Do derivedClasses.%Push("Tartessos.Quest.Chambers.Hall")
    Do derivedClasses.%Push("Tartessos.Quest.Chambers.Mortuary")
    Do derivedClasses.%Push("Tartessos.Quest.Chambers.Storage")

    Set model = {
        "baseClass": (baseClass),
        "derivedClasses": (derivedClasses)
    }

    Set response = {
        "success": true,
        "exercise": 3,
        "validationCode": (..#EXERCISE3CODE),
        "model": (model),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateDerivedChamberClass(className As %String, firstProperty As %String, firstType As %String, firstInitial As %String, secondProperty As %String, secondType As %String, secondInitial As %String, errorPrefix As %String) As %Status
{
    If '..ClassExists(className) {
        Return $$$ERROR($$$GeneralError,errorPrefix_" class was not found")
    }

    If '..ClassExtends(className, "Tartessos.Quest.Chambers.Chamber") {
        Return $$$ERROR($$$GeneralError,errorPrefix_" must extend Tartessos.Quest.Chambers.Chamber")
    }

    If '..PropertyMatches(className, firstProperty, firstType, "", firstInitial) {
        Return $$$ERROR($$$GeneralError,errorPrefix_" property "_firstProperty_" is invalid")
    }

    If '..PropertyMatches(className, secondProperty, secondType, "", secondInitial) {
        Return $$$ERROR($$$GeneralError,errorPrefix_" property "_secondProperty_" is invalid")
    }

    Return $$$OK
}

ClassMethod ClassExists(className As %String) As %Boolean
{
    Set count = 0

    &sql(
        SELECT COUNT(*)
        INTO :count
        FROM %Dictionary.CompiledClass
        WHERE Name = :className
    )

    If SQLCODE < 0 {
        Return 0
    }

    Return count > 0
}

ClassMethod ClassIsAbstract(className As %String) As %Boolean
{
    Set abstract = 0

    &sql(
        SELECT Abstract
        INTO :abstract
        FROM %Dictionary.CompiledClass
        WHERE Name = :className
    )

    If SQLCODE '= 0 {
        Return 0
    }

    Return abstract = 1
}

ClassMethod ClassExtends(className As %String, expectedSuper As %String) As %Boolean
{
    Set actualSuper = ""

    &sql(
        SELECT Super
        INTO :actualSuper
        FROM %Dictionary.CompiledClass
        WHERE Name = :className
    )

    If SQLCODE '= 0 {
        Return 0
    }

    If actualSuper = expectedSuper {
        Return 1
    }

    If (expectedSuper = "%RegisteredObject") && (actualSuper = "%Library.RegisteredObject") {
        Return 1
    }

    If (expectedSuper = "%Library.RegisteredObject") && (actualSuper = "%RegisteredObject") {
        Return 1
    }

    Return 0
}

ClassMethod PropertyMatches(className As %String, propertyName As %String, expectedType As %String, expectedRequired As %String = "", expectedInitial As %String = "") As %Boolean
{
    Set actualType = ""
    Set isRequired = ""
    Set actualInitial = ""

    &sql(
        SELECT Type, Required, InitialExpression
        INTO :actualType, :isRequired, :actualInitial
        FROM %Dictionary.CompiledProperty
        WHERE parent->Name = :className
        AND Name = :propertyName
    )

    If SQLCODE '= 0 {
        Return 0
    }

    If '..TypeMatches(actualType, expectedType) {
        Return 0
    }

    If expectedRequired '= "" {
        If +isRequired '= +expectedRequired {
            Return 0
        }
    }

    If expectedInitial '= "" {
        If '..InitialExpressionMatches(actualInitial, expectedInitial) {
            Return 0
        }
    }

    Return 1
}

ClassMethod TypeMatches(actualType As %String, expectedType As %String) As %Boolean
{
    If actualType = expectedType {
        Return 1
    }

    If (expectedType = "%String") && (actualType = "%Library.String") {
        Return 1
    }

    If (expectedType = "%Integer") && (actualType = "%Library.Integer") {
        Return 1
    }

    If (expectedType = "%Boolean") && (actualType = "%Library.Boolean") {
        Return 1
    }

    Return 0
}

ClassMethod InitialExpressionMatches(actualInitial As %String, expectedInitial As %String) As %Boolean
{
    If actualInitial = expectedInitial {
        Return 1
    }

    If actualInitial = "{"_expectedInitial_"}" {
        Return 1
    }

    Return 0
}

ClassMethod WriteError(statusCode As %Integer, errorCode As %String, errorMessage As %String, exercise As %Integer = 1) As %Status
{
    Set %response.Status = statusCode
    Set %response.ContentType = "application/json; charset=utf-8"

    Set response = {
        "success": false,
        "exercise": (exercise),
        "validationCode": "",
        "errorCode": (errorCode),
        "errorMessage": (errorMessage)
    }

    Write response.%ToJSON()

    Return $$$OK
}

}
