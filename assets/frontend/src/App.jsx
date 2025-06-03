// import { useState } from 'react'
import {Route, Routes} from 'react-router-dom';
// import reactLogo from './assets/react.svg'
// import viteLogo from '/vite.svg'
// import './App.css';
import Home from './pages/Home/Home';
import Translator from './pages/Translator/Translator';
import Summarizer from './pages/Summarizer/Summarizer';
import Login from './pages/Login/Login';

function App() {
  return (
    <Routes>
      <Route index element={<Login/>}/>
      <Route path="translator" element={<Translator/>}/>
      <Route path="summarizer" element={<Summarizer/>}/>
      <Route path="home" element={<Home/>}/>
    </Routes>
  )
}

export default App;
