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

Parameter EXERCISE4CODE = "TQ04D4";

Parameter EXERCISE4LEVEL = "level-04-notebook";

Parameter EXERCISE5CODE = "TQ05E5";

Parameter EXERCISE5LEVEL = "level-05-persistent-chambers";

Parameter EXERCISE6CODE = "TQ06F6";

Parameter EXERCISE6LEVEL = "level-06-connected-model";

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/progress" Method="GET" Call="GetProgress"/>
    <Route Url="/exercise/1/validate" Method="GET" Call="ValidateExercise1"/>
    <Route Url="/exercise/2/validate" Method="GET" Call="ValidateExercise2"/>
    <Route Url="/exercise/3/validate" Method="GET" Call="ValidateExercise3"/>
    <Route Url="/exercise/4/validate" Method="GET" Call="ValidateExercise4"/>
    <Route Url="/exercise/5/validate" Method="GET" Call="ValidateExercise5"/>
    <Route Url="/exercise/6/validate" Method="GET" Call="ValidateExercise6"/>
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

    Set className = "Tartessos.Quest.ExcavationUtils"
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

ClassMethod ValidateExercise4() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set className = "Tartessos.Quest.Notebook"

    If '$Data(^notebook) {
        Return ..WriteError(400, "NOTEBOOK_GLOBAL_NOT_FOUND", "The ^notebook global was not found", 4)
    }

    If '$Data(^notebook("totalLines")) {
        Return ..WriteError(400, "NOTEBOOK_TOTAL_LINES_NOT_FOUND", "The ^notebook(""totalLines"") value was not found", 4)
    }

    If '$Data(^notebook("firstChamberType")) {
        Return ..WriteError(400, "NOTEBOOK_FIRST_CHAMBER_TYPE_NOT_FOUND", "The ^notebook(""firstChamberType"") value was not found", 4)
    }

    If +$Get(^notebook("totalLines")) '= 1 {
        Return ..WriteError(400, "NOTEBOOK_GLOBAL_TOTAL_LINES_INVALID", "The ^notebook(""totalLines"") value is invalid", 4)
    }

    If $Get(^notebook("firstChamberType")) '= "Hall" {
        Return ..WriteError(400, "NOTEBOOK_GLOBAL_CHAMBER_TYPE_INVALID", "The ^notebook(""firstChamberType"") value is invalid", 4)
    }

    If '..ClassExists(className) {
        Return ..WriteError(400, "NOTEBOOK_CLASS_NOT_FOUND", "The Notebook class was not found", 4)
    }

    If '..ClassExtends(className, "%RegisteredObject") {
        Return ..WriteError(400, "NOTEBOOK_INVALID_SUPERCLASS", "Notebook must extend %RegisteredObject", 4)
    }

    If '..CollectionPropertyMatches(className, "HallEntries", "list", "Tartessos.Quest.Chambers.Hall") {
        Return ..WriteError(400, "NOTEBOOK_HALLENTRIES_PROPERTY_INVALID", "Notebook must define HallEntries as list Of Tartessos.Quest.Chambers.Hall", 4)
    }

    If '..CollectionPropertyMatches(className, "MortuaryEntries", "list", "Tartessos.Quest.Chambers.Mortuary") {
        Return ..WriteError(400, "NOTEBOOK_MORTUARYENTRIES_PROPERTY_INVALID", "Notebook must define MortuaryEntries as list Of Tartessos.Quest.Chambers.Mortuary", 4)
    }

    If '..CollectionPropertyMatches(className, "StorageEntries", "list", "Tartessos.Quest.Chambers.Storage") {
        Return ..WriteError(400, "NOTEBOOK_STORAGEENTRIES_PROPERTY_INVALID", "Notebook must define StorageEntries as list Of Tartessos.Quest.Chambers.Storage", 4)
    }

    If '..CollectionPropertyMatches(className, "CorridorEntries", "list", "Tartessos.Quest.Chambers.Corridor") {
        Return ..WriteError(400, "NOTEBOOK_CORRIDORENTRIES_PROPERTY_INVALID", "Notebook must define CorridorEntries as list Of Tartessos.Quest.Chambers.Corridor", 4)
    }

    Try {
        Set notebook = $CLASSMETHOD(className, "%New")
        Set hall = $CLASSMETHOD("Tartessos.Quest.Chambers.Hall", "%New")

        Set hall.Code = "HALL-VALIDATION"
        Set hall.Name = "Validation Hall"
        Set hall.Description = "Temporary hall used by validation"
        Set hall.FloorLevel = 1
        Set hall.IsSealed = 0

        Do notebook.HallEntries.Insert(hall)

        Set totalLines = notebook.GetTotalLines()
        Set chamberType = $CLASSMETHOD(className, "GetChamberType", hall)
    } Catch ex {
        Return ..WriteError(500, "NOTEBOOK_BEHAVIOR_ERROR", ex.DisplayString(), 4)
    }

    If totalLines '= 1 {
        Return ..WriteError(400, "NOTEBOOK_TOTAL_LINES_METHOD_FAILED", "GetTotalLines() must return the total number of entries in the notebook", 4)
    }

    If chamberType '= "Hall" {
        Return ..WriteError(400, "NOTEBOOK_CHAMBER_TYPE_METHOD_FAILED", "GetChamberType() must return Hall for a Hall instance", 4)
    }

    Set ^progress = ..#EXERCISE4LEVEL
    Set ^progress("completed", ..#EXERCISE4LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE4LEVEL) = ..#EXERCISE4CODE

    Set notebookInfo = {
        "totalLines": (totalLines),
        "firstChamberType": (chamberType)
    }

    Set response = {
        "success": true,
        "exercise": 4,
        "validationCode": (..#EXERCISE4CODE),
        "notebook": (notebookInfo),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateExercise5() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set baseClass = "Tartessos.Quest.Chambers.Chamber"
    Set utilsClass = "Tartessos.Quest.ExcavationUtils"

    If '..ClassExists(baseClass) {
        Return ..WriteError(400, "CHAMBER_CLASS_NOT_FOUND", "The Chamber class was not found", 5)
    }

    If '..ClassExtends(baseClass, "%Persistent") {
        Return ..WriteError(400, "CHAMBER_NOT_PERSISTENT", "Chamber must extend %Persistent", 5)
    }

    If '..ClassIsAbstract(baseClass) {
        Return ..WriteError(400, "CHAMBER_MUST_BE_ABSTRACT", "Chamber must remain abstract", 5)
    }

    If '..PropertyMatches(baseClass, "IsRelevant", "%Boolean", "", "0") {
        Return ..WriteError(400, "CHAMBER_RELEVANCE_PROPERTY_INVALID", "Chamber must define IsRelevant as %Boolean with InitialExpression 0", 5)
    }

    If '..ClassExists("Tartessos.Quest.Chambers.Hall") {
        Return ..WriteError(400, "HALL_CLASS_NOT_FOUND", "The Hall class was not found", 5)
    }

    If '..ClassExists("Tartessos.Quest.Chambers.Mortuary") {
        Return ..WriteError(400, "MORTUARY_CLASS_NOT_FOUND", "The Mortuary class was not found", 5)
    }

    If '..ClassExists("Tartessos.Quest.Chambers.Storage") {
        Return ..WriteError(400, "STORAGE_CLASS_NOT_FOUND", "The Storage class was not found", 5)
    }

    If '..ClassExists("Tartessos.Quest.Chambers.Corridor") {
        Return ..WriteError(400, "CORRIDOR_CLASS_NOT_FOUND", "The Corridor class was not found", 5)
    }

    If '..ClassExtends("Tartessos.Quest.Chambers.Hall", baseClass) {
        Return ..WriteError(400, "HALL_INVALID_SUPERCLASS", "Hall must extend Chamber", 5)
    }

    If '..ClassExtends("Tartessos.Quest.Chambers.Mortuary", baseClass) {
        Return ..WriteError(400, "MORTUARY_INVALID_SUPERCLASS", "Mortuary must extend Chamber", 5)
    }

    If '..ClassExtends("Tartessos.Quest.Chambers.Storage", baseClass) {
        Return ..WriteError(400, "STORAGE_INVALID_SUPERCLASS", "Storage must extend Chamber", 5)
    }

    If '..ClassExtends("Tartessos.Quest.Chambers.Corridor", baseClass) {
        Return ..WriteError(400, "CORRIDOR_INVALID_SUPERCLASS", "Corridor must extend Chamber", 5)
    }

    If '..ClassExists(utilsClass) {
        Return ..WriteError(400, "EXCAVATION_UTILS_CLASS_NOT_FOUND", "The ExcavationUtils class was not found", 5)
    }

    Try {
        Set invalidHall = $CLASSMETHOD("Tartessos.Quest.Chambers.Hall", "%New")
        Set invalidHall.HasMosaic = 1

        Set invalidStatus = $CLASSMETHOD(utilsClass, "addPage", invalidHall)
    } Catch ex {
        Return ..WriteError(500, "ADDPAGE_METHOD_ERROR", ex.DisplayString(), 5)
    }

    If $System.Status.IsOK(invalidStatus) {
        Return ..WriteError(400, "INVALID_CHAMBER_ACCEPTED", "addPage must reject chambers with missing required fields", 5)
    }

    Try {
        Set hall = $CLASSMETHOD("Tartessos.Quest.Chambers.Hall", "%New")
        Set hall.Code = "HALL-EX5"
        Set hall.Name = "Validation Hall"
        Set hall.Description = "Hall used by exercise 5 validation"
        Set hall.FloorLevel = 1
        Set hall.IsSealed = 0
        Set hall.HasMosaic = 1

        Set status = ..ValidateAddPageForChamber("Tartessos.Quest.Chambers.Hall", hall, 1, "HALL")
    } Catch ex {
        Return ..WriteError(500, "HALL_VALIDATION_ERROR", ex.DisplayString(), 5)
    }

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "HALL_RELEVANCE_FAILED", $System.Status.GetErrorText(status), 5)
    }

    Try {
        Set mortuary = $CLASSMETHOD("Tartessos.Quest.Chambers.Mortuary", "%New")
        Set mortuary.Code = "MORT-EX5"
        Set mortuary.Name = "Validation Mortuary"
        Set mortuary.Description = "Mortuary used by exercise 5 validation"
        Set mortuary.FloorLevel = 2
        Set mortuary.IsSealed = 0
        Set mortuary.TombCount = 2

        Set status = ..ValidateAddPageForChamber("Tartessos.Quest.Chambers.Mortuary", mortuary, 1, "MORTUARY")
    } Catch ex {
        Return ..WriteError(500, "MORTUARY_VALIDATION_ERROR", ex.DisplayString(), 5)
    }

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "MORTUARY_RELEVANCE_FAILED", $System.Status.GetErrorText(status), 5)
    }

    Try {
        Set storage = $CLASSMETHOD("Tartessos.Quest.Chambers.Storage", "%New")
        Set storage.Code = "STOR-EX5"
        Set storage.Name = "Validation Storage"
        Set storage.Description = "Storage used by exercise 5 validation"
        Set storage.FloorLevel = 2
        Set storage.IsSealed = 0
        Set storage.ContainsSupplies = 1

        Set status = ..ValidateAddPageForChamber("Tartessos.Quest.Chambers.Storage", storage, 1, "STORAGE")
    } Catch ex {
        Return ..WriteError(500, "STORAGE_VALIDATION_ERROR", ex.DisplayString(), 5)
    }

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "STORAGE_RELEVANCE_FAILED", $System.Status.GetErrorText(status), 5)
    }

    Try {
        Set corridor = $CLASSMETHOD("Tartessos.Quest.Chambers.Corridor", "%New")
        Set corridor.Code = "CORR-EX5"
        Set corridor.Name = "Validation Corridor"
        Set corridor.Description = "Corridor used by exercise 5 validation"
        Set corridor.FloorLevel = 1
        Set corridor.IsSealed = 0
        Set corridor.Length = 10
        Set corridor.HasFork = 0

        Set status = ..ValidateAddPageForChamber("Tartessos.Quest.Chambers.Corridor", corridor, 0, "CORRIDOR")
    } Catch ex {
        Return ..WriteError(500, "CORRIDOR_VALIDATION_ERROR", ex.DisplayString(), 5)
    }

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "CORRIDOR_RELEVANCE_FAILED", $System.Status.GetErrorText(status), 5)
    }

    Set ^progress = ..#EXERCISE5LEVEL
    Set ^progress("completed", ..#EXERCISE5LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE5LEVEL) = ..#EXERCISE5CODE

    Set persistentChambers = {
        "hallRelevant": true,
        "mortuaryRelevant": true,
        "storageRelevant": true,
        "corridorRelevant": false
    }

    Set response = {
        "success": true,
        "exercise": 5,
        "validationCode": (..#EXERCISE5CODE),
        "persistentChambers": (persistentChambers),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateExercise6() As %Status
{
    Set %response.ContentType = "application/json; charset=utf-8"

    Set mortuaryClass = "Tartessos.Quest.Chambers.Mortuary"
    Set sarcophagusClass = "Tartessos.Quest.Finds.Sarcophagus"
    Set offeringClass = "Tartessos.Quest.Finds.Offering"

    If '..ClassExists(sarcophagusClass) {
        Return ..WriteError(400, "SARCOPHAGUS_CLASS_NOT_FOUND", "Sarcophagus class was not found", 6)
    }

    If '..ClassExists(offeringClass) {
        Return ..WriteError(400, "OFFERING_CLASS_NOT_FOUND", "Offering class was not found", 6)
    }

    If '..ClassExtends(sarcophagusClass, "%Persistent") {
        Return ..WriteError(400, "SARCOPHAGUS_NOT_PERSISTENT", "Sarcophagus must extend %Persistent", 6)
    }

    If '..ClassExtends(offeringClass, "%Persistent") {
        Return ..WriteError(400, "OFFERING_NOT_PERSISTENT", "Offering must extend %Persistent", 6)
    }

    If '..PropertyMatches(sarcophagusClass, "Owner", "%String", 1, "") {
        Return ..WriteError(400, "SARCOPHAGUS_OWNER_PROPERTY_INVALID", "Sarcophagus must define Owner as required %String", 6)
    }

    If '..PropertyMatches(sarcophagusClass, "StateConservation", "%String", 1, "") {
        Return ..WriteError(400, "SARCOPHAGUS_STATE_PROPERTY_INVALID", "Sarcophagus must define StateConservation as required %String", 6)
    }

    If '..PropertyMatches(sarcophagusClass, "Material", "%String", 1, "") {
        Return ..WriteError(400, "SARCOPHAGUS_MATERIAL_PROPERTY_INVALID", "Sarcophagus must define Material as required %String", 6)
    }

    If '..PropertyMatches(sarcophagusClass, "Inscriptions", "%String", "", "") {
        Return ..WriteError(400, "SARCOPHAGUS_INSCRIPTIONS_PROPERTY_INVALID", "Sarcophagus must define Inscriptions as %String", 6)
    }

    If '..PropertyMatches(offeringClass, "Material", "%String", 1, "") {
        Return ..WriteError(400, "OFFERING_MATERIAL_PROPERTY_INVALID", "Offering must define Material as required %String", 6)
    }

    If '..PropertyMatches(offeringClass, "Classification", "%String", 1, "") {
        Return ..WriteError(400, "OFFERING_CLASSIFICATION_PROPERTY_INVALID", "Offering must define Classification as required %String", 6)
    }

    If '..PropertyMatches(offeringClass, "Description", "%String", "", "") {
        Return ..WriteError(400, "OFFERING_DESCRIPTION_PROPERTY_INVALID", "Offering must define Description as %String", 6)
    }

    If '..PropertyMatches(offeringClass, "Inscription", "%String", "", "") {
        Return ..WriteError(400, "OFFERING_INSCRIPTION_PROPERTY_INVALID", "Offering must define Inscription as %String", 6)
    }

    If '..RelationshipMatches(mortuaryClass, "Sarcophagi", sarcophagusClass, "many", "Mortuary") {
        Return ..WriteError(400, "MORTUARY_SARCOPHAGI_RELATIONSHIP_INVALID", "Mortuary must define Sarcophagi as a many relationship to Sarcophagus", 6)
    }

    If '..RelationshipMatches(sarcophagusClass, "Mortuary", mortuaryClass, "one", "Sarcophagi") {
        Return ..WriteError(400, "SARCOPHAGUS_MORTUARY_RELATIONSHIP_INVALID", "Sarcophagus must define Mortuary as a one relationship to Mortuary", 6)
    }

    If '..RelationshipMatches(sarcophagusClass, "Offerings", offeringClass, "many", "Sarcophagus") {
        Return ..WriteError(400, "SARCOPHAGUS_OFFERINGS_RELATIONSHIP_INVALID", "Sarcophagus must define Offerings as a many relationship to Offering", 6)
    }

    If '..RelationshipMatches(offeringClass, "Sarcophagus", sarcophagusClass, "one", "Offerings") {
        Return ..WriteError(400, "OFFERING_SARCOPHAGUS_RELATIONSHIP_INVALID", "Offering must define Sarcophagus as a one relationship to Sarcophagus", 6)
    }

    If '..IndexOnPropertyMatches(offeringClass, "ClassificationIdx", "Classification") {
        Return ..WriteError(400, "OFFERING_CLASSIFICATION_INDEX_MISSING", "Offering must define an index on Classification", 6)
    }

    Set status = ..ValidateSarcophagusValidationRules()

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "SARCOPHAGUS_VALIDATION_FAILED", $System.Status.GetErrorText(status), 6)
    }

    Set status = ..ValidateOfferingValidationRules()

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "OFFERING_VALIDATION_FAILED", $System.Status.GetErrorText(status), 6)
    }

    Set status = ..ValidateMortuarySarcophagusOfferingBehavior()

    If '$System.Status.IsOK(status) {
        Return ..WriteError(400, "RELATIONSHIP_BEHAVIOR_FAILED", $System.Status.GetErrorText(status), 6)
    }

    Set ^progress = ..#EXERCISE6LEVEL
    Set ^progress("completed", ..#EXERCISE6LEVEL) = 1
    Set ^progress("activationCodes", ..#EXERCISE6LEVEL) = ..#EXERCISE6CODE

    Set relationships = {
        "mortuarySarcophagus": true,
        "sarcophagusOffering": true
    }

    Set indexes = {
        "offeringClassification": true
    }

    Set validations = {
        "sarcophagus": true,
        "offering": true
    }

    Set response = {
        "success": true,
        "exercise": 6,
        "validationCode": (..#EXERCISE6CODE),
        "relationships": (relationships),
        "indexes": (indexes),
        "validations": (validations),
        "errorCode": "",
        "errorMessage": ""
    }

    Write response.%ToJSON()

    Return $$$OK
}

ClassMethod ValidateSarcophagusValidationRules() As %Status
{
    Try {
        Set mortuary = ##class(Tartessos.Quest.Chambers.Mortuary).%New()
        Set mortuary.Code = "MORT-EX6-VAL"
        Set mortuary.Name = "Validation Mortuary"
        Set mortuary.Description = "Temporary mortuary used for validation"
        Set mortuary.Level = 3
        Set mortuary.IsSealed = 0
        Set mortuary.IsRelevant = 1
        Set mortuary.TombCount = 2
        Set mortuary.IsSacred = 1

        Set status = mortuary.%Save()

        If '$System.Status.IsOK(status) {
            Return status
        }

        Set invalidSarcophagus = ##class(Tartessos.Quest.Finds.Sarcophagus).%New()
        Set invalidSarcophagus.Owner = "Unknown"
        Set invalidSarcophagus.StateConservation = "wrong-state"
        Set invalidSarcophagus.Material = "stone"
        Set invalidSarcophagus.Mortuary = mortuary

        Set status = invalidSarcophagus.%ValidateObject()

        Do ##class(Tartessos.Quest.Chambers.Mortuary).%DeleteId(mortuary.%Id())

        If $System.Status.IsOK(status) {
            Return $$$ERROR($$$GeneralError,"Sarcophagus accepted an invalid conservation state")
        }
    } Catch ex {
        Return $$$ERROR($$$GeneralError,ex.DisplayString())
    }

    Return $$$OK
}

ClassMethod ValidateOfferingValidationRules() As %Status
{
    Try {
        Set mortuary = ##class(Tartessos.Quest.Chambers.Mortuary).%New()
        Set mortuary.Code = "MORT-EX6-OFF"
        Set mortuary.Name = "Offering Mortuary"
        Set mortuary.Description = "Temporary mortuary used for offering validation"
        Set mortuary.Level = 3
        Set mortuary.IsSealed = 0
        Set mortuary.IsRelevant = 1
        Set mortuary.TombCount = 2
        Set mortuary.IsSacred = 1

        Set status = mortuary.%Save()

        If '$System.Status.IsOK(status) {
            Return status
        }

        Set sarcophagus = ##class(Tartessos.Quest.Finds.Sarcophagus).%New()
        Set sarcophagus.Owner = "Validation Owner"
        Set sarcophagus.StateConservation = "intact"
        Set sarcophagus.Material = "stone"
        Set sarcophagus.Inscriptions = "Validation inscription"
        Set sarcophagus.Mortuary = mortuary

        Set status = sarcophagus.%Save()

        If '$System.Status.IsOK(status) {
            Do ##class(Tartessos.Quest.Chambers.Mortuary).%DeleteId(mortuary.%Id())
            Return status
        }

        Set invalidOffering = ##class(Tartessos.Quest.Finds.Offering).%New()
        Set invalidOffering.Material = "gold"
        Set invalidOffering.Classification = "invalid-classification"
        Set invalidOffering.Description = "Invalid offering"
        Set invalidOffering.Inscription = "None"
        Set invalidOffering.Sarcophagus = sarcophagus

        Set status = invalidOffering.%ValidateObject()

        Do ##class(Tartessos.Quest.Finds.Sarcophagus).%DeleteId(sarcophagus.%Id())
        Do ##class(Tartessos.Quest.Chambers.Mortuary).%DeleteId(mortuary.%Id())

        If $System.Status.IsOK(status) {
            Return $$$ERROR($$$GeneralError,"Offering accepted an invalid classification")
        }
    } Catch ex {
        Return $$$ERROR($$$GeneralError,ex.DisplayString())
    }

    Return $$$OK
}

ClassMethod ValidateMortuarySarcophagusOfferingBehavior() As %Status
{
    Set mortuaryId = ""
    Set sarcophagusId = ""
    Set offeringId = ""

    Try {
        Set mortuary = ##class(Tartessos.Quest.Chambers.Mortuary).%New()
        Set mortuary.Code = "MORT-EX6"
        Set mortuary.Name = "Connected Mortuary"
        Set mortuary.Description = "Mortuary used by exercise 6 validation"
        Set mortuary.Level = 4
        Set mortuary.IsSealed = 0
        Set mortuary.IsRelevant = 1
        Set mortuary.TombCount = 2
        Set mortuary.IsSacred = 1

        Set status = mortuary.%Save()

        If '$System.Status.IsOK(status) {
            Return status
        }

        Set mortuaryId = mortuary.%Id()

        Set sarcophagus = ##class(Tartessos.Quest.Finds.Sarcophagus).%New()
        Set sarcophagus.Owner = "Validation Owner"
        Set sarcophagus.StateConservation = "intact"
        Set sarcophagus.Material = "stone"
        Set sarcophagus.Inscriptions = "Validation inscription"
        Set sarcophagus.Mortuary = mortuary

        Set status = sarcophagus.%Save()

        If '$System.Status.IsOK(status) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return status
        }

        Set sarcophagusId = sarcophagus.%Id()

        Set offering = ##class(Tartessos.Quest.Finds.Offering).%New()
        Set offering.Material = "gold"
        Set offering.Classification = "jewel"
        Set offering.Description = "Validation offering"
        Set offering.Inscription = "Validation inscription"
        Set offering.Sarcophagus = sarcophagus

        Set status = offering.%Save()

        If '$System.Status.IsOK(status) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return status
        }

        Set offeringId = offering.%Id()

        Set savedSarcophagus = ##class(Tartessos.Quest.Finds.Sarcophagus).%OpenId(sarcophagusId)

        If '$ISOBJECT(savedSarcophagus) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Sarcophagus could not be opened")
        }

        If '$ISOBJECT(savedSarcophagus.Mortuary) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Sarcophagus is not linked to Mortuary")
        }

        If savedSarcophagus.Mortuary.%Id() '= mortuaryId {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Sarcophagus is linked to the wrong Mortuary")
        }

        Set savedOffering = ##class(Tartessos.Quest.Finds.Offering).%OpenId(offeringId)

        If '$ISOBJECT(savedOffering) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Offering could not be opened")
        }

        If '$ISOBJECT(savedOffering.Sarcophagus) {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Offering is not linked to Sarcophagus")
        }

        If savedOffering.Sarcophagus.%Id() '= sarcophagusId {
            Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
            Return $$$ERROR($$$GeneralError,"Offering is linked to the wrong Sarcophagus")
        }

        Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
    } Catch ex {
        Do ..CleanupExercise6Objects(mortuaryId, sarcophagusId, offeringId)
        Return $$$ERROR($$$GeneralError,ex.DisplayString())
    }

    Return $$$OK
}

ClassMethod CleanupExercise6Objects(mortuaryId As %String = "", sarcophagusId As %String = "", offeringId As %String = "")
{
    If offeringId '= "" {
        Do ##class(Tartessos.Quest.Finds.Offering).%DeleteId(offeringId)
    }

    If sarcophagusId '= "" {
        Do ##class(Tartessos.Quest.Finds.Sarcophagus).%DeleteId(sarcophagusId)
    }

    If mortuaryId '= "" {
        Do ##class(Tartessos.Quest.Chambers.Mortuary).%DeleteId(mortuaryId)
    }

    Return
}

ClassMethod RelationshipMatches(className As %String, relationshipName As %String, expectedType As %String, expectedCardinality As %String, expectedInverse As %String) As %Boolean
{
    Set actualType = ""
    Set actualCardinality = ""
    Set actualInverse = ""
    Set isRelationship = 0

    &sql(
        SELECT Type, Cardinality, Inverse, Relationship
        INTO :actualType, :actualCardinality, :actualInverse, :isRelationship
        FROM %Dictionary.CompiledProperty
        WHERE parent->Name = :className
        AND Name = :relationshipName
    )

    If SQLCODE '= 0 {
        Return 0
    }

    If 'isRelationship {
        Return 0
    }

    If '..TypeMatches(actualType, expectedType) {
        Return 0
    }

    If $ZCONVERT(actualCardinality,"L") '= $ZCONVERT(expectedCardinality,"L") {
        Return 0
    }

    If actualInverse '= expectedInverse {
        Return 0
    }

    Return 1
}

ClassMethod IndexOnPropertyMatches(className As %String, indexName As %String, propertyName As %String) As %Boolean
{
    Set count = 0

    &sql(
        SELECT COUNT(*)
        INTO :count
        FROM %Dictionary.CompiledIndexProperty
        WHERE parent->parent->Name = :className
        AND parent->Name = :indexName
        AND Property = :propertyName
    )

    If SQLCODE < 0 {
        Return 0
    }

    Return count > 0
}

ClassMethod ValidateAddPageForChamber(className As %String, chamber As %RegisteredObject, expectedRelevant As %Boolean, errorPrefix As %String) As %Status
{
    Set status = $CLASSMETHOD("Tartessos.Quest.ExcavationUtils", "addPage", chamber)

    If '$System.Status.IsOK(status) {
        Return status
    }

    Set id = chamber.%Id()

    If id = "" {
        Return $$$ERROR($$$GeneralError,errorPrefix_" chamber was not saved")
    }

    Set exists = $CLASSMETHOD(className, "%ExistsId", id)

    If 'exists {
        Return $$$ERROR($$$GeneralError,errorPrefix_" chamber does not exist after save")
    }

    Set savedChamber = $CLASSMETHOD(className, "%OpenId", id)

    If '$ISOBJECT(savedChamber) {
        Return $$$ERROR($$$GeneralError,errorPrefix_" chamber could not be opened after save")
    }

    If +savedChamber.IsRelevant '= +expectedRelevant {
        Return $$$ERROR($$$GeneralError,errorPrefix_" chamber relevance value is incorrect")
    }

    Do $CLASSMETHOD(className, "%DeleteId", id)

    Return $$$OK
}

ClassMethod CollectionPropertyMatches(className As %String, propertyName As %String, expectedCollection As %String, expectedType As %String) As %Boolean
{
    Set actualType = ""
    Set actualCollection = ""

    &sql(
        SELECT Type, Collection
        INTO :actualType, :actualCollection
        FROM %Dictionary.CompiledProperty
        WHERE parent->Name = :className
        AND Name = :propertyName
    )

    If SQLCODE '= 0 {
        Return 0
    }

    If $ZCONVERT(actualCollection,"L") '= $ZCONVERT(expectedCollection,"L") {
        Return 0
    }

    If '..TypeMatches(actualType, expectedType) {
        Return 0
    }

    Return 1
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
    Set currentClass = className

    For {
        Set actualSuper = ""

        &sql(
            SELECT Super
            INTO :actualSuper
            FROM %Dictionary.CompiledClass
            WHERE Name = :currentClass
        )

        If SQLCODE '= 0 {
            Return 0
        }

        If actualSuper = "" {
            Return 0
        }

        If ..ClassNameMatches(actualSuper, expectedSuper) {
            Return 1
        }

        Set currentClass = actualSuper
    }

    Return 0
}

ClassMethod ClassNameMatches(actualClass As %String, expectedClass As %String) As %Boolean
{
    If actualClass = expectedClass {
        Return 1
    }

    If (actualClass = "%RegisteredObject") && (expectedClass = "%Library.RegisteredObject") {
        Return 1
    }

    If (actualClass = "%Library.RegisteredObject") && (expectedClass = "%RegisteredObject") {
        Return 1
    }

    If (actualClass = "%Persistent") && (expectedClass = "%Library.Persistent") {
        Return 1
    }

    If (actualClass = "%Library.Persistent") && (expectedClass = "%Persistent") {
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

    If (expectedType = "%Persistent") && (actualType = "%Library.Persistent") {
        Return 1
    }

    If (expectedType = "%Library.Persistent") && (actualType = "%Persistent") {
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
