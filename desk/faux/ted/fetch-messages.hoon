/-  spider
/-  *resource
/+  *strandio
/+  faux-discord
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  url
  |=  [channel=tape after=tape]
  ;:  weld
    base-api-url:faux-discord
    "channels/"  channel  "/messages"
    "?after="  after
  ==
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  arguments  !<  (unit [tape tape tape])  arg
  =/  [channel=tape bot-token=tape after=tape]
    (need arguments)
  =/  =request:http
    :*  %'GET'
        (crip (url channel after))
        (headers:faux-discord bot-token)
        ~
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
