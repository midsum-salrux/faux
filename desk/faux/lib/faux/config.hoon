/+  resource
=,  dejs:format
|%
+$  channel
  [=resource discord-id=tape last-seen-message=tape name=tape]
+$  config  [channels=(list channel) bot-token=tape self-bot=?]
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
    :~  ['discordChannelId' s+(crip discord-id.channel)]
        ['resource' (enjs:resource resource.channel)]
        ['lastSeenMessage' s+(crip last-seen-message.channel)]
        ['name' s+(crip name.channel)]
    ==
  %-  pairs:enjs:format
  :~  ['botToken' s+(crip bot-token.config)]
      ['channels' json-channels]
      ['selfBot' b+self-bot.config]
  ==
++  dejs
  |=  =json
  ^-  config
  (json-decoder json)
++  json-decoder
  %-  ot
  :~  :-  %channels
      %-  ar
      %-  ot
      :~  :-  %resource
              %-  ot
              :~  ship+(su fed:ag)
                  name+so
              ==
          [%'discordChannelId' sa]
          [%'lastSeenMessage' sa]
          [%'name' sa]
      ==
      [%'botToken' sa]
      [%'selfBot' bo]
  ==
::
::  these are for migrating old state formats
::
++  deunitize
  |=  [channels=(list [=resource discord-id=tape last-seen-message=(unit tape)]) bot-token=tape]
  ^-  [channels=(list [=resource discord-id=tape last-seen-message=tape]) bot-token=tape]
  :_  bot-token
  %+  turn  channels
  |=  old-channel=[=resource discord-id=tape last-seen-message=(unit tape)]
  [resource.old-channel discord-id.old-channel (need last-seen-message.old-channel)]
++  add-names-and-selfbot
  |=  [channels=(list [=resource discord-id=tape last-seen-message=tape]) bot-token=tape]
  ^-  config
  =/  new-channels
    %+  turn  channels
    |=  old-channel=[=resource discord-id=tape last-seen-message=tape]
    ^-  channel
    :*  resource.old-channel
        discord-id.old-channel
        last-seen-message.old-channel
        name=""
    ==
  :*  new-channels
      bot-token
      self-bot=%.n
  ==
--
