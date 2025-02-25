import React, { useState } from "react";
import busTimetable from "../data/busTimetable";

function BusSelection({ onSelection }) {
  const [selectedRoute, setSelectedRoute] = useState("");
  const [selectedDay, setSelectedDay] = useState(""); // 평일/휴일 선택
  const [selectedTurn, setSelectedTurn] = useState("");

  const handleRouteChange = (event) => {
    setSelectedRoute(event.target.value);
    setSelectedDay(""); // 노선 변경 시 요일 초기화
    setSelectedTurn(""); // 순번 초기화
  };

  const handleDayChange = (event) => {
    setSelectedDay(event.target.value);
    setSelectedTurn(""); // 요일 변경 시 순번 초기화
  };

  const handleTurnChange = (event) => {
    setSelectedTurn(event.target.value);
  };

  const handleConfirm = () => {
    if (selectedRoute && selectedDay && selectedTurn) {
      onSelection({ route: selectedRoute, day: selectedDay, turn: selectedTurn });
    }
  };

  return (
    <div>
      <h2>🚌 버스 선택</h2>
      <label>
        노선 선택:
        <select value={selectedRoute} onChange={handleRouteChange}>
          <option value="">-- 노선 선택 --</option>
          {Object.keys(busTimetable).map((route) => (
            <option key={route} value={route}>
              {route}번
            </option>
          ))}
        </select>
      </label>

      {selectedRoute && (
        <label>
          요일 선택:
          <select value={selectedDay} onChange={handleDayChange}>
            <option value="">-- 요일 선택 --</option>
            {Object.keys(busTimetable[selectedRoute]).map((day) => (
              <option key={day} value={day}>
                {day}
              </option>
            ))}
          </select>
        </label>
      )}

      {selectedRoute && selectedDay && (
        <label>
          순번 선택:
          <select value={selectedTurn} onChange={handleTurnChange}>
            <option value="">-- 순번 선택 --</option>
            {Object.keys(busTimetable[selectedRoute][selectedDay]).map((turn) => (
              <option key={turn} value={turn}>
                {turn}
              </option>
            ))}
          </select>
        </label>
      )}

      <button onClick={handleConfirm} disabled={!selectedRoute || !selectedDay || !selectedTurn}>
        선택 완료
      </button>
    </div>
  );
}

export default BusSelection;
