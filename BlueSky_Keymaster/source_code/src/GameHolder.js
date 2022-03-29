import logo from './logo.svg';
import './GameHolder.css';
import Game from './Game';
import React, { useCallback, useEffect, useState } from 'react';
import { NuiProvider } from "fivem-nui-react-lib";
import {
    useNuiEvent,
    useNuiCallback,
    useNuiRequest,
  } from "fivem-nui-react-lib";

const defaultConfig = {
    keys: ["W", "A", "S", "D"],
    speed: 30,
    winScore: 50,
    loseScore: -25,
    missScore: -5,
    fps: 45
}


function GameHolder() {
    const [totalScore, setTotalScore] = useState(0);
    const [indivScore, setIndivScore] = useState(0);
    const [started, setStarted] = useState(false);
    const [config, setConfig] = useState({});

    const reportScore = (score) => {
        setIndivScore(score);
    };

    useNuiEvent("keymaster", "start", setStarted);
    useNuiEvent("keymaster", "setConfig", setConfig);

    useEffect(() => {
        setTotalScore(totalScore + indivScore);
    }, [indivScore]);

    const { send } = useNuiRequest();
    useEffect(() => {
        if (totalScore >= config.winScore) {
            //success 
            send("success", {});
            setStarted(false);
            setTotalScore(0)
        }else if (totalScore <= config.loseScore){
            //fail
            send("fail", {});
            setStarted(false);
            setTotalScore(0)
        }
    }, [totalScore]);


    return (
        started && (
        <div className="Container">
            <h1> {Math.round(totalScore)} </h1>
            <div className="GameHolder">
                {
                    config.keys.map(letter => (
                        <Game
                            letter={letter}
                            speed={config.speed}
                            reportScore={reportScore}
                            currScore={totalScore}
                            missScore={config.missScore}
                            fps={config.fps}
                        />
                    ))
                }
            </div>
        </div>
        )
    );
}

export default GameHolder;
