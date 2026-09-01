Class Tartessos.Quest.Boot Extends %RegisteredObject
{

Parameter ADVENTURERNAME = "LUIS ÁNGEL";

ClassMethod GetAdventurerName() As %String
{
    Set ^adventurerName = ..#ADVENTURERNAME

    Return ..#ADVENTURERNAME
}

}
