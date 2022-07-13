/+  resource
=,  dejs:format
|%
+$  new-channel  [=resource discord-id=tape]
++  dejs
  |=  =json
  ^-  new-channel
  (json-decoder json)
++  json-decoder
  %-  ot
  :~  :-  %resource
      %-  ot
      :~  ship+(su fed:ag)
          name+so
      ==
      [%'discordChannelId' sa]
  ==
--
