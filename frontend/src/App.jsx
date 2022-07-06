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
    <h1>Faux</h1>
    <Config />
  </>;
}

function Config() {
  const [config, setConfig] = useState({botToken: "", channels: []});
  const [botToken, setBotToken] = useState("");
  const [resource, setResource] = useState("");
  const [discordChannel, setDiscordChannel] = useState("");
  const [latestMessage, setLatestMessage] = useState("");

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

  function addChannel() {
    const [ship, name] =  resource.replace("~", "").split("/");
    const newChannels = config.channels

    newChannels.push({
      discordChannelId: discordChannel,
      lastSeenMessage: latestMessage,
      resource: {
        name: name,
        ship: ship
      }
    });

    configPoke({botToken: config.botToken,
                channels: newChannels});
  }

  function removeChannel(i) {
    let newChannels = config.channels;
    newChannels.splice(i, 1);

    configPoke({botToken: config.botToken, channels: newChannels});
  }

  function pokeBotToken() {
    configPoke({botToken: botToken, channels: config.channels});
  }

  useEffect(() => configScry(), []);

  const channels = config.channels.map((channel, i) =>
    <li key={i}>
      {channel.resource.ship + "/" + channel.resource.name} linked to {channel.discordChannelId}
      <button onClick={() => removeChannel(i)}>Remove</button>
    </li>
  );

  return <>
    <h2>Bot Token</h2>
    <p>{config.botToken}</p>
    <input id="botToken" type="text" value={botToken}
           onChange={(e) => setBotToken(e.target.value)}
           placeholder="New Bot Token" />
    <button onClick={pokeBotToken}>Set Token</button>
    <h2>Channels</h2>
    <ul>{channels}</ul>
    <h3>New Channel</h3>
    <input id="resource" type="text" value={resource}
           onChange={(e) => setResource(e.target.value)}
           placeholder="Urbit group resource" />
    <input id="discordChannel" type="text" value={discordChannel}
           onChange={(e) => setDiscordChannel(e.target.value)}
           placeholder="Channel ID" />
    <input id="latestMessage" type="text" value={latestMessage}
           onChange={(e) => setLatestMessage(e.target.value)}
           placeholder="Latest message ID" />
    <button onClick={addChannel}>Add Channel</button>
  </>;
}
