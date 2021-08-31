// Dialog file for research journal.
// m_activate has the code to set up journals.
// MAX_NOTE (int variable) - index of the highest research note currently stored.
// research_note_x (int variable) - title of the page. 
#include "inc_activity"
#include "inc_database"
#include "inc_zdlg"

const string ARTICLES     = "rj_articles";
const string ART_IDS      = "rj_article_ids";
const string PAGE_ARTICLE = "rj_page_article";

void Init()
{
  // Build the list of articles. 
  DeleteList(ARTICLES);  
  DeleteList(ART_IDS);  
  object oJournal = GetLocalObject(GetPcDlgSpeaker(), "RESEARCH_JOURNAL");
  int ii;
  string sTitle;
  for (ii = 0; ii <= GetLocalInt(oJournal, "MAX_NOTE"); ii++)
  {
    sTitle = GetLocalString(oJournal, "research_note_" + IntToString(ii));
	if (sTitle != "")
	{
	  AddStringElement(sTitle, ARTICLES); 
	  AddIntElement(ii, ART_IDS);
	}  
  }
  
  if (GetElementCount(PAGE_ARTICLE) == 0)
  {
    AddStringElement("[Done]", PAGE_ARTICLE);
  }
}

void PageInit()
{
  string sPage = GetDlgPageString();
  
  if (sPage == "")
  {
    SetDlgPrompt("Select the article you want to review.");
	SetDlgResponseList(ARTICLES);
  }
  else if (sPage == PAGE_ARTICLE)
  {
    int nID = GetLocalInt(OBJECT_SELF, PAGE_ARTICLE);
	
	  SQLExecDirect("SELECT c.old_text FROM " + WIKI_PREFIX + "page AS a INNER JOIN " + WIKI_PREFIX + "revision AS b ON " +
  "a.page_id=b.rev_page INNER JOIN " + WIKI_PREFIX + "text AS c ON b.rev_text_id=c.old_id WHERE a.page_id=" + IntToString(nID) + " ORDER BY b.rev_id DESC LIMIT 1");	
	
	  if (SQLFetch())
	  {
		SetDlgPrompt(_Cleanup(SQLGetData(1)));
		SetDlgResponseList(PAGE_ARTICLE);
	  }
	  else
	  {
	    SetDlgPrompt("Sorry, we failed to retrieve that article.  Try another article.");
	  }
	
  }
  else 
  {
    // Oops.
	SendMessageToPC(GetPcDlgSpeaker(), "Oops - that page is missing.  Please report.");
  }
}

void HandleSelection()
{
	string sPage = GetDlgPageString();
	
	if (sPage == "")
	{
	  SetLocalInt(OBJECT_SELF, PAGE_ARTICLE, GetIntElement(GetDlgSelection(), ART_IDS));
	  SetDlgPageString(PAGE_ARTICLE);
	}
	else if (sPage == PAGE_ARTICLE)
	{
	  SetDlgPageString("");
	}
	else
	{
		// Oops.
		SendMessageToPC(GetPcDlgSpeaker(), "Oops - that page is missing.  Please report.");
	}
}


void main()
{
  int nEvent = GetDlgEventType();
  Trace(ZDIALOG, "Called conversation script with event... " + IntToString(nEvent));
  switch (nEvent)
  {
    case DLG_INIT:
      Init();
      break;
    case DLG_PAGE_INIT:
      PageInit();
      break;
    case DLG_SELECTION:
      HandleSelection();
      break;
    case DLG_ABORT:
      break;
    case DLG_END:
      break;
  }
}
