import React from "react";
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
  window.urbit.onError = function (err) {
    this.setState({status: "err"});
  }
  return <>
    <h1>{window.urbit.ship}</h1>
  </>;
}
