import React, { useState } from 'react';

export default function Home() {
  const [did, setDid] = useState('');
  const [status, setStatus] = useState('');

  const registerIdentity = async () => {
    setStatus('Registering identity...');
    // Web3 logic to interact with smart contract
    setTimeout(() => setStatus('Identity registered!'), 2000);
  };

  return (
    <div>
      <h1>Decentralized Identity Verification</h1>
      <input type="text" placeholder="Enter your DID" onChange={(e) => setDid(e.target.value)} />
      <button onClick={registerIdentity}>Register</button>
      <p>{status}</p>
    </div>
  );
}