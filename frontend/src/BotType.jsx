import { TOKEN } from "./NavBar";
import React from "react";

export default function BotType(props) {
  return <>
    <div className="px-3 py-3 pt-md-5 pb-md-4 mx-auto text-center">
      <h1 className="display-4">Bot Type</h1>
      <p className="lead">Faux can be used be used with a bot user or as a self-bot.</p>
    </div>

    <div className="container">
      <div className="card-deck mb-3 text-center">
        <div className="card mb-4 box-shadow">
          <div className="card-header">
            <h4 className="my-0 font-weight-normal">Bot User</h4>
          </div>
          <div className="card-body">
            <p>Create a new bot user and invite it to your group. This is the recommended way to use Faux.</p>
            <button type="button" className="btn btn-lg btn-block btn-primary"
                    onClick={() => props.setPage(TOKEN)}>Continue</button>
          </div>
        </div>
        <div className="card mb-4 box-shadow">
          <div className="card-header">
            <h4 className="my-0 font-weight-normal">Self-Bot</h4>
          </div>
          <div className="card-body">
            <p>Connect to your personal discord account. This is against the discord terms of service, and could result in your account getting banned.</p>
            <button type="button" className="btn btn-lg btn-block btn-primary"
                    onClick={() => props.setPage(TOKEN)}>Continue</button>
          </div>
        </div>
      </div>
    </div>
  </>
}
