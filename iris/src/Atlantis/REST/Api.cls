Class Mus.REST.Api Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>
    <Route Url="/progress " Method="GET" Call="GetProgress"/>
</Routes>
}

ClassMethod GetProgress() As %Status
{
    Set resp = {
        "success": true,
        "errorCode": "",
        "errorMessage": ""
    }

    Write resp.%ToJSON()

    Return $$$OK
}

ClassMethod WriteStatusError(statusCode As %Integer, errorCode As %String, errorMessage As %String) As %Status
{
    If statusCode = "" {
        Set statusCode = 500
    }

    Set %response.Status = statusCode
    Do %response.SetHeader("Content-Type", "application/json; charset=utf-8")

    Set err = {
        "success": false,
        "errorCode": (errorCode),
        "errorMessage": (errorMessage)
    }

    Write err.%ToJSON()

    Return $$$OK
}

}