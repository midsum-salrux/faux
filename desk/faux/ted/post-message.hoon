/-  spider
/-  *resource
/+  *strandio
/+  faux-discord
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  url
  |=  discord-channel-id=tape
  ;:  weld
    base-api-url:faux-discord
    "channels/"  discord-channel-id  "/messages"
  ==
++  body
  |=  [message=tape author=@p]
  ^-  json
  =/  full-text
    ;:  weld
      (point-text:faux-discord author)  ": "
      message
    ==
  (frond:enjs:format 'content' (tape:enjs:format full-text))
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  [discord-channel-id=tape bot-token=tape message=tape author=@p]
    !<  [tape tape tape @p]  arg
  =/  =request:http
    :*  %'POST'
        (crip (url discord-channel-id))
        (headers:faux-discord bot-token)
        `(json-to-octs:server (body message author))
    ==
  ~&  request
  ;<  ~  bind:m  (send-request request)
  ;<  =client-response:iris  bind:m  take-client-response
  ?>  ?=(%finished -.client-response)
  ~&  response-header.client-response
  =/  body
    ?~  full-file.client-response  ''
    q.data.u.full-file.client-response
  ~&  body
  (pure:m !>(~))
--
