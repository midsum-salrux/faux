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
  ++  messages-from-json
    |=  =json
    ^-  (list message)
    =/  decoder
    %-  ar
    %-  ot
    :~  id+sa
        content+sa
        [%'channel_id' sa]
        author+(ou ~[username+(uf "" sa) bot+(uf %.n bo)])
    ==
    =/  decoded  (decoder json)
    %+  turn
      (skip decoded |=(m=parsed-message bot.author.m))
    |=  m=parsed-message
    ^-  message
    :*  id=id.m
        content=content.m
        channel=channel-id.m
        author=username.author.m
    ==
--
