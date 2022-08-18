/-  *post
/-  *graph-store
/+  *graph-store
/+  default-agent, dbug, resource
/+  faux-discord, faux-config, faux-add-channel
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
::  cards
++  timer-card
  |=  now=@da
  [%pass /faux-timer %arvo %b [%wait (add ~s4 now)]]
++  add-channel-card
  |=  [=bowl:gall =new-channel:faux-add-channel bot-token=tape self-bot=?]
  :*  %pass  /add-channel  %arvo  %k  %fard
      %faux  %add-channel  %noun
      !>  :*
        bowl
        resource.new-channel
        discord-id.new-channel
        bot-token
        self-bot
      ==
  ==
++  post-to-discord-card
  |=  [discord-channel-id=tape bot-token=tape self-bot=? =post]
  :*  %pass  /post-to-discord  %arvo  %k  %fard
      %faux  %post-message  %noun
      !>  :*
        discord-channel-id
        bot-token
        self-bot
        (flatten-contents:faux-discord contents.post)
        author.post
      ==
  ==
++  fetch-messages-cards
  |=  [=bowl:gall channels=(list channel) bot-token=tape self-bot=?]
  ^-  (list card)
  %+  turn  channels
    |=  [=resource discord-id=tape last-seen-message=tape name=tape]
    ^-  card
    :*  %pass  /fetch-discord-messages  %arvo  %k  %fard
        %faux  %fetch-messages  %noun
        !>  [bowl discord-id bot-token self-bot last-seen-message resource]
    ==
++  graph-store-message-card
  |=  [=bowl:gall text=tape attachments=(list attachment:faux-discord) =resource snowflake=@]
  =/  attached-urls=(list content)
    (turn attachments |=(=attachment:faux-discord [%url (crip url.attachment)]))
  =/  message-text=(list content)
    ~[[%text (crip text)]]
  =/  contents
    (weld message-text attached-urls)
  =/  =post
    %+  ~(post create our.bowl now.bowl)
      ~[snowflake]
    contents
  =/  mp  (maybe-post [%.y post])
  =/  nodes
    %+  ~(put by *(map index node))
      ~[snowflake]
    [post=mp children=*internal-graph]
  =/  data
    !>  :-  now.bowl
        :+  %add-nodes  resource
        nodes
  :*  %pass  /post-to-graph-from-discord  %agent
      [our:bowl %graph-push-hook]  %poke  %graph-update-3
      data
  ==
::
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
  |=  [=message:faux-discord old-channels=(list channel)]
  ^-  (list channel)
  =/  [these-channels=(list channel) other-channels=(list channel)]
    %+  skid  old-channels
    |=  =channel
    =(discord-id.channel channel.message)
  ?~  these-channels  !!
  =/  this-channel  i.these-channels
  :-  :*  resource.this-channel
          discord-id.this-channel
          (later-snowflake:faux-discord id.message last-seen-message.this-channel)
          name.this-channel
      ==
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
      ::  frontend pokes
      %faux-set-config
    =/  config  !<(config:faux-config vase)
    `this(channels channels.config, bot-token bot-token.config, self-bot self-bot.config)
      %faux-add-channel
    =/  new-channel  !<(new-channel:faux-add-channel vase)
    :_  this
    ~[(add-channel-card bowl new-channel bot-token self-bot)]
      ::  thread pokes
      %new-channel
    =/  =channel  !<(channel:faux-config vase)
    `this(channels (weld channels ~[channel]))
      %new-discord-messages
    =/  messages  !<  (list message:faux-discord)  vase
    ?~  messages  `this
    :_  this(channels (update-latest-seen (rear messages) channels))
    %+  turn  messages
    |=  =message:faux-discord
    =/  resource  resource:(channel-by-discord-id channel.message channels)
    =/  author  ;:(weld "**" author.message "**")
    =/  reply-content
      ;:(weld author ": " content.message)
    %:  graph-store-message-card  bowl
      reply-content  attachments.message
      resource  (crip id.message)
    ==
      %retry-after
    =/  retry  !<  @dr  vase
    ~&  >>>  %rate-limited  `this
      %start-timer
    :_  this  ~[(timer-card now:bowl)]
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek
  |=  [=path]
  ^-  (unit (unit cage))
  ?>  ?=([%x %config ~] path)
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
          (post-to-discord-card discord-id bot-token self-bot post)
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
      [%add-channel ~]
    `this
      [%faux-timer ~]
    :_  this
    :-  (timer-card now:bowl)
    (fetch-messages-cards bowl channels bot-token self-bot)
      [%fetch-discord-messages ~]
    `this
  ==
++  on-fail   on-fail:def
--
