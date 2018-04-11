//::///////////////////////////////////////////////
//:: String Library
//:: inc_string
//:://////////////////////////////////////////////
/*
    Contains functions for manipulating strings.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////

#include "x3_inc_string"

/**********************************************************************
 * PUBLIC FUNCTION PROTOTYPES
 **********************************************************************/

// Returns the nNth element of a delimited string. Note that when nElement = 0, the
// first value of the string will be returned.
string GetDelimitedStringElement(string sString, string sDelimiter, int nElement);
// Finds the position of the nNth sSubstring inside sString:
//   - nStart: The position to start searching at (from the left end of the string).
//   * Return value on error: -1
int FindNthSubString(string sString, string sSubString, int nStart = 0, int nNth = 1);
// Returns the a substring found between two specified elements in a string. If either
// element has no value, then all parts of string to the left or right of the other
// element will be returned.
//
// For example, given the string, "THIS IS A STRING":
//   ("THIS", "STRING") returns " IS A "
//   ("THIS", "") returns " IS A STRING"
//   ("", "STRING") returns "THIS IS A "
string GetSubStringBetween(string sString, string sElement1, string sElement2);
// Returns the ordinal suffix for the number (e.g. 1 would return "st", 2 would return
// "nd").
string OrdinalSuffix(int nNum);
// Replaces designated formatting characters in a string with their values (e.g. if
// passed in ("deals %d damage", "%d", "3"), then "deals 3 damage" would be returned.)
string ParseFormatStrings(string sSource, string sFormat1, string sVal1, string sFormat2 = "", string sValu2 = "", string sFormat3 = "", string sVal3 = "");
// Modifies the string to the possessive variant (e.g. "Giant" becomes "Giant's").
string PossessiveString(string sString);
// Strips any colour tokens (<cxxx> or </c>) in the provided string.
// This function assumes that the token are well formed, e.g. <c/ is INVALID.
string StripColourTokens(string str);

// evaluates string expression, but only supports +, -, and the dice functions d4(2), stuff like that
int gvd_Eval(string sExpression);

/**********************************************************************
 * PUBLIC FUNCTION DEFINITIONS
 **********************************************************************/

//::///////////////////////////////////////////////
//:: GetDelimitedStringElement
//:://////////////////////////////////////////////
/*
    Returns the nNth element of a delimited
    string. Note that when nElement = 0, the
    first value of the string will be returned.
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: July 27, 2016
//:://////////////////////////////////////////////
string GetDelimitedStringElement(string sString, string sDelimiter, int nElement)
{
    if(!nElement) return GetSubStringBetween(sString, "", sDelimiter);

    int nStartPos = FindNthSubString(sString, sDelimiter, 0, nElement);
    int nEndPos = FindNthSubString(sString, sDelimiter, nStartPos);

    if(nEndPos == -1)
    {
        nEndPos = GetStringLength(sString) + 1;
    }

    return GetSubString(sString, nStartPos + 1, nEndPos - nStartPos - 1);
}

//::///////////////////////////////////////////////
//:: GetSubStringBetween
//:://////////////////////////////////////////////
/*
    Returns the a substring found between
    two specified elements in a string. If either
    element has no value, then all parts of
    string to the left or right of the other
    element will be returned.

    For example, given the string,
    "THIS IS A STRING":
      ("THIS", "STRING") returns " IS A "
      ("THIS", "") returns " IS A STRING"
      ("", "STRING") returns "THIS IS A "
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
string GetSubStringBetween(string sString, string sElement1, string sElement2)
{
    string sSubString;
    int nPos1;
    int nPos2;

    if(sString == "" || (sElement1 == "" && sElement2 == ""))
        return "";

    if(sElement1 != "")
        nPos1 = FindSubString(sString, sElement1);
    if(nPos1 == -1)
        return "";

    if(sElement2 != "")
        nPos2 = FindSubString(sString, sElement2);
    if(nPos2 == -1)
        return "";

    if(nPos1 >= nPos2)
        return "";

    if(sElement1 == "")
        return GetStringLeft(sString, nPos2);
    if(sElement2 == "")
        return GetStringRight(sString, GetStringLength(sString) - nPos1);
    return GetSubString(sString, nPos1, nPos2 - nPos1);
}

//::///////////////////////////////////////////////
//:: FindNthSubString
//:://////////////////////////////////////////////
/*
    Finds the position of the nNth sSubstring
    inside sString:
    - nStart: The position to start searching at
    (from the left end of the string).
    * Return value on error: -1
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 9, 2016
//:://////////////////////////////////////////////
int FindNthSubString(string sString, string sSubString, int nStart = 0, int nNth = 1)
{
    if(nNth <= 0)
        return -1;

    int nPosition = FindSubString(sString, sSubString, nStart);

    if(nPosition == -1)
        return -1;
    if(nNth == 1)
        return nPosition;
    return FindNthSubString(sString, sSubString, nPosition +1, nNth - 1);
}

//::///////////////////////////////////////////////
//:: OrdinalSuffix
//:://////////////////////////////////////////////
/*
    Returns the ordinal suffix for the number
    (e.g. 1 would return "st", 2 would return
    "nd").
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
string OrdinalSuffix(int nNum)
{
    switch(abs(nNum))
    {
        case 1:
            return "st";
        case 2:
            return "nd";
        case 3:
            return "rd";
    }
    return "th";
}

//::///////////////////////////////////////////////
//:: ParseFormatStrings
//:://////////////////////////////////////////////
/*
    Replaces designated formatting characters
    in a string with their values (e.g. if
    passed in ("deals %d damage", "%d", "3"), then
    "deals 3 damage" would be returned.)
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: May 21, 2016
//:://////////////////////////////////////////////
string ParseFormatStrings(string sSource, string sFormat1, string sVal1, string sFormat2 = "", string sVal2 = "", string sFormat3 = "", string sVal3 = "")
{
    string sParsedString = sSource;

    sParsedString = StringReplace(sParsedString, sFormat1, sVal1);
    sParsedString = StringReplace(sParsedString, sFormat2, sVal2);
    sParsedString = StringReplace(sParsedString, sFormat3, sVal3);

    return sParsedString;
}

//::///////////////////////////////////////////////
//:: PossessiveString
//:://////////////////////////////////////////////
/*
    Modifies the string to the possessive
    variant (e.g. "Giant" becomes "Giant's").
*/
//:://////////////////////////////////////////////
//:: Created By: Peppermint
//:: Created On: February 8, 2017
//:://////////////////////////////////////////////
string PossessiveString(string sString)
{
    if(GetStringRight(sString, 1) == "s") return sString + "'";
    return sString + "'s";
}

string StripColourTokens(string str)
{
    // Handle the closing token.
    str = StringReplace(str, "</c>", "");

    int indexOfOpenTag = 0;

    while (TRUE)
    {
        indexOfOpenTag = FindSubString(str, "<c", indexOfOpenTag);

        if (indexOfOpenTag == -1)
        {
            // No more occurances. We're done.
            break;
        }

        int indexOfCloseTag = FindSubString(str, ">", indexOfOpenTag);

        if (indexOfCloseTag == -1)
        {
            // This tag has been opened but not closed, so we're not going to touch it.
            continue;
        }

        int colourTagLen = indexOfCloseTag - indexOfOpenTag + 1;
        int leftLen = indexOfOpenTag;
        int rightLen = GetStringLength(str) - leftLen;
        str = GetStringLeft(str, leftLen) + GetStringRight(str, rightLen - colourTagLen);
    }

    return str;
}

int gvd_Eval(string sExpression) {

  // do a manual attempt to evaluate the expression
  // it will support +, -, and dice formula's like d2(1), d4(2), nothing else

  // remove all spaces
  sExpression = StringReplace(sExpression, " ", "");

  // make lowercase
  sExpression = GetStringLowerCase(sExpression);

  // loop through the expression 1 char at a time
  string sChar;
  int iChar = 0;
  int iLength = GetStringLength(sExpression);  
  int iDice = 0;
  string sDice = "";
  string sQty = "";
  int iQty = 0;
  int iResult = 0;
  int iEval = 0;
  int iPlusMinus = 1;
  string sNumber = "";

  while (iChar < iLength) {

    sChar = GetSubString(sExpression, iChar, 1);

    // check if we're in "dice mode"
    if (iDice == 1) {
      // determine if it's a d4, d12, d100 ... all chars until we reach "("
      if (sChar != "(") {
        sDice = sDice + sChar;
      } else {
        // sDice should hold the number of the dice now, lets continue with the qty of them rolled
        iDice = 2;
      }

    } else if (iDice == 2) {
      // determine qty of the dice, all chars until we reach ")"
      if (sChar != ")") {
        sQty = sQty + sChar;
      } else {
        // sQty should hold the qty of the dice now, evaluate
        iQty = StringToInt(sQty);
        if (iQty == 0) {
          // () defaults to 1
          iQty = 1;
        }
        if (sDice == "2") {
          iEval = d2(iQty);
        } else if (sDice == "3") {
          iEval = d3(iQty);
        } else if (sDice == "4") {
          iEval = d4(iQty);
        } else if (sDice == "6") {
          iEval = d6(iQty);
        } else if (sDice == "8") {
          iEval = d8(iQty);
        } else if (sDice == "10") {
          iEval = d10(iQty);
        } else if (sDice == "12") {
          iEval = d12(iQty);
        } else if (sDice == "20") {
          iEval = d20(iQty);
        } else if (sDice == "100") {
          iEval = d100(iQty);
        }
        if (iEval != 0) {
          // add/substract to end result
          iResult = iResult + (iPlusMinus * iEval);
        }
        iDice = 0;
        sQty = "";
        sDice = "";

      }

    } else {

      // check for d (dice function)
      if (sChar == "d") {
        if (sNumber != "") {
          iResult = iResult + (iPlusMinus * StringToInt(sNumber));
          sNumber = "";
        }
        iDice = 1;      
      } else if (sChar == "+") {
        if (sNumber != "") {
          iResult = iResult + (iPlusMinus * StringToInt(sNumber));
          sNumber = "";
        }
        iPlusMinus = 1;
      } else if (sChar == "-") {
        if (sNumber != "") {
          iResult = iResult + (iPlusMinus * StringToInt(sNumber));
          sNumber = "";
        }
        iPlusMinus = -1;
      } else {
        // should be a number
        if (FindSubString("1234567890", sChar) >= 0) {
          sNumber = sNumber + sChar;
        } else {
          // unsupported char, skip
        }
      }

    }
 
    // next char
    iChar = iChar + 1;

  }
  
  // add/substract final number
  if (sNumber != "") {
    iResult = iResult + (iPlusMinus * StringToInt(sNumber));
  }

  return iResult;

}
