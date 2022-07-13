/-  spider
/-  *resource
/+  *strandio
/+  faux-discord, faux-add-channel
/+  server
=,  strand=strand:spider
=,  strand-fail=strand-fail:libstrand:spider
|^  ted
++  url
  |=  discord-channel-id=tape
  ;:  weld
    base-api-url:faux-discord
    "channels/"  discord-channel-id
  ==
++  ted
  ^-  thread:spider
  |=  arg=vase
  =/  m  (strand ,vase)
  =/  [=bowl:gall =resource discord-channel-id=tape bot-token=tape self-bot=?]
    !<  [bowl:gall resource tape tape ?]  arg
  =/  =request:http
    :*  %'GET'
        (crip (url discord-channel-id))
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
  =/  channel  (channel-from-json:faux-discord json-body resource)
  ;<  ~  bind:m  (poke [our.bowl %faux] [%new-channel !>(channel)])
  (pure:m !>(~))
--
