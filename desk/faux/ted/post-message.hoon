/-  spider
/-  *resource
/+  *strandio
/+  faux-discord
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  point-text
  |=  point=@p
  ~(rend co %$ %p point)
++  url
  |=  channel=tape
  ;:  weld
    base-api-url:faux-discord
    "channels/"  channel  "/messages"
  ==
++  body
  |=  [message=tape author=@p]
  ^-  json
  =/  full-text
    ;:  weld
      (point-text author)  ": "
      message
    ==
  (frond:enjs:format 'content' (tape:enjs:format full-text))
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  arguments  !<  (unit [tape tape tape @p])  arg
  =/  [channel=tape bot-token=tape message=tape author=@p]
    (need arguments)
  =/  =request:http
    :*  %'POST'
        (crip (url channel))
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
