import { useState } from 'react'
import heroImg from './assets/figure.png'
import './App.css'

function App() {
  const [count, setCount] = useState(0);
  const [webResponse, setWebResponse] = useState("");

  const testWebAccess = async () => {
    try {
      const response = await fetch('https://httpbin.io/post', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: 'Hello, World! V2',
          count: 123,
          active: true,
          list: [ 'alice', 'bob', 'charlie' ],
        }),
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      console.log('Data fetched successfully:', data);
      setWebResponse(JSON.stringify(data.json, null, 2));
    } catch (error) {
      console.error('Error fetching data:', error);
      setWebResponse(JSON.stringify({ error: error.message }, null, 2));
    }
  }
  
  return (
    <>
      <section id="center">
        <div className="hero">
          <img src={heroImg} className="base" width="170" alt="" />
        </div>
        <div>
          <h1>Let's Get started</h1>
          <p>
            Edit <code>src/App.jsx</code> and save to test <code>HMR</code>
          </p>
        </div>
        <button
          type="button"
          className="counter"
          onClick={() => setCount((count) => count + 1)}
        >
          Count is {count}
        </button>
        <button
          type="button"
          className="counter"
          onClick={testWebAccess}
        >
          Test Web Access
        </button>
      </section>
      <section id="bottom">
        <p>
          {webResponse}
        </p>
      </section>
      <section id="spacer"></section>
    </>
  )
}

export default App
