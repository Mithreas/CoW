#include "fb_inc_chatutils"
#include "fb_inc_external"
#include "mi_inc_database"
#include "inc_examine"

// Chat command to create forum accounts and set passwords.
// Passwords are created in the clear.  Arelith-specific code
// in includes/auth/auth_db.php hashes them at login time.

const string HELP = "Used to create a forum password, and to update its password.  If you want your password to be 'fred', type -forum_password fred.";

void main()
{
  object oSpeaker = OBJECT_SELF;
  string sParams = chatGetParams(oSpeaker);
  chatVerifyCommand(oSpeaker);


  if (sParams == "?")
  {
    DisplayTextInExamineWindow("-forum_password", HELP);
  }
  else
  {
    string sPassword = sParams;
    string sUsername = GetPCPlayerName(oSpeaker);

    // Strength checking.  Very basic.
    if (GetStringLength(sPassword) < 6)
    {
      SendMessageToPC(oSpeaker, "Please use a longer password.");
      return;
    }
    else if (sPassword == sUsername)
    {
      SendMessageToPC(oSpeaker, "Your password must differ from your login name.");
      return;
    }

    SQLExecStatement("SELECT user_id FROM nwn.forum_users WHERE username=?", sUsername);
    string sUserID = "";

    if (SQLFetch())
    {
      sUserID = SQLGetData(1);

      // Existing user.
      SQLExecStatement("UPDATE nwn.forum_users SET user_password=?, user_login_attempts=0 WHERE user_id=?", sPassword, sUserID);

      SendMessageToPC(oSpeaker, "Your forum password has been updated successfully.");
    }
    else
    {
      // New user.
      // Cleaning should include collapsing multiple spaces to single spaces, and trimming whitespace from
      // each end.  But that shouldn't be needed for usernames - if it is, we'll add it.
      string sUsernameClean = GetStringLowerCase(sUsername);

      string sGroupID = "2"; // Registered users.

      SQLExecStatement("INSERT INTO nwn.forum_users (group_id,username,username_clean, user_password, user_regdate,user_lang) VALUES (?,?,?,?,UNIX_TIMESTAMP(NOW()),'en')",
                 sGroupID, sUsername, sUsernameClean, sPassword);



      SQLExecStatement("SELECT user_id FROM nwn.forum_users WHERE username=?", sUsername);

      if (SQLFetch())
      {
        sUserID = SQLGetData(1);
        SQLExecStatement("INSERT INTO nwn.forum_user_group (group_id, user_id, group_leader, user_pending) VALUES ('2', ?, '0', '0')", sUserID);
        SendMessageToPC(oSpeaker, "Your forum account has been created successfully.");
      }
      else
      {
        SendMessageToPC(oSpeaker, "Failed to add forum account!  Please report this problem.");
        return;
      }
    }
  }
}
