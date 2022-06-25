/-  spider
/-  *resource
/+  *strandio
/+  faux-discord
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  url
  |=  [channel=tape after=(unit tape)]
  ;:  weld
    base-api-url:faux-discord
    "channels/"  channel  "/messages"
    ?~  after
      ""
    (weld "?after=" (need after))
  ==
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  [=bowl:gall channel=tape bot-token=tape after=(unit tape) =resource]
    !<  [bowl:gall tape tape (unit tape) resource]  arg
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
  ~&  response-header.client-response
  =/  messages  (messages-from-json:faux-discord json-body)
  ?~  messages
    (pure:m !>(~))
  ::  TODO messages are out of order
  (pure:m !>(messages))
--
