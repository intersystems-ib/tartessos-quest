Class Tartessos.REST.API Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter EXERCISE1CODE = "TQ01A1";

Parameter DEFAULTLEVEL = "level-00-intro";

Parameter EXERCISE1LEVEL = "level-01-adventurer-registration";

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/progress" Method="GET" Call="GetProgress"/>
    <Route Url="/exercise/1/validate" Method="GET" Call="ValidateExercise1"/>
    <Route Url="/exercise/2/validate" Method="GET" Call="ValidateExercise2"/>
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

    Do ##class(Tartessos.Quest.ExcavationKitUtils).Reset()

    Try {
        Do $CLASSMETHOD(className, "PrepareTool", "trowel", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "hat", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "flashlight", testTotal)
        Do $CLASSMETHOD(className, "PrepareTool", "batteries", testTotal)
    } Catch ex {
        Return ..WriteError(500, "EXCAVATION_TOOLS_METHOD_ERROR", ex.DisplayString(), 2)
    }

    Set trowel = ##class(Tartessos.Quest.ExcavationKitUtils).GetCount("trowel")
    Set hat = ##class(Tartessos.Quest.ExcavationKitUtils).GetCount("hat")
    Set flashlight = ##class(Tartessos.Quest.ExcavationKitUtils).GetCount("flashlight")
    Set batteries = ##class(Tartessos.Quest.ExcavationKitUtils).GetCount("batteries")

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

    Do ##class(Tartessos.Quest.ExcavationKitUtils).Reset()

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

ClassMethod WriteError(statusCode As %Integer, errorCode As %String, errorMessage As %String) As %Status
{
    Set %response.Status = statusCode
    Set %response.ContentType = "application/json; charset=utf-8"

    Set response = {
        "success": false,
        "exercise": 1,
        "validationCode": "",
        "errorCode": (errorCode),
        "errorMessage": (errorMessage)
    }

    Write response.%ToJSON()

    Return $$$OK
}

}
