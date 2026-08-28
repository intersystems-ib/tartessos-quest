Class Tartessos.Checkpoints.Validation Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

Parameter EXERCISE1CODE = "TQ01A1";

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/exercise/1/validate" Method="GET" Call="ValidateExercise1"/>
</Routes>
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