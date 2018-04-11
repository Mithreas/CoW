#include "inc_database"

// Returns a space delimited list of topic IDs from the provided forum.
// Empty string if failure.
string GetTopicIds(int forumId);

// Returns whether the provided topic is a sticky.
// -1 if failure.
int GetIsTopicSticky(int topicId);

// Returns a string delimited list of post IDs from the provided topic.
// Empty string if failure.
string GetPostIdsInTopic(int topicId, int descending = FALSE);

// Returns the contents of the provided post.
// Empty string if failure.
string GetPostContents(int postId);

// Returns the subject of the provided post.
// Empty string if failure.
string GetPostSubject(int postId);

// Returns the time of the provided post.
// Empty string if failure.
string GetPostTime(int postId);

// INTERNAL USE ONLY
// Prepares a space delimited list from the returned conents of the provided SQL query.
string _GetListFromSQLQuery(string query, int columnCount);

string GetTopicIds(int forumId)
{
    return _GetListFromSQLQuery(
        SQLPrepareStatement(
            "SELECT topic_id " +
            "FROM forum_topics " +
            "WHERE forum_id = ? " +
            "ORDER BY topic_last_post_subject",  // Alphabetical order based on title.
            IntToString(forumId)), 1);
}

int GetIsTopicSticky(int topicId)
{
    SQLExecStatement(
        "SELECT topic_type " +
        "FROM forum_topics " +
        "WHERE topic_id = ?",
        IntToString(topicId));

    return SQLFetch() ? SQLGetData(1) != "0" /* 0 is regular post type */ : -1;
}

string GetPostIdsInTopic(int topicId, int descending)
{
    return _GetListFromSQLQuery(
        SQLPrepareStatement(
            "SELECT post_id " +
            "FROM forum_posts " +
            "WHERE topic_id = ? " +
            "ORDER BY post_id " + (descending ? "DESC" : "ASC"),
            IntToString(topicId)), 1);
}

string GetPostContents(int postId)
{
    SQLExecStatement(
        "SELECT post_text FROM forum_posts WHERE post_id = ? LIMIT 1",
        IntToString(postId));
    return SQLFetch() ? SQLGetData(1) : "";
}

string GetPostSubject(int postId)
{
    SQLExecStatement(
        "SELECT post_subject FROM forum_posts WHERE post_id = ? LIMIT 1",
        IntToString(postId));
    return SQLFetch() ? SQLGetData(1) : "";
}

string GetPostTime(int postId)
{
    SQLExecStatement(
        "SELECT from_unixtime(post_time) FROM forum_posts WHERE post_id = ? LIMIT 1",
        IntToString(postId));
    return SQLFetch() ? SQLGetData(1) : "";
}

string _GetListFromSQLQuery(string query, int columnCount)
{
    SQLExecStatement(query);

    string ret = "";

    while (SQLFetch())
    {
        int i = 1;
        while (i <= columnCount)
        {
            string data = SQLGetData(i);

            if (data == "")
            {
                break;
            }

            ret += data + " ";
            ++i;
        }
    }

    return ret;
}