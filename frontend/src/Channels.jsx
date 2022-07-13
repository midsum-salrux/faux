import fetchDiscordChannel from "./fetchDiscordChannel"
import React, { useState } from "react";
import { PlusIcon, TrashIcon } from "@primer/octicons-react";

export default function Channels(props) {
  const [resource, setResource] = useState("");
  const [discordChannel, setDiscordChannel] = useState("");

  function channelRemover(i) {
    return function () {
      let newChannels = props.config.channels;
      newChannels.splice(i, 1);
      props.configPoke({botToken: props.config.botToken,
                        selfBot: props.config.selfBot,
                        channels: newChannels});
    }
  }

  function addChannel() {
    const [ship, name] =  resource.replace("~", "").split("/");
    const newChannels = props.config.channels

    const channelResponse = fetchDiscordChannel(discordChannel, props.config.botToken, props.config.selfBot);
    console.log(channelResponse);

    // https://discord.com/developers/docs/resources/channel#channel-object
    newChannels.push({
      discordChannelId: discordChannel,
      lastSeenMessage: "", // TODO
      name: "", // TODO
      resource: {
        name: name,
        ship: ship
      }
    });

    props.configPoke({botToken: props.config.botToken,
                      selfBot: props.config.selfBot,
                      channels: newChannels});

    setResource("");
    setDiscordChannel("");
  }

  // TODO add a popup w/ screenshot when you click the question mark
  const channels = props.config.channels.map((channel, i) =>
    <div className="row py-3 text-center" key={i}>
      <div className="col">
        <div className="card">
          <div className="card-body">
            <div className="container">
              <div className="row">
                <div className="col">
                  <h5 className="card-title">Urbit Channel</h5>
                  <h6 className="card-subtitle mb-2 text-muted">{"~" + channel.resource.ship + "/" + channel.resource.name}</h6>
                </div>
                <div className="col">
                  <h5 className="card-title">Discord Channel</h5>
                  <h6 className="card-subtitle mb-2 text-muted">{channel.discordChannelId}</h6>
                </div>
                <div className="col my-auto">
                  <button type="button" className="btn btn-danger" onClick={channelRemover(i)}>
                    <TrashIcon />
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
  return <>
    <div className="px-3 py-3 pt-md-1 pb-md-1 mx-auto text-center">
      <h3>Channels</h3>
    </div>
    <div className="container">
      {channels}
      <div className="row py-3 text-center">
        <div className="col">
          <div className="card">
            <div className="card-body">
              <div className="container">
                <div className="row">
                  <div className="col">
                    <h5 className="card-title">Urbit Channel</h5>
                    <div className="input-group input-group-sm">
                      <input type="text" className="form-control" value={resource}
                             onChange={(e) => setResource(e.target.value)} />
                      <div className="input-group-append">
                        <button className="btn btn-outline-secondary" type="button">?</button>
                      </div>
                    </div>
                  </div>
                  <div className="col">
                    <h5 className="card-title">Discord Channel</h5>
                    <div className="input-group input-group-sm">
                      <input type="text" className="form-control" value={discordChannel}
                             onChange={(e) => setDiscordChannel(e.target.value)} />
                      <div className="input-group-append">
                        <button className="btn btn-outline-secondary" type="button">?</button>
                      </div>
                    </div>
                  </div>
                  <div className="col my-auto">
                    <button type="button" className="btn btn-success" onClick={addChannel}>
                      <PlusIcon />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </>
}
