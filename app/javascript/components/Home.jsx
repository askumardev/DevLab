import React from "react";
import { Link } from "react-router-dom";

export default function Home() {
  return (
    <div>
      <h1>React Dashboard</h1>

      <ul>
        <li><Link to="/cars">Cars</Link></li>
      </ul>
    </div>
  );
}