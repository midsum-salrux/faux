import Config from "./Config";
import React from "react";
import Urbit from "@urbit/http-api";

export default function App() {
  window.urbit = new Urbit("");
  window.urbit.ship = window.ship;
  return <>
    <h1>Faux</h1>
    <Config />
  </>;
}
