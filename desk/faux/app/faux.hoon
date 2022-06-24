/-  *post
/-  *graph-store
/+  default-agent, dbug
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  [%0 [channels=(list channel) bot-token=tape]]
+$  channel
  [=resource discord-id=tape last-seen-message=(unit tape)]
+$  state-update-poke
  $%  [%channels channels=(list channel)]
      [%bot-token bot-token=tape]
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  `this
++  on-save
  ^-  vase
  !>  state
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  `this(state old)
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  !!
      %noun
    =/  update  !<(state-update-poke vase)
    ?-  -.update
      %channels   `this(channels channels:update)
      %bot-token  `this(bot-token bot-token:update)
    ==
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
