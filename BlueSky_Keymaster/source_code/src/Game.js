import './Game.css';
import React, { useState, useEffect, useCallback } from 'react';
import useInterval from 'use-interval'
import { selectOptions } from '@testing-library/user-event/dist/select-options';
import { CSSTransition } from 'react-transition-group'

function Game(props) {
    const [blockLocation, setBlockLocation] = useState(Math.random() * -200);
    const [reset, setReset] = useState(false);
    const [success, setSuccess] = useState(false);
    const [inProp, setInProp] = useState(false);
    const DELAYMAX = 3000;
    const FPS = 30;

    useInterval(() => {
        if (blockLocation < 100) {
            setBlockLocation(blockLocation + props.speed / props.fps);
        } else {
            setBlockLocation(Math.floor(Math.random() * -200));
            props.reportScore(props.missScore+Math.random()*.001);
        }
    }, 1000 / props.fps, true);


    function checkOverlap(box1, box2) {
        return !(
            box1.top > box2.bottom ||
            box1.right < box2.left ||
            box1.bottom < box2.top ||
            box1.left > box2.right
        );
    }

    function calculateScore(box1, box2) {
        const top = Math.max(box1.top, box2.top);
        const bottom = Math.min(box1.bottom, box2.bottom);
        const left = Math.max(box1.left, box2.left);
        const right = Math.min(box1.right, box2.right);
        const overlap = (bottom - top) * (right - left);
        const area = (box1.bottom - box1.top) * (box1.right - box1.left);
        const score = overlap / area;
        return score;
    }

    const handleButtonPress = useCallback((event) => {
        if (event.key === props.letter || event.key === props.letter.toLowerCase()) {

            var el1 = document.getElementById(props.letter + " Target");
            var el2 = document.getElementById(props.letter + " IncomingBlock")
            const domTarget = el1.getBoundingClientRect();
            const domIncomingBlock = el2.getBoundingClientRect();
            if (checkOverlap(domTarget, domIncomingBlock)) {
                var score = calculateScore(domTarget, domIncomingBlock) * 10;
                props.reportScore(score);
                setReset(false);
                setSuccess(true);
            } else {
                var score = props.missScore+Math.random()*.001;
                props.reportScore(score);
                setReset(false);
                setSuccess(false);
            }
            setBlockLocation(Math.floor(Math.random() * -200));
        }
    }, [props.currScore]);


    useEffect(() => {
        document.addEventListener("keydown", handleButtonPress, false);

        return () => {
            document.removeEventListener("keydown", handleButtonPress, false);
        };
    }, []);

    const toggleFeedback = () => {
        setTimeout(() => setReset(true), 500);
        return success ? "win" : "lose";
      };

    return (
        <div className="Game">
            <div id={props.letter + " IncomingBlock"} className="IncomingBlock" style={{ top: blockLocation.toString() + "%" }}>
                <p className="BlockText"> {props.letter} </p>
            </div>
                <div id={props.letter + " Target"} className={"Target " +  (reset ? "" : toggleFeedback())}>
                    <p className="BlockText"> {props.letter} </p>
                </div> 
        </div>
    );
}

export default React.memo(Game);
