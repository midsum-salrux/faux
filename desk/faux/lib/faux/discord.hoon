/-  *post
/+  resource
/+  faux-config
=,  dejs:format
|%
+$  mention  [id=tape username=tape]
+$  attachment  [url=tape]
+$  parsed-message
  [id=tape content=tape channel-id=tape author=[id=tape username=tape bot=?] mentions=(list mention) attachments=(list attachment)]
+$  message
  [id=tape content=tape channel=tape author=tape author-id=tape attachments=(list attachment) bot-message=?]
++  base-api-url  "https://discord.com/api/v9/"
++  user-agent  'Faux (https://github.com/midsum-salrux/faux, 0.1)'
++  self-user-agent
  'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/1.0.9004 Chrome/91.0.4472.164 Electron/13.6.6 Safari/537.36'
++  bot-user-headers
  |=  bot-token=tape
  :~  [key='Authorization' value=(crip (weld "Bot " bot-token))]
      [key='User-Agent' value=user-agent]
      [key='Content-Type' value='application/json']
  ==
++  self-headers
  |=  bot-token=tape
  :~  [key='Authorization' value=(crip bot-token)]
      [key='Referer' value='https://discord.com/channels/@me']
      [key='User-Agent' value=self-user-agent]
      [key='Content-Type' value='application/json']
[key='Sec-Ch-Ua' value='"Not A;Brand";v="99", "Chromium";v="100", "Google Chrome";v="100']
      [key='Sec-Ch-Ua-Mobile' value='?0']
      [key='Sec-Ch-Ua-Platform' value='"Windows"']
      [key='Sec-Fetch-Dest' value='empty']
      [key='Pragma' value='no-cache']
      [key='Sec-Fetch-Site' value='same-origin']
      [key='Cache-Control' value='no-cache']
      [key='Connection' value='no-cache']
  ==
++  headers
  |=  [bot-token=tape self-bot=?]
  ?:  self-bot
    (self-headers bot-token)
  (bot-user-headers bot-token)
++  user-id-from-json  (ot ~[id+sa])
++  messages-json-decoder
  %-  ar
  %-  ot
  :~  id+sa
      content+sa
      [%'channel_id' sa]
      author+(ou ~[id+(un sa) username+(uf "" sa) bot+(uf %.n bo)])
      :-  %mentions
          %-  ar
          %-  ot
          :~  id+sa
              username+sa
          ==
      :-  %attachments
          %-  ar
          %-  ot
          ~[url+sa]
  ==
++  messages-from-json
  |=  [bot-user-id=tape =json]
  ^-  (list message)
  =/  decoded  (messages-json-decoder json)
  =/  messages
    %+  turn  decoded
    |=  m=parsed-message
    ^-  message
    :*  id=id.m
        content=(replace-mentions content.m mentions.m)
        channel=channel-id.m
        author=username.author.m
        author-id=id.author.m
        attachments=attachments.m
        bot-message=bot.author.m
    ==
  =/  sorted  (sort messages message-sorter)
  %+  skip  sorted
  |=  m=message
  =(author-id.m bot-user-id)
++  replace-mentions
  |=  [content=tape mentions=(list mention)]
  ^-  tape
  ?~  content  content
  (zing (scan content (plus (message-parser mentions))))
++  mention-parser
  |=  mentions=(list mention)
  =/  replacer
    |=  id=tape
    =/  match  (skim mentions |=(=mention =(id id.mention)))
    ?~  match  "@[unknown user]"  (weld "@" username.i.match)
  ::  <@65432745377> to username
  (cook replacer (ifix [(jest '<@') gar] (plus (shim '0' '9'))))
++  message-parser
  |=  mentions=(list mention)
  ;~  pose
      (mention-parser mentions)
      (cook trip next)
  ==
++  channel-info-decoder
  %-  ot
  :~  id+sa
      [%'last_message_id' (mu sa)]
      name+sa
  ==
++  channel-from-json
  |=  [=json =resource]
  ^-  channel:faux-config
  =/  decoded=[id=tape last-message-id=(unit tape) name=tape]
    (channel-info-decoder json)
  :*  resource
      id.decoded
      (fall last-message-id.decoded "")
      name.decoded
  ==
++  later-snowflake
  |=  [left=tape right=tape]
  ^-  tape
  ?~  left  right
  ?~  right  left
  ?:  (compare-snowflakes left right)
    right
  left
++  message-sorter
  |=  [left=message right=message]
  ^-  ?
  (compare-snowflakes id.left id.right)
::  https://discord.com/developers/docs/reference#snowflakes
::  the most significant bits of a discord message id are a timestamp
++  compare-snowflakes
  |=  [left=tape right=tape]
  ^-  ?
  |-
  ?~  left   %.n
  ?~  right  %.y
  =/  left-lent  (lent left)
  =/  right-lent  (lent right)
  ?:  (gth left-lent right-lent)
    %.n
  ?:  (gth right-lent left-lent)
    %.y
  ?.  =(i.left i.right)
    (lth i.left i.right)
  $(left t.left, right t.right)
++  point-text
  |=  point=@p
  ^-  tape
  ~(rend co %$ %p point)
++  flatten-contents
  |=  contents=(list content)
  ^-  tape
  =/  segments=(list tape)
    %+  turn  contents
    |=  =content
    ?+  -.content  ""
        %text
      (trip text.content)
        %url
      (trip url.content)
        %mention
      (point-text ship.content)
        %code
      ;:(weld "`" (trip expression.content) "`")
    ==
  (zing segments)
--
