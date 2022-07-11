/-  *post
/-  *graph-store
/+  *graph-store
/+  default-agent, dbug, faux-discord, resource, faux-config
|%
::  aliases
+$  card      card:agent:gall
+$  sign      sign:agent:gall
+$  channel   channel:faux-config
::  state
+$  versioned-state
  $%  state-0
      state-1
      state-2
  ==
+$  state-0
  [%0 [channels=(list [=resource discord-id=tape last-seen-message=(unit tape)]) bot-token=tape]]
+$  state-1
  [%1 [channels=(list [=resource discord-id=tape last-seen-message=tape]) bot-token=tape]]
+$  state-2
  [%2 [channels=(list channel) bot-token=tape self-bot=?]]
+$  state-update-poke
  $%  [%channels channels=(list channel)]
      [%bot-token bot-token=tape]
  ==
::
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
++  fetch-messages-cards
  |=  [=bowl:gall channels=(list channel) bot-token=tape]
  ^-  (list card)
  %+  turn  channels
    |=  [=resource discord-id=tape last-seen-message=tape name=tape]
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
  ::  TODO add a check so we never make this an older message
  |=  [=message:faux-discord old-channels=(list channel)]
  ^-  (list channel)
  =/  [these-channels=(list channel) other-channels=(list channel)]
    %+  skid  old-channels
    |=  =channel
    =(discord-id.channel channel.message)
  ?~  these-channels  !!
  =/  this-channel  i.these-channels
  :-  [resource.this-channel discord-id.this-channel id.message name.this-channel]
  other-channels
--
%-  agent:dbug
=|  state-2
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
  ?-  -.old
      %0
    `this(state [%2 (add-names-and-selfbot:faux-config (deunitize:faux-config +.old))])
      %1
    `this(state [%2 (add-names-and-selfbot:faux-config +.old)])
      %2
    `this(state old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+  mark  !!
      %json
    =/  config-json  !<(json vase)
    =/  =config:faux-config  (dejs:faux-config config-json)
    `this(channels channels.config, bot-token bot-token.config)
      %noun
    =/  update  !<(state-update-poke vase)
    ?-  -.update
        %channels
      `this(channels channels.update)
        %bot-token
      `this(bot-token bot-token.update)
    ==
      %new-discord-messages
    =/  messages  !<  (list message:faux-discord)  vase
    ?~  messages  `this
    :_  this(channels (update-latest-seen (rear messages) channels))
    %+  turn  (numbered-messages:faux-discord messages)
    |=  [=message:faux-discord index=@ud]
    =/  resource  resource:(channel-by-discord-id channel.message channels)
    =/  reply-content
      ;:(weld author.message ": " content.message)
    %:  graph-store-message-card  bowl  reply-content  resource
      index
    ==
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  [=path]
  ^-  (unit (unit cage))
  ?>  ?=([%x %faux %config ~] path)
  :^  ~  ~  %json
  !>  (enjs:faux-config [channels bot-token self-bot])
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
      [%post-to-discord ~]
    ~&  "posted urbit message to discord"
    `this
      [%faux-timer ~]
    :_  this
    :-  (timer-card now:bowl)
    (fetch-messages-cards bowl channels bot-token)
      [%fetch-discord-messages ~]
    `this
  ==
++  on-fail   on-fail:def
--
