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
  =/  [channel=tape bot-token=tape after=tape =resource]
    !<  [tape tape tape resource]  arg
  =/
    (need arguments)
  =/  =request:http
    :*  %'GET'
        (crip (url channel after))
        (headers:faux-discord bot-token)
        ~
    ==
  ;<  ~  bind:m  (send-request request)
  ;<  =client-response:iris  bind:m  take-client-response
  ?>  ?=(%finished -.client-response)
  =/  raw-body
    ?~  full-file.client-response  !!
    q.data.u.full-file.client-response
  =/  json-body  (need (de-json:html raw-body))
  =/  messages  (messages-from-json:faux-discord json-body)
  (pure:m !>(messages))
--
