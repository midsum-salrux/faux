import React, { useState, useEffect } from "react";
import Urbit from "@urbit/http-api";

export default function App() {
  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;
  window.urbit.onOpen = function () {
    this.setState({status: "con"});
  }
  window.urbit.onRetry = function () {
    this.setState({status: "try"});
  }
  window.urbit.onError = function (_err) {
    this.setState({status: "err"});
  }
  return <>
    <h1>{window.urbit.ship}</h1>
    <Config />
  </>;
}

function Config() {
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
  </>;
}
