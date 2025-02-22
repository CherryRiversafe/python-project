import React, {useState} from 'react';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from './home.jsx';
import Login from './login.jsx';
import Register from './register.jsx'
import 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import './App.css';

function App() {
  const [userId, setUserId] = useState(null);

  const handleUserId = (id) => {
    setUserId(id);
  }
  return (
    <Router>
      <Routes>
        <Route exact path="/" element={<Home userId = {userId} />} />
        <Route path="/login" element={<Login onLogin={handleUserId}/>} />
        <Route path="/register" element={<Register />} />
      </Routes>
    </Router>
  );
}

export default App;
