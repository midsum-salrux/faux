/-  *post
/-  *graph-store
/+  default-agent, dbug
/+  faux-discord
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
          %+  turn  channel-posts
          |=  [discord-id=tape =post]
          (post-to-discord-card discord-id bot-token post)
        ==
      ==
    ==
  ==
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
