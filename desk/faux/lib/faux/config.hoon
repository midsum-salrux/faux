/+  resource
=,  dejs:format
|%
+$  channel
  [=resource discord-id=tape last-seen-message=tape]
+$  config  [channels=(list channel) bot-token=tape]
++  enjs
  |=  =config
  ^-  json
  =/  json-channels=json
    :-  %a
    ^-  (list json)
    %+  turn  channels.config
    |=  =channel
    ^-  json
    %-  pairs:enjs:format
    =/  chan
      :~  ['discordChannelId' [%s (crip discord-id.channel)]]
          ['resource' (enjs:resource resource.channel)]
      ==
    ?~  last-seen-message.channel  chan
    :-  ['lastSeenMessage' [%s (crip (need last-seen-message.channel))]]
        chan
  %-  pairs:enjs:format
  :~  ['botToken' q=[%s (crip bot-token.config)]]
      [p='channels' q=json-channels]
  ==
++  dejs
  |=  =json
  (json-decoder json)
++  json-decoder
  %-  ot
  :~  [%'botToken' sa]
      :-  %channels
      %-  ar
      %-  ot
      :~  [%'discordChannelId' sa]
          [%resource dejs:resource]
          [%'lastSeenMessage' sa]
      ==
  ==
++  deunitize
  |=  [channels=(list [=resource discord-id=tape last-seen-message=(unit tape)]) bot-token=tape]
  ^-  config
  :_  bot-token
  %+  turn  channels
  |=  old-channel=[=resource discord-id=tape last-seen-message=(unit tape)]
  [resource.old-channel discord-id.old-channel (need last-seen-message.old-channel)]
--
