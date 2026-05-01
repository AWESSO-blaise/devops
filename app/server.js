const express = require('express');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
app.use(express.json());

const db = mysql.createConnection({
  host: process.env.DB_HOST || 'mysql',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'lacesdb'
});

db.connect((err) => {
  if (err) {
    console.error('DB connection failed:', err);
  } else {
    console.log('Connected to MySQL');
    db.query(`CREATE TABLE IF NOT EXISTS laces (
      id INT AUTO_INCREMENT PRIMARY KEY,
      owner VARCHAR(255),
      status VARCHAR(50),
      battery INT
    )`);
  }
});

app.get('/health', (req, res) => res.json({ status: 'ok' }));

app.get('/laces', (req, res) => {
  db.query('SELECT * FROM laces', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

app.post('/laces', (req, res) => {
  const { owner, status, battery } = req.body;
  db.query('INSERT INTO laces (owner, status, battery) VALUES (?, ?, ?)',
    [owner, status, battery],
    (err, result) => {
      if (err) return res.status(500).
[200~EOF~
