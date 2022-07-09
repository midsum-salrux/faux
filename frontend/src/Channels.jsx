import React, { useState } from "react";
import { TrashIcon } from "@primer/octicons-react";

export default function Channels(props) {
  const [resource, setResource] = useState("");
  const [discordChannel, setDiscordChannel] = useState("");

  function channelRemover(i) {
    return function () {
      let newChannels = props.config.channels;
      newChannels.splice(i, 1);
      props.configPoke({botToken: props.config.botToken, channels: newChannels});
    }
  }

  function addChannel() {
    const [ship, name] =  resource.replace("~", "").split("/");
    const newChannels = props.config.channels

    // TODO make an api call to discord to get the channel name
    // TODO get the latest message id
    // https://discord.com/developers/docs/resources/channel#channel-object
    newChannels.push({
      discordChannelId: discordChannel,
      lastSeenMessage: "",
      resource: {
        name: name,
        ship: ship
      }
    });

    props.configPoke({botToken: props.config.botToken,
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
          <h5 className="py-3">New Connection</h5>

          <div className="input-group mb-3">
            <div className="input-group-prepend">
              <span className="input-group-text" id="basic-addon1">Urbit Channel</span>
            </div>
            <input type="text" className="form-control" value={resource}
                   onChange={(e) => setResource(e.target.value)} />
            <div className="input-group-append">
              <button className="btn btn-outline-secondary" type="button">?</button>
            </div>
          </div>

          <div className="input-group mb-3">
            <div className="input-group-prepend">
              <span className="input-group-text" id="basic-addon1">Discord Channel</span>
            </div>
            <input type="text" className="form-control" value={discordChannel}
                   onChange={(e) => setDiscordChannel(e.target.value)} />
            <div className="input-group-append">
              <button className="btn btn-outline-secondary" type="button">?</button>
            </div>
          </div>
        </div>
      </div>
      <div className="row-sm pt-md-1 text-center">
        <button type="button" className="btn btn-primary" onClick={addChannel}>
          Add
        </button>
      </div>
    </div>
  </>
}
