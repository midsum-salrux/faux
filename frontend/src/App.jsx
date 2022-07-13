import BotType from "./BotType";
import Channels from "./Channels";
import NavBar, { BOT_TYPE, TOKEN, CHANNELS } from "./NavBar";
import React, { useState, useEffect } from "react";
import Token from "./Token"
import Urbit from "@urbit/http-api";

function componentForPage(page, setPage, config, configPoke, addChannelPoke) {
  if (page == BOT_TYPE) {
    return <BotType setPage={setPage} config={config} configPoke={configPoke} />;
  } else if (page == TOKEN) {
    return <Token setPage={setPage} config={config} configPoke={configPoke} />;
  } else if (page == CHANNELS) {
    return <Channels setPage={setPage} config={config} configPoke={configPoke} addChannelPoke={addChannelPoke} />;
  } else {
    return <p>Something went wrong</p>;
  }
}

export default function App() {
  const [page, setPage] = useState(BOT_TYPE);
  const [config, setConfig] = useState({botToken: "", selfBot: false, channels: []});

  async function configScry() {
    const result = await window.urbit.scry({app: "faux", path: "/config"});
    setConfig(result);
  }

  function configPoke(newConfig) {
    window.urbit.poke({
      app: "faux",
      mark: "faux-set-config",
      json: newConfig,
      onSuccess: configScry
    });
  }

  function addChannelPoke(newChannel) {
    window.urbit.poke({
      app: "faux",
      mark: "faux-add-channel",
      json: newChannel,
      onSuccess: () => setTimeout(configScry, 1000)
    });
  }

  useEffect(() => configScry(), []);

  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;

  // TODO maybe there's a cleaner way of doing this
  return <>
    <NavBar page={page} setPage={setPage} />
    {componentForPage(page, setPage, config, configPoke, addChannelPoke)}
  </>;
}
