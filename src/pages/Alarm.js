import React, { useState, useEffect } from "react";
import BusSelection from "../components/BusSelection";
import busTimetable from "../data/busTimetable";

function Alarm() {
  const [busInfo, setBusInfo] = useState(null);
  const [alarmTime, setAlarmTime] = useState(null);
  const [alarmSet, setAlarmSet] = useState(false);

  useEffect(() => {
    if (busInfo && busInfo.route && busInfo.turn) {
      const departureTime = busTimetable[busInfo.route]?.[busInfo.turn];
      if (departureTime) {
        const alarmTime = calculateAlarmTime(departureTime);
        setAlarmTime(alarmTime);
        setAlarmSet(true);

        // 알람 설정
        const now = new Date();
        const alarmTimestamp = new Date(now.toDateString() + " " + alarmTime).getTime();
        const delay = alarmTimestamp - now.getTime();

        if (delay > 0) {
          setTimeout(() => {
            alert(`🚨 ${busInfo.route}번 ${busInfo.turn} 출발 5분 전입니다!`);
          }, delay);
        }
      }
    }
  }, [busInfo]);

  const calculateAlarmTime = (departureTime) => {
    const [hours, minutes] = departureTime.split(":").map(Number);
    const alarmDate = new Date();
    alarmDate.setHours(hours);
    alarmDate.setMinutes(minutes - 5);
    return `${alarmDate.getHours()}:${String(alarmDate.getMinutes()).padStart(2, "0")}`;
  };

  return (
    <div>
      <h1>⏰ 알람 설정</h1>
      <BusSelection onSelection={setBusInfo} />

      {busInfo && (
        <div>
          <h3>🚍 선택한 버스:</h3>
          <p>🚌 노선: {busInfo.route}번</p>
          <p>🔢 순번: {busInfo.turn}</p>
          <p>⏳ 출발 시간: {busTimetable[busInfo.route]?.[busInfo.turn]}</p>
          {alarmSet && <p>⏰ 알람 설정 완료: {alarmTime}에 알람이 울립니다!</p>}
        </div>
      )}
    </div>
  );
}

export default Alarm;
