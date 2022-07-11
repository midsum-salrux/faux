/-  spider
/-  *resource
/+  *strandio
/+  faux-discord
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  url
  |=  [discord-channel-id=tape after=tape]
  ;:  weld
    base-api-url:faux-discord
    "channels/"  discord-channel-id  "/messages"
    "?limit=10"
    ?~  after
      ""
    (weld "&after=" after)
  ==
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  [=bowl:gall discord-channel-id=tape bot-token=tape self-bot=? after=tape =resource]
    !<  [bowl:gall tape tape ? tape resource]  arg
  =/  =request:http
    :*  %'GET'
        (crip (url discord-channel-id after))
        (headers:faux-discord bot-token self-bot)
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
  ?~  messages
    (pure:m !>(~))
  ~&  ;:  weld  "found discord messages for channel "  discord-channel-id
          " latest message "  content:(rear messages)
      ==
  ;<  ~  bind:m  (poke [our.bowl %faux] [%new-discord-messages !>(messages)])
  (pure:m !>(~))
--
