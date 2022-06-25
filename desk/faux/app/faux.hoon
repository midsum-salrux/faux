/-  *post
/-  *graph-store
/+  default-agent, dbug
/+  faux-discord
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  [%0 [=channels bot-token=tape]]
+$  channel
  [=resource discord-id=tape last-seen-message=(unit tape)]
+$  channels  (list channel)
+$  state-update-poke
  $%  [%channels =channels]
      [%bot-token bot-token=tape]
  ==
+$  card  card:agent:gall
+$  sign  sign:agent:gall
++  post-to-discord-card
  |=  [discord-channel-id=tape bot-token=tape =post]
  :*  %pass  /post-to-discord  %arvo  %k  %fard
      %faux  %post-message  %noun
      !>  :*
        discord-channel-id
        bot-token
        (flatten-contents:faux-discord contents.post)
        author.post
      ==
  ==
++  timer-card
  |=  now=@da
  [%pass /faux-timer %arvo %b [%wait (add ~s3 now)]]
::
::  sometimes behn gets stuck, so we send this no-op card
::  to unstick it when we see an urbit message
::
++  huck-card
  [%pass /faux-huck %arvo %b [%huck *sign-arvo]]
++  fetch-messages-cards
  |=  [=bowl:gall =channels bot-token=tape]
  ^-  (list card)
  %+  turn  channels
    |=  [=resource discord-id=tape last-seen-message=(unit tape)]
    ^-  card
    :*  %pass  /fetch-discord-messages  %arvo  %k  %fard
        %faux  %fetch-messages  %noun
        !>  [bowl discord-id bot-token last-seen-message resource]
    ==
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
  :_  this
  :~  [%pass /graph/updates %agent [our:bowl %graph-store] %watch /updates]
      (timer-card now:bowl)
  ==
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
++  on-agent
  |=  [=wire =sign]
  ^-  (quip card _this)
  ?+  wire  (on-agent:def wire sign)
      [%graph %updates ~]
    ?+  -.sign  (on-agent:def wire sign)
        %kick
      :_  this
      :~  [%pass /graph/updates %agent [our:bowl %graph-store] %watch /updates]
      ==
        %fact
      ?+  p.cage.sign  (on-agent:def wire sign)
          %graph-update-3
        =/  =update  !<(update q:cage:sign)
        =/  =action  q.update
        ?+  -.action  (on-agent:def wire sign)
            %add-nodes
          =/  =resource  resource.action
          =/  nodes=(list node)  ~(val by nodes.action)
          =/  maybe-posts=(list maybe-post)
            (turn nodes |=(=node post.node))
          =/  channel-posts=(list [discord-id=tape =post])
            %+  murn  maybe-posts
            |=  =maybe-post
            ?+  -.maybe-post  ~
                %.y
              =/  post  p.maybe-post
              =/  matching-channels
                %+  skim  channels
                |=  =channel  =(resource:channel resource)
              ?~  matching-channels  ~
              `[discord-id.i.matching-channels post]
            ==
          :_  this
          :-  huck-card
          %+  turn  channel-posts
          |=  [discord-id=tape =post]
          (post-to-discord-card discord-id bot-token post)
        ==
      ==
    ==
  ==
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ~&  [wire sign-arvo]
  ?+  wire  (on-arvo:def wire sign-arvo)
      [%faux-timer ~]
    :_  this
    :-  (timer-card now:bowl)
    (fetch-messages-cards bowl channels bot-token)
      [%fetch-discord-messages ~]
    `this
  ==
++  on-fail   on-fail:def
--
