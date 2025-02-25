// src/components/KookminAlarm.js

import React, { useState } from 'react';
import busTimetable from '../data/busTimetable'; // busTimetable.js 파일을 가져옴

// 알람 소리 파일 (기본 알람음 사용)
const alarmSound = new Audio('https://www.soundjay.com/button/sounds/beep-07.mp3');

const KookminAlarm = () => {
    const [selectedBus, setSelectedBus] = useState(Object.keys(busTimetable)[0]);
    const [selectedDay, setSelectedDay] = useState('평일');
    const [selectedRoute, setSelectedRoute] = useState('');
    const [isAlarmSet, setIsAlarmSet] = useState(false);
    const [alarmInterval, setAlarmInterval] = useState(null);

    const handleSetAlarm = () => {
        setIsAlarmSet(true);
        if (!alarmInterval) {
            const interval = setInterval(checkAlarm, 60000);
            setAlarmInterval(interval);
            alert('알람이 설정되었습니다!');
        }
    };

    const handleCancelAlarm = () => {
        setIsAlarmSet(false);
        if (alarmInterval) {
            clearInterval(alarmInterval);
            setAlarmInterval(null);
            alert('알람이 취소되었습니다.');
        }
    };

    const checkAlarm = () => {
        const now = new Date();
        const times = busTimetable[selectedBus][selectedDay][selectedRoute] || [];
        times.forEach(time => {
            const [hour, minute] = time.split(':').map(Number);
            const alarmTime = new Date();
            alarmTime.setHours(hour);
            alarmTime.setMinutes(minute - 5);
            alarmTime.setSeconds(0);

            if (now >= alarmTime && now < new Date(alarmTime.getTime() + 60000)) {
                alarmSound.play();
                if (Notification.permission === 'granted') {
                    new Notification('버스 알람', {
                        body: `${selectedBus}번 버스 ${selectedRoute}번 순번이 곧 출발합니다!`
                    });
                }
            }
        });
    };

    return (
        <div className="p-4">
            <h2 className="text-xl mb-4">버스 알람 설정</h2>
            <div>
                <label>버스 노선 선택:</label>
                <select value={selectedBus} onChange={(e) => setSelectedBus(e.target.value)}>
                    {Object.keys(busTimetable).map(bus => (
                        <option key={bus} value={bus}>{bus}번</option>
                    ))}
                </select>
            </div>
            <div>
                <label>운행일 선택:</label>
                <select value={selectedDay} onChange={(e) => setSelectedDay(e.target.value)}>
                    <option value="평일">평일</option>
                    <option value="휴일">휴일</option>
                </select>
            </div>
            <div>
                <label>순번 선택:</label>
                <select value={selectedRoute} onChange={(e) => setSelectedRoute(e.target.value)}>
                    {Object.keys(busTimetable[selectedBus][selectedDay] || {}).map(route => (
                        <option key={route} value={route}>{route}번</option>
                    ))}
                </select>
            </div>
            <button onClick={handleSetAlarm} disabled={!selectedRoute}>알람 설정</button>
            <button onClick={handleCancelAlarm} disabled={!isAlarmSet}>알람 취소</button>
        </div>
    );
};

export default KookminAlarm;
