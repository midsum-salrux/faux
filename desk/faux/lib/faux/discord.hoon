/-  *post
=,  dejs:format
|%
+$  parsed-message
  [id=tape content=tape channel-id=tape author=[username=tape bot=?]]
+$  message
  [id=tape content=tape channel=tape author=tape]
++  base-api-url  "https://discord.com/api/v9/"
++  user-agent  'Faux (https://github.com/midsum-salrux/faux, 0.1)'
++  headers
  |=  bot-token=tape
  :~  [key='Authorization' value=(crip (weld "Bot " bot-token))]
      [key='User-Agent' value=user-agent]
      [key='Content-Type' value='application/json']
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
--
