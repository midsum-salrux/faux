/+  resource
|%
+$  channel
  [=resource discord-id=tape last-seen-message=(unit tape)]
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
    :~  ['discordChannelId' [%s (crip discord-id.channel)]]
        ['resource' (enjs:resource resource.channel)]
    ==
  %-  pairs:enjs:format
  :~  ['botToken' q=[%s (crip bot-token.config)]]
      [p='channels' q=json-channels]
  ==
--
