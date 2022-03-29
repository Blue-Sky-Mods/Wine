
import './App.css';
import GameHolder from './GameHolder';
import React, { useCallback, useEffect, useState } from 'react';
import { NuiProvider } from "fivem-nui-react-lib";

function App() {

  return (
    <NuiProvider resource="BlueSky_Keymaster">
      <div className="App">
        <GameHolder />
      </div>
    </NuiProvider>
  );
}

export default App;
