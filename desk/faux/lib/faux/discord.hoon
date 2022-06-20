|%
  ++  base-api-url  "https://discord.com/api/v9/"
  ++  user-agent  'Faux (https://github.com/midsum-salrux/faux, 0.1)'
  ++  headers
    |=  bot-token=tape
    :~  [key='Authorization' value=(crip (weld "Bot " bot-token))]
        [key='User-Agent' value=user-agent]
        [key='Content-Type' value='application/json']
    ==
--
