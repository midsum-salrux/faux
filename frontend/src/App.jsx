import React, { useState, useEffect } from "react";
import Urbit from "@urbit/http-api";

export default function App() {
  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;
  window.urbit.onOpen = function () {
    console.log("urbit open");
  }
  window.urbit.onRetry = function () {
    console.log("urbit retry");
  }
  window.urbit.onError = function (err) {
    console.log("urbit err");
    console.log(err);
  }
  return <>
    <h1>{window.urbit.ship}</h1>
    <Config />
  </>;
}

function Config() {
  function poke() {
    window.urbit.poke({
      app: "faux",
      mark: "json",
      json: config,
      onSuccess: () => null
    })
  }
  const [config, setConfig] = useState({botToken: "", channels: []});

  useEffect(() => {
    async function configScry() {
      const result = await window.urbit.scry({app: "faux", path: "/faux/config"});
      setConfig(result);
    }

    configScry();
  }, []);

  let channels = config.channels.map((channel, i) =>
    <li key={i}>{channel.resource.ship + "/" + channel.resource.name} linked to {channel.discordChannelId}</li>
  );

  return <>
    <h2>Bot Token</h2>
    <p>{config.botToken}</p>
    <h2>Channels</h2>
    <ul>{channels}</ul>
    <button onClick={poke}>Poke</button>
  </>;
}
