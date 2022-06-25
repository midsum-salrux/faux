/-  *post
/-  *graph-store
/+  *graph-store
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
  [%pass /faux-timer %arvo %b [%wait (add ~s4 now)]]
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
++  graph-store-message-card
  |=  [=bowl:gall text=tape =resource index-number=@]
  =/  contents=(list content)  ~[[%text (crip text)]]
  =/  =post
    %+  ~(post create our.bowl now.bowl)
      ~[(add now.bowl index-number)]
    contents
  =/  mp  (maybe-post [%.y post])
  =/  data
    !>  :-  now.bowl
        :+  %add-nodes  resource
        %+  ~(put by *(map index node))
          ~[(add now.bowl index-number)]
        [post=mp children=*internal-graph]
  :*  %pass  /post-to-graph-from-discord  %agent
      [our:bowl %graph-push-hook]  %poke  %graph-update-3
      data
  ==
++  channel-by-discord-id
  |=  [discord-id=tape channels=(list channel)]
  =/  matching
  %+  skim  channels
  |=  =channel
  =(discord-id.channel discord-id)
  ::  there should always be a match since this runs per channel
  ?~  matching  !!
  i.matching
++  update-latest-seen
  |=  [=message:faux-discord channels=(list channel)]
  ^-  (list channel)
  =/  [these-channels=(list channel) other-channels=(list channel)]
    %+  skid  channels
    |=  =channel
    =(discord-id.channel channel.message)
  ?~  these-channels  !!
  =/  this-channel  i.these-channels
  :-  [resource.this-channel discord-id.this-channel `id.message]
  other-channels
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
              ::  ignore our own messages
              ?:  =(author.post our.bowl)  ~
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
  ?+  wire  (on-arvo:def wire sign-arvo)
      [%post-to-discord ~]  `this
      [%faux-huck ~]  `this
      [%faux-timer ~]
    :_  this
    :-  (timer-card now:bowl)
    (fetch-messages-cards bowl channels bot-token)
      [%fetch-discord-messages ~]
    ?.  ?=([%khan %arow %.y %noun *] sign-arvo)
      (on-arvo:def wire sign-arvo)
    =/  [%khan %arow %.y %noun result=vase]  sign-arvo
    =/  messages
      !<  (list message:faux-discord)  result
    ?~  messages  `this
    :_  this(channels (update-latest-seen (rear messages) channels))
    %+  turn  messages
    |=  =message:faux-discord
    =/  resource  resource:(channel-by-discord-id channel.message channels)
    =/  reply-content
      ;:(weld author.message ": " content.message)
    %:  graph-store-message-card  bowl  reply-content  resource
      ::  TODO improve this
      (need (find ~[message] messages))
    ==
  ==
++  on-fail   on-fail:def
--
