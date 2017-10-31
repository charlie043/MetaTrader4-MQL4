/**
 * @see
 *   Slack incomming webhooks : https://api.slack.com/incoming-webhooks
 *   MQL4 Documentation(webrequest): https://docs.mql4.com/common/webrequest
 **/

const string url = "[Slack hook URL]";

/**
 * @params text {String} - send text
 */
void sendToSlack(string text) {

  string cookie=NULL, referer=NULL, headers;
  char post[],result[];

  // send payload
  string str = "payload={\"text\":\""+text+"\", \"username\": \"Override Bot Name\", \"icon_emoji\": \":ghost:\"}";

  ArrayResize(post,StringToCharArray(str,post,0,WHOLE_ARRAY,CP_UTF8)-1);

  int res = WebRequest(
    "POST",
    url,
    cookie,
    referer,
    5000,
    post,
    ArraySize(post),
    result,
    headers
  );

  // Error
  if (res == -1) {
    Print("Error:", GetLastError());
  }
}
