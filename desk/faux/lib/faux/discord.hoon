/-  *post
=,  dejs:format
|%
+$  parsed-message
  [id=tape content=tape channel-id=tape author=[username=tape bot=?]]
+$  message
  [id=tape content=tape channel=tape author=tape]
++  base-api-url  "https://discord.com/api/v9/"
++  user-agent  'Faux (https://github.com/midsum-salrux/faux, 0.1)'
++  self-user-agent
  'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) discord/1.0.9004 Chrome/91.0.4472.164 Electron/13.6.6 Safari/537.36'
++  headers
  |=  bot-token=tape
  :~  [key='Authorization' value=(crip (weld "Bot " bot-token))]
      [key='User-Agent' value=user-agent]
      [key='Content-Type' value='application/json']
  ==
++  self-headers
  |=  bot-token=tape
  :~  [key='Authorization' value=(crip bot-token)]
      [key='Referer' value='https://discord.com/channels/@me']
      [key='User-Agent' value=user-agent]
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
++  messages-json-decoder
  %-  ar
  %-  ot
  :~  id+sa
      content+sa
      [%'channel_id' sa]
      author+(ou ~[username+(uf "" sa) bot+(uf %.n bo)])
  ==
++  messages-from-json
  |=  =json
  ^-  (list message)
  =/  decoded  (messages-json-decoder json)
  =/  messages=(list message)
    %+  turn
      (skip decoded |=(m=parsed-message bot.author.m))
    |=  m=parsed-message
    ^-  message
    :*  id=id.m
        content=content.m
        channel=channel-id.m
        author=username.author.m
    ==
  (sort messages message-sorter)
++  later-snowflake
  |=  [left=tape right=tape]
  ^-  tape
  ?:  (compare-snowflakes left right)
    left
  right
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
    ==
  (zing segments)
++  numbered-messages
  |=  messages=(list message)
  ^-  (list [message @ud])
  =/  index  0
  |-
  ?~  messages  ~
  :-  [i.messages index]
  $(messages t.messages, index +(index))
--
