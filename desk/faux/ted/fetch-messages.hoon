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
++  boom
  |=  msgs=(list message:faux-discord)
  =/  m  (strand ,vase)
  ^-  form:m
  |-
  =*  loop  $
  ?~  msgs  (pure:m *vase)
  ;<  =bowl:spider  bind:m  get-bowl
  ;<  ~  bind:m  (poke-our %faux [%new-discord-messages !>(~[i.msgs])])
  ;<  ~  bind:m  (sleep `@dr`(div ~s1 100))
  loop(msgs t.msgs)

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
  ?.  ?=(%finished -.client-response)
    ~&  >>  not-finished+client-response  (pure:m !>(%not-finished))
  ?~  full-file.client-response  ~&  >>  rate-limited+client-response  (pure:m !>(%rate-limited))
  =/  raw-body
    q.data.u.full-file.client-response
  =/  json-body  (need (de-json:html raw-body))
  =/  messages  (mule |.((messages-from-json:faux-discord self-bot json-body)))
  =/  [ok=? =tang res=(list message:faux-discord)]
    ?-  -.messages
      %|  :-  |  :_  ~  (welp p.messages leaf+"retry" ~)
      %&  ?:  =(~ p.messages)
        :-  &  :_  ~  `tang`[leaf+"no messages" ~]
      :-  &  :_  p.messages  (flop `tang`[leaf+"got messages" ~])
    ==
  ;<  vaz=vase  bind:m
    ?:  ok
      (boom res)
    (pure:m !>(~))
    ::  %-  (slog tang)
    ::  (poke [our.bowl %faux] [%retry-after !>(res)])
  (pure:m !>(~))
--
