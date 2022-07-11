import BotType from "./BotType";
import Channels from "./Channels";
import NavBar, { BOT_TYPE, TOKEN, CHANNELS } from "./NavBar";
import React, { useState, useEffect } from "react";
import Token from "./Token"
import Urbit from "@urbit/http-api";

function componentForPage(page, setPage, config, configPoke) {
  if (page == BOT_TYPE) {
    return <BotType setPage={setPage} config={config} configPoke={configPoke} />;
  } else if (page == TOKEN) {
    return <Token setPage={setPage} config={config} configPoke={configPoke} />;
  } else if (page == CHANNELS) {
    return <Channels setPage={setPage} config={config} configPoke={configPoke} />;
  } else {
    return <p>Something went wrong</p>;
  }
}

export default function App() {
  const [page, setPage] = useState(BOT_TYPE);
  const [config, setConfig] = useState({botToken: "", selfBot: false, channels: []});

  async function configScry() {
    const result = await window.urbit.scry({app: "faux", path: "/faux/config"});
    setConfig(result);
  }

  function configPoke(newConfig) {
    window.urbit.poke({
      app: "faux",
      mark: "json",
      json: newConfig,
      onSuccess: () => configScry()
    });
  }

  useEffect(() => configScry(), []);

  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;

  return <>
    <NavBar page={page} setPage={setPage} />
    {componentForPage(page, setPage, config, configPoke)}
  </>;
}
